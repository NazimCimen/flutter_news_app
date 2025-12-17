import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/utils/size/app_border_radius_extensions.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/core/utils/size/padding_extension.dart';
import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:shimmer/shimmer.dart';

class CategoryNewsCard extends StatelessWidget {
  final NewsModel news;
  final VoidCallback? onBookmarkTap;

  const CategoryNewsCard({
    required this.news,
    this.onBookmarkTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(context.cMediumValue),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: context.cBorderRadiusAllSmall * 1.5,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (news.sourceProfilePictureUrl != null)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: news.sourceProfilePictureUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(
                        Icons.newspaper,
                        size: 20,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              SizedBox(width: context.cSmallValue),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${news.sourceTitle ?? StringConstants.unknownSource} • ${news.categoryName ?? StringConstants.general}',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      news.publishedAt ?? '',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.cMediumValue),

              InkWell(
                onTap: onBookmarkTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: context.cPaddingSmall,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.secondary.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    (news.isSaved ?? false)
                        ? Icons.bookmark
                        : Icons.bookmark_outline,
                    color: colorScheme.secondary.withValues(alpha: 0.7),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.cMediumValue),

          Text(
            news.title ?? StringConstants.noTitle,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.3,
              color: colorScheme.onSurface,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          if (news.imageUrl != null) ...[
            SizedBox(height: context.cMediumValue),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: news.imageUrl!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: colorScheme.primary.withValues(alpha: 0.3),
                  highlightColor: colorScheme.primary.withValues(alpha: 0.1),
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: double.infinity,
                  height: 180,
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 48,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
