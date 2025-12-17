import 'dart:async';
import 'package:flutter_news_app/feature/auth/view/sign_up_view.dart';
import 'package:flutter_news_app/feature/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// SIGNUP MIXIN IS USED TO MANAGE SIGNUP LOGIC
mixin SignupMixin on ConsumerState<SignUpView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController confirmPasswordController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool isRequestAvailable = false;
  bool isGoogleLoading = false;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  bool obscureText = true;
  bool isTermsAgreed = true;

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

  Future<void> signupUser() async {
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

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void makeRequestUnavailable() {
    setState(() {
      isRequestAvailable = false;
    });
  }
}
