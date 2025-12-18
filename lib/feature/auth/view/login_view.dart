import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/config/routes/app_routes.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/core/utils/size/padding_extension.dart';
import 'package:flutter_news_app/core/utils/app_validators.dart';
import 'package:flutter_news_app/feature/auth/mixin/login_mixin.dart';
import 'package:flutter_news_app/feature/auth/widgets/auth_header.dart';
import 'package:flutter_news_app/app/common/widgets/custom_button.dart';
import 'package:flutter_news_app/feature/auth/widgets/custom_password_text_field.dart';
import 'package:flutter_news_app/feature/auth/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/feature/auth/widgets/forget_password_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/feature/auth/view_model/auth_view_model.dart';
import 'package:flutter_news_app/app/common/components/custom_snack_bars.dart';
import 'package:go_router/go_router.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> with LoginMixin {
  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (previous, next) {
      next.when(
        data: (_) {
          context.go(AppRoutes.selectSources);
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
                child: Padding(
                  padding: context.paddingHorizAllMedium,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: context.cMediumValue),
                        AuthHeader(
                          title: StringConstants.loginTitle,
                          subtitle: StringConstants.loginSubtitle,
                        ),
                        SizedBox(height: context.cXLargeValue),
                        CustomTextFormField(
                          controller: mailController,
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
                          hintText: StringConstants.passwordHint,  validator: (value) =>
                              AppValidators.passwordValidator(value),
                        ),
                        SizedBox(height: context.cMediumValue),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: ForgetPasswordButton(),
                        ),
                        SizedBox(height: context.cMediumValue),
                        CustomButtonWidget(
                          onPressed: () async {
                            await loginUser();
                          },
                          text: StringConstants.signInButton,
                          isLoading: isRequestAvailable,
                        ),
                        SizedBox(height: context.cMediumValue),
                        CustomButtonWidget(
                          onPressed: () {
                            context.push(AppRoutes.signup);
                          },
                          text: StringConstants.signUpButton,
                          isLoading: false,
                          buttonType: ButtonType.outlined,
                        ),
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
