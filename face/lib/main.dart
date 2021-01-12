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

class UserManager {
  UserEntity userEntity;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserManager userManager;

  Dio dio;
  AuthService authService;
  ContactsService contactService;

  @override
  void initState() {
    super.initState();

    userManager = UserManager();

    dio = Dio(BaseOptions(baseUrl: 'http://192.168.1.101:8000/api'));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options) {
        return options..headers['accept'] = 'application/json';
      },
    ));

    authService = AuthService(dio, baseUrl: 'http://192.168.1.101:8000/api');
    contactService =
        ContactsService(dio, baseUrl: 'http://192.168.1.101:8000/api/contacts');
  }

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: 'Priamoriks Demo',
      home: LoadingScreen(),
    );

    final provider = MultiProvider(
      providers: [
        Provider<Dio>.value(value: dio),
        Provider<AuthService>.value(value: authService),
        Provider<ContactsService>.value(value: contactService),
        Provider<UserManager>.value(value: userManager),
      ],
      child: app,
    );

    return provider;
  }
}
