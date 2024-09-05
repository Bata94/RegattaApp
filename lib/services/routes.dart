import 'package:flutter/material.dart';
import 'package:regatta_app/screens/admin/index.dart';
import 'package:regatta_app/screens/admin/test.dart';
import 'package:regatta_app/screens/admin/theme_show.dart';
import 'package:regatta_app/screens/buero/abmeldung.dart';
import 'package:regatta_app/screens/buero/athlet_anlegen.dart';
import 'package:regatta_app/screens/buero/index.dart';
import 'package:regatta_app/screens/buero/nachmeldung.dart';
import 'package:regatta_app/screens/buero/startberechtigung.dart';
import 'package:regatta_app/screens/buero/ummeldung.dart';
import 'package:regatta_app/screens/buero/waage.dart';
import 'package:regatta_app/screens/ergebnisse/index.dart';
import 'package:regatta_app/screens/home.dart';
import 'package:regatta_app/screens/leiter/drv_upload.dart';
import 'package:regatta_app/screens/leiter/index.dart';
import 'package:regatta_app/screens/leiter/meldeergebnis.dart';
import 'package:regatta_app/screens/leiter/pausen.dart';
import 'package:regatta_app/screens/leiter/setzung_change.dart';
import 'package:regatta_app/screens/leiter/setzungslosung.dart';
import 'package:regatta_app/screens/leiter/startnummernvergabe.dart';
import 'package:regatta_app/screens/leiter/zeitplan.dart';
import 'package:regatta_app/screens/login.dart';
import 'package:regatta_app/screens/startlisten/index.dart';
import 'package:regatta_app/screens/startlisten/startliste.dart';
import 'package:regatta_app/screens/zeitnahme/index.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  '/home': (context) => const Home(),
  '/login': (context) => const Login(),

  '/zeitnahme': (context) => const ZeitnahmeIndex(),

  '/startlisten': (context) => const StartlistenIndex(),
  '/startlisten/langstrecke': (context) => const Startliste(wettkampf: StartlisteWettkampf.langstrecke),
  '/startlisten/slalom': (context) => const Startliste(wettkampf: StartlisteWettkampf.slalom),
  '/startlisten/kurzstrecke': (context) => const Startliste(wettkampf: StartlisteWettkampf.kurzstrecke),
  '/startlisten/staffel': (context) => const Startliste(wettkampf: StartlisteWettkampf.staffel),

  '/ergebnisse': (context) => const ErgebnisseIndex(),

  '/leitung': (context) => const LeitungIndex(),
  '/leitung/drvupload': (context) => const DrvUpload(),
  '/leitung/setzungslosung': (context) => const Setzungslosung(),
  '/leitung/setzunganpassen': (context) => const SetzungChange(),
  '/leitung/startnummernvergabe': (context) => const Startnummernvergabe(),
  '/leitung/pausen': (context) => const Pausen(),
  '/leitung/zeitplan': (context) => const Zeitplan(),
  '/leitung/meldeergebnis': (context) => const LeitungMeldeergebnis(),

  '/buero': (context) => const BueroIndex(),
  '/buero/abmeldung': (context) => const BueroAbmeldung(),
  '/buero/ummeldung': (context) => const BueroUmmeldung(),
  '/buero/nachmeldung': (context) => const BueroNachmeldung(),
  '/buero/waage': (context) => const BueroWaage(),
  '/buero/startberechtigung': (context) => const BueroStartberechtigung(),
  '/buero/athletAnlegen': (context) => const BueroAthletAnlegen(),

  '/admin': (context) => const AdminIndex(),
  '/admin/themeshow': (context) => const ThemeShowCase(),
  '/admin/test': (context) => const AdminTest(),
};

class AppRoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final dynamic args = settings.arguments;
    switch (settings.name) {
      // Root Layer
      case '/':
        return MaterialPageRoute(
          builder: (_) => const Home(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const Home(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const Login(),
        );
      // Zeitnahme
      case '/zeitnahme': 
        return MaterialPageRoute(
          builder: (_) => const ZeitnahmeIndex(),
        );
      // Startlisten
      case '/startlisten': 
        if (args != null && args is StartlisteWettkampf) {
          return MaterialPageRoute(
            builder: (_) => Startliste(wettkampf: args,),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const StartlistenIndex(),
        );
      case '/startlisten/langstrecke': 
        return MaterialPageRoute(
          builder: (_) => const Startliste(wettkampf: StartlisteWettkampf.langstrecke),
        );
      case '/startlisten/slalom': 
        return MaterialPageRoute(
          builder: (_) => const Startliste(wettkampf: StartlisteWettkampf.slalom),
        );
      case '/startlisten/kurzstrecke': 
        return MaterialPageRoute(
          builder: (_) => const Startliste(wettkampf: StartlisteWettkampf.kurzstrecke),
        );
      case '/startlisten/staffel': 
        return MaterialPageRoute(
          builder: (_) => const Startliste(wettkampf: StartlisteWettkampf.staffel),
        );
      // Ergebnisse
      case '/ergebnisse': 
        return MaterialPageRoute(
          builder: (_) => const ErgebnisseIndex(),
        );
      // Leitung
      case '/leitung': 
        return MaterialPageRoute(
          builder: (_) => const LeitungIndex(),
        );
      case '/leitung/drvupload': 
        return MaterialPageRoute(
          builder: (_) => const DrvUpload(),
        );
      case '/leitung/setzungslosung': 
        return MaterialPageRoute(
          builder: (_) => const Setzungslosung(),
        );
      case '/leitung/setzunganpassen': 
        return MaterialPageRoute(
          builder: (_) => const SetzungChange(),
        );
      case '/leitung/startnummernvergabe': 
        return MaterialPageRoute(
          builder: (_) => const Startnummernvergabe(),
        );
      case '/leitung/pausen': 
        return MaterialPageRoute(
          builder: (_) => const Pausen(),
        );
      case '/leitung/zeitplan': 
        return MaterialPageRoute(
          builder: (_) => const Zeitplan(),
        );
      case '/leitung/meldeergebnis': 
        return MaterialPageRoute(
          builder: (_) => const LeitungMeldeergebnis(),
        );
      // Büro
      case '/buero': 
        return MaterialPageRoute(
          builder: (_) => const BueroIndex(),
        );
      case '/buero/abmeldung': 
        return MaterialPageRoute(
          builder: (_) => const BueroAbmeldung(),
        );
      case '/buero/ummeldung': 
        return MaterialPageRoute(
          builder: (_) => const BueroUmmeldung(),
        );
      case '/buero/nachmeldung': 
        return MaterialPageRoute(
          builder: (_) => const BueroNachmeldung(),
        );
      case '/buero/waage': 
        return MaterialPageRoute(
          builder: (_) => const BueroWaage(),
        );
      case '/buero/startberechtigung': 
        return MaterialPageRoute(
          builder: (_) => const BueroStartberechtigung(),
        );
      case '/buero/athletAnlegen': 
        return MaterialPageRoute(
          builder: (_) => const BueroAthletAnlegen(),
        );
      // Admin
      case '/admin': 
        return MaterialPageRoute(
          builder: (_) => const AdminIndex(),
        );
      case '/admin/themeshow': 
        return MaterialPageRoute(
          builder: (_) => const ThemeShowCase(),
        );
      case '/admin/test': 
        return MaterialPageRoute(
          builder: (_) => const AdminTest(),
        );
      // Def Route, maybe ErrorPage is better
      default:
        return MaterialPageRoute(
          builder: (_) => const Home(),
        );
    }
  }
}
