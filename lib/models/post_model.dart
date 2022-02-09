import 'comment_model.dart';

class PostModel{
  String?uId;
  String?uName;
  String?uImage;
  String?dateTime;
  String?postText;
  String?postImage;
  String? postID ;
  List<String>?postLikes = [];
  PostModel({
    this.uId,
    this.uName,
    this.uImage,
    this.dateTime,
    this.postText,
    this.postImage,
    this.postID,
    this.postLikes,
  });
  PostModel.fromJson(Map<String,dynamic>json){
    uId=json['uId'];
    uName=json['name'];
    uImage=json['image'];
    dateTime=json['dateTime'];
    postText=json['text'];
    postImage=json['postImage'];
    postID=json['postID'];
    postLikes = (json['postLikes'] != null ? List<String>.from(json['postLikes']) : null)!;
  }

  Map<String,dynamic> toMap(){
    return{
      'uId':uId,
      'name':uName,
      'image':uImage,
      'dateTime':dateTime,
      'text':postText,
      'postImage':postImage,
      'postID':postID,
      'postLikes': postLikes!.map((e) => e.toString()).toList(),
    };
  }
}