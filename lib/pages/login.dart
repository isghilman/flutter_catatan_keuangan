import 'dart:convert';

import 'package:catatan_keuangan/helpers/database_helper.dart';
import 'package:catatan_keuangan/models/user.dart';
import 'package:catatan_keuangan/pages/home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bool _isLoading = true;

  final formKey = GlobalKey<FormState>();

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  //Here is our bool variable
  bool isLoginTrue = false;

  final db = DatabaseHelper();

  //Now we should call this function in login button
  _login() async {
    var response =
        await db.login(Users(username: username.text, password: password.text));
    if (response == true) {
      //If login is correct, then goto notes
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      //If not, true the bool value to show error message
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'Catatan Keuangan Sederhana',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // We will disable this message in default, when user and pass is incorrect we will trigger this message to user
                  isLoginTrue
                      ? const SizedBox(
                        height: 30,
                        child: Text(
                            "Username or passowrd is incorrect",
                            style: TextStyle(color: Colors.red),
                          ),
                      )
                      : const SizedBox(),
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                      hintText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Username harus diisi";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password harus diisi";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          )),
    );
  }
}
