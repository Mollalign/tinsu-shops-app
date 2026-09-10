import 'package:flutter/material.dart';

/// Worker shell — Sell only.
/// No bottom navigation bar; the sell screen fills the entire viewport.
class WorkerShell extends StatelessWidget {
  final Widget child;
  const WorkerShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
}
