import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/search/search_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/cubit/cubit.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  bool switchvalue=true;
  final items=const[
    Icon(Icons.home_filled,size:30,),
    Icon(Icons.chat,size:30,),
    Icon(Icons.camera_alt,size:30,),
    Icon(Icons.person,size:30,),
    Icon(Icons.settings,size:30,),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is NewPostState){
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit=SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              Icon(IconBroken.Notification),
              SizedBox(
                width:15.0,
              ),
              IconButton(
                onPressed: () {
                  navigateTo(context, SearchScreen());
                },
                icon: Icon(IconBroken.Search),

              ),
              SizedBox(
                width:15.0,
              ),
              IconButton(
                  onPressed:(){
                    AppCubit.get(context).ChangeAppMode();
                  },
                  icon:AppCubit.get(context).isDark?Icon(Icons.brightness_4_outlined)
                      :Icon(Icons.brightness_3_outlined),
              ),
            ],
          ),
          body:cubit.screens[cubit.currentIndex],
          bottomNavigationBar:CurvedNavigationBar(
            items:items,
            index:cubit.currentIndex,
            onTap:(index){
              cubit.changeItemBottomNavBar(index);
            },
            height:70,
            backgroundColor:Colors.indigo,
            animationDuration: const Duration(milliseconds:300),
          ),
        );
      },
    );
  }
}
