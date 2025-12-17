part of '../view/twitter_tab_view.dart';

/// TWEET CARD WIDGET
class _TweetCard extends StatelessWidget {
  final TweetModel tweet;

  const _TweetCard({required this.tweet});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(context.cMediumValue),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: context.cBorderRadiusAllMedium,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              /// ACCOUNT AVATAR
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

              /// ACCOUNT NAME & ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tweet.accountName ?? '',
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

              SizedBox(width: context.cMediumValue),

              /// DATE
              if (tweet.createdAt != null)
                Text(
                  tweet.createdAt ?? '',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),

          SizedBox(height: context.cSmallValue),

          /// TWEET CONTENT
          if (tweet.content != null)
            Text(
              tweet.content!,
              style: textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
        ],
      ),
    );
  }
}
