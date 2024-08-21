import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  SettingsTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final Icon? leading;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: myBoxDecoration(context),
      child: InkWell(
        borderRadius: BorderRadius.circular(15), // Ограничение сплэш-эффекта
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: Row(
            children: [
              if (leading != null) leading!,
              if (leading != null) const SizedBox(width: 10.0),
              center(),
              if (leading != null) const SizedBox(width: 10.0),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }

  Expanded center() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16.0),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
            ),
        ],
      ),
    );
  }
}

BoxDecoration myBoxDecoration(
  BuildContext context, {
  double width = 1.5,
  double borderRadius = 15,
}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: Theme.of(context).colorScheme.primary,
      width: width,
    ),
  );
}
