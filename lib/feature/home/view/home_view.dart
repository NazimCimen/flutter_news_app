import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/feature/home/viewmodel/home_view_model.dart';
import 'package:flutter_news_app/feature/home/widgets/news_tab.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // TabBar
          TabBar(
            padding: EdgeInsets.symmetric(horizontal: context.cMediumValue),
            controller: _tabController,
            indicatorColor: const Color(0xFFFF5252),
            labelColor: const Color(0xFFFF5252),
            labelStyle: Theme.of(context).textTheme.bodySmall,
            unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
            dividerColor: Colors.transparent,
            labelPadding: EdgeInsets.zero,
            tabs: const [
              Tab(text: 'Son Haberler'),
              Tab(text: 'Sana Özel'),
              Tab(text: 'Twitter'),
              Tab(text: 'YouTube'),
            ],
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                NewsTab(provider: popularNewsProvider),
                NewsTab(provider: personalizedNewsProvider),
                _buildPlaceholder('Twitter'),
                _buildPlaceholder('YouTube'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: context.cMediumValue),
          Text(
            '$title içeriği',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Yakında eklenecek',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
