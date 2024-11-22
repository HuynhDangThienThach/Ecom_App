import 'dart:async';
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
  late final HealthFactory _healthFactory;
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  static final types = [
    HealthDataType.STEPS,
  ];

  List<HealthDataAccess> get permissions =>
      types.map((e) => HealthDataAccess.READ_WRITE).toList();

  @override
  void initState() {
    super.initState();
    _healthFactory = HealthFactory(useHealthConnectIfAvailable: true);
  }

  Future<void> authorize() async {
    final activityPermission = await Permission.activityRecognition.request();
    final locationPermission = await Permission.location.request();

    if (activityPermission.isPermanentlyDenied || locationPermission.isPermanentlyDenied) {
      openAppSettings();
      setState(() => _state = AppState.AUTH_NOT_GRANTED);
      return;
    }

    if (activityPermission.isDenied || locationPermission.isDenied) {
      setState(() => _state = AppState.AUTH_NOT_GRANTED);
      return;
    }

    bool? hasPermissions = await _healthFactory.hasPermissions(types, permissions: permissions);
    bool authorized = false;

    if (hasPermissions == false) {
      try {
        authorized = await _healthFactory.requestAuthorization(types, permissions: permissions);
      } catch (error) {
        debugPrint("Ngoại lệ trong ủy quyền: $error");
      }
    }

    setState(() => _state = authorized ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED);
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
      List<HealthDataPoint> healthData = await _healthFactory.getHealthDataFromTypes(
        yesterday,
        now,
        types,
      );

      if (healthData.isEmpty) {
        setState(() => _state = AppState.NO_DATA);
        return;
      }

      _healthDataList.addAll(HealthFactory.removeDuplicates(healthData));
      setState(() => _state = AppState.DATA_READY);
    } catch (error) {
      debugPrint("Ngoại lệ trong getHealthDataFromTypes: $error");
      setState(() => _state = AppState.NO_DATA);
    }
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
                    width: 200,
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
            const Divider(thickness: 3),
            const SizedBox(height: 32),
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
                _buildTextButton("2. Lấy dữ liệu", fetchData),
              ],
            ),
            const Divider(thickness: 3),
            const SizedBox(height: 20),
            Center(child: _content),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton(String text, VoidCallback onPressed) {
    return Expanded(
      child: TextButton(
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
      ),
    );
  }

  Widget _buildHealthDataTile(HealthDataPoint data) {
    String title = data.typeString;
    String subtitle = '${data.dateFrom} - ${data.dateTo}';
    String trailing;

    switch (data.value.runtimeType) {
      case AudiogramHealthValue:
        trailing = data.unitString;
        break;
      case WorkoutHealthValue:
        final workout = data.value as WorkoutHealthValue;
        trailing = "${workout.totalEnergyBurned} ${workout.totalEnergyBurnedUnit?.name}";
        break;
      case NutritionHealthValue:
        final nutrition = data.value as NutritionHealthValue;
        trailing = "${nutrition.calories} kcal";
        break;
      default:
        trailing = data.value.toString();
    }

    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(trailing),
    );
  }

  Widget get _contentFetchingData => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        padding: const EdgeInsets.all(20),
        child: const CircularProgressIndicator(
          strokeWidth: 10,
        ),
      ),
      const Text('Nạp dữ liệu...')
    ],
  );

  Widget get _contentDataReady => ListView.builder(
    itemCount: _healthDataList.length,
    itemBuilder: (_, index) => _buildHealthDataTile(_healthDataList[index]),
  );

  final Widget _contentNoData = const Text('Không có dữ liệu về sức khỏe');

  final Widget _contentNotFetched = const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Nhấn 'Xác thực' để thực hiện cho phép lấy dữ liệu sức khỏe"),
      Text("Nhấn 'Lấy dữ liệu sức khỏe' để hiển thị chỉ số sức khỏe của bạn"),
    ],
  );

  final Widget _authorized = const Text('Đã được cấp phép!');

  Widget get _authorizationNotGranted => const Center(
    child: Text(
      'Bạn chưa cấp quyền truy cập sức khỏe. Vui lòng kiểm tra cài đặt của ứng dụng.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.red),
    ),
  );

  Widget get _content => switch (_state) {
    AppState.DATA_READY => _contentDataReady,
    AppState.DATA_NOT_FETCHED => _contentNotFetched,
    AppState.FETCHING_DATA => _contentFetchingData,
    AppState.NO_DATA => _contentNoData,
    AppState.AUTHORIZED => _authorized,
    AppState.AUTH_NOT_GRANTED => _authorizationNotGranted,
    _ => const Center(child: Text('Trạng thái không xác định')),
  };
}
