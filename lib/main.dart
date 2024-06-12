import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/options/firebase_options.dart';
import 'package:app/screens/menu.dart';
import 'create.dart';
import 'join.dart';
import 'package:app/screens/lobby.dart';
import 'package:app/screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brisca Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MenuScreen(),
        '/create_game': (context) => CreateGameScreen(),
        '/join_game': (context) => JoinGameScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/lobby') {
          final args = settings.arguments as Map;
          return MaterialPageRoute(
            builder: (context) {
              return LobbyScreen(roomId: args['roomId']);
            },
          );
        } else if (settings.name == '/game') {
          final args = settings.arguments as Map;
          return MaterialPageRoute(
            builder: (context) {
              return GameScreen(game: args['game']);
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}