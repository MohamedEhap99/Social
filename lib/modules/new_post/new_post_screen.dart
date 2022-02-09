import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  var postTextController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        var postImage = SocialCubit.get(context).postImage;
        return Scaffold(
          appBar:defaultAppBar(
            context: context,
            title:'Create Post',
            actions:[
              defaultTextButton(
                onpressed:(){
                  var now=DateTime.now();
                  if(SocialCubit.get(context).postImage==null){
                    SocialCubit.get(context).createNewPost(
                      dateTime:now.toString(),
                      postText: postTextController.text,
                    );
                  }
                  else{
                    SocialCubit.get(context).uploadPostImage(
                      dateTime:now.toString(),
                      postText: postTextController.text,
                    );
                  }
                },
                text:'post',
              ),
            ],

          ),
          body:Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if(state is UploadPhotoPostLoadingState)
                  LinearProgressIndicator(),
                if(state is UploadPhotoPostLoadingState)
                  SizedBox(
                    height:10.0,
                  ),
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
                      child: Text(
                        '${SocialCubit.get(context).userModel!.name}',
                        style: TextStyle(
                          height: 1.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    decoration:InputDecoration(
                      hintText:'what is on your mind ...',
                      border:InputBorder.none,
                    ),
                    controller: postTextController,
                  ),
                ),
                SizedBox(
                  height:20.0,
                ),
                if(SocialCubit.get(context).postImage!=null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 140.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                              image:FileImage(postImage!)as ImageProvider,
                              fit: BoxFit.cover
                          ),
                        ),
                      ),
                      IconButton(
                        icon: CircleAvatar(
                          radius: 20.0,
                          backgroundColor:Colors.grey[300],
                          child: Icon(
                            Icons.close,
                            size: 18.0,
                            color:Colors.black,
                          ),
                        ),
                        onPressed: () {
                          SocialCubit.get(context).removePostImage();
                        },
                      ),
                    ],
                  ),
                SizedBox(
                  height:20.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed:(){
                          SocialCubit.get(context).getPostImage();
                        },
                        child:Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconBroken.Image,
                            ),
                            SizedBox(
                              width:5.0,
                            ),
                            Text(
                              'add photo',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed:(){

                        },
                        child:Text(
                            '# tags'
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
