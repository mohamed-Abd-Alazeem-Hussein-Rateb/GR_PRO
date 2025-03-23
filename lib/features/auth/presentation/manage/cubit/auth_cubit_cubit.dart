import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_cubit_state.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  AuthCubit({required this.firebaseAuth}) : super(AuthCubitInitial());
  final FirebaseAuth firebaseAuth;
   // Sign Up
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // تحديث اسم المستخدم بعد التسجيل
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();
      
      emit(AuthSignUpSuccess(userCredential.user));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(error: e.message));
    }
  }

  // Sign In
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSignInSuccess(userCredential.user));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(error: e.message));
    }
  }

  // Forget Password
  Future<void> forgetPassword({required String email}) async {
    try {
      emit(AuthLoading());
      await firebaseAuth.sendPasswordResetEmail(email: email);
      emit(AuthForgetPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(error: e.message));
    }
  }

  // Get Profile (يمكنك استخدام هذه الدالة لاسترجاع بيانات المستخدم الحالي)
  Future<void> getProfile() async {
    try {
      emit(AuthLoading());
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        emit(AuthProfileSuccess(user));
      } else {
        emit(AuthFailure(error: "No user logged in."));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      await firebaseAuth.signOut();
      emit(AuthSignOutSuccess());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

}
