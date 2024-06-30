import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:regatta_app/provider/auth.dart';
import 'package:regatta_app/provider/user.dart';
import 'package:regatta_app/screens/home.dart';
import 'package:regatta_app/screens/login.dart';
import 'package:regatta_app/screens/welcome.dart';
import 'package:regatta_app/services/shared_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'MRG Regatta App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: FutureBuilder(
          future: UserPreferences().getUser(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  return const Login();
                } else {
                  UserPreferences().removeUser();
                  return Welcome(user: snapshot.data!);
                }
            }
        }),
        routes: {
          '/home': (context) => const Home(),
          '/login': (context) => const Login(),
        },
      ),
    );
  }
}
