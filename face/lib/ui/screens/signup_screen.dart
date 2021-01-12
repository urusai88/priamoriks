import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../import.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var nameController = TextEditingController();

  var name = '';
  var loading = false;

  LaravelErrorBag errorBag;

  Future<void> onButtonTap() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    setState(() {
      loading = true;
      errorBag = null;
    });

    try {
      final resp = await authService.signin(name: name);

      await Hive.box('box').put('api_token', resp.apiToken);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen()),
        (route) => false,
      );
    } on DioError catch (e) {
      setState(() => errorBag = LaravelErrorBag.fromJson(e.response.data));
    } finally {
      setState(() => loading = false);
    }
  }

  void onUpdate() {
    setState(() => errorBag = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Регистрация / Авторизация',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 300,
              ),
              child: Container(
                height: 80,
                alignment: Alignment.topCenter,
                child: TextField(
                  controller: nameController,
                  onChanged: (s) {
                    onUpdate();
                    setState(() => name = s.trim());
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Имя пользователя',
                    errorText: LaravelErrorBag.getError('name', errorBag),
                    errorMaxLines: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 64,
              child: Center(
                child: loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: onButtonTap,
                        child: Text('Войти'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
