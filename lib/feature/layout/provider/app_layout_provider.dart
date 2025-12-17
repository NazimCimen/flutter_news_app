import 'package:flutter_riverpod/flutter_riverpod.dart';

/// APP LAYOUT PROVIDER - MANAGES NAVIGATION BETWEEN TABS
final appLayoutProvider = StateNotifierProvider<AppLayoutNotifier, int>((ref) {
  return AppLayoutNotifier();
});

/// NOTIFIER FOR MANAGING THE CURRENT TAB INDEX
class AppLayoutNotifier extends StateNotifier<int> {
  AppLayoutNotifier() : super(0);

  /// CHANGE THE CURRENT NAVIGATION INDEX
  void changeTab(int index) {
    if (index >= 0 && index < 5) {
      state = index;
    }
  }

  /// NAVIGATE TO HOME TAB
  void goToHome() {
    state = 0;
  }

  /// NAVIGATE TO AGENDA TAB
  void goToAgenda() {
    state = 1;
  }

  /// NAVIGATE TO BREAKING NEWS TAB
  void goToBreakingNews() {
    state = 2;
  }

  /// NAVIGATE TO SAVED TAB
  void goToSaved() {
    state = 3;
  }

  /// NAVIGATE TO LOCAL TAB
  void goToLocalNews() {
    state = 4;
  }
}
