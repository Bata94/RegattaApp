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

