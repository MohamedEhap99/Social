import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart'; 

class RegisterCubit extends Cubit<RegisterStates>{

  RegisterCubit():super(initialState());
  static RegisterCubit get(context)=>BlocProvider.of(context);

void userRegister({
     required String name,
     required String email,
     required String password,
     required String phone,
   }){
   FirebaseAuth.instance.createUserWithEmailAndPassword(
       email: email,
       password: password,
   ).then((value){
     emit(RegisterLoadingState());
     print(value.user!.email);
     print(value.user!.uid);
     userCreate(
         name: name,
         email: email,
         phone: phone,
         uId: value.user!.uid.toString(),
     );
     //emit(RegisterSuccessStateState());
   }).catchError((error){
     emit(RegisterErrorState(error.toString()));
   });
   }

   void userCreate({
     required String name,
     required String email,
     required String phone,
     required String uId,
}){
  UserModel?model=UserModel(
    name: name,
    email: email,
    phone: phone,
    uId: uId,
    cover:'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
    image:'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
    bio:'write your bio ...',
    isEmailVerified: false,
    uPosts: [],
  );
  FirebaseFirestore.instance
      .collection('users')
      .doc(uId)
      .set(model.toMap()).then((value){
        emit(CreatUserSuccessStateState());
  }).catchError((error){
    emit(CreatUserErrorState(error.toString()));
  });
   }

  IconData suffixIcon=Icons.visibility_outlined;
  bool isPassword=true;
  changePasswordShow(){
    isPassword=!isPassword;
    suffixIcon=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(ChangePasswordShowState());
  }


}