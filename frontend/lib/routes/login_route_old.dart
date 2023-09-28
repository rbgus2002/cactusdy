import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

@deprecated
class LoginTest extends StatelessWidget {
  static const title = 'SnowDeer\'s Login Example';
  static const String defaultImageFile = 'assets/images/default_profile.png';
  static const String domain = 'http://localhost:8080/user';
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  void _callLogin() async {
    var url = Uri.parse('$domain/test');

    Map data = {"email": _email, "password": _password};
    var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data)
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
//            appBar: AppBar(title: Text(title)),
          body: Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      defaultImageFile,
                      width: 160,
                      height: 160,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Input email',
                          ),
                          onSaved: (value) {
                            _email = value as String;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            } else if (value
                                .toString()
                                .length < 8) {
                              return 'Please enter email more than size 8';
                            }
                            return null;
                          },
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (value) {
                            _password = value as String;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Input password',
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: const Text("Login"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              print('$_email/$_password');
                              _callLogin();
                            }
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                            child: const Text("Cancel"),
                            onPressed: () =>
                            {
                              Navigator.pop(context),
                            })
                      ],
                    )
                  ],
                ),
              )),
        ));
  }
}
