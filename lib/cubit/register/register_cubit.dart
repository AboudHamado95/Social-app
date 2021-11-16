import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/register/register_states.dart';
import 'package:socialapp/models/user.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(RegisterLoadingState());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(
          uId: value.user!.uid,
          name: name,
          email: email,
          phone: phone,
          image:
              'https://management4volunteers.files.wordpress.com/2013/05/communication-pattern1.jpg',
          cover:
              'https://assets-global.website-files.com/5b5aa355afe474a8b1329a37/5b983ec8d826746dbdde7949_1509990774-communication-both-ways-article.png');
    }).catchError((error) {
      emit(RegisterErrorState(error));
    });
  }

  Future<void> userCreate({
    required String uId,
    required String name,
    required String email,
    required String phone,
    required String image,
    required String cover,
  }) async {
    SocialUser model = SocialUser(
        uId: uId,
        name: name,
        email: email,
        phone: phone,
        image: image,
        cover: cover,
        bio: 'write your bio...',
        isEmailVerified: false);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }
}
