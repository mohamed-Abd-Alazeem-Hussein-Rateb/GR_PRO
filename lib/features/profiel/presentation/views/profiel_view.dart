import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow/features/auth/presentation/manage/cubit/auth_cubit_cubit.dart';
import 'package:grow/features/auth/presentation/views/sign_in.dart';

class ProfielView extends StatefulWidget {
  const ProfielView({super.key});

  @override
  State<ProfielView> createState() => _ProfielViewState();
}

class _ProfielViewState extends State<ProfielView> {
  @override
  void initState() {
    super.initState();
    // استدعاء دالة getProfile() لجلب بيانات المستخدم
    context.read<AuthCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthCubitState>(
      listener: (context, state) {
        if (state is AuthSignOutSuccess) {
          // عند تسجيل الخروج بننتقل لشاشة تسجيل الدخول
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
          );
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? 'Error')),
          );
        }
      },
      builder: (context, state) {
        // استخرج بيانات المستخدم إذا كانت متاحة
        final user = state is AuthProfileSuccess ? state.user : null;

        return Scaffold(
          backgroundColor: Colors.green[50],
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                children: [
                  const SizedBox(height: 90),
                  Center(child: Image.asset('images/Ellipse 2 (1).png')),
                  const SizedBox(height: 40),
                  // حقل الاسم
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: user?.displayName ?? '',
                      prefixIcon: const Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // حقل البريد الإلكتروني
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: user?.email ?? '',
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // حقل الباسورد (عادةً لا تعرض كلمة السر)
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      // لا يتم عرض كلمة السر هنا
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // زر تسجيل الخروج
                  Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 36, 134, 40),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        context.read<AuthCubit>().signOut();
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
