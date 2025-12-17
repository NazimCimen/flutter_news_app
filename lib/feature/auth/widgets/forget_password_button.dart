import 'package:flutter/material.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';

/// FORGOT PASSWORD BUTTON IS USED TO DISPLAY FORGOT PASSWORD BUTTON
class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Todo: Forgot password
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        StringConstants.forgetPassword,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
