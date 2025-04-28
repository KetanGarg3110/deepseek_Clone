import 'package:flutter/material.dart';

class OnBoardingProvider extends ChangeNotifier {
  int _currentIndex = 0;

  PageController pageController = PageController(initialPage: 0);

  int get currentIndex => _currentIndex;

  void changePage(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentIndex < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
