import 'package:flutter/material.dart';
import 'package:grow/features/Home/presentation/views/widgets/Home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeViewBody(),
    );
  }
}