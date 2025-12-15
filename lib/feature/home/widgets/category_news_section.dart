import 'package:flutter/material.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:flutter_news_app/feature/home/widgets/category_news_card.dart';

class CategoryNewsSection extends StatelessWidget {
  final String categoryName;
  final List<NewsModel> news;
  final VoidCallback onSeeMore;

  const CategoryNewsSection({
    required this.categoryName,
    required this.news,
    required this.onSeeMore,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Show only first 2 news
    final displayNews = news.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.cMediumValue),
          child: Row(
            children: [
              // Red line indicator
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5252),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: context.cSmallValue),
              
              // Category name
              Expanded(
                child: Text(
                  categoryName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // "Daha Fazla Göster" link
              TextButton(
                onPressed: onSeeMore,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Daha Fazla Göster',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: context.cMediumValue),

        // News Cards
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.cMediumValue),
          child: Column(
            children: [
              for (int i = 0; i < displayNews.length; i++) ...[
                CategoryNewsCard(news: displayNews[i]),
                if (i < displayNews.length - 1) SizedBox(height: context.cSmallValue),
              ],
            ],
          ),
        ),

        SizedBox(height: context.cMediumValue),

        // "Daha Fazla Göster" Button
        Center(
          child: ElevatedButton(
            onPressed: onSeeMore,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: context.cLargeValue,
                vertical: context.cSmallValue * 1.2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: Text(
              'Daha Fazla Göster',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
