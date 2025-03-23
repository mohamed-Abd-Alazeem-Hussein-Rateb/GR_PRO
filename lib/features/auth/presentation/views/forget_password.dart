import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow/features/auth/presentation/manage/cubit/auth_cubit_cubit.dart';
import 'package:grow/features/auth/presentation/views/sign_in.dart';
import 'package:grow/features/auth/presentation/views/widgets/custom_Text_form_field.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthCubitState>(
      listener: (context, state) {
        
        if (state is AuthForgetPasswordSuccess) {
          // عند نجاح إرسال طلب استعادة كلمة السر
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent!')),
          );
        }
        if (state is AuthFailure) {
          // عند حدوث خطأ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? 'Error')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.green[50],
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Center(child: Image.asset('images/photo (3).png')),
                  const SizedBox(height: 5),
                  const Text(
                    'Forget Password',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enter your registered email below',
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    lableText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    controller: emailController,
                    obscureText: false,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Remember your password?',
                        style: TextStyle(fontSize: 18),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignIn(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.green, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 36, 134, 40),
                    ),
                    child: MaterialButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                // استدعاء دالة forgetPassword من AuthCubit
                                context.read<AuthCubit>().forgetPassword(
                                      email: emailController.text.trim(),
                                    );
                              }
                            },
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            )
                          : const Text(
                              'Submit',
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
