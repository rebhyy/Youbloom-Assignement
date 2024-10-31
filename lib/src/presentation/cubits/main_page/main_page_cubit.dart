import 'package:flutter_bloc/flutter_bloc.dart';

class MainPageCubit extends Cubit<List<String>> {
  List<String> _allItems = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"];

  MainPageCubit() : super([]);

  void fetchItems() {
    emit(_allItems);
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      emit(_allItems);
    } else {
      emit(_allItems.where((item) => item.contains(query)).toList());
    }
  }
}
