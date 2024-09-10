import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/shop/models/payment_method_model.dart';
import 'package:t_store/utils/constants/image_strings.dart';

import '../../../../utils/constants/sizes.dart';
import '../../screens/checkout/widgets/payment_title.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  //--- Variables
  final Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.empty().obs;

  @override
  void onInit() {
    selectedPaymentMethod.value = PaymentMethodModel(name: 'Paypal', image: TImages.paypal);
    super.onInit();
  }

  //--- Functions
  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (_) => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(TSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TSectionHeading(title: 'Select Payment Method', showActionButton: false,),
                const SizedBox(height: TSizes.spaceBtwSections),
                TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Paypal', image: TImages.paypal),),
                const SizedBox(height: TSizes.spaceBtwItems/2,),
                TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Google Pay', image: TImages.googlePay),),
                const SizedBox(height: TSizes.spaceBtwItems/2,),
                TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Apple Pay', image: TImages.applePay),),
                const SizedBox(height: TSizes.spaceBtwItems/2,),
                TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'VISA', image: TImages.visa),),
                const SizedBox(height: TSizes.spaceBtwItems/2,),
                TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Master Card', image: TImages.masterCard),),
                const SizedBox(height: TSizes.spaceBtwItems/2,),
                TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Paytm', image: TImages.paytm),),
                const SizedBox(height: TSizes.spaceBtwItems/2,),
                TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'PayStack', image: TImages.paystack),),
                const SizedBox(height: TSizes.spaceBtwItems/2,),
                TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Credit Card', image: TImages.creditCard),),
                const SizedBox(height: TSizes.spaceBtwItems/2,),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
        )
    );
  }
}
