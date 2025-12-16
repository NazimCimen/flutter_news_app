import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/config/theme/app_colors.dart';
import 'package:flutter_news_app/core/utils/size/app_border_radius_extensions.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/data/model/tweet_model.dart';

class TweetCard extends StatelessWidget {
  final TweetModel tweet;

  const TweetCard({required this.tweet, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(context.cMediumValue),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: context.cBorderRadiusAllMedium,
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Profile + Name + Time
          Row(
            children: [
              // Profile Image
              if (tweet.accountImageUrl != null)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: tweet.accountImageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(
                        Icons.account_circle,
                        size: 40,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                )
              else
                Icon(
                  Icons.account_circle,
                  size: 40,
                  color: colorScheme.primary,
                ),

              SizedBox(width: context.cSmallValue),

              // Account Name + Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tweet.accountName ?? 'Unknown',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (tweet.accountId != null)
                      Text(
                        '@${tweet.accountId}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Time
              if (tweet.createdAt != null)
                Text(
                  tweet.createdAt!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),

          SizedBox(height: context.cSmallValue),

          // Tweet Content
          if (tweet.content != null)
            Text(
              tweet.content!,
              style: textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),

          // Popular Badge
          if (tweet.isPopular ?? false) ...[
            SizedBox(height: context.cSmallValue),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.cSmallValue,
                vertical: context.cSmallValue * 0.5,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.trending_up,
                    size: 14,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: context.cSmallValue * 0.5),
                  Text(
                    'Popüler',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
