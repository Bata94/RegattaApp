import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:regatta_app/provider/auth.dart';
import 'package:regatta_app/provider/zeitnahme_ziel.dart';
import 'package:regatta_app/screens/home.dart';
import 'package:regatta_app/services/navigation.dart';
import 'package:regatta_app/screens/login.dart';
import 'package:regatta_app/services/routes.dart';
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
        ChangeNotifierProvider(create: (context) => ZeitnahmeZielProvider()),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        title: 'MRG Regatta App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            // seedColor: Colors.blue,
            seedColor: const Color.fromRGBO(34, 79, 170, 1.0),
            brightness: Brightness.light,
            // dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
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
        routes: appRoutes,
      ),
    );
  }
}
