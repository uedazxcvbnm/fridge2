import 'package:flutter/foundation.dart';

class NavBarProvider extends ChangeNotifier {
  int _currentPage = 0;
  set currentPage(int pageInt) {
    _currentPage = pageInt;
    notifyListeners();
  }

  int get currentPage => _currentPage;
}
