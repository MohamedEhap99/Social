import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/comments/comments_screen.dart';
import 'package:social_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        var userModel=SocialCubit.get(context).userModel;
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height:190.0,
                    child: Stack(
                      alignment:AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Container(
                            height:140.0,
                            width:double.infinity,
                            decoration:BoxDecoration(
                              borderRadius:BorderRadius.only(
                                topLeft: Radius.circular(
                                  4.0,
                                ) ,
                                topRight: Radius.circular(
                                  4.0,
                                ) ,
                              ),
                              image:DecorationImage(
                                  image:NetworkImage(
                                    '${userModel!.cover}',
                                  ),
                                  fit:BoxFit.cover
                              ),
                            ),
                          ),
                          alignment:AlignmentDirectional.topCenter,
                        ),

                        CircleAvatar(
                          radius:63,
                          backgroundColor:Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius:60.0 ,
                            backgroundImage:NetworkImage(
                              '${userModel.image}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${userModel.name} ',
                    style:Theme.of(context).textTheme.bodyText1,
                    maxLines:1,
                    overflow:TextOverflow.ellipsis,

                  ),
                  Text(
                    '${userModel.bio}',
                    style:Theme.of(context).textTheme.caption,
                    maxLines:1,
                    overflow:TextOverflow.ellipsis,

                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '100',
                                style:Theme.of(context).textTheme.bodyText1,
                                maxLines:1,
                                overflow:TextOverflow.ellipsis,

                              ),
                              Text(
                                'Posts',
                                style:Theme.of(context).textTheme.caption,
                                maxLines:1,
                                overflow:TextOverflow.ellipsis,

                              ),
                            ],
                          ),
                          onTap:(){},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '265',
                                style:Theme.of(context).textTheme.bodyText1,
                                maxLines:1,
                                overflow:TextOverflow.ellipsis,

                              ),
                              Text(
                                'Photos',
                                style:Theme.of(context).textTheme.caption,
                                maxLines:1,
                                overflow:TextOverflow.ellipsis,

                              ),
                            ],
                          ),
                          onTap:(){},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '10k',
                                style:Theme.of(context).textTheme.bodyText1,
                                maxLines:1,
                                overflow:TextOverflow.ellipsis,

                              ),
                              Text(
                                'Followers',
                                style:Theme.of(context).textTheme.caption,
                                maxLines:1,
                                overflow:TextOverflow.ellipsis,

                              ),
                            ],
                          ),
                          onTap:(){},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '64',
                                style:Theme.of(context).textTheme.bodyText1,
                                maxLines:1,
                                overflow:TextOverflow.ellipsis,

                              ),
                              Text(
                                'Followings',
                                style:Theme.of(context).textTheme.caption,
                                maxLines:1,
                                overflow:TextOverflow.ellipsis,

                              ),
                            ],
                          ),
                          onTap:(){},
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:(){},
                          child:Text(
                              'Add Photos'
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      OutlinedButton(
                        onPressed:(){
                          navigateTo(context, EditProfileScreen());
                        },
                        child:Icon(
                          IconBroken.Edit,
                          size:16.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Container(
                        decoration:BoxDecoration(
                          borderRadius:BorderRadius.circular(10.0),
                          color:Colors.indigo,
                        ),
                       child:FlatButton(
                              onPressed:(){
                               },
                              child:Text(
                                'SignOut',
                                style:TextStyle(
                                    color:Colors.white
                                ),
                              ),
                            ),

                      ),
                    ],
                  ),
                  SizedBox(
                    height:10.0,
                  ),
                  ConditionalBuilder(
                    condition:SocialCubit.get(context).allPosts.length>0 && SocialCubit.get(context).userModel!=null,
                    builder: (BuildContext context)=>SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [

                          ListView.separated(
                            shrinkWrap:true,
                            physics:NeverScrollableScrollPhysics(),
                            itemBuilder:(context,index)=>buildPostItem(SocialCubit.get(context).allPosts[index],context,index),
                            separatorBuilder:(context,index)=>SizedBox(
                              height:8.0,
                            ),
                            itemCount:SocialCubit.get(context).allPosts.length,
                          ),
                          SizedBox(
                            height:8.0,
                          ),
                        ],
                      ),
                    ),
                    fallback: (BuildContext context)=>Center(child: CircularProgressIndicator()),
                  ),


                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget buildPostItem(PostModel?postModel,context,index,){
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(
                    '${SocialCubit.get(context).userModel!.image}',
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${SocialCubit.get(context).userModel!.name}',
                            style: TextStyle(
                              height: 1.4,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.check_circle,
                            color: defaultColor,
                            size: 16.0,
                          ),
                        ],
                      ),
                      Text(
                        '${postModel!.dateTime}',
                        style:
                        Theme.of(context).textTheme.caption!.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_horiz,
                    size: 17.0,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Text(
              '${postModel.postText}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            if(postModel.postImage!='')
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top:15.0,
                ),
                child: Container(
                  width: double.infinity,
                  height: 140.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    image: DecorationImage(
                      image: NetworkImage(
                        '${postModel.postImage}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical:6.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Row(
                        children: [
                          Icon(
                            postModel.postLikes!.contains(SocialCubit.get(context).userModel!.uId)?
                            Icons.recommend:Icons.recommend_outlined,
                            size:20.0,
                            color: postModel.postLikes!.contains(SocialCubit.get(context).userModel!.uId) ?
                            defaultColor : Colors.black54,
                          ),
                          SizedBox(
                            width:5.0,
                          ),
                          Text('Like',style:Theme.of(context).textTheme.caption!.copyWith(
                            color: postModel.postLikes!.contains(SocialCubit.get(context).userModel!.uId) ? defaultColor: Colors.black54,
                          )),
                          SizedBox(
                            width:5.0,
                          ),
                          Text(postModel.postLikes!.length.toString(),style:Theme.of(context).textTheme.caption),
                        ],
                      ),
                      onTap:(){
                        SocialCubit.get(context).likeUnlikePost(postModel.postID);
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.end,
                        children: [
                          Icon(
                            IconBroken.Chat,
                            size: 18.0,
                            color: Colors.amber,
                          ),
                          SizedBox(
                            width:5.0,
                          ),
                          Text(
                            '${SocialCubit.get(context).allComments.length} comments',
                            style:Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      onTap:(){
                        navigateTo(context, CommentsScreen());
                      },
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom:10.0,
              ),
              child: Container(
                width:double.infinity,
                height:1.0,
                color:Colors.grey[300],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius:18,
                          backgroundImage:NetworkImage(
                            '${SocialCubit.get(context).userModel!.image}',
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'write a comment ...',
                          style:Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    onTap:(){

                    },
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
