import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/networks/local/cache_helper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(InitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

//-------Switch between light and dark---------------------------------------
  bool isDark = true;

  void changeAppMode(bool?fromShared) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(ChangeAppModeState());
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(ChangeAppModeState());
      });
    }
  }

//--------Change NottomNavBar Item------------
  int currentIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeItemBottomNavBar(index) {
    if(index==1){
      getAllUsers();
    }

    if (index == 2) {
      emit(NewPostState());
    }
    else {
      currentIndex = index;
      emit(ChangeItemBottomNavBarState());
    }
  }

// --------Get UserData for Users----------
  UserModel? userModel;
  PostModel? postModel;
  CommentModel?commentModel;
  Future getUserdata()async{
    emit(GetUserLoadingState());
    await  FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(GetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserErrorState(error.toString()));
    });
  }

  // -----------Ready Files for Images----------------
  File?profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedfile = await picker.getImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      profileImage = File(pickedfile.path);
      print(pickedfile.path);
      emit(ImagePickerProfileSuccessState());
    }
    else {
      print('No Image Selected');
      emit(ImagePickerProfileErrorState());
    }
  }

  File?coverImage;

  Future<void> getCoverImage() async {
    final pickedfile = await picker.getImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      coverImage = File(pickedfile.path);
      print(pickedfile.path);
      emit(ImagePickerCoverSuccessState());
    }
    else {
      print('No Image Selected');
      emit(ImagePickerCoverErrorState());
    }
  }


// ------------ upload  Images -------------
  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance.ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')//خد بالك users دا اسم الفولدر البسمية انا بمزاجي العاوز مسار الصورة تتحفظ فية
        .putFile(coverImage!).then((value) {
      value.ref.getDownloadURL().then((value) { //لان الgetDownloadURL فيوتشر استرنج
        //emit(UploadImageCoverSuccessState());
        print(value);
        updateUser(
          name:name,
          phone:phone,
          bio:bio,
          cover:value,
        );
      }).catchError((error) {
        emit(UploadImageCoverErrorState());
      });
    }).catchError((error) {
      emit(UploadImageCoverErrorState());
    });
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path)//خد بالك users دا اسم الفولدر البسمية انا بمزاجي العاوز مسار الصورة تتحفظ فية
        .pathSegments
        .last}')
        .putFile(profileImage!).then((value) {
      value.ref.getDownloadURL().then((value) { //لان الgetDownloadURL فيوتشر استرنج
//emit(UploadImageProfileSuccessState());
        print(value);
        updateUser(
          name:name,
          phone:phone,
          bio:bio,
          image:value,
        );
      }).catchError((error) {
        emit(UploadImageProfileErrorState());
      });
    }).catchError((error) {
      emit(UploadImageProfileErrorState());
    });
  }


// ----------Go Update Data------------
  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String?cover,
    String?image,
  }) {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel!.email,
      uId: userModel!.uId,
      cover:cover??userModel!.cover,
      image:image??userModel!.image,
      uPosts: [],
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap()).then((value) {
      getUserdata();
    }).catchError((error) {
      emit(UserUpdateErrorState());
    });
  }

//--------------------------Posts-----------------------------------------


  // ------------Ready File For Image Post------------
  File?postImage;

  Future<void> getPostImage() async {
    final pickedfile = await picker.getImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      postImage = File(pickedfile.path);
      print(pickedfile.path);
      emit(ImagePickerPostSuccessState());
    }
    else {
      print('No Image Selected');
      emit(ImagePickerPostErrorState());
    }
  }

