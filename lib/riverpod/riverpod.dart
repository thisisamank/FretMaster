import 'package:dyte_uikit_flutter_starter_app/riverpod/dyte_room_notifier.dart';
import 'package:dyte_uikit_flutter_starter_app/riverpod/states/app_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appNotifier =
    NotifierProvider<AppNotifier, MyAppStates>(
  () => AppNotifier(),
);
