import 'package:dyte_uikit_flutter_starter_app/riverpod/states/app_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppNotifier extends Notifier<MyAppStates> {
  AppNotifier();

  @override
  MyAppStates build() {
    return InitialState();
  }
}
