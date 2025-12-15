import 'package:flutter_news_app/feature/auth/view/login_view.dart';
import 'package:flutter_news_app/feature/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin LoginMixin on ConsumerState<LoginView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController mailController;
  late TextEditingController passwordController;
  bool isRequestAvailable = false;
  bool isGoogleLoading = false;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  bool obscureText = true;

  @override
  void initState() {
    mailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Attempts to log in user with email and password.
  /// Returns nothing as state is handled by Riverpod listener in View.
  Future<void> loginUser() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    validateFields();
    if (isRequestAvailable) {
      await ref
          .read(authViewModelProvider.notifier)
          .login(mailController.text.trim(), passwordController.text.trim());
    }
  }

  /// Validates form fields and updates request availability status.
  void validateFields() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isRequestAvailable = true;
      });
    } else {
      setState(() {
        autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  /// Toggles password visibility in the password field.
  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  /// Sets request availability to false and updates UI state.
  void makeRequestUnavailable() {
    setState(() {
      isRequestAvailable = false;
    });
  }
}
