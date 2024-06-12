import 'dart:math';

import 'dart:math';

class GameCard {
  final String suit;
  final String value;
  final int points;

  GameCard(this.suit, this.value, this.points);

  @override
  String toString() {
    return '$value$suit';
  }
}

class Player {
  final bool isBot;
  final List<GameCard> hand;
  int points;
  final List<String> cardValues;
  final String name;

  Player(this.isBot, this.cardValues, this.name) : hand = [], points = 0;

  GameCard playCard() {
    if (isBot) {
      var highestValueIndex = 0;
      for (var i = 1; i < hand.length; i++) {
        if (cardValues.indexOf(hand[i].value) < cardValues.indexOf(hand[highestValueIndex].value)) {
          highestValueIndex = i;
        }
      }
      final card = hand.removeAt(highestValueIndex);
      print('Bot juega: $card');
      return card;
    } else {
      final card = hand.removeAt(0);
      print('Jugador humano juega: $card');
      return card;
    }
  }

  void drawCard(GameCard card) {
    hand.add(card);
  }

  void addPoints(int points) {
    this.points += points;
  }
}

class BriscaGame {
  List<Player> players = [];
  List<GameCard> deck = [];
  late GameCard trumpCard;
  List<String> suits = ['❤️', '♦️', '♣️', '♠️'];
  List<String> cardValues = ['A', '3', 'K', 'Q', 'J', '7', '6', '5', '4', '2'];
  Map<String, int> cardPoints = {
    'A': 11, '3': 10, 'K': 4, 'Q': 3, 'J': 2, '7': 0, '6': 0, '5': 0, '4': 0, '2': 0
  };

  void initGame() {
    deck = [];
    for (var suit in suits) {
      for (var value in cardValues) {
        deck.add(GameCard(suit, value, cardPoints[value]!));
      }
    }
    shuffleDeck();
    trumpCard = deck.removeLast(); // La última carta del mazo es la carta de triunfo
    dealInitialCards();
  }

  void shuffleDeck() {
    for (var i = deck.length - 1; i > 0; i--) {
      final j = Random().nextInt(i + 1);
      final temp = deck[i];
      deck[i] = deck[j];
      deck[j] = temp;
    }
  }

  void dealInitialCards() {
    for (var player in players) {
      for (var i = 0; i < 3; i++) {
        player.drawCard(deck.removeAt(0));
      }
    }
  }

  void dealAdditionalCards() {
    for (var player in players) {
      if (deck.isNotEmpty) {
        player.drawCard(deck.removeAt(0));
      }
    }
  }

  int determineRoundWinner(List<GameCard> cardsOnTable) {
    var winningCard = cardsOnTable[0];
    var winningPlayerIndex = 0;
    for (var i = 1; i < cardsOnTable.length; i++) {
      var card = cardsOnTable[i];
      if (card.suit == trumpCard.suit && winningCard.suit != trumpCard.suit) {
        winningCard = card;
        winningPlayerIndex = i;
      } else if (card.suit == winningCard.suit &&
          cardValues.indexOf(card.value) < cardValues.indexOf(winningCard.value)) {
        winningCard = card;
        winningPlayerIndex = i;
      }
    }
    return winningPlayerIndex;
  }

  bool allRoundsPlayed() {
    return deck.isEmpty && players.every((player) => player.hand.isEmpty);
  }
}