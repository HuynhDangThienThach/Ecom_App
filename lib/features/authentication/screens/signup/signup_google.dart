import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/login_signup/form_diver.dart';
import 'package:t_store/common/widgets/login_signup/social_buttons.dart';
import 'package:t_store/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:t_store/features/authentication/screens/signup/widgets/signup_form_google.dart';
import 'package:t_store/utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class SignupGoogle extends StatelessWidget {
  const SignupGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //--- Title
              Text(TTexts.signupGoogleTitle, style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: TSizes.spaceBtwSections),
              //--- Form
              const SignupFormGoogle(),
              const SizedBox(height: TSizes.spaceBtwSections,),
              //--- Divider
              TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections,),
              // --- Social Buttons
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}