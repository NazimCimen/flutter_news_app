import 'package:flutter_news_app/common/decorations/custom_input_decoration.dart';
import 'package:flutter_news_app/core/utils/app_validators.dart';
import 'package:flutter_news_app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';

/// Custom password text field for the app
class CustomPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obsecureText;
  final VoidCallback changeObsecureText;
  final String topLabel;
  final String hintText;

  const CustomPasswordTextField({
    required this.controller,
    required this.obsecureText,
    required this.changeObsecureText,
    required this.topLabel,
    required this.hintText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          topLabel,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: context.cSmallValue),
        TextFormField(
          controller: controller,
          validator: (value) => AppValidators.passwordValidator(value),
          obscureText: obsecureText,
          textInputAction: TextInputAction.done,
          decoration: CustomInputDecoration.authInputDecoration(
            context: context,
            hintText: hintText,
            suffixIcon: IconButton(
              onPressed: changeObsecureText,
              icon: Icon(
                obsecureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
