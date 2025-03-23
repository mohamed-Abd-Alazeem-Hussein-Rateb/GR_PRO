part of 'auth_cubit_cubit.dart';

sealed class AuthCubitState extends Equatable {
  const AuthCubitState();

  @override
  List<Object> get props => [];
}

final class AuthCubitInitial extends AuthCubitState {}


class AuthLoading extends AuthCubitState {}

// نجاح التسجيل
class AuthSignUpSuccess extends AuthCubitState {
  final User? user;
  AuthSignUpSuccess(this.user);
}

// نجاح تسجيل الدخول
class AuthSignInSuccess extends AuthCubitState {
  final User? user;
  AuthSignInSuccess(this.user);
}

// نجاح طلب تغيير كلمة المرور
class AuthForgetPasswordSuccess extends AuthCubitState {}

// نجاح استرجاع بيانات المستخدم
class AuthProfileSuccess extends AuthCubitState {
  final User user;
  AuthProfileSuccess(this.user);
}

// نجاح تسجيل الخروج
class AuthSignOutSuccess extends AuthCubitState {}

class AuthFailure extends AuthCubitState {
  final String? error;
  AuthFailure({this.error});
}
