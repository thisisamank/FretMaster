import 'package:dyte_uikit_flutter_starter_app/pages/widgets/size/size_config.dart';
import 'package:dyte_uikit_flutter_starter_app/provider_logger.dart';
import 'package:dyte_uikit_flutter_starter_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [Logger()],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig().init(context);
    return MaterialApp(
        title: 'DyteMeeting',
        theme: AppTheme.darkTheme,
        home: const Center(
          child: Text('Dyte Flutter Starter App'),
        ),
      );
  }
}
