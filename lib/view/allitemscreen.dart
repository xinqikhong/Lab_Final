import 'package:flutter/material.dart';

class AllItemScreen extends StatefulWidget {
  const AllItemScreen({super.key});

  @override
  State<AllItemScreen> createState() => _AllItemScreenState();
}

class _AllItemScreenState extends State<AllItemScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text ("All Item"),
    );
  }
}