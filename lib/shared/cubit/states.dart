
abstract class SocialStates{}

class InitialState extends SocialStates{}

class ChangeAppModeState extends SocialStates{}

class ChangeItemBottomNavBarState extends SocialStates{}

class NewPostState extends SocialStates{}

class GetUserLoadingState extends SocialStates{}

class GetUserSuccessState extends SocialStates{}

class GetUserErrorState extends SocialStates{
  final String?error;

  GetUserErrorState(this.error);
}

class GetAllUsersLoadingState extends SocialStates{}

class GetAllUsersSuccessState extends SocialStates{}

class GetAllUsersErrorState extends SocialStates{
  final String?error;

  GetAllUsersErrorState(this.error);
}

class GetPostsLoadingState extends SocialStates{}

class GetPostsSuccessState extends SocialStates{}

class GetPostsErrorState extends SocialStates{}

class ImagePickerProfileSuccessState extends SocialStates{}

class ImagePickerProfileErrorState extends SocialStates{}

class ImagePickerCoverSuccessState extends SocialStates{}

class ImagePickerCoverErrorState extends SocialStates{}

class UploadImageProfileSuccessState extends SocialStates{}

class UploadImageProfileErrorState extends SocialStates{}

class UploadImageCoverSuccessState extends SocialStates{}

class UploadImageCoverErrorState extends SocialStates{}

class UserUpdateLoadingState extends SocialStates{}

class UserUpdateErrorState extends SocialStates{}

//Create Post

class ImagePickerPostSuccessState extends SocialStates{}

class ImagePickerPostErrorState extends SocialStates{}
////////////////////////////////////
class UploadPhotoPostLoadingState extends SocialStates{}

class CreateNewPostLoadingState extends SocialStates{}

class CreateNewPostSuccessState extends SocialStates{}

class CreateNewPostErrorState extends SocialStates{}

class RemovePostImageState extends SocialStates{}

class LikePostsSuccessState extends SocialStates{}

class LikePostsErrorState extends SocialStates{}

class UnLikePostsSuccessState extends SocialStates{}

class UnLikePostsErrorState extends SocialStates{}

class GetLikedUsersLoadingState extends SocialStates{}

class GetLikedUsersSuccessState extends SocialStates{}

//Comments
class CreateNewCommentSuccessStates extends SocialStates{}

class CreateNewCommentErrorStates extends SocialStates{}

class UploadCommentImageLoadingStates extends SocialStates{}

class UploadCommentImageErrorStates extends SocialStates{}

class GetCommentsLoadingState extends SocialStates{}

class GetCommentsSuccessState extends SocialStates{}

class GetCommentsErrorState extends SocialStates{}

class GetCommentImageFromGalleryState extends SocialStates{}

class GetCommentImageErrorStates extends SocialStates{}

class SelectImageSuccessState extends SocialStates{}

class ImagePickerCameraSuccessState extends SocialStates{}



//Chat

class SendMessageSuccessState extends SocialStates{}

class SendMessageErrorState extends SocialStates{}

class GetAllMessagesSuccessState extends SocialStates{}

class DeleteCommentsSuccessState extends SocialStates{}

// Search

class BuildSearchFieldState extends SocialStates{}

class BuildNoContentState extends SocialStates{}

class HandleSearchSuccessState extends SocialStates{}


