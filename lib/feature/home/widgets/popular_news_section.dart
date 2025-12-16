part of 'news_tab.dart';

class _PopularNewsSection extends StatefulWidget {
  final List<NewsModel> news;
  final Function(NewsModel)? onBookmarkTap;

  const _PopularNewsSection({
    required this.news,
    this.onBookmarkTap,
  });

  @override
  State<_PopularNewsSection> createState() => _PopularNewsSectionState();
}

class _PopularNewsSectionState extends State<_PopularNewsSection> {
  int _currentPage = 0;
  final _carouselController = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    final itemCount = widget.news.length > 10 ? 10 : widget.news.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.cMediumValue),
          child: Text(
            StringConstants.popularNews,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: context.cMediumValue),
        
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final news = widget.news[index];
            return _PopularNewsCard(
              news: news,
              onBookmarkTap: widget.onBookmarkTap != null
                  ? () => widget.onBookmarkTap!(news)
                  : null,
            );
          },
          options: CarouselOptions(
            height: 280,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            enlargeFactor: 0.15,
            enableInfiniteScroll: itemCount > 1,
            onPageChanged: (int index, CarouselPageChangedReason reason) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        
        SizedBox(height: context.cMediumValue),
        
        // Smooth page indicators
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: _currentPage,
            count: itemCount,
            effect: ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 4,
              activeDotColor: const Color(0xFFFF5252),
              dotColor: Colors.grey.shade400,
            ),
            onDotClicked: (int index) {
              _carouselController.animateToPage(index);
            },
          ),
        ),
      ],
    );
  }
}
