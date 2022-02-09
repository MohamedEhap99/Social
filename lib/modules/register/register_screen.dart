import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_screen.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';

class RegisterScreen extends StatelessWidget {
  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var phoneController=TextEditingController();
  var formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context)=>RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(
        listener:(context,state){
          if(state is CreatUserSuccessStateState) {
         navigateAndFinish(context, HomeScreen());
          }
        },
        builder:(context,state){
          return Scaffold(
            backgroundColor:Colors.white,
            appBar:AppBar(
              backgroundColor:Colors.white,
              elevation:0.0,
            ),
            body:SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  key:formKey,
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Text(
                          'REGISTER',
                      style:Theme.of(context).textTheme.headline4!.copyWith(
                        color:Colors.black,
                      ),
                      ),
                      Text(
                        'Register now to communicate with friends',
                        style:Theme.of(context).textTheme.bodyText1!.copyWith(
                          color:Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height:30.0,
                      ),
                      defaultFormField(
                          labeltext:'name',
                          style:TextStyle(
                            color:Colors.black,
                          ),
                          prefixicon:Icons.person,
                          fillcolor:Colors.white,
                          filled:true,
                          borderradius:BorderRadius.circular(30.0),
                          borderside:BorderSide(width:2.0,color:Colors.indigo) ,
                          obscuretext:false,
                          keyboardtype:TextInputType.name,
                          controller:nameController,
                          onSubmit:(String?value){
                             if(formKey.currentState!.validate()){
                               RegisterCubit.get(context).userRegister(
                                 name: nameController.text,
                                 email: emailController.text,
                                 password: passwordController.text,
                                 phone: phoneController.text,
                               );
                             }
                          },
                          validate:(String?value ){
                            if(value!.trim().length<3 || value.isEmpty){
                              return 'Username too short';
                            }
                            else if(value.trim().length>12 ){
                              return 'Username too long';
                            }
                            else{
                              return null;
                            }

                          }
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
                               RegisterCubit.get(context).userRegister(
                                 name: nameController.text,
                                 email: emailController.text,
                                 password: passwordController.text,
                                 phone: phoneController.text,
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
                            RegisterCubit.get(context).changePasswordShow();
                          },
                          fillcolor:Colors.white,
                          filled:true,
                          borderradius:BorderRadius.circular(30.0),
                          borderside:BorderSide(width:2.0,color:Colors.indigo) ,
                          obscuretext:RegisterCubit.get(context).isPassword,
                          keyboardtype:TextInputType.visiblePassword,
                          controller:passwordController,
                          onSubmit:(String?value){
                             if(formKey.currentState!.validate()){
                               RegisterCubit.get(context).userRegister(
                                 name: nameController.text,
                                 email: emailController.text,
                                 password: passwordController.text,
                                 phone: phoneController.text,
                               );
                             }
                          },
                          validate:(String?value ){
                            if(value!.trim().length<=3 || value.isEmpty){
                              return 'Password too short';
                            }
                            else if(value.trim().length>12 ){
                              return 'Password too long';
                            }
                            else{
                              return null;
                            }

                          }
                      ),
                      SizedBox(
                        height:20,
                      ),
                      defaultFormField(
                          labeltext:'phone',
                          style:TextStyle(
                            color:Colors.black,
                          ),
                          prefixicon:Icons.phone,
                          fillcolor:Colors.white,
                          filled:true,
                          borderradius:BorderRadius.circular(30.0),
                          borderside:BorderSide(width:2.0,color:Colors.indigo) ,
                          obscuretext:false,
                          keyboardtype:TextInputType.phone,
                          controller:phoneController,
                          onSubmit:(String?value){
                             if(formKey.currentState!.validate()){
                               RegisterCubit.get(context).userRegister(
                                 name: nameController.text,
                                 email: emailController.text,
                                 password: passwordController.text,
                                 phone: phoneController.text,
                               );
                             }
                          },

                          validate:(String?value ){
                            if(value!.trim().length<11 || value.isEmpty){
                              return 'The phone number must be 11 digits';
                            }
                            else if(value.trim().length>11 ){
                              return 'The phone number must be 11 digits';
                            }
                            else{
                              return null;
                            }

                          }
                      ),
                      SizedBox(
                        height:20,
                      ),
                      ConditionalBuilder(
                        condition:state is !RegisterLoadingState,
                        builder:(context)=>defaultMaterialButton(
                          onpressed: () {
                             if(formKey.currentState!.validate()){
                               RegisterCubit.get(context).userRegister(
                                 name: nameController.text,
                                 email: emailController.text,
                                 password: passwordController.text,
                                 phone: phoneController.text,
                               );
                             }
                          },
                          text:'register',
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

                    ],
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
