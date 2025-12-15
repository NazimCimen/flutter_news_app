import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/data/model/news_model.dart';

class CategoryNewsCard extends StatelessWidget {
  final NewsModel news;

  const CategoryNewsCard({required this.news, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.cMediumValue),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Source Logo
          if (news.sourceProfilePictureUrl != null)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: news.sourceProfilePictureUrl!,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(
                    Icons.newspaper,
                    size: 20,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          SizedBox(width: context.cMediumValue),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Source Name and Time
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        news.sourceTitle ?? 'Unknown Source',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      ' • ${_formatTime(news.publishedAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
                SizedBox(height: context.cSmallValue * 0.5),

                // Title
                Text(
                  news.title ?? 'No Title',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(width: context.cSmallValue),

          // News Image (if available)
          if (news.imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: news.imageUrl!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFFF5252),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 80,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.cSmallValue),
          ],

          // Bookmark Icon
          Icon(
            news.isSaved ?? false ? Icons.bookmark : Icons.bookmark_outline,
            color: news.isSaved ?? false
                ? const Color(0xFFFF5252)
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
            size: 20,
          ),
        ],
      ),
    );
  }

  String _formatTime(String? publishedAt) {
    if (publishedAt == null) return '';
    
    try {
      final date = DateTime.parse(publishedAt);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} dakika önce';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} saat önce';
      } else {
        return '${difference.inDays} gün önce';
      }
    } catch (e) {
      return '';
    }
  }
}
