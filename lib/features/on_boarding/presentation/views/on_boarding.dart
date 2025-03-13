import 'package:flutter/material.dart';
import 'package:grow/features/dashboard/presentation/views/dashboard_view.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Image.asset(
          'images/Rectangle 15 (1).png',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        const SizedBox(
          height: 40,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            '"The Smart Irrigation Application is an innovative system that utilizes  AI technologies to efficiently monitor and manage irrigation. By leveraging this technology, farmers can control water usage based on soil and weather data, optimizing resource management. This, in turn, reduces water waste and enhances productivity, contributing to sustainable and efficient agriculture."',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        const Spacer(),
         InkWell(
           onTap: (){
            Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const  DashboardScreen()),
      );
           },
           child: Container(
             width: 150,
             padding: const EdgeInsets.all(6.0),
             decoration: BoxDecoration(
               color: Colors.grey[200],
               borderRadius: BorderRadius.circular(10),
             ),
             child: const Center(
               child:  Text(
                'Skip',
                style: TextStyle(fontSize: 25,),
                       ),
             ),
           ),
         ),
        const Spacer(),
      ],
    ));
  }
}