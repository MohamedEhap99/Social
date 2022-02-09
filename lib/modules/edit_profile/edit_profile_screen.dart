import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;

        nameController.text = '${userModel!.name}';
        phoneController.text = '${userModel.phone}';
        bioController.text = '${userModel.bio}';


        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      4.0,
                                    ),
                                    topRight: Radius.circular(
                                      4.0,
                                    ),
                                  ),
                                  image: DecorationImage(
                                      image: coverImage == null ? NetworkImage(
                                        '${userModel.cover}',
                                      )
                                          : FileImage(
                                          coverImage) as ImageProvider,
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor:Colors.grey[300],
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 18.0,
                                    color:Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  SocialCubit.get(context).getCoverImage();
                                },
                              ),
                            ],
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),

                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 63,
                              backgroundColor: Theme
                                  .of(context)
                                  .scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: profileImage == null
                                    ? NetworkImage(
                                  '${userModel.image}',
                                )
                                    : FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            IconButton(
                              icon: CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.grey[300],
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 18.0,
                                  color:Colors.black,
                                ),
                              ),
                              onPressed: () {
                                SocialCubit.get(context).getProfileImage();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if(SocialCubit.get(context).profileImage != null || SocialCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if(SocialCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultMaterialButton(
                                  onpressed: () {
                                    SocialCubit.get(context).uploadProfileImage(
                                      name:nameController.text,
                                      phone:phoneController.text,
                                      bio:bioController.text,
                                    );
                                  },
                                  text: 'upload profile ',
                                  style:TextStyle(
                                      color:Colors.blue[700]
                                  ),
                                  color:Colors.blue[50],
                                ),
                                if(state is UserUpdateLoadingState)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if(state is UserUpdateLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if(SocialCubit.get(context).coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultMaterialButton(
                                  onpressed: () {
                                    SocialCubit.get(context).uploadCoverImage(
                                      name:nameController.text,
                                      phone:phoneController.text,
                                      bio:bioController.text,
                                    );
                                  },
                                  text: 'upload cover ',
                                  style:TextStyle(
                                    color:Colors.blue[700],
                                  ),
                                  color:Colors.blue[50],

                                ),
                                if(state is UserUpdateLoadingState)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if(state is UserUpdateLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  if(SocialCubit.get(context).profileImage != null || SocialCubit.get(context).coverImage != null)
                    SizedBox(
                      height: 10.0,
                    ),
                  defaultFormField(
                    labeltext: 'Name ...',
                    labelstyle: TextStyle(
                      color: Colors.blue[700],
                    ),
                    prefixicon: IconBroken.User,
                    color: Colors.blue[700],
                    controller: nameController,
                    obscuretext: false,
                    keyboardtype: TextInputType.name,
                    borderside: BorderSide(width: 1.0, color: Colors.blue),
                    borderradius: BorderRadius.circular(10.0),
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'name must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  defaultFormField(
                    labeltext: 'Phone ...',
                    labelstyle: TextStyle(
                      color: Colors.blue[700],
                    ),
                    prefixicon: IconBroken.Call,
                    color: Colors.blue[700],
                    controller: phoneController,
                    obscuretext: false,
                    keyboardtype: TextInputType.phone,
                    borderside: BorderSide(width: 1.0, color: Colors.blue),
                    borderradius: BorderRadius.circular(10.0),
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'phone must not be empty';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 10.0,
                  ),

                  defaultFormField(
                    labeltext: 'bio ...',
                    labelstyle: TextStyle(
                      color: Colors.blue[700],
                    ),
                    prefixicon: IconBroken.Info_Circle,
                    color: Colors.blue[700],
                    controller: bioController,
                    obscuretext: false,
                    keyboardtype: TextInputType.text,
                    borderside: BorderSide(width: 1.0, color: Colors.blue),
                    borderradius: BorderRadius.circular(10.0),
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'name must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width:double.infinity,
                    height:40,
                    color:Colors.blue[50],
                    child:defaultTextButton(
                      onpressed: () {
                        SocialCubit.get(context).updateUser(
                          name: nameController.text,
                          phone: phoneController.text,
                          bio: bioController.text,
                        );
                      },
                      text: 'Edit Details',
                      style:TextStyle(
                        color:Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },

    );
  }
}
