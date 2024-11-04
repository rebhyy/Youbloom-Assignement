import 'package:flutter/material.dart';
import '../cubits/login/login_cubit.dart';
import 'otp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Phone number is required';
    }
    // Validate if the phone number is in E.164 format (simplified check)
    final phoneRegex = RegExp(
        r'^\+[1-9]\d{1,14}$'); // This regex checks if the number starts with '+' and has 8 to 15 digits total
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number in international format starting with +';
    }
    return null;
  }

  String formatPhoneNumber(String phoneNumber) {
    // Assuming phoneNumber is obtained from IntlPhoneField and already in complete format
    // This function should check if the number starts with '+' and has only digits afterwards
    String formattedNumber =
        phoneNumber.replaceAll(RegExp(r'\D'), ''); // Remove all non-digits
    if (!formattedNumber.startsWith('+')) {
      formattedNumber = '+' + formattedNumber;
    }
    return formattedNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xfff7f6fb),
      body: SafeArea(
        child: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 24,
                left: 32,
                right: 32,
                bottom: isKeyboardVisible
                    ? MediaQuery.of(context).viewInsets.bottom
                    : 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/images/illustration-2.png'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        'Registration',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Add your phone number. We'll send you a verification code so we know you're real",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          IntlPhoneField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode:
                                'TN', // Ensure this is the correct country code for Tunisia
                            onChanged: (phone) {
                              // Check if the phone object is not null and then access completeNumber
                              if (phone != null) {
                                print("Changed: " + phone.completeNumber);
                                // Set the complete number to the controller
                                _phoneController.text = phone.completeNumber;
                              }
                            },
                            onSaved: (phone) {
                              // Similarly, check for null before accessing completeNumber
                              if (phone != null) {
                                _phoneController.text = phone.completeNumber;
                              }
                            },
                            validator: (phone) {
                              // Ensure phone is not null and not empty
                              if (phone == null ||
                                  phone.completeNumber.isEmpty) {
                                return 'Phone number is required';
                              }
                              // Use the complete number for regex match
                              if (!RegExp(r'^\+[1-9]\d{1,14}$')
                                  .hasMatch(phone.completeNumber)) {
                                return 'Enter a valid phone number in international format starting with +';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true; // Show loading indicator
                                  });
                                  // Format phone number to E.164
                                  String formattedPhoneNumber =
                                      formatPhoneNumber(_phoneController.text);
                                  print(
                                      "Formatted Phone Number: $formattedPhoneNumber"); // Log to debug

                                  // Send OTP
                                  context
                                      .read<LoginCubit>()
                                      .sendOtp(formattedPhoneNumber);

                                  // Navigate to OTP screen after sending OTP
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const Otp()));

                                  setState(() {
                                    _isLoading =
                                        false; // Hide loading indicator
                                  });
                                }
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.purple),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator() // Show loading indicator
                                  : const Padding(
                                      padding: EdgeInsets.all(14.0),
                                      child: Text(
                                        'Send',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
