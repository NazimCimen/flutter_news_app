import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing app layout navigation state
final appLayoutProvider = StateNotifierProvider<AppLayoutNotifier, int>((ref) {
  return AppLayoutNotifier();
});

/// Notifier for managing the current tab index
class AppLayoutNotifier extends StateNotifier<int> {
  AppLayoutNotifier() : super(0);

  /// Change the current navigation index
  void changeTab(int index) {
    if (index >= 0 && index < 5) {
      state = index;
    }
  }

  /// Navigate to Home tab
  void goToHome() {
    state = 0;
  }

  /// Navigate to Agenda tab
  void goToAgenda() {
    state = 1;
  }

  /// Navigate to Breaking News tab
  void goToBreakingNews() {
    state = 2;
  }

  /// Navigate to Saved tab
  void goToSaved() {
    state = 3;
  }

  /// Navigate to Local tab
  void goToLocalNews() {
    state = 4;
  }
}
