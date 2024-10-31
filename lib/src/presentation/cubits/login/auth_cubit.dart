import 'package:flutter_bloc/flutter_bloc.dart';

// Define states for each stage of the authentication process
enum AuthState { welcome, login, register, otp }

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.welcome);

  // Move to login page
  void goToLogin() => emit(AuthState.login);

  // Move to register page
  void goToRegister() => emit(AuthState.register);

  // Move to OTP page
  void goToOtp() => emit(AuthState.otp);

  // Return to welcome page
  void goToWelcome() => emit(AuthState.welcome);
}
