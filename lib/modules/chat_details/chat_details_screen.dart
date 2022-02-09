import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel?userModel;
  ChatDetailsScreen(this.userModel);

  var messageController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(// رابت الBlocConsumer ب widget اسمها Builder عشان عاوزها تنفذلي حاجة تبنيلي حاجة بمعني اصح قبل ما يعمل Consume
      builder: (BuildContext context) {
SocialCubit.get(context).getMessages(receiverId:'${userModel!.uId}');

        return  BlocConsumer<SocialCubit,SocialStates>(
          listener:(context,state){},
          builder:(context,state){
            return Scaffold(
              appBar: AppBar(
                titleSpacing:0.0,//شيل المسافة الواخدها الtitle
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        '${userModel!.image}',
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      '${userModel!.name}',
                    ),
                  ],
                ),
              ),
              body:ConditionalBuilder(
                condition:SocialCubit.get(context).messages.length>0,
                builder: (BuildContext context)=>Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics:BouncingScrollPhysics(),
                          itemBuilder:(context,index){
                            var message=SocialCubit.get(context).messages[index];//انا كدا ماسك الرسالة في ايدي
                            if(SocialCubit.get(context).userModel!.uId==message.senderId)
                              return buildMyMessage(message,context);

                            return buildMessage(message,context);
                          },
                          separatorBuilder:(context,index)=>SizedBox(
                            height:15.0,
                          ),
                          itemCount:SocialCubit.get(context).messages.length,
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,//سعشان الrow الداخل الcontainer يتقص علي الcontainer بظبط
                        decoration:BoxDecoration(
                          border:Border.all(
                            color:Colors.blueGrey,
                            width:1.0,
                          ),
                          borderRadius:BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal:15.0,
                                ),
                                child: TextFormField(
                                  decoration:InputDecoration(
                                    border:InputBorder.none,
                                    hintText:'type your message here ...',
                                  ),
                                  controller: messageController,
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              color:defaultColor,
                              child: MaterialButton(
                                onPressed:(){
                                  SocialCubit.get(context).sendMessage(
                                    receiverId:'${userModel!.uId}',
                                    dateTime: DateTime.now().toString(),
                                    text: messageController.text,
                                  );
                                  messageController.clear();
                                },
                                child:Icon(
                                  IconBroken.Send,
                                  size:16.0,
                                  color:Colors.white,
                                ),
                                minWidth:1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (BuildContext context)=>Center(child: CircularProgressIndicator()),

              ),
                //الشرط ان لازم list بتاعة الmessages تكون فيها علي الاقل رسالة واحدة غير كدا جبلة loading



            ) ;
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel?messageModel,context)=>Align(
    alignment:AlignmentDirectional.centerStart,
    child: Container(
      padding:EdgeInsets.symmetric(
        vertical:5.0,
        horizontal:10.0,
      ),
      decoration:BoxDecoration(
        color:Colors.grey[300],
        borderRadius:BorderRadiusDirectional.only(
          topStart:Radius.circular(10.0),
          topEnd:Radius.circular(10.0),
          bottomEnd:Radius.circular(10.0),
        ),
      ),
      child: Text(
        '${messageModel!.text}',
        style:Theme.of(context).textTheme.subtitle1,
      ),
    ),
  );

  Widget buildMyMessage(MessageModel?messageModel,context)=>Align(
    alignment:AlignmentDirectional.centerEnd,
    child: Container(
      padding:EdgeInsets.symmetric(
        vertical:5.0,
        horizontal:10.0,
      ),
      decoration:BoxDecoration(
        color:defaultColor.withOpacity(0.2),
        borderRadius:BorderRadiusDirectional.only(
          bottomStart:Radius.circular(10.0),
          topEnd:Radius.circular(10.0),
          bottomEnd:Radius.circular(10.0),
        ),
      ),
      child: Text(
        '${messageModel!.text}',
style:Theme.of(context).textTheme.subtitle1,
      ),
    ),
  );
}

/*
شكل الشات هيكون عامل ازاي بقا في الداتا بيز؟ هو مش انا بعمل شات مع فلان مثلا ؟ هتقولي اة.
يعني انا هشوف الرسايل بتعتي وبتاعة فلان ... مش انا لما ببعت ل فلان رسالة يبقا كدا فلان دا
بيعمل شات معايا ؟ اة
يعني المفروض هو يشوف الرسايل بتعتي وبتعتة فا هنلعبها لعبة حلوة اوي
 هنودي في collection أل users بتاعنا الاساسي الاحنا عملينة فا هتلاقي الid كل user في الdocument
 لما ادوس علي user معين هخلية يروح ل collection ثابتة اسمها chats  ولما يروح هيلاقي id خاص بفلان الهيعمل شات معاة  شايل الmessages في الdocument المتفرع
 من collection الchats  لما ادوس علي الid الهو بتاع فلان دا هيوديني لcollection اسمها messages
 فيها رساايل كل رسالة بتروح تعمل id خاص بيها في document لما تدوس علي الرسالة بقا
 هتفتحلك fields فيها البيانات زي dateTime وقت الرسالة وزي receiverId وزي senderId عشان ابقا عارف
 الرسالة دي بتعتي ولا مش بتعتي علي شان لو بتعتي اجبها يمين ولو مش بتعتي اجبها شمال وبيكون
 موجود بيانات زي ال text الهي الرسالة المكتوبة بما ان ان الرسالة الواحدة شايلة بيانات خاصة بيها
 اذا دي بيانات data فا هعملها model خاصة بيها  وهسميها message_model
 */