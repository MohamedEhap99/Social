import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_screen.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/networks/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context)=>LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener:(context,state){
          if(state is LoginErrorState) {
            showToast(
                text: '${state.error }',
                state:ToastStates.ERROR,
            );
          }
          if(state is LoginSuccessStateState){
            CacheHelper.saveData(
                key: 'uId',
              value: state.uId,
            ).then((value){
navigateAndFinish(context, HomeScreen());
            });
          }

        },
        builder:(context,state){
          return Scaffold(
            backgroundColor:Colors.white,
            appBar:AppBar(
              backgroundColor:Colors.white,
              elevation:0.0,
            ),
            body:Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key:formKey,
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style:TextStyle(
                            fontSize:40.0,
                            fontWeight:FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height:10.0,
                        ),
                        Text(
                          'Login now to communicate with friends',
                          style:TextStyle(
                            fontSize:15.0,
                            fontWeight: FontWeight.bold,
                            color:Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height:20.0,
                        ),
                        defaultFormField(
                            labeltext:'Email Address',
                            style:TextStyle(
                              color:Colors.black,
                            ),
                            prefixicon:Icons.email,
                            fillcolor:Colors.white,
                            filled:true,
                            borderradius:BorderRadius.circular(30.0),
                            borderside:BorderSide(width:2.0,color:Colors.indigo) ,
                            obscuretext:false,
                            keyboardtype:TextInputType.emailAddress,
                            controller:emailController,
                            onSubmit:(String?value){
                               if(formKey.currentState!.validate()){
                                 LoginCubit.get(context).userLogin(
                                   email: emailController.text,
                                   password: passwordController.text,
                                 );
                               }
                            },
                            validate:(String?value ){
                              if(value!.isEmpty){
                                return 'required';
                              }
                              return null;
                            }
                        ),
                        SizedBox(
                          height:20.0,
                        ),
                        defaultFormField(
                            labeltext:'Password',
                            style:TextStyle(
                              color:Colors.black,
                            ),
                            prefixicon:Icons.lock_outline_rounded,
                            suffixicon:Icons.visibility_outlined,
                            suffixpressed:(){
                              LoginCubit.get(context).changePasswordVisibility();
                            },
                            fillcolor:Colors.white,
                            filled:true,
                            borderradius:BorderRadius.circular(30.0),
                            borderside:BorderSide(width:2.0,color:Colors.indigo) ,
                            obscuretext:LoginCubit.get(context).isPassword,
                            keyboardtype:TextInputType.visiblePassword,
                            controller:passwordController,
                            onSubmit:(String?value){
                               if(formKey.currentState!.validate()){
                                 LoginCubit.get(context).userLogin(
                                   email: emailController.text,
                                   password: passwordController.text,
                                 );
                               }
                            },
                            validate:(String?value ){
                              if(value!.isEmpty){
                                return 'required';
                              }
                              return null;
                            }
                        ),
                        SizedBox(
                          height:20,
                        ),
                        ConditionalBuilder(
                          condition:state is !LoginLoadingState,
                          builder:(context)=>defaultMaterialButton(
                            onpressed: () {
                               if(formKey.currentState!.validate()){
                                 LoginCubit.get(context).userLogin(
                                   email: emailController.text,
                                   password: passwordController.text,
                                 );
                               }

                            },
                            text:'login',
                            style:TextStyle(
                              color:Colors.white,
                            ),
                            shape:RoundedRectangleBorder(
                              borderRadius:BorderRadius.circular(25.0) ,
                            ),
                            color:Colors.indigo,
                            minwidth:400.0,
                            height:50.0,
                          ),
                          fallback:(context)=>Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height:20,
                        ),
                    Center(
                      child: InkWell(
                        onTap: () =>LoginCubit.get(context).signInWithGoogle(context),
                        child: Container(
                          width:200.0,
                          height:50.0,
                          child: Row(
                            children: [
                              Image(
                                image: AssetImage('assets/images/google_signin_button.png'),
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: Container(
                                  width:200.0,
                                  height:50.0,
                                  color:Colors.indigo,
                                  child: Center(
                                    child: Text(
                                      'Sign in with Google',
                                      style:TextStyle(
                                        color:Colors.white,
                                        fontWeight:FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                        SizedBox(
                          height:10,
                        ),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                            ),
                            SizedBox(
                              width:5.0,
                            ),
                            TextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              child: Text(
                                'REGISTER',
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },

      ),
    );
  }
}
