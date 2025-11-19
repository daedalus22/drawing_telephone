import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import 'game_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceVariant,
            ],
          ),
        ),
        child: BlocListener<GameBloc, GameState>(
          listener: (context, state) {
            if (state is GameActive) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const GamePage()),
              );
            } else if (state is GameError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'app_logo',
                    child: Icon(
                      Icons.brush_rounded,
                      size: 100,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Drawing\nTelephone',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<GameBloc>().add(StartGame());
                      },
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Start New Game'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 250,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['json'],
                          withData: true, // Important for Web to get bytes
                        );

                        if (result != null &&
                            result.files.single.bytes != null) {
                          // Web or Mobile with data
                          final xFile = XFile.fromData(
                            result.files.single.bytes!,
                            name: result.files.single.name,
                          );
                          // ignore: use_build_context_synchronously
                          context.read<GameBloc>().add(ImportSession(xFile));
                        } else if (result != null &&
                            result.files.single.path != null) {
                          // Mobile fallback if bytes are null (though withData: true should give bytes)
                          final xFile = XFile(result.files.single.path!);
                          // ignore: use_build_context_synchronously
                          context.read<GameBloc>().add(ImportSession(xFile));
                        }
                      },
                      icon: const Icon(Icons.file_upload_rounded),
                      label: const Text('Join Game'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
