import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener:(context,state){},
      builder:(context,state){
        var cubit=SocialCubit.get(context);
        return Scaffold(
          backgroundColor:Colors.white,
          appBar:cubit.buildSearchField(),
          body:cubit.searchResultFutures==null?cubit.buildNoContent(context):cubit.buildSearchResult(context),
        );
      },

    );
  }
}