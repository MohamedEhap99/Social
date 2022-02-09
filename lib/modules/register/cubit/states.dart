abstract class RegisterStates{}

class initialState extends RegisterStates{}

class RegisterLoadingState extends RegisterStates{}

class RegisterSuccessStateState extends RegisterStates{}

class RegisterErrorState extends RegisterStates{
  final String?error;

  RegisterErrorState(this.error);
}
class CreatUserLoadingState extends RegisterStates{}

class CreatUserSuccessStateState extends RegisterStates{}

class CreatUserErrorState extends RegisterStates{
  final String?error;

  CreatUserErrorState(this.error);
}

class ChangePasswordShowState extends RegisterStates{}