import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart'; // Import AutoRoute package
import '../cubits/login/login_cubit.dart';
import '../../config/router/app_router.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocProvider(
        create: (_) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginStatus>(
          listener: (context, state) {
            if (state == LoginStatus.success) {
              context.router
                  .replace(MainPageRoute()); // Use auto_route's navigation
            } else if (state == LoginStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login Failed')),
              );
            }
          },
          builder: (context, state) {
            if (state == LoginStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'OTP'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LoginCubit>().login("123456", "1234");
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
