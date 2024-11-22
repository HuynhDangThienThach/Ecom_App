import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../features/shop/controllers/product/product_controller.dart';

class NotifyCationRemindScreen extends StatefulWidget {
  const NotifyCationRemindScreen({super.key});

  @override
  _NotifyCationRemindScreenState createState() => _NotifyCationRemindScreenState();
}

class _NotifyCationRemindScreenState extends State<NotifyCationRemindScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? medicineName;
  String? dose;

  final ValueNotifier<String?> selectedShapeNotifier = ValueNotifier<String?>(null);
  List<Map<String, dynamic>> reminders = [];

  // Access ProductController instance
  final ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersString = prefs.getString('reminders');

    if (remindersString != null) {
      setState(() {
        reminders = List<Map<String, dynamic>>.from(json.decode(remindersString));
      });
    }
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersString = json.encode(reminders);
    await prefs.setString('reminders', remindersString);
  }

  void _pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          selectedDate = date;
          selectedTime = time;
        });
      }
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        year: scheduledDateTime.year,
        month: scheduledDateTime.month,
        day: scheduledDateTime.day,
        hour: scheduledDateTime.hour,
        minute: scheduledDateTime.minute,
        second: 0,
        millisecond: 0,
        repeats: false,
      ),
    );
  }

  void _showAddMedicineModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Đặt lời nhắc sử dụng thuốc',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Obx(() {
                // Show loader if products are still loading
                if (productController.isLoading.value) {
                  return const CircularProgressIndicator();
                }

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  hint: const Text(
                    "Chọn tên thuốc",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  items: productController.featuredProducts.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    var product = entry.value;
                    return DropdownMenuItem<String>(
                      value: product.title,
                      child: Column(
                        children: [
                          Text(
                            '$index. ${product.title}',
                            style: const TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const Divider(thickness: 1,)
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      medicineName = value;
                    });
                  },
                );

              }),

              TextField(
                decoration: const InputDecoration(labelText: 'Liều lượng', hintText: '2 viên'),
                onChanged: (value) {
                  dose = value;
                },
              ),
              const SizedBox(height: 16),
              const Text('Hình dạng thuốc', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildShapeSelector('assets/icons/health/pills-bottle.png'),
                  _buildShapeSelector('assets/icons/health/pill.png'),
                  _buildShapeSelector('assets/icons/health/pill1.png'),
                  _buildShapeSelector('assets/icons/health/pill2.png'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickDateTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(100, 50),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    selectedDate != null && selectedTime != null
                        ? 'Nhắc nhở vào lúc: ${DateFormat('yMd').format(selectedDate!)} ${selectedTime!.format(context)}'
                        : 'Đặt thời gian',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (medicineName != null && dose != null && selectedShapeNotifier.value != null && selectedDate != null && selectedTime != null) {
                    setState(() {
                      reminders.add({
                        'name': medicineName,
                        'dose': dose,
                        'shape': selectedShapeNotifier.value,
                        'date': selectedDate.toString(),
                        'time': selectedTime!.format(context),
                      });
                      _saveReminders();
                    });

                    DateTime notificationDateTime = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );

                    await scheduleNotification(
                      id: reminders.length,
                      title: 'Đã đến giờ uống thuốc!',
                      body: 'Đã đến giờ uống thuốc $medicineName với liều lượng $dose',
                      scheduledDateTime: notificationDateTime,
                    );

                    medicineName = null;
                    dose = null;
                    selectedShapeNotifier.value = null;
                    selectedDate = null;
                    selectedTime = null;
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Thêm lời nhắc'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShapeSelector(String shapePath) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedShapeNotifier,
      builder: (context, selectedShape, child) {
        return GestureDetector(
          onTap: () {
            selectedShapeNotifier.value = shapePath;
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedShape == shapePath ? Colors.green : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              shapePath,
              color: selectedShape == shapePath ? Colors.green : Colors.grey,
              width: 40,
              height: 40,
            ),
          ),
        );
      },
    );
  }

  void _removeReminder(int index) {
    setState(() {
      reminders.removeAt(index);
      _saveReminders();  // Update saved reminders after removing one
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMedicineModal(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: const TAppBar(
        title: Text("Nhắc nhở sử dụng thuốc"),
        showBackArrow: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: reminders.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/health/thuoc_icon.png", width: 50, height: 50),
              const Text(
                "Không có lời nhắc. Hãy đặt thêm lời nhắc ngay bây giờ!",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            final reminder = reminders[index];
            return Card(
              child: ListTile(
                leading: Image.asset(reminder['shape'], width: 40, height: 40),
                title: Text(reminder['name']),
                subtitle: Text('${reminder['dose']} - ${reminder['date']} ${reminder['time']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeReminder(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

