import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:regatta_app/provider/auth.dart';
import 'package:regatta_app/screens/admin/index.dart';
import 'package:regatta_app/screens/admin/theme_show.dart';
import 'package:regatta_app/screens/buero/abmeldung.dart';
import 'package:regatta_app/screens/buero/index.dart';
import 'package:regatta_app/screens/buero/waage.dart';
import 'package:regatta_app/screens/ergebnisse/index.dart';
import 'package:regatta_app/screens/home.dart';
import 'package:regatta_app/screens/leiter/drv_upload.dart';
import 'package:regatta_app/screens/leiter/index.dart';
import 'package:regatta_app/screens/leiter/pausen.dart';
import 'package:regatta_app/screens/leiter/setzung_change.dart';
import 'package:regatta_app/screens/leiter/setzungslosung.dart';
import 'package:regatta_app/screens/leiter/startnummernvergabe.dart';
import 'package:regatta_app/screens/leiter/zeitplan.dart';
import 'package:regatta_app/screens/login.dart';
import 'package:regatta_app/screens/startlisten/index.dart';
import 'package:regatta_app/screens/zeitnahme/index.dart';
import 'package:regatta_app/services/navigation.dart';
import 'package:regatta_app/services/shared_preference.dart';
import 'package:regatta_app/models/user.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';

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
        navigatorKey: NavigationService.navigatorKey,
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
                  return easyFutureBuilder(
                    Provider.of<AuthProvider>(context, listen: false).getUserFromApi(snapshot.data as JWT),
                    (data) {
                      if (data == null) {
                        UserPreferences().removeUser();
                        return const Login();
                      }
                      return const Home();
                    },
                  );

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
          '/leitung/setzungslosung': (context) => const Setzungslosung(),
          '/leitung/setzunganpassen': (context) => const SetzungChange(),
          '/leitung/startnummernvergabe': (context) => const Startnummernvergabe(),
          '/leitung/pausen': (context) => const Pausen(),
          '/leitung/zeitplan': (context) => const Zeitplan(),

          '/buero': (context) => const BueroIndex(),
          '/buero/abmeldung': (context) => const BueroAbmeldung(),
          '/buero/waage': (context) => const BueroWaage(),

          '/admin': (context) => const AdminIndex(),
          '/admin/themeshow': (context) => const ThemeShowCase(),
        },
      ),
    );
  }
}
