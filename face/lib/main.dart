import 'package:dio/dio.dart';
import 'package:face/import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('box');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Dio dio;
  AuthService authService;

  @override
  void initState() {
    super.initState();

    dio = Dio(BaseOptions(baseUrl: 'http://192.168.1.101:8000/api'));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options) {
        return options..headers['accept'] = 'application/json';
      },
    ));

    authService = AuthService(dio);
  }

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: 'Priamoriks Demo',
      home: SignupScreen(),
    );

    final provider = MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
      ],
      child: app,
    );

    return provider;
  }
}
