import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum LoginStatus { initial, loading, otpSent, success, failure }

class LoginCubit extends Cubit<LoginStatus> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  LoginCubit() : super(LoginStatus.initial);

  Future<void> sendOtp(String phoneNumber) async {
    emit(LoginStatus.loading);

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        emit(LoginStatus.success);
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(LoginStatus.failure);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        emit(LoginStatus.otpSent);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> verifyOtp(String otp) async {
    if (_verificationId == null) {
      emit(LoginStatus.failure);
      return;
    }

    emit(LoginStatus.loading);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      emit(LoginStatus.success);
    } catch (e) {
      emit(LoginStatus.failure);
    }
  }
}
