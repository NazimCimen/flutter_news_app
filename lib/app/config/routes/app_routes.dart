import 'package:flutter_news_app/app/data/model/category_model.dart';
import 'package:flutter_news_app/feature/auth/view/login_view.dart';
import 'package:flutter_news_app/feature/auth/view/sign_up_view.dart';
import 'package:flutter_news_app/feature/category_news/view/category_news_view.dart';
import 'package:flutter_news_app/feature/layout/view/app_layout.dart';
import 'package:flutter_news_app/feature/sources/view/select_sources_view.dart';
import 'package:flutter_news_app/feature/splash/splash_view.dart';
import 'package:go_router/go_router.dart';

/// APP ROUTES FOR THE APP
final class AppRoutes {
  const AppRoutes._();

  static const String initialRoute = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String selectSources = '/select_sources';
  static const String mainLayout = '/main_layout';
  static const String categoryNews = '/category_news';

  static final GoRouter router = GoRouter(
    initialLocation: initialRoute,

    routes: [
      GoRoute(
        path: initialRoute,
        name: 'splash',
        builder: (context, state) => const SplashView(),
      ),

      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),

      GoRoute(
        path: signup,
        name: 'signup',
        builder: (context, state) => const SignUpView(),
      ),

      GoRoute(
        path: selectSources,
        name: 'selectSources',
        builder: (context, state) => const SelectSourcesView(),
      ),
      GoRoute(
        path: mainLayout,
        name: 'mainLayout',
        builder: (context, state) => const AppLayout(),
      ),
      GoRoute(
        path: categoryNews,
        name: 'categoryNews',
        builder: (context, state) {
          final category = state.extra as CategoryModel;
          return CategoryNewsView(category: category);
        },
      ),
    ],
  );
}
