import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/game/presentation/bloc/game_bloc.dart';
import 'features/game/presentation/pages/start_page.dart'; // Will create this next

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const DrawingTelephoneApp());
}

class DrawingTelephoneApp extends StatelessWidget {
  const DrawingTelephoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<GameBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Drawing Telephone',
        theme: AppTheme.lightTheme,
        home: const StartPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
