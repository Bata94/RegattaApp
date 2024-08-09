import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:regatta_app/provider/auth.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/dialog.dart';
import 'package:regatta_app/widgets/text_input.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";

  Widget loginBtn(BuildContext context, AuthProvider auth) {
    String label = "Login";
    bool enabled = true;

    if (auth.loggedInStatus == Status.Authenticating) {
      label = "Laden... Bitte warten!";
      enabled = false;
    }

    return ElevatedButton(
      onPressed: enabled ? () => _login(Provider.of<AuthProvider>(context, listen: false)) : null,
      child: Text(label),
    );
  }

  void _login(AuthProvider auth) async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    final FormState form = formKey.currentState!;
    form.save();

    final Future<bool> successfulMessage = auth.login(_username, _password);

    successfulMessage.then((response) {
      if (response) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        dialogError(context, "Login fehlgeschlagen", "Login fehlgeschlagen. Bitte versuchen Sie es erneut.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    return BaseLayout(
      "Login",
      Center(
        child: SizedBox(
          height: 400,
          width: 320,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/mrg_logo.png",
                      width: 80,
                      height: 80,
                    ),
                    textField(
                      context,
                      "Username:",
                      Icons.person,
                      (val) => _username = val ?? "",
                    ),
                    textField(
                      context,
                      "Password:",
                      Icons.key,
                      (val) => _password = val ?? "",
                      obscureText: true,
                    ),
                    loginBtn(context, auth),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
