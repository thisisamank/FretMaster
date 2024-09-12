abstract class MyAppStates {}

class InitialState extends MyAppStates {}

class LoadingState extends MyAppStates {}

class ErrorState extends MyAppStates {
  final String message;

  ErrorState(this.message);
}

class SuccessState extends MyAppStates {
  final String message;

  SuccessState(this.message);
}
