import 'dart:async';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/features/shop/screens/profileDS/profileDsScreen.dart';

import '../../../../navigation_menu.dart';

class QuizResultScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final String title;

  const QuizResultScreen({
    super.key,
    required this.questions,
    required this.title,
  });

  @override
  _QuizResultScreenState createState() => _QuizResultScreenState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  /// All the data types that are available on Android and iOS.
  /* List<HealthDataType> get types => (Platform.isAndroid)
      ? dataTypeKeysAndroid
      : (Platform.isIOS)
          ? dataTypeKeysIOS
          : []; */

  static final types = [
    HealthDataType.STEPS,
  ];

  List<HealthDataAccess> get permissions =>
      types.map((e) => HealthDataAccess.READ_WRITE).toList();

  @override
  void initState() {
    HealthFactory(useHealthConnectIfAvailable: true);
    super.initState();
  }

  Future<void> authorize() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();

    bool? hasPermissions =
        await HealthFactory().hasPermissions(types, permissions: permissions);
    hasPermissions = false;
    bool authorized = false;
    if (!hasPermissions) {
      try {
        authorized = await HealthFactory()
            .requestAuthorization(types, permissions: permissions);
      } catch (error) {
        debugPrint("Ngoại lệ trong ủy quyền: $error");
      }
    }
    setState(() => _state =
        (authorized) ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED);
  }

  Future<void> fetchData() async {
    if (_state != AppState.AUTHORIZED) {
      await authorize();
      if (_state != AppState.AUTHORIZED) return;
    }

    setState(() => _state = AppState.FETCHING_DATA);

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));
    _healthDataList.clear();

    try {
      List<HealthDataPoint> healthData =
          await HealthFactory().getHealthDataFromTypes(yesterday, now, types);

      _healthDataList.addAll(
          (healthData.length < 100) ? healthData : healthData.sublist(0, 100));
    } catch (error) {
      debugPrint("Ngoại lệ trong getHealthDataFromTypes: $error");
    }
    _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
    for (var data in _healthDataList) {
      debugPrint(toJsonString(data));
    }
    setState(() {
      _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
    });
  }

  @override
  Widget build(BuildContext context) {
    int countYes =
        widget.questions.where((question) => question['answer'] == true).length;
    int countNo = widget.questions.length - countYes;

    String resultText;
    String imagePath;

    if (countYes > countNo) {
      resultText = widget.title;
      imagePath = 'assets/icons/health/bad_conditon.png';
    } else {
      resultText = "Sức khỏe của bạn không đáng lo";
      imagePath = 'assets/icons/health/good_condition.png';
    }
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Kết quả đánh giá'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    imagePath,
                    height: 200,
                    width: 200, // Ensures the image maintains its aspect ratio
                  ),
                  const SizedBox(height: 16),
                  Text(
                    resultText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTextButton("Tư vấn", () => Get.to(() => const ProfileDsScreen())),
                      const SizedBox(width: 16),
                      _buildTextButton("Trang chủ", () => Get.to(() => const NavigationMenu())),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(thickness: 3,),
            const SizedBox(height: 32), // Increased space for clarity
            const Text(
              "Chỉ số sức khỏe",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextButton("1. Xác thực", authorize),
                const SizedBox(width: 16),
                _buildTextButton("2. Lấy dữ liệu sức khỏe", fetchData),
              ],
            ),
            const Divider(thickness: 3,),
            const SizedBox(height: 20),
            Center(child: _content),
          ],
        ),
      ),

    );
  }

  Widget _buildTextButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue[800],
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget get _contentFetchingData => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(20),
              child: const CircularProgressIndicator(
                strokeWidth: 10,
              )),
          const Text('Nạp dữ liệu...')
        ],
      );

  Widget get _contentDataReady => ListView.builder(
      itemCount: _healthDataList.length,
      itemBuilder: (_, index) {
        HealthDataPoint p = _healthDataList[index];
        if (p.value is AudiogramHealthValue) {
          return ListTile(
            title: Text("${p.typeString}: ${p.value}"),
            trailing: Text(p.unitString),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        }
        if (p.value is WorkoutHealthValue) {
          return ListTile(
            title: Text(
                "${p.typeString}: ${(p.value as WorkoutHealthValue).totalEnergyBurned} ${(p.value as WorkoutHealthValue).totalEnergyBurnedUnit?.name}"),
            trailing:
                Text((p.value as WorkoutHealthValue).workoutActivityType.name),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        }
        if (p.value is NutritionHealthValue) {
          return ListTile(
            title: Text(
                "${p.typeString} ${(p.value as NutritionHealthValue).mealType}: ${(p.value as NutritionHealthValue).name}"),
            trailing:
                Text('${(p.value as NutritionHealthValue).calories} kcal'),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        }
        return ListTile(
          title: Text("${p.typeString}: ${p.value}"),
          trailing: Text(p.unitString),
          subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
        );
      });

  final Widget _contentNoData = const Text('Không có dữ liệu về sức khỏe');

  final Widget _contentNotFetched =
      const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text("Nhấn 'Xác thực' để thực hiện cho phép lấy dữ liệu sức khỏe"),
    Text("Nhấn 'Lấy dữ liệu sức khỏe' để hiển thị chỉ số sức khỏe của bạn"),
  ]);

  final Widget _authorized = const Text('Đã được cấp phép!');

  final Widget _authorizationNotGranted = const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Chưa cấp quyền.'),
      Text('Bạn cần cấp tất cả các quyền về sức khỏe trên Health Connect.'),
    ],
  );

  Widget get _content => switch (_state) {
        AppState.DATA_READY => _contentDataReady,
        AppState.DATA_NOT_FETCHED => _contentNotFetched,
        AppState.FETCHING_DATA => _contentFetchingData,
        AppState.NO_DATA => _contentNoData,
        AppState.AUTHORIZED => _authorized,
        AppState.AUTH_NOT_GRANTED => _authorizationNotGranted,
      };
}
