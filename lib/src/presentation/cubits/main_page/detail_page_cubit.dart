import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPageCubit extends Cubit<String?> {
  DetailPageCubit() : super(null);

  void loadItemDetails(String item) {
    emit(item); // In a real app, fetch additional details for the item here
  }
}
