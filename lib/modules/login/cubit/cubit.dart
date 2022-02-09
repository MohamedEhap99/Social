  import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/layout/home_screen.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';

class LoginCubit extends Cubit<LoginStates>{

  LoginCubit():super(InitialState());
  static LoginCubit get(context)=>BlocProvider.of(context);

   userLogin({
     required String email,
     required String password,
   }){
     emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value){
      print(value.user!.email);
      print(value.user!.uid);
      emit(LoginSuccessStateState(value.user!.uid));
    }).catchError((error){
      emit(LoginErrorState(error.toString()));
    });
   }




  IconData suffixIcon=Icons.visibility_outlined;
  bool isPassword=true;
  changePasswordVisibility(){
    isPassword=!isPassword;
    suffixIcon=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityState());
  }

// Sign in With Google

// Future<UserCredential> signInWithGoogle()async{
//     emit(SignInWithGoogleState());
//     final GoogleSignInAccount? googleUser=await GoogleSignIn().signIn();
//     //obtain the auth details from request
//   final GoogleSignInAuthentication googleAuth=await googleUser!.authentication;
//   //create a new credential
//   final AuthCredential credential=GoogleAuthProvider.credential(
//     accessToken: googleAuth.accessToken,
//     idToken:googleAuth.idToken,
//   );
//   //Once  signed in, return the  Usercredential
//   return await  FirebaseAuth.instance.signInWithCredential(credential).then((value){
//
//   });
// }

   FirebaseAuth _auth = FirebaseAuth.instance;
   GoogleSignIn googleSignIn = GoogleSignIn();

   Future<void> signInWithGoogle(context) async {
     GoogleSignInAccount? account = await googleSignIn.signIn();
     GoogleSignInAuthentication authentication = await account!.authentication;
     AuthCredential credential = GoogleAuthProvider.credential(
         idToken: authentication.idToken,
         accessToken: authentication.accessToken);
     final user = await (_auth.signInWithCredential(credential)).then((value) {
       if (value != null) {
         print('${value.user!.email}');
         navigateTo(context, HomeScreen());
       }
       emit(LoginSuccessStateState(value.user!.uid));
     }).catchError((error) {
       print('errrrrorrrrr When Sign in${error.toString()}');
     });
   }

}