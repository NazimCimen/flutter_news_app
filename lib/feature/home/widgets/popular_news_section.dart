import 'package:flutter/material.dart';
import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:flutter_news_app/feature/home/widgets/popular_news_card.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';

class PopularNewsSection extends StatefulWidget {
  final List<NewsModel> news;

  const PopularNewsSection({required this.news, super.key});

  @override
  State<PopularNewsSection> createState() => _PopularNewsSectionState();
}

class _PopularNewsSectionState extends State<PopularNewsSection> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.news.length > 10 ? 10 : widget.news.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.cMediumValue),
          child: Text(
            'Popüler Haberler',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: context.cMediumValue),
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: context.cSmallValue),
                child: PopularNewsCard(news: widget.news[index]),
              );
            },
          ),
        ),
        SizedBox(height: context.cSmallValue),
        // Page indicators
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              itemCount,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentPage == index
                      ? const Color(0xFFFF5252)
                      : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
