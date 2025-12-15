import 'package:flutter_news_app/core/utils/size/dynamic_size.dart';
import 'package:flutter_news_app/core/utils/size/padding_extension.dart';
import 'package:flutter/material.dart';

/// Custom error widget for the app
/// [title] is the title of the error widget
/// [iconData] is the icon data for the error widget
final class CustomErrorWidget extends StatelessWidget {
  final String title;
  final IconData iconData;
  const CustomErrorWidget({
    required this.title,
    required this.iconData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.paddingHorizAllXlarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: context.dynamicWidht(0.28),
              color: Theme.of(context).colorScheme.tertiary,
            ),
            SizedBox(height: context.dynamicHeight(0.02)),
            Text(
              maxLines: 3,
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: context.dynamicHeight(0.02)),
          ],
        ),
      ),
    );
  }
}
