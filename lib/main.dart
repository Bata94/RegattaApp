import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:regatta_app/provider/auth.dart';
import 'package:regatta_app/screens/admin/index.dart';
import 'package:regatta_app/screens/admin/theme_show.dart';
import 'package:regatta_app/screens/buero/index.dart';
import 'package:regatta_app/screens/ergebnisse/index.dart';
import 'package:regatta_app/screens/home.dart';
import 'package:regatta_app/screens/leiter/drv_upload.dart';
import 'package:regatta_app/screens/leiter/index.dart';
import 'package:regatta_app/screens/login.dart';
import 'package:regatta_app/screens/startlisten/index.dart';
import 'package:regatta_app/screens/zeitnahme/index.dart';
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
      ],
      child: MaterialApp(
        title: 'MRG Regatta App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
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
                  // TODO: Validate Token!
                  return const Home();
                  // UserPreferences().removeUser();
                  // return Welcome(user: snapshot.data!);
                }
            }
        }),
        routes: {
          '/home': (context) => const Home(),
          '/login': (context) => const Login(),

          '/zeitnahme': (context) => const ZeitnahmeIndex(),

          '/startlisten': (context) => const StartlistenIndex(),

          '/ergebnisse': (context) => const ErgebnisseIndex(),

          '/leitung': (context) => const LeitungIndex(),
          '/leitung/drvupload': (context) => const DrvUpload(),

          '/buero': (context) => const BueroIndex(),

          '/admin': (context) => const AdminIndex(),
          '/admin/themeshow': (context) => const ThemeShowCase(),
        },
      ),
    );
  }
}
