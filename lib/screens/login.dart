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

  Widget textField(String labelStr, IconData icon, void Function(String?) onSaved, {bool obscureText=false}) {
    Widget label = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: 8,),
        Text(
          labelStr,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label,
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
                      "Username:",
                      Icons.person,
                      (val) => _username = val ?? "",
                    ),
                    textField(
                      "Password:",
                      Icons.key,
                      (val) => _password = val ?? "",
                      obscureText: true,
                    ),
                    loginBtn(authProv)
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