//----------Create New Post ------------------------------

  void uploadPostImage({
    required String dateTime ,
    String? postText ,
  }){
    emit(UploadPhotoPostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value){
      print('photo uploaded successfully');
      value.ref.getDownloadURL().then((value){
        createNewPost(
          dateTime: dateTime,
          postImage: value,
          postText: postText ,
        );

      }).catchError((error){
        print('errrrrrrror in get post photo uri $error');
      });
    })
        .catchError((error){
      emit(CreateNewPostErrorState());
      print('errrrrrrror in create new post $error');
    })
    ;
  }
  
  void createNewPost ({
    String? postImage,
    String? postText ,
    required String dateTime ,
  }){
    emit(CreateNewPostLoadingState());
    PostModel postModel = PostModel(
      uId: userModel!.uId ,
      uName: userModel!.name,
      uImage : userModel!.image ,
      postImage : postImage ,
      postText: postText ,
      dateTime : dateTime ,
      postID: null,
      postLikes : [],
    );
    String postID = '' ;
    FirebaseFirestore.instance.collection('posts').add(postModel.toMap())
        .then((value) {
      postID = value.id ;
      FirebaseFirestore.instance.collection('posts').doc(value.id).update({'postID':value.id})
          .then((value){
        postModel.postID = postID ;
        addPostToUser(postModel);
        allPosts.add(postModel);
      });

      emit(CreateNewPostSuccessState());
    })
        .catchError((error){
      print('error in creating postModel $error');
      emit(CreateNewPostErrorState());
    });


  }
  
  void addPostToUser (PostModel newPost){
    List<PostModel>? userPosts;
    userPosts =  userModel!.uPosts;
    userPosts!.add(newPost);

    FirebaseFirestore.instance.collection('users').doc(uId).update({'uPosts':userPosts.map((e) => e.toMap()).toList()})
        .then((value) => userModel!.uPosts!.add(newPost))
        .catchError((error){print(error.toString());});
  }

  void removePostImage (){
    postImage = null ;
    emit(RemovePostImageState());
  }

  //get All posts to Feeds -------------------------------------
  List<PostModel> allPosts = []  ;
  Future<void> getPosts()async {
    emit(GetPostsLoadingState());
    allPosts.clear() ;
    await FirebaseFirestore.instance.collection('posts').orderBy('dateTime',descending: true).get()
        .then((value) {
      emit(GetPostsSuccessState());
      value.docs.forEach((element) {
        allPosts.add(PostModel.fromJson(element.data()));
      });


    })
        .catchError((error){
      print(error.toString());
      emit(GetPostsErrorState());
    })
    ;
  }




