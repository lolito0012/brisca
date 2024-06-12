import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'game_screen.dart';
import 'package:app/logic/logic.dart' as game_logic;
import 'package:app/services/service.dart'; // Importar el servicio

class LobbyScreen extends StatefulWidget {
  final String roomId;

  LobbyScreen({required this.roomId});

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<DocumentSnapshot> _gameRoomStream;

  @override
  void initState() {
    super.initState();
    _gameRoomStream = _firestore.collection('game_rooms').doc(widget.roomId).snapshots();
  }

  void _startGame() {
    // Aquí asumo que la clase BriscaGame está en logic.dart
    game_logic.BriscaGame game = game_logic.BriscaGame();
    game.initGame();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(game: game)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _gameRoomStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var gameRoomData = snapshot.data!.data() as Map<String, dynamic>;
          var players = gameRoomData['players'] as List<dynamic>;

          if (players.length == 4) {
            _startGame();
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Esperando jugadores: ${players.length}/4'),
                // Mostrar la lista de jugadores esperando
                for (var player in players) Text(player.toString()),
              ],
            ),
          );
        },
      ),
    );
  }
}
