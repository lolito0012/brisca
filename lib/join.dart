import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/screens/lobby.dart';
import 'dart:math';



class JoinGameScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String generateRandomId() {
    final Random random = Random();
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(16, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> joinGameRoom(BuildContext context, String roomId) async {
    try {
      String playerId = generateRandomId();

      DocumentSnapshot roomSnapshot = await _firestore.collection('game_rooms').doc(roomId).get();

      if (roomSnapshot.exists && roomSnapshot['status'] == 'waiting') {
        List players = List.from(roomSnapshot['players']);
        if (!players.contains(playerId)) {
          // Añadir el jugador a la lista de players
          await _firestore.collection('game_rooms').doc(roomId).update({
            'players': FieldValue.arrayUnion([playerId]),
          });

          Navigator.pushReplacementNamed(
            context,
            '/lobby',
            arguments: {'roomId': roomId},
          );
        } else {
          print('Jugador ya en la sala');
        }
      } else {
        print('Sala no disponible o ya en juego');
      }
    } catch (e) {
      print('Error al unirse a la sala de juego: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unirse a Sala'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Ingrese el ID de la Sala'),
            ),
            ElevatedButton(
              onPressed: () => joinGameRoom(context, _controller.text),
              child: Text('Unirse a Sala'),
            ),
          ],
        ),
      ),
    );
  }
}