import 'package:flutter/material.dart';

class AuthorsSpacePage extends StatefulWidget {
  const AuthorsSpacePage({super.key});

  @override
  State<AuthorsSpacePage> createState() => _AuthorsSpacePageState();
}

class _AuthorsSpacePageState extends State<AuthorsSpacePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Author's Space",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}