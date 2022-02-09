abstract class LoginStates{}

class InitialState extends LoginStates{}

class LoginLoadingState extends LoginStates{}

class LoginSuccessStateState extends LoginStates{
  final String?uId;

  LoginSuccessStateState(this.uId);

}

class LoginErrorState extends LoginStates{
  final String?error;

  LoginErrorState(this.error);
}


class ChangePasswordVisibilityState extends LoginStates{}

