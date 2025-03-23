import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grow/features/on_boarding/presentation/views/on_boarding.dart';
import 'package:grow/features/auth/presentation/views/sign_in.dart';
import 'package:grow/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplachView extends StatefulWidget {
  const SplachView({super.key});

  @override
  State<SplachView> createState() => _SplachViewState();
}

class _SplachViewState extends State<SplachView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      // التحقق من حالة تسجيل الدخول عبر FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;
      
      // استخدام SharedPreferences للتحقق من انتهاء OnBoarding
      final prefs = await SharedPreferences.getInstance();
      final onBoardingDone = prefs.getBool('onBoardingDone') ?? false;
      
      if (user != null) {
        // إذا كان المستخدم مسجل دخوله، نتوجه مباشرةً إلى Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        // لو المستخدم مش مسجل دخوله، ننتقل إلى OnBoarding إذا لم ينتهي، وإلا إلى شاشة تسجيل الدخول
        if (!onBoardingDone) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnBoarding()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2A602E),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset('images/photo (3).png')),
          const Center(
            child: Text(
              'AgriGrow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            
          ),
        ],
      ),
    );
  }
}
