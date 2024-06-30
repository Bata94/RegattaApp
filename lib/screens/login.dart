import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:regatta_app/provider/auth.dart';
import 'package:regatta_app/widgets/base_layout.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";

  Widget textField(String label, void Function(String?) onSaved, {bool obscureText=false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextFormField(
          autofocus: false,
          obscureText: obscureText,
          validator: (value) => value!.isEmpty ? "Bitte ausfüllen!" : null,
          onSaved: onSaved,
        ),
      ],
    );
  }

  Widget loginBtn(AuthProvider auth) {
    String label = "Login";
    bool enabled = true;

    if (auth.loggedInStatus == Status.Authenticating) {
      label = "Laden... Bitte warten!";
      enabled = false;
    }

    return ElevatedButton(
      onPressed: enabled ? () => _login(auth) : null,
      child: Text(label),
    );
  }

  void _login(AuthProvider auth) async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    final FormState form = formKey.currentState!;
    form.save();

    final Future<bool> successfulMessage =
      auth.login(_username, _password);

    successfulMessage.then((response) {
      if (response) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        debugPrint("Failed Login: $response");
        // Flushbar(
        //   title: "Failed Login",
        //   message: response['message']['message'].toString(),
        //   duration: Duration(seconds: 3),
        // ).show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProv = Provider.of<AuthProvider>(context);

    return BaseLayout(
      "Login",
      Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                textField(
                  "Username:",
                  (val) => _username = val ?? "",
                ),
                textField(
                  "Password:",
                  (val) => _password = val ?? "",
                  obscureText: true,
                ),
                loginBtn(authProv)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
