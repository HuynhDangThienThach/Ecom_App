import 'package:logger/logger.dart';
//--- Thông báo khi lỗi hoặc cần hiện thông báo lên màn hình
class TLoggerHelper {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
    // Customize the log levels based on your needs
    level: Level.debug,
  );

  static void debug(String message) {
    _logger.d(message);
  }

  static void info(String message) {
    _logger.i(message);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void error(String message, [dynamic error]) {
    _logger.e(message, error: error,  stackTrace: StackTrace.current);
  }
}
