import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../../../utils/popups/loaders.dart';
import '../const.dart';
class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(double amount, Function onSuccess) async {
    try {
      String? result = await createPaymentIntent(amount, "vnd");
      if (result == null) return;
      // Nguoc lai neu khong null se tao ra bang thanh toan
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: result,
              merchantDisplayName: "Thien Thach",
          ));

      try {
        await Stripe.instance.presentPaymentSheet().then((value) {
          print("Payment Sheet Presented Successfully");
          // Thực hiện gọi onSuccess
          onSuccess();
          print("Success Callback Called");
        }).catchError((e) {
          // Xử lý lỗi nếu có
          print("Error presenting payment sheet: $e");
        });
      } catch (e) {
        print("General Exception when presenting payment sheet: $e");
      }

    } on StripeException catch (e) {
      TLoaders.warningSnackBar(title: "Thanh toán bị huỷ!", message: "Bạn đã hủy giao dịch thanh toán");
    } catch (e) {
      print(e);
    }

  }

  Future<String?> createPaymentIntent(double amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": calculateAmount(amount),
        "currency": currency,
      };
      var response = await dio.post("https://api.stripe.com/v1/payment_intents",
          data: data,
          options:
          Options(contentType: Headers.formUrlEncodedContentType, headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": "application/x-www-form-urlencoded"
          }));
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> processPayment() async{
    try{
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch(e){print(e);}
  }

  String calculateAmount(double amount) {
    final calculatedAmount = (amount ~/ 1000) * 1000;
    return calculatedAmount.toString();
  }
}
