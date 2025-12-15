import 'dart:async';
import 'package:flutter_news_app/feature/auth/view/sign_up_view.dart';
import 'package:flutter_news_app/feature/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin SignupMixin on ConsumerState<SignUpView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController confirmPasswordController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool isRequestAvailable = false;
  bool isGoogleLoading = false;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  bool obscureText = true;
  bool isTermsAgreed = true; // Implied consent by clicking button

  @override
  void initState() {
    confirmPasswordController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  /// Creates a new user account with provided credentials.
  /// Returns nothing, state handled by view listener.
  Future<void> signupUser() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    validateFields();
    if (isRequestAvailable && isTermsAgreed) {
      await ref
          .read(authViewModelProvider.notifier)
          .signup(
            emailController.text.trim(),
            passwordController.text.trim(),
            confirmPasswordController.text.trim(),
          );
    }
  }

  /// Validates form fields and terms agreement.
  /// Updates request availability and shows appropriate messages.
  void validateFields() {
    if (formKey.currentState!.validate() && isTermsAgreed) {
      setState(() {
        isRequestAvailable = true;
      });
    } else {
      setState(() {
        autoValidateMode = AutovalidateMode.always;
        isRequestAvailable = false;
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
