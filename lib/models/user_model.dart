
import 'package:social_app/models/post_model.dart';

class UserModel{
  String?uId;
  String?name;
  String?email;
  String?phone;
  String?cover;
  String?image;
  String?bio;
  bool?isEmailVerified;
  List<PostModel>?uPosts =[];
  UserModel({
    this.uId,
    this.name,
    this.email,
    this.phone,
    this.cover,
    this.image,
    this.bio,
    this.isEmailVerified,
     this.uPosts,
  });
  UserModel.fromJson(Map<String,dynamic>?json){
    uId=json!['uId'];
    name=json['name'];
    email=json['email'];
    phone=json['phone'];
    cover=json['cover'];
    image=json['image'];
    bio=json['bio'];
    isEmailVerified=json['isEmailVerified'];

    print(json['uPosts']);
    json['uPosts'].forEach((v)
    {
      if( v != null)
        uPosts!.add(PostModel.fromJson(v));
    }) ;

  }

  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'email':email,
      'phone':phone,
      'cover':cover,
      'image':image,
      'bio':bio,
      'uId':uId,
      'isEmailVerified':isEmailVerified,
      'uPosts' : uPosts!.map((e) => e.toMap()) .toList(),
    };
  }
}