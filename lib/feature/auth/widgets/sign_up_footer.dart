import 'package:flutter/material.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/config/routes/app_routes.dart';
import 'package:flutter_news_app/config/theme/app_colors.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:go_router/go_router.dart';

class SignupFooter extends StatelessWidget {
  const SignupFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            text: 'By creating an account, you agree to our ',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.grey, height: 1.5),
            children: [
              TextSpan(
                text: 'Terms of Service',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              TextSpan(
                text: ' and ',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
              TextSpan(
                text: 'Privacy Policy.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.cMediumValue),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              StringConstants.allreadyHaveAccount,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push(AppRoutes.login);
              },
              child: Text(
                ' ${StringConstants.signInButton}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
