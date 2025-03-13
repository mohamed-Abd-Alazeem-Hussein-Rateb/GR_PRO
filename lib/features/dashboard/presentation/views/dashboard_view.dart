import 'package:flutter/material.dart';
import 'package:grow/features/Home/presentation/views/home_view.dart';
import 'package:grow/features/Recomandation/presentation/views/reqomendation.dart';
import 'package:grow/features/Water/presentation/views/water_requierd.dart';
import 'package:grow/features/chat/presentation/views/chat_view.dart';
import 'package:grow/features/profiel/presentation/views/profiel_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeView(),
    WaterRequierd(),  // تم إضافة شاشة العربة هنا
    ChatView(),
    Reqomendation(),
    ProfielView()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_sync),  // أيقونة العربة
            label: 'Refresh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'share',
          ),
          BottomNavigationBarItem(
             icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 75, 232, 175),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}