import 'package:cloud_firestore/cloud_firestore.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a game room with an initial player
  Future<DocumentReference> createGameRoom(String playerId) async {
    try {
      DocumentReference gameRoom = await _firestore.collection('game_rooms').add({
        'status': 'waiting',
        'players': [{'id': playerId, 'index': 0}],
      });
      return gameRoom;
    } catch (e) {
      print('Error creating game room: $e');
      rethrow;
    }
  }

  // Join an existing game room
  Future<void> joinGameRoom(String roomId, String playerId) async {
    try {
      DocumentSnapshot roomSnapshot = await _firestore.collection('game_rooms').doc(roomId).get();

      if (roomSnapshot.exists && roomSnapshot['status'] == 'waiting') {
        List players = List.from(roomSnapshot['players']);
        if (!players.any((player) => player['id'] == playerId)) {
          await _firestore.collection('game_rooms').doc(roomId).update({
            'players': FieldValue.arrayUnion([{'id': playerId, 'index': players.length}]),
          });
        }
      }
    } catch (e) {
      print('Error joining game room: $e');
      rethrow;
    }
  }

  // Get real-time updates of a game room's state
  Stream<DocumentSnapshot> getGameRoomStream(String roomId) {
    return _firestore.collection('game_rooms').doc(roomId).snapshots();
  }
}

// Class to represent the data structure of the game
class GameData {
  final List<PlayerData> players;
  final List<CardData> tableCards;

  GameData({
    required this.players,
    required this.tableCards,
  });

  factory GameData.fromMap(Map<String, dynamic> map) {
    List<dynamic> playersData = map['players'] ?? [];
    List<PlayerData> players = playersData.map((player) => PlayerData.fromMap(player)).toList();

    List<dynamic> tableCardsData = map['table_cards'] ?? [];
    List<CardData> tableCards = tableCardsData.map((card) => CardData.fromMap(card)).toList();

    return GameData(players: players, tableCards: tableCards);
  }
}

// Class to represent a player in the game
class PlayerData {
  final String id;
  final int index;
  final List<CardData> hand;

  PlayerData({
    required this.id,
    required this.index,
    required this.hand,
  });

  factory PlayerData.fromMap(Map<String, dynamic> map) {
    List<dynamic> handData = map['hand'] ?? [];
    List<CardData> hand = handData.map((card) => CardData.fromMap(card)).toList();

    return PlayerData(id: map['id'], index: map['index'], hand: hand);
  }
}

// Class to represent a card in the game
class CardData {
  final String suit;
  final String value;

  CardData({
    required this.suit,
    required this.value,
  });

  factory CardData.fromMap(Map<String, dynamic> map) {
    return CardData(
      suit: map['suit'],
      value: map['value'],
    );
  }
}
