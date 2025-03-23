import 'package:flutter/material.dart';
import 'package:grow/features/auth/presentation/views/sign_up.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على حجم الشاشة
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // الصورة تأخذ 40% من ارتفاع الشاشة
                  SizedBox(
                    height: size.height * 0.4,
                    width: double.infinity,
                    child: Image.asset(
                      'images/Rectangle 15 (1).png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  // النص مع Padding نسبياً
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Text(
                      '"The Smart Irrigation Application is an innovative system that utilizes AI technologies to efficiently monitor and manage irrigation. By leveraging this technology, farmers can control water usage based on soil and weather data, optimizing resource management. This, in turn, reduces water waste and enhances productivity, contributing to sustainable and efficient agriculture."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.width * 0.05, // حجم النص كنسبة من عرض الشاشة
                      ),
                    ),
                  ),
                  const Spacer(),
                  // زر Skip بحجم نسبي
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>  SignUp()),
                      );
                    },
                    child: Container(
                      width: size.width * 0.4, // 40% من عرض الشاشة
                      padding: EdgeInsets.all(size.width * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: size.width * 0.06, // حجم النص كنسبة من عرض الشاشة
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
