import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class CommentsScreen extends StatelessWidget {
  var commentController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, states) {},
      builder: (context, states) {
        var cubit = SocialCubit.get(context);

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
            Expanded(
            child: Container(
            child: SingleChildScrollView(
            child: ListView.separated(
              reverse: true,
            shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => commentItem(cubit.allComments[index],context),
              separatorBuilder: (context, index) => const SizedBox(height: 15.0,),
              itemCount:cubit.allComments.length,
            ),
          ),
        ),
        ),
        TextField(
        controller: commentController,
        decoration: InputDecoration(
        border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        ),
        hintText: 'Write a Comment...',
        hintStyle: const TextStyle(
        color: Colors.grey,
        ),
        prefixIcon: InkWell(
        child: const Icon(IconBroken.Image_2),
        onTap: ()=>cubit.selectImage(context),
        ),
        suffixIcon: IconButton(
        onPressed: (){
          DateTime now = DateTime.now();
          var formattedDate=DateFormat('yyyy-MM-dd – kk:mm').format(now);
          var jj=Jiffy().fromNow();

          if(SocialCubit.get(context).createCommentImage==null){
            SocialCubit.get(context).createNewComment(
              dateTime:formattedDate.toString(),
              commentText: commentController.text,
            );
            commentController.clear();
          }
          else{
            SocialCubit.get(context).uploadCommentImage(
              dateTime:formattedDate.toString(),
              commentText: commentController.text,
            );
          }
        },
        icon: const Icon(
        Icons.send,
        ),
    )
    ,

    ),
    style: const TextStyle(color: Colors.black, height: 1),
    ),
    ]
    ,
    )
    )
    );
  },

  );
}

Widget commentItem(CommentModel commentModel,context) {
  var CommentImage = SocialCubit.get(context).createCommentImage;
  return Column(
    children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                '${commentModel.uImage}',
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${commentModel.uName}',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(
                          fontSize: 18.0,
                          color: Colors.black,
                          height: 1.0,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {

                        },
                        icon: Icon(
                          Icons.more_horiz,
                          size: 17.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Text(
                      '${commentModel.commentText}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                          height: 1.6, fontSize: 15, color: Colors.grey[700]),
                    ),
                  ),
                  Text(
                      '${commentModel.dateTime}'
                  ),
                  SizedBox(
                    height:10.0,
                  ),
                   //if(commentModel.commentImage!='')
                   // Container(
                   //   height: 140.0,
                   //   width: double.infinity,
                   //   decoration: BoxDecoration(
                   //     borderRadius: BorderRadius.circular(4.0),
                   //     image: DecorationImage(
                   //         image:FileImage(CommentImage!)as ImageProvider,
                   //         fit: BoxFit.cover
                   //     ),
                   //   ),
                   // ),
                ],
              ),
            ),
          ],
        ),
    ],
  );
}}