//Like / unlike a post --------------------------------------------------------------


  List<String> postLikesUID = []  ;
  Future<void> getPostLikes (String? postID) async{
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postID!)
        .get().then((value) {
      postLikesUID = List<String>.from(value.data()!['postLikes']);
      print('this post likes are : $postLikesUID');
    });
  }

  void likeUnlikePost (String? postID){
    getPostLikes(postID).then((value) {
      postLikesUID.contains(userModel!.uId) ? unlike(postID!) : like(postID!);
    });
  }

  void like (String postID){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .update({'postLikes':FieldValue.arrayUnion([userModel!.uId])})
        .then((value) {


      allPosts.forEach((element) {
        if(element.postID == postID)
          element.postLikes!.add(userModel!.uId.toString());
      });

      userModel!.uPosts!.forEach((element) {
        if(element.postID == postID)
          element.postLikes!.add(userModel!.uId.toString());
      });
      //getPosts();
      emit(LikePostsSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(LikePostsErrorState());
    });
  }

  void unlike (String postID){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .update({'postLikes':FieldValue.arrayRemove([userModel!.uId])})

        .then((value) {
      // getPostLikes(postID);
      allPosts.forEach((element) {
        if(element.postID == postID)
          element.postLikes!.remove(userModel!.uId.toString());
      });

      userModel!.uPosts!.forEach((element) {
        if(element.postID == postID)
          element.postLikes!.remove(userModel!.uId.toString());
      });
      //  getPosts();
      emit(UnLikePostsSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(UnLikePostsErrorState());
    });
  }


// get users who Likes this post -------------------------------------
  List<UserModel>? usersWhoLikes =[] ;
  Future<void> getPostUsersLikes (String? postID) async{
    usersWhoLikes!.clear();
    emit(GetLikedUsersLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postID!)
        .get().then((value) {
      List<String>.from(value.data()!['postLikes']).forEach((element) {

        FirebaseFirestore.instance
            .collection('users')
            .doc(element)
            .get().then((value)  {
          usersWhoLikes!.add(UserModel.fromJson(value.data()));
          emit(GetLikedUsersSuccessState());
        });
      });


    });
  }

//--------Comments--------------
  File? createCommentImage;
  final ImagePicker createCommentPicker = ImagePicker();

  Future<void> getCommentImageFromGallery() async {
    final pickedFileCover = await createCommentPicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFileCover != null) {
      createCommentImage = File(pickedFileCover.path);
      emit(GetCommentImageFromGalleryState());
    } else {
      print('Error in image');
      emit(GetCommentImageErrorStates());
    }
  }

  Future<void> getCommentImageFromCamera(context) async {
    Navigator.pop(context);
    final pickedfile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    if (pickedfile != null) {
      createCommentImage = File(pickedfile.path);
      print(pickedfile.path);
      emit(ImagePickerCameraSuccessState());
    }
  }

  selectImage(parentContext) {
    emit(SelectImageSuccessState());
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Create Post'),
            children: [
              SimpleDialogOption(
                onPressed: () => getCommentImageFromCamera(context),
                child: Text('Photo with Camera'),
              ),
              SimpleDialogOption(
                onPressed: () => getCommentImageFromGallery(),
                child: Text('Photo with Gallery'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          );
        }
    );
  }

//Logic Comments-------------------

  void uploadCommentImage({
    String?dateTime,
    String?commentText,

  }){
    emit(UploadCommentImageLoadingStates());
    firebase_storage.FirebaseStorage.instance
        .ref().child('comments/${Uri.file(createCommentImage!.path).pathSegments.last}')
        .putFile(createCommentImage!).then((value){
      print('photo comment uploaded successfully');
      value.ref.getDownloadURL().then((value){
        createNewComment(
          dateTime:dateTime ,
          commentText: commentText ,
          commentImage: value,
          postID:postModel!.postID,
        );

      }).catchError((error){
        print('errrrrrrror in get post photo uri $error');
      });

    }).catchError((error){
      emit(CreateNewCommentErrorStates());
      print('errrrrrrror in create new post $error');
    });
  }
  
  void createNewComment({
    String?postID,
    String?commentText,
    String?commentImage,
    String?dateTime,
  }){
    CommentModel commentModel=CommentModel(
      uId:userModel!.uId,
      uName: userModel!.name,
      uImage:userModel!.image,
      commentText:commentText,
      commentImage: commentImage,
      dateTime:dateTime,
      commentID:null,
    );
    String commentID = '' ;
    FirebaseFirestore.instance.collection('comments').add(commentModel.toMap()).then((value){
      commentID = value.id ;
      FirebaseFirestore.instance.collection('comments').doc(value.id).update({'commentID':value.id})
          .then((value){
        commentModel.commentID = commentID ;
        allComments.add(commentModel);
      });
      emit(CreateNewCommentSuccessStates());
    }).catchError((error){
      emit(CreateNewCommentErrorStates());
    });
  }

  List<CommentModel> allComments = []  ;
  void getComments(){
    emit(GetCommentsLoadingState());
    allComments.clear() ;
     FirebaseFirestore.instance.collection('comments').orderBy('dateTime',descending: true)
        .snapshots().listen((event) {
      allComments.clear() ;
      emit(GetCommentsSuccessState());
      event.docs.forEach((element) {
        allComments.add(CommentModel.fromJson(element.data()));
      });
    });

  }


  deleteComment({
    String?commentText,
    String?commentImage,
    String?dateTime,
}){
    CommentModel commentModel=CommentModel(
      uId:userModel!.uId,
      uName: userModel!.name,
      uImage:userModel!.image,
      commentText:commentText,
      commentImage: commentImage,
      dateTime:dateTime,
      commentID:null,
    );
    String commentID = '' ;
  FirebaseFirestore.instance.collection('comments').doc(commentID).delete().then((value) {
    commentModel.commentID=commentID;
    emit(DeleteCommentsSuccessState());
  }).catchError((error){});
}





  List<UserModel> users=[];

  void getAllUsers(){
    //users=[];دا حل انك بتصفر المصفوفة لكل مرة بتدوس علي ايكونة الشات وانت داخل عشان مش يقعد يروح يجيب مع كل دوسة
    if(users.length==0)//دا شكل تاني
      FirebaseFirestore.instance.collection('users').get().then((value){//دايما اتعلم تreuse شغلك وانا هنا بجيب داتا الusers بتعتي بreuse شغلي
        value.docs.forEach((element){
          if(element.data()['uId'] != userModel!.uId)//بقولة لو الداتا بتاعة العنصر الهتضاف دي  الid بتاعها مش زي الid بتاعي انا هاتها عشان انا مش عاوز اظهر نفسي مع قائمة الشات بتاعة الusers الهخش اكلمهم واعمل معاهم شات وكدا
            users.add(UserModel.fromJson(element.data()));
        });
        emit(GetAllUsersSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(GetAllUsersErrorState(error.toString()));
      });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }){
    MessageModel messageModel=MessageModel(
      senderId:userModel!.uId,//ownerId
      receiverId:receiverId,//pepoleIsLike
      dateTime:dateTime,//dateTime
      text: text,
    );
//set my chats
    FirebaseFirestore.instance
        .collection('users')//collecttion('posts').doc(postId).collection(likes).add(likesModel.toMap)
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value){
      emit(SendMessageSuccessState());
    })
        .catchError((error){
      emit(SendMessageErrorState());
    });
