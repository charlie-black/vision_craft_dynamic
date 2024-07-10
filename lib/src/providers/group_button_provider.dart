import 'package:flutter/foundation.dart';

class GroupButtonModel extends ChangeNotifier {
  String _selectedChip = "";

  String get selectedItem => _selectedChip;

  void setSelectedItem(String selectedItem) {
    _selectedChip = selectedItem;
    notifyListeners();
  }
}
