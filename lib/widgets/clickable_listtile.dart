import 'package:flutter/material.dart';

class ClickableListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function()? onTap;
  const ClickableListTile({
    super.key,
    required this.title,
    this.subtitle = "",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );

    if (subtitle != "") {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Divider(),
          Text(
            subtitle,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.black54),
          ),
        ],
      );
    }

    Widget listTile = Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black45,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: body,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: listTile,
      );
    } else {
      return listTile;
    }
  }
}

