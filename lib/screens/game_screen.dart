import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/logic/logic.dart' as game_logic;

class GameScreen extends StatefulWidget {
  final game_logic.BriscaGame game;

  const GameScreen({required this.game, Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<game_logic.GameCard> playerCards = [];
  List<game_logic.GameCard> opponent1Cards = [];
  List<game_logic.GameCard> opponent2Cards = [];
  List<game_logic.GameCard> opponent3Cards = [];
  int currentPlayer = 0;
  int roundNumber = 0;
  List<game_logic.GameCard> cardsOnTable = [];

  @override
  void initState() {
    super.initState();
    widget.game.players = [
      game_logic.Player(false, widget.game.cardValues, 'FELIX'),
      game_logic.Player(true, widget.game.cardValues, 'SOLE'),
      game_logic.Player(true, widget.game.cardValues, 'JAIME'),
      game_logic.Player(true, widget.game.cardValues, 'TERE'),
    ];
    widget.game.initGame();
    updateHands();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Brisca Game'),
    ),
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Trump Card: ${widget.game.trumpCard}'),
          Text('FELIX: ${widget.game.players[0].points} puntos'),
          buildPlayerHand(),
          Text('SOLE: ${widget.game.players[1].points} puntos'),
          buildOpponentHand(opponent1Cards),
          Text('JAIME: ${widget.game.players[2].points} puntos'),
          buildOpponentHand(opponent2Cards),
          Text('TERE: ${widget.game.players[3].points} puntos'),
          buildOpponentHand(opponent3Cards),
          const Text('Table:'),
          buildTable(),
          ElevatedButton(
            onPressed: dealCards,
            child: const Text('Deal Cards'),
          ),
          ElevatedButton(
            onPressed: resetGame,
            child: const Text('Reset Game'),
          ),
        ],
      ),
    ),
  );
}


  Widget buildPlayerHand() {
    return Row(
      children: playerCards.map((card) {
        return GestureDetector(
          onTap: () {
            playCard(card);
          },
          child: CardWidget(card),
        );
      }).toList(),
    );
  }

  Widget buildOpponentHand(List<game_logic.GameCard> hand) {
    return Row(
      children: hand.map((card) {
        return Container(
          width: 50,
          height: 100,
          color: Colors.grey,
          child: const Center(
            child: Text('?'),
          ),
        );
      }).toList(),
    );
  }

  Widget buildTable() {
    return Row(
      children: cardsOnTable.map((card) {
        return CardWidget(card);
      }).toList(),
    );
  }

  void dealCards() {
    setState(() {
      widget.game.dealInitialCards();
      updateHands();
    });
  }

  void resetGame() {
    setState(() {
      widget.game.initGame();
      updateHands();
    });
  }

  void playCard(game_logic.GameCard card) {
    if (currentPlayer == 0) {
      setState(() {
        playerCards.remove(card);
        widget.game.players[0].hand.remove(card);
        cardsOnTable.add(card);
        currentPlayer++;
      });
      opponentPlay();
    }
  }

  void opponentPlay() {
    if (currentPlayer > 0 && currentPlayer < 4) {
      Future.delayed(const Duration(seconds: 2)).then((_) => playOpponentCard());
    }
  }

  void playOpponentCard() {
    if (currentPlayer >= 4) return; // Si currentPlayer es 4 o más, salimos de la función

    final playedCard = widget.game.players[currentPlayer].playCard();
    setState(() {
      switch (currentPlayer) {
        case 1:
          opponent1Cards.remove(playedCard);
          break;
        case 2:
          opponent2Cards.remove(playedCard);
          break;
        case 3:
          opponent3Cards.remove(playedCard);
          break;
      }
      cardsOnTable.add(playedCard);
      currentPlayer++;
    });

    if (currentPlayer < 4) {
      opponentPlay();
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        resolveRound();
      });
    }
  }

  void resolveRound() {
    final winnerIndex = widget.game.determineRoundWinner(cardsOnTable);
    final winningPlayer = widget.game.players[winnerIndex];
    final pointsWon = cardsOnTable.fold(0, (acc, card) => acc + (card.points ?? 0));
    winningPlayer.addPoints(pointsWon);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('END OF ROUND $roundNumber'),
          content: Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'The Winner is Player ${winningPlayer.name} '),
                TextSpan(text: '+ $pointsWon points', style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (!todasLasRondasHanSidoJugadas()) {
                  dealAdditionalCards();
                  updateHands();
                  currentPlayer = 0;
                  allowPlayerToPlay();
                } else {
                  showFinalScreen();
                }
              },
            ),
          ],
        );
      },
    );

    cardsOnTable.clear();
    roundNumber++;
  }

  bool todasLasRondasHanSidoJugadas() {
    return widget.game.deck.isEmpty && widget.game.players.every((player) => player.hand.isEmpty);
  }

  void dealAdditionalCards() {
    if (widget.game.deck.length >= 4) {
      widget.game.players[0].drawCard(widget.game.deck.removeAt(0));
      widget.game.players[1].drawCard(widget.game.deck.removeAt(0));
      widget.game.players[2].drawCard(widget.game.deck.removeAt(0));
      widget.game.players[3].drawCard(widget.game.deck.removeAt(0));
    }
  }

  void updateHands() {
    setState(() {
      playerCards.clear();
      playerCards.addAll(widget.game.players[0].hand);

      opponent1Cards.clear();
      opponent1Cards.addAll(widget.game.players[1].hand);

      opponent2Cards.clear();
      opponent2Cards.addAll(widget.game.players[2].hand);

      opponent3Cards.clear();
      opponent3Cards.addAll(widget.game.players[3].hand);
    });
    print('Player hand after update: $playerCards');
  }

  void allowPlayerToPlay() {
    // Implementar lógica para permitir al jugador jugar una carta
  }

  void showFinalScreen() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Final Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Points:'),
              const SizedBox(height: 10),
              for (int i = 0; i < widget.game.players.length; i++)
                Text('${widget.game.players[i].name}: ${widget.game.players[i].points} points'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class CardWidget extends StatelessWidget {
  final game_logic.GameCard card;

  const CardWidget(this.card, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text('${card.value}${card.suit}'),
      ),
    );
  }
}
