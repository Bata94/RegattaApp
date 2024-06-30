import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regatta_app/provider/user.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.watch<UserProvider>().user!.username));
    // return BaseLayout(
    //   "MRG Regatta",
    //   GridView.extent(
    //     maxCrossAxisExtent: 400,
    //     padding: const EdgeInsets.all(24),
    //     mainAxisSpacing: 24,
    //     crossAxisSpacing: 24,
    //     childAspectRatio: 1.8,
    //     children: [
    //       NavBtn(
    //         context,
    //         Icons.watch,
    //         "/zeitnahme",
    //         "Zeitnahme",
    //       ),
    //       NavBtn(
    //         context,
    //         Icons.assignment,
    //         "/startlisten",
    //         "Startlisten",
    //       ),
    //       NavBtn(
    //         context,
    //         Icons.computer,
    //         "/ergebnisse",
    //         "Ergebnisse",
    //       ),
    //       NavBtn(
    //         context,
    //         Icons.person,
    //         "/regattaleiter",
    //         "Regattaleiter",
    //       ),
    //       NavBtn(
    //         context,
    //         Icons.computer,
    //         "/regattabuero",
    //         "Regattabüro",
    //       ),
    //       // NavBtn(
    //       //   context,
    //       //   Icons.admin_panel_settings,
    //       //   "/admin",
    //       //   "Admin",
    //       // ),
    //     ],
    //   ),
    // );
  }
}
