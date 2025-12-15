import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/core/utils/size/padding_extension.dart';
import 'package:flutter_news_app/core/utils/app_validators.dart';
import 'package:flutter_news_app/feature/auth/mixin/sign_up_mixin.dart';
import 'package:flutter_news_app/feature/auth/widgets/auth_header.dart';
import 'package:flutter_news_app/common/widgets/custom_button.dart';
import 'package:flutter_news_app/feature/auth/widgets/custom_password_text_field.dart';
import 'package:flutter_news_app/feature/auth/widgets/custom_text_form_field.dart';
import 'package:flutter_news_app/feature/auth/widgets/sign_up_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/feature/auth/view_model/auth_view_model.dart';
import 'package:flutter_news_app/common/componets/custom_snack_bars.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_news_app/config/routes/app_routes.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> with SignupMixin {
  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (previous, next) {
      next.when(
        data: (_) {
          context.go(AppRoutes.mainLayout);
        },
        error: (error, stackTrace) {
          makeRequestUnavailable();
          CustomSnackBars.showCustomBottomScaffoldSnackBar(
            context: context,
            text: error.toString(),
          );
        },
        loading: () {},
      );
    });

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: context.paddingHorizAllMedium,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: context.cXLargeValue),
                        AuthHeader(
                          title: StringConstants.signUpTitle,
                          subtitle: StringConstants.signUpSubtitle,
                        ),

                        SizedBox(height: context.cXLargeValue),
                        CustomTextFormField(
                          controller: emailController,
                          validator: (value) =>
                              AppValidators.emailValidator(value),
                          topLabel: StringConstants.emailLabel,
                          hintText: StringConstants.emailHint,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: context.cMediumValue),
                        CustomPasswordTextField(
                          controller: passwordController,
                          obsecureText: obscureText,
                          changeObsecureText: togglePasswordVisibility,
                          topLabel: StringConstants.passwordLabel,
                          hintText: StringConstants.passwordHint,
                        ),
                        SizedBox(height: context.cMediumValue),
                        CustomPasswordTextField(
                          controller: confirmPasswordController,
                          obsecureText: obscureText,
                          changeObsecureText: togglePasswordVisibility,
                          topLabel: StringConstants.confirmPasswordLabel,
                          hintText: StringConstants.passwordHint,
                        ),
                        SizedBox(height: context.cXLargeValue),
                        CustomButtonWidget(
                          onPressed: () async {
                            await signupUser();
                          },
                          text: StringConstants.createAccount,
                          isLoading: isRequestAvailable,
                        ),
                        SizedBox(height: context.cXLargeValue),
                        const SignupFooter(),
                        SizedBox(height: context.cXLargeValue * 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
