import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/core/utils/size/app_border_radius_extensions.dart';
import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';

class PopularNewsCard extends StatelessWidget {
  final NewsModel news;

  const PopularNewsCard({required this.news, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: context.cBorderRadiusAllMedium,
        image: news.sourceProfilePictureUrl != null
            ? DecorationImage(
                image: CachedNetworkImageProvider(
                  news.sourceProfilePictureUrl!,
                ),
                fit: BoxFit.cover,
              )
            : null,
        color: news.sourceProfilePictureUrl == null
            ? Colors.blue.shade700
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: context.cBorderRadiusAllMedium,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.7),
              Colors.black.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: Stack(
          children: [
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
                    color: const Color(0xFFFF5252),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    news.categoryName!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            // Bookmark Icon (Top Right)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  news.isSaved == true
                      ? Icons.bookmark
                      : Icons.bookmark_outline,
                  color: news.isSaved == true
                      ? const Color(0xFFFF5252)
                      : Colors.white,
                  size: 20,
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
                      news.title ?? 'No Title',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
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
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: news.sourceProfilePictureUrl!,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.newspaper,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        SizedBox(width: context.cSmallValue),

                        // Source Name
                        Expanded(
                          child: Text(
                            news.sourceTitle ?? 'Unknown Source',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
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
      ),
    );
  }
}
