import 'package:flutter_bloc/flutter_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginCubit extends Cubit<LoginStatus> {
  LoginCubit() : super(LoginStatus.initial);

  void login(String phone, String otp) async {
    emit(LoginStatus.loading);

    // Simulate a network request with a delay
    await Future.delayed(Duration(seconds: 2));

    // Mock validation - change as needed
    if (phone == "123456" && otp == "1234") {
      emit(LoginStatus.success);
    } else {
      emit(LoginStatus.failure);
    }
  }
}
