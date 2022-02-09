class CommentModel{
  String?uId;
  String?uName;
  String?uImage;
  String?commentText;
  String?commentImage;
  String?dateTime;
  String?commentID;

  CommentModel({
    this.uId,
    this.uName,
    this.uImage,
    this.commentText,
    this.commentImage,
    this.dateTime,
    this.commentID,
});

  CommentModel.fromJson(Map<String,dynamic>json){
    uId=json['uId'];
    uName=json['uName'];
    uImage=json['uImage'];
    commentText=json['CommentText'];
    commentImage=json['commentPhoto'];
    dateTime=json['dateTime'];
    commentID=json['commentID'];
  }
  Map<String,dynamic> toMap(){
    return{
      'uId':uId,
      'uName':uName,
      'uImage':uImage,
      'CommentText':commentText,
      'commentPhoto':commentImage,
      'dateTime':dateTime,
      'commentID':commentID,
    };
  }
}