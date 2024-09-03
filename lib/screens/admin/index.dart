import 'package:flutter/material.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/layout_grid.dart';
import 'package:regatta_app/widgets/nav_btn.dart';

class AdminIndex extends StatelessWidget {
  const AdminIndex({super.key});

  @override
  Widget build(BuildContext context) {
      return BaseLayout(
      "Admin",
      LayoutGrid([
          NavBtn(
            context,
            Icons.colorize,
            "/admin/themeshow",
            "ThemeShowCase",
          ),
          NavBtn(
            context,
            Icons.question_mark,
            "/admin/test",
            "TestPage",
          ),
        ],
      ),
    );
  }
}
