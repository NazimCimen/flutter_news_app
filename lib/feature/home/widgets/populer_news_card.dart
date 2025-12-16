part of 'news_tab.dart';

class _PopularNewsCard extends StatelessWidget {
  final NewsModel news;
  final VoidCallback? onBookmarkTap;

  const _PopularNewsCard({
    required this.news,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return ClipRRect(
      borderRadius: context.cBorderRadiusAllMedium,
      child: Stack(
        children: [
          // Background Image with Loading
          if (news.imageUrl != null)
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: news.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: colorScheme.primary.withValues(alpha: 0.3),
                  highlightColor: colorScheme.primary.withValues(alpha: 0.1),
                  child: Container(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.image_not_supported_outlined,
                  color: colorScheme.onPrimary.withValues(alpha: 0.7),
                  size: 48,
                ),
              ),
            )
          else
            Positioned.fill(
              child: Container(color: colorScheme.primary),
            ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.black.withValues(alpha: 0.5),
                    AppColors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),

          // Category Badge (Top Left)
          if (news.categoryName != null)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  news.categoryName!,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Bookmark Icon (Top Right)
          Positioned(
            top: 16,
            right: 16,
            child: InkWell(
              onTap: onBookmarkTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  (news.isSaved ?? false)
                      ? Icons.bookmark
                      : Icons.bookmark_outline,
                  color: (news.isSaved ?? false)
                      ? colorScheme.secondary
                      : AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          // Content (Bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(context.cMediumValue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    news.title ?? StringConstants.noTitle,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      shadows: [
                        Shadow(
                          color: AppColors.black.withValues(alpha: 0.8),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.cSmallValue),

                  // Source Info
                  Row(
                    children: [
                      // Source Logo
                      if (news.sourceProfilePictureUrl != null)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 1.5,
                            ),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: news.sourceProfilePictureUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Icon(
                                Icons.newspaper,
                                size: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(width: context.cSmallValue),

                      // Source Name
                      Expanded(
                        child: Text(
                          news.sourceTitle ?? StringConstants.unknownSource,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
