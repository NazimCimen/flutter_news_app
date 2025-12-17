import 'package:flutter/material.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';

/// NO NEWS ITEM WIDGET - DISPLAYS EMPTY STATE WHEN NO NEWS AVAILABLE
class NoNewsItem extends StatelessWidget {
  const NoNewsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.article_outlined, size: 64),
          SizedBox(height: context.cMediumValue),
          Text(
            StringConstants.noNewsYet,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
