/// Custom exception class to handle various Firebase authentication-related errors.
class TFirebaseAuthException implements Exception {
  /// The error code associated with the exception.
  final String code;

  /// Constructor that takes an error code.
  TFirebaseAuthException(this.code);

  /// Get the corresponding error message based on the error code.
  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'Địa chỉ email đã được đăng ký. Vui lòng sử dụng email khác.';
      case 'invalid-email':
        return 'Địa chỉ email cung cấp không hợp lệ. Vui lòng nhập email hợp lệ.';
      case 'weak-password':
        return 'Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn.';
      case 'user-disabled':
        return 'Tài khoản người dùng này đã bị vô hiệu hóa. Vui lòng liên hệ với bộ phận hỗ trợ để được trợ giúp.';
      case 'user-not-found':
        return 'Thông tin đăng nhập không hợp lệ. Không tìm thấy người dùng.';
      case 'wrong-password':
        return 'Mật khẩu không chính xác. Vui lòng kiểm tra lại mật khẩu của bạn và thử lại.';
      case 'invalid-verification-code':
        return 'Mã xác minh không hợp lệ. Vui lòng nhập mã hợp lệ.';
      case 'invalid-verification-id':
        return 'ID xác minh không hợp lệ. Vui lòng yêu cầu mã xác minh mới.';
      case 'quota-exceeded':
        return 'Đã vượt quá hạn mức. Vui lòng thử lại sau.';
      case 'email-already-exists':
        return 'Địa chỉ email đã tồn tại. Vui lòng sử dụng email khác.';
      case 'provider-already-linked':
        return 'Tài khoản đã được liên kết với nhà cung cấp khác.';
      case 'requires-recent-login':
        return 'Thao tác này nhạy cảm và yêu cầu xác thực gần đây. Vui lòng đăng nhập lại.';
      case 'credential-already-in-use':
        return 'Thông tin xác thực này đã được liên kết với tài khoản người dùng khác.';
      case 'user-mismatch':
        return 'Thông tin xác thực cung cấp không khớp với người dùng đã đăng nhập trước đó.';
      case 'account-exists-with-different-credential':
        return 'Một tài khoản đã tồn tại với cùng email nhưng thông tin xác thực đăng nhập khác.';
      case 'operation-not-allowed':
        return 'Thao tác này không được phép. Vui lòng liên hệ với bộ phận hỗ trợ để được trợ giúp.';
      case 'expired-action-code':
        return 'Mã hành động đã hết hạn. Vui lòng yêu cầu mã hành động mới.';
      case 'invalid-action-code':
        return 'Mã hành động không hợp lệ. Vui lòng kiểm tra mã và thử lại.';
      case 'missing-action-code':
        return 'Mã hành động bị thiếu. Vui lòng cung cấp mã hành động hợp lệ.';
      case 'user-token-expired':
        return 'Mã thông báo của người dùng đã hết hạn, và yêu cầu xác thực lại. Vui lòng đăng nhập lại.';
      case 'user-not-found':
        return 'Không tìm thấy người dùng cho email hoặc UID đã cho.';
      case 'invalid-credential':
        return 'Thông tin xác thực cung cấp không hợp lệ hoặc đã hết hạn.';
      case 'wrong-password':
        return 'Mật khẩu không hợp lệ. Vui lòng kiểm tra mật khẩu của bạn và thử lại.';
      case 'user-token-revoked':
        return 'Mã thông báo của người dùng đã bị thu hồi. Vui lòng đăng nhập lại.';
      case 'invalid-message-payload':
        return 'Nội dung tin nhắn xác minh mẫu email không hợp lệ.';
      case 'invalid-sender':
        return 'Người gửi mẫu email không hợp lệ. Vui lòng xác minh email của người gửi.';
      case 'invalid-recipient-email':
        return 'Địa chỉ email người nhận không hợp lệ. Vui lòng cung cấp địa chỉ email người nhận hợp lệ.';
      case 'missing-iframe-start':
        return 'Mẫu email thiếu thẻ bắt đầu iframe.';
      case 'missing-iframe-end':
        return 'Mẫu email thiếu thẻ kết thúc iframe.';
      case 'missing-iframe-src':
        return 'Mẫu email thiếu thuộc tính src của iframe.';
      case 'auth-domain-config-required':
        return 'Cấu hình authDomain là cần thiết cho liên kết xác minh mã hành động.';
      case 'missing-app-credential':
        return 'Thông tin xác thực ứng dụng bị thiếu. Vui lòng cung cấp thông tin xác thực ứng dụng hợp lệ.';
      case 'invalid-app-credential':
        return 'Thông tin xác thực ứng dụng không hợp lệ. Vui lòng cung cấp thông tin xác thực ứng dụng hợp lệ.';
      case 'session-cookie-expired':
        return 'Cookie phiên Firebase đã hết hạn. Vui lòng đăng nhập lại.';
      case 'uid-already-exists':
        return 'ID người dùng đã cung cấp đã được sử dụng bởi một người dùng khác.';
      case 'invalid-cordova-configuration':
        return 'Cấu hình Cordova cung cấp không hợp lệ.';
      case 'app-deleted':
        return 'Phiên bản FirebaseApp này đã bị xóa.';
      case 'user-disabled':
        return 'Tài khoản người dùng đã bị vô hiệu hóa.';
      case 'user-token-mismatch':
        return 'Mã thông báo của người dùng cung cấp không khớp với ID người dùng đã xác thực.';
      case 'web-storage-unsupported':
        return 'Lưu trữ web không được hỗ trợ hoặc đã bị vô hiệu hóa.';
      case 'invalid-credential':
        return 'Thông tin xác thực cung cấp không hợp lệ. Vui lòng kiểm tra thông tin xác thực và thử lại.';
      case 'app-not-authorized':
        return 'Ứng dụng không được phép sử dụng xác thực Firebase với khóa API đã cung cấp.';
      case 'keychain-error':
        return 'Đã xảy ra lỗi keychain. Vui lòng kiểm tra keychain và thử lại.';
      case 'internal-error':
        return 'Đã xảy ra lỗi xác thực nội bộ. Vui lòng thử lại sau.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Thông tin đăng nhập không hợp lệ.';
      default:
        return 'Đã xảy ra lỗi xác thực không mong đợi. Vui lòng thử lại.';
    }
  }
}