//set receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value){
      emit(SendMessageSuccessState());
    })
        .catchError((error){
      emit(SendMessageErrorState());
    });
    /*
    خد بالك انا مرة وديت عندي ومرة عكست ووديت عند فلان البكلمة في الشات عشان يكون
    متاح عندي اقدر امسح الرسالة من عندي وهو يقدر يمسح من عندة وانا اقدر امسح من عندي ومن عندة
    وهو نفس الكلام
     */
  }

  List<MessageModel> messages=[];

  void getMessages({
    required String receiverId,
  }){
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')//عشان يرتبهملي حسب الثواني بتاعة الوقت عشان الرسايل تكون مترتبة مش عشوائية في الترتيب
        .snapshots()
        .listen((event) {
      messages=[];

      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetAllMessagesSuccessState());
    });
  }


  //Searh Design Screen and Add Logig In Functions
  var SearchContoller = TextEditingController();

  AppBar buildSearchField() {
    emit(BuildSearchFieldState());
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      title: TextFormField(
        decoration: InputDecoration(
            hintText: 'Search for a user...',
            filled: true,
            prefixIcon: Icon(
              Icons.account_box,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              onPressed: () => clearSearch(),
              icon: Icon(Icons.clear),
            )
        ),
        onFieldSubmitted: getUserInfo(),
        controller: SearchContoller,
      ),
    );
  }

  Container buildNoContent(context) {
    emit(BuildNoContentState());
    final Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              height: orientation == Orientation.portrait ? 300 : 150,
              child: Image(
                image: AssetImage(
                  'assets/images/searchImage.jpg',
                ),
              ),
            ),
            Text(
              'Find Users',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[300],
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<QuerySnapshot>?searchResultFutures;

  getUserInfo() {
    Future<QuerySnapshot>users = FirebaseFirestore.instance.collection('users')
        .where("name", isEqualTo: query).get();
    searchResultFutures = users;
    emit(HandleSearchSuccessState());
  }

  buildSearchResult(context) {
    emit(HandleSearchSuccessState());
    return InkWell(
      onTap: (){
        navigateTo(context,SettingsScreen() );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          color: Colors.grey[100],
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                FutureBuilder(
                  future: searchResultFutures,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Text('No user found.');
                    }
                    else
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading ...');
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var result = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(result["name"]),
                          leading: CircleAvatar(backgroundImage: NetworkImage(
                              result["image"]),),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Divider(
                            height: 2.0,
                            color: Colors.white,
                          ),
                      itemCount: snapshot.data!.docs.length,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  clearSearch() {
    SearchContoller.clear();
  }
/*
   المرادي مش هيديني future المرادي هيديني stream الsnapshots دي لو دخلت عليها هتلاقيها
    عبارة عن Stream of query snapshots طب هو يعني اية Stream؟ احنا عارفين ان Future هي
    داتا جاية كمان شوية الStream بقا هو طبور من الFutures جاي كمان شوية..
    لية؟ عشان انت هتفتح real time .. انت بعت رسالة هيقوم رميهالك في الStream فا انت هتسمعها
    وتستقبلها عندك وتظهرها .. طب بعتى رسالة تانية هيروح بردو رميهالك في الاستريم فا الاستريم مفتوح
    لكن الfuture كان بيجيب الداتا مرة واحدة في المستقبل ويقطع صح كان يروح يجيب الداتا يقعد ثانيتين
    ويجبها ويفصل لكن الاستريم مختلف بقا هيروح يجيب الداتا عادي زي الfuture بس هيفضل مفتوح مش هيفصل  .. عشان هو زي ما بقولك هو
    عبارة عن طبرو من الfuture  هيجيب داتا وهيفضل مفتوح مش هيقفل وبعدين جاب داتا تانية  هيفضل مفتوح مش هيقفل بردو
    وبعدين جاب داتا تالتة هيفضل مفتوح مش هيقفل  وهكذا real time بقا يا باشا
    طب listen يعني اية ؟ يعني ابدا استمع الي التغيرات الممكن تحصل فية
    طب اية الevent دي ؟ دي الداتا الجاية عادي جدا الحدث الحصل الهي الرسالة
    ومفيش .catchError هنا للlisten هي emit واحدة للsucces مفيش ايرور هو بيروح ي listen
    جاب بقا جاب مجابش خلاص .. وخد بالك في الlisten ابقا صفر الlist عشان مش يجبلك كل مرة القديم
   */



}






/*
  انا  عملت دالة اسمها uploadProfileImage وظيفتها بترفع الصورة في الstorage
  عشان توديها firstore Database فا هروح اجيب اسم الimport الخاصة الانا استدعيتها
كدا firebase_storage ثم FirbaseStorage ثم instance كدا انا بعرفة ثم ref يعني دخلت
جواها خلاص ثم هعمل اية جواها بقا عاوزين نحط الصورة فا هقولة اخلق child مكان
جواة فولدر وهسمية مثلا users وهحط جواة اسم الصورة اسم ال الصورة
ال هو last path segment لان الpath بيكون متخزن بالشكل دا في جهازك لو روحت
اختارت صورة دلوقتي من تليفونك هتكون متخزنة بالشكل دا مثلا
/data/user/0/com.flutter.social_app/cache/image_picker7612164508535476377.jpg
فا هي بتكون متخزنة علي هيئة sgements شرائح كدا طب فين بقا الlast segment
الانت بتقولي علية دا الصورة هو داimage_picker7612164508535476377.jpg

 يبقا هعمل child هخلق فولدر هناك اسمة users وهحط جواة اسم الصورة طب اسم الصورة
 انا كدا عاوز استخدم الlast path segment طب اطلع ازاي الlast path segment

  معانا حاجة جاهزة اسمها
  Uri.file(path)
  محتاج path بتاع الصورة خلاص  انت مش شايل فايل معاك شايل صورة يعني في المتغير
  الاسمة profileImage او coverImage اة خلاص اروح ادهولة وقولة
  .path
  ثم
  .pathSegments.last
  يعني بقولة قسمهوملي شرائح
   ثم هقولة
   .putFile(profileImage)
   بقولة ارفع بقا اخر حاجة ارفع الفايل ارفع الصورة بقا
   بعد كدا بما ان الدالة future فا هقولة
   .then(value){

   }.catch((error){
   });
طبعا ال.then بيديني الvalue بس مش دا اللينك  مش احنا قولنا في الشرح في الكشكول
عاوزين نمسك اللينك بتاع الصورة ويكون معانا لما جربنا نعملupload لصورة من اللاب علي الموقع
بادينا وشوفنا اللينك بعنينا عاوزين بقا نمسك اللينك دا نمسكة ازاي ؟
خش ال.then
وقولة
value.ref.getDownloadURL().then((value){
}).catchError(()){
}
 كدا بقولة خش وهتلي الاترفع الهو اللينك
 طب ازاي بعد ما رفعنا الصورة ومعايا اللينك بتاعلا الصورة اوديها بقا في
 الfirestore database

  هعمل اتنين emit للerror س عشان احنا معانا حالتين ايرور  الحالة الاولي في الرفع
  وانت بترفع ممكن يحصل معاك ايرور والحالة التانية وانت بتجيب اللينك getDownloadUrl
  لكن في الthen الاولي مش محتاج تعمل emit للsucces لانك بتجيب الurl وكدا كدا جواة emit هتنفذة

  عاوزين نمسك الdownloadUrl في ادينا ونحفظة فا هروح اعمل متغير
  هسمية String ?profileImageUrl='';
  وهحط فية الvalue
  profileImageUrl=value;
 يبئا انا كدا رفعت ومعايا الurl في ايدي عشان ابدا اعملة update
   واعمل نفس الكلام للcover بردو مفيش اختلاف

هعمل دالة بتعمل الupdate بقا وهستدعي فيها الgetUserData البيانات الجديدة الاترفعت
بقا هاتها فاهم ؟ وهتلاحظ معملتش emit للthen لان دالة الgetUserData فيها emit للsucces مش محتاج اعملها
عشان تكون فاهم النقطة دي  لما تلاقي دالة  هتستدعيها فيها emit للحالة الsucces بتاعتها
متعملهاش emit لحالة الsuccec بتاعتها
هروح بقا للزرار بتاع الابديت في اسكرينة الedit_profile وهتسدعي فية الدوسة
دالة الupdate  بتجبلي الجديد من بيانات المستخدمزي الاسم والفون والbio
بس بقولك اية الupdate هيupload الاول ركز  انا لسة معملتش upload للصور
   هقولة لو المتغير الشايل ملف صورة الcover دا مليان في صورة يعني مش فاضي استدعي
   دالة uploadCoverImage ونفذها طب لو ملف الشايل صورة البروفايل مليان ومش فاضي
   استدعي الدالة الuploadProfileImage طب لا دا ولا دا يبقا الاتنين مع بعض
   طب مغيرناش ولا كوفر ولا بروفايل ولا حتي الاتنين مع بعض خلاص خش   استدعي الدالة الخاصة ببيانات الuser لو هتغير حاجة هتغيرهالك من الاسم او الفون
   او الbio لو مش هتغير هتسبهملك عادي ومعاهم الصور زي ما هي غيرت هتروح معاهم
   مغيرتش صور هتدنها زي ما هي في بيناتة عادي

   هنبدا بقا نروح نعمل زرار في اسكرينة الedit_profile الزرار دا هيكون
   اسمة UPLOAD PROFILE  وظيفتة  بيحفظ تغير الصورة للبروفايل وزرار جنبة بظبط بيحفظ تغير الكوفر
    وكل واحد لية حالة شرط ان الزرار  يظهر المسافة التحتية في حالة لو المستخدم غير االصورة
    وعملنا تحتية linaer progressIndecator
    هروح بقا احط في بداية كل دالة خاصة ب upload سواء profile او cover هحط
    الstate بتاعة الloading في بدايتهم
     emit(UserUpdateLoadingState());
     الهي دي وهشيل اي emit خاصة بالsucces لانهم بستدعو دالة والدالة بتستدعي
    دالة فيها emit succes

 لاحظ انا جيت افصل كل دوسة زرار لوحدها بحيث ان لما ادوس علي زرار الupdateProfile
 بيروح يغير الصور عادي بس لازم تكون مديلة الداتا كلماة من حيث الاسم والرقم والbio فا
 فو مش ادنتهملة  كدا هيرجهم ب null لانة في الاخر هو بيروح يستدعي دالة الgetdata
 فا كدا هو راح يستدعي دالة الgetdata بس من غير باقي الداتا فا هيرجعهم ب null
 ممكن الحل يكون في انك تروح تفصل model خاص بداتا الصور لوحدهم وتعملهم getDataImages
 ممكن يكون دا حل  فا علي ا يحال  منفعش اننا نفصل  تغير البيانات مع تغير الصورة
 يعني انت لو غيرت الاسم وغيرت الصورة بتاعة البرولفايل ودوست علي updateprofile
 هيغير الاسم وهغير الصورة طب لو دوست علي edit details  بس هيغير الاسم او اي بيانات فقط
 ولا يغير الصور  لانة بيستدعي دالة updateUser بس لازم  تديلة الصور الموجودة حاليا في
 الmodel الصور المتخزنة في الfirestore database يعني

 updateUserImages   خد بالك احنا وقفنا دالة اسمها
 وعملنا الشروط برا مع دوسة الزراير في ملف الedit_profile.dart
   */

