import 'package:flutter/material.dart';
import 'package:regatta_app/widgets/nav_bar.dart';

class BaseLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  const BaseLayout(this.title, this.body, {this.floatingActionButton, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(
        context,
        title: title,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

