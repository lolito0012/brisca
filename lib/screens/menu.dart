import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'package:app/logic/logic.dart';


class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brisca Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  GameScreen(game: BriscaGame())),
                );
              },
              child: const Text('Play'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_game');
              },
              child: const Text('Create Room'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/join_game');
              },
              child: const Text('Join Room'),
            ),
          ],
        ),
      ),
    );
  }
}
