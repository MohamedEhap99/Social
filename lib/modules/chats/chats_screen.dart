import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        return ConditionalBuilder(
          condition:SocialCubit.get(context).users.length>0 ,
          builder: (BuildContext context)=>ListView.separated(
            physics:BouncingScrollPhysics(),
            itemBuilder:(context,index)=>buildChatItem(SocialCubit.get(context).users[index],context),
            separatorBuilder:(context,index)=>Container(
              width:double.infinity,
              height:1.0,
              color: Colors.grey,
            ),
            itemCount:SocialCubit.get(context).users.length,
          ),
          fallback: (BuildContext context)=>Center(child: CircularProgressIndicator()),

        );
      },

    );
  }

  Widget buildChatItem(UserModel?userModel,context)=>InkWell(
    onTap:(){
navigateTo(context, ChatDetailsScreen(userModel));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              '${userModel!.image}',
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            '${userModel.name}',
            style: TextStyle(
              height: 1.4,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
