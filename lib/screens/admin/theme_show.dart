import 'package:flutter/material.dart';
import 'package:regatta_app/widgets/base_layout.dart';

class ThemeShowCase extends StatelessWidget {
  const ThemeShowCase ({super.key});

  Widget colorRow(BuildContext context, String name1, Color color1, String name2, Color color2) {
    Widget colorContainer(String name, Color color) {
      return Container(
        width: MediaQuery.of(context).size.width * .4,
        height: 40,
        color: color,
        child: Center(child: Text(name)),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        colorContainer(name1, color1),
        colorContainer(name2, color2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return BaseLayout(
      "Theme Show Case",
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              colorRow(context, "Primary", theme.primaryColor, "PrimaryDark", theme.primaryColorDark),
              colorRow(context, "Canvas", theme.canvasColor, "Card", theme.cardColor),
              const Divider(),
              Text("DisplayLarge", style: textTheme.displayLarge),
              Text("DisplayMedium", style: textTheme.displayMedium),
              Text("DisplaySmall", style: textTheme.displaySmall),
              Text("HeadlineLarge", style: textTheme.headlineLarge),
              Text("HeadlineMedium", style: textTheme.headlineMedium),
              Text("HeadlineSmall", style: textTheme.headlineSmall),
              Text("TitleLarge", style: textTheme.titleLarge),
              Text("TitleMedium", style: textTheme.titleMedium),
              Text("TitleSmall", style: textTheme.titleSmall),
              Text("BodyLarge", style: textTheme.bodyLarge),
              Text("BodyMedium", style: textTheme.bodyMedium),
              Text("BodySmall", style: textTheme.bodySmall),
              Text("LabelLarge", style: textTheme.labelLarge),
              Text("LabelMedium", style: textTheme.labelMedium),
              Text("LabelSmall", style: textTheme.labelSmall),
              const Divider(),
              ElevatedButton(onPressed: () {}, child: const Text("Default"))
            ],
          ),
        ),
      ),
    );
  }
}
