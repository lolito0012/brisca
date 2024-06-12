import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/screens/lobby.dart';
import 'dart:math';
class CreateGameScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createGameRoom(BuildContext context) async {
    try {
      // Generar un ID único para el jugador creador de la sala
      String playerId = generateRandomId();

      // Crear la sala de juego con el jugador creador incluido en la lista de jugadores
      DocumentReference gameRoom = await _firestore.collection('game_rooms').add({
        'status': 'waiting',
        'players': [playerId], // Agregar el ID del jugador creador a la lista de jugadores
      });

      // Navegar al lobby con el ID de la sala como argumento
      Navigator.pushReplacementNamed(
        context,
        '/lobby',
        arguments: {'roomId': gameRoom.id},
      );
    } catch (e) {
      print('Error creating game room: $e');
    }
  }

  // Generar un ID único para el jugador
  String generateRandomId() {
    final Random random = Random();
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(16, (index) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Game'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => createGameRoom(context),
          child: Text('Crear Sala'),
        ),
      ),
    );
  }
}