import 'package:dio/dio.dart';
import 'package:face/data/auth_service.dart';
import 'package:face/import.dart';
import 'package:face/main.dart';
import 'package:face/ui/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Interceptor tokenInterceptor;

  @override
  void initState() {
    super.initState();

    Future(asyncInitState);
  }

  void switchToSigninScreen() {
    Provider.of<Dio>(context, listen: false)
        .interceptors
        .remove(tokenInterceptor);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
      (route) => false,
    );
  }

  Future<void> asyncInitState() async {
    final box = Hive.box('box');

    if (box.containsKey('api_token')) {
      final apiToken = box.get('api_token');
      final dio = Provider.of<Dio>(context, listen: false);

      tokenInterceptor = InterceptorsWrapper(
        onRequest: (request) {
          return request..headers['authorization'] = 'Bearer $apiToken';
        },
      );

      dio.interceptors.insert(dio.interceptors.length - 1, tokenInterceptor);

      try {
        final user =
            await Provider.of<AuthService>(context, listen: false).user();

        if (user != null) {
          Provider.of<UserManager>(context, listen: false).userEntity = user;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false,
          );
        } else {
          switchToSigninScreen();
        }
      } catch (e) {
        switchToSigninScreen();
      }
    } else {
      switchToSigninScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
