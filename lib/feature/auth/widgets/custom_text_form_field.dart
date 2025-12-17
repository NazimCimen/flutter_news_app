import 'package:flutter_news_app/common/decorations/custom_input_decoration.dart';
import 'package:flutter/material.dart';

/// Custom text form field for the app
class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? topLabel;

  const CustomTextFormField({
    required this.controller,
    required this.validator,
    required this.keyboardType,
    required this.textInputAction,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.topLabel,

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (topLabel != null) ...[
          Text(
            topLabel!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: CustomInputDecoration.authInputDecoration(
            context: context,
            hintText: hintText ?? labelText ?? '',
          ),
        ),
      ],
    );
  }
}
