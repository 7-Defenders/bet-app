import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final double? height;

  final Widget? leading;
  final String? title;
  final List<Widget>? actions;
  const CustomAppbar(this.height, this.leading, this.title, this.actions)
      : super();

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ?? Container(),
      title: Text(title ?? ''),
      actions: actions ?? [],
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
