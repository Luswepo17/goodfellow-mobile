import 'package:flutter/material.dart';

class BillCustomDialog extends StatelessWidget {
  const BillCustomDialog(
      {super.key,
      this.title,
      this.message,
      this.content,
      this.actions,
      this.icon,
      required this.isLoading,
      this.iconBackgroundColor,
      this.contentPadding});

  final String? title;
  final String? message;
  final Widget? content;
  final List<Widget>? actions;
  final Widget? icon;
  final bool isLoading;
  final Color? iconBackgroundColor;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: content ?? Text(message ?? ""),
      actions: actions,
    );
  }
}
