import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/presentation/widgets/default_button.dart';

// constants
const String playerX = 'X';
const String playerO = 'O';
const Color playerXColor = Colors.red;
const Color playerOColor = Colors.blue;

/// Tic Tac Toe page widget  to play the game
class GamePage extends StatefulWidget {
  final bool isSinglePlayer;
  const GamePage({super.key, required this.isSinglePlayer});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const int boardSize = 9;
  static List<String> initialBoard = List.filled(boardSize, '');

  int playerXScore = 0;
  int playerOScore = 0;

  List<String> board = [...initialBoard];
  String initialStartingPlayer = playerX;
  String currentPlayer = playerX;

  /// Function to reset the board
  void resetBoard() {
    setState(() {
      board = [...initialBoard];
      // Switch the starting player
      initialStartingPlayer =
          initialStartingPlayer == playerX ? playerO : playerX;
      currentPlayer = initialStartingPlayer;
      // if it's the computer's turn, make a move using the minimax algorithm
      if (widget.isSinglePlayer && initialStartingPlayer == playerO) {
        int computerMove = getBestMove();
        makeMove(computerMove);
      }
    });
  }

  /// Function to update the scores
  void updateScores(String? winner) {
    if (winner == playerX) {
      setState(() {
        playerXScore++;
      });
    } else if (winner == playerO) {
      setState(() {
        playerOScore++;
      });
    }
  }

  /// Function to check if the game is over
  String? checkWin() {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (board[i] != '' &&
          board[i] == board[i + 1] &&
          board[i + 1] == board[i + 2]) {
        return board[i];
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[i] != '' &&
          board[i] == board[i + 3] &&
          board[i + 3] == board[i + 6]) {
        return board[i];
      }
    }

    // Check diagonals
    if (board[0] != '' && board[0] == board[4] && board[4] == board[8]) {
      return board[0];
    }
    if (board[2] != '' && board[2] == board[4] && board[4] == board[6]) {
      return board[2];
    }

    // Check for tie
    bool isTie = true;
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        isTie = false;
        break;
      }
    }
    if (isTie) {
      return 'Tie';
    }

    return null;
  }

  /// Function to make a move
  void makeMove(int index) {
    if (board[index] == '') {
      setState(() {
        board[index] = currentPlayer;
        currentPlayer = currentPlayer == playerX ? playerO : playerX;
      });

      // Check if the game is over
      String? winner = checkWin();
      if (winner != null) {
        return;
      }

      if (widget.isSinglePlayer && currentPlayer == playerO) {
        // If it's the computer's turn, make a move using the minimax algorithm
        int computerMove = getBestMove();
        makeMove(computerMove);
      }
    }
  }

  /// Function to get the best move for the computer using the minimax algorithm and alpha-beta pruning to reduce the number of nodes that need to be evaluated in the search tree
  int getBestMove() {
    int bestScore = -1000;
    int bestMove = -1;
    int alpha = -1000;
    int beta = 1000;
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = playerO;
        int score = minimax(false, alpha, beta);
        board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
        alpha = max(alpha, bestScore);
      }
    }
    return bestMove;
  }

  /// Minimax algorithm to find the best move for the computer
  int minimax(bool isMaximizing, int alpha, int beta) {
    String? winner = checkWin();
    if (winner == playerO) {
      return 10;
    } else if (winner == playerX) {
      return -10;
    } else if (winner == 'Tie') {
      return 0;
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = playerO;
          int score = minimax(false, alpha, beta);
          board[i] = '';
          bestScore = max(bestScore, score);
          alpha = max(alpha, bestScore);
          if (beta <= alpha) {
            break;
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = playerX;
          int score = minimax(true, alpha, beta);
          board[i] = '';
          bestScore = min(bestScore, score);
          beta = min(beta, bestScore);
          if (beta <= alpha) {
            break;
          }
        }
      }
      return bestScore;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the scores
              Text(
                'Player X: $playerXScore',
                style: const TextStyle(fontSize: 20, color: playerXColor),
              ),
              Text(
                'Player O: $playerOScore',
                style: const TextStyle(fontSize: 20, color: playerOColor),
              ),
              const SizedBox(height: 16),

              // Display the board
              for (int i = 0; i < 9; i += 3)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int j = 0; j < 3; j++)
                      GestureDetector(
                        onTap: () {
                          if (checkWin() == null) {
                            makeMove(i + j);
                          }
                        },
                        child: Container(
                          constraints: const BoxConstraints(
                            maxHeight: 100,
                            maxWidth: 100,
                          ),
                          height: MediaQuery.of(context).size.width / 5,
                          width: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              board[i + j],
                              style: TextStyle(
                                fontSize: 48,
                                color: board[i + j] == playerX
                                    ? playerXColor
                                    : playerOColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 16),

              // Display whose turn it is if the game is not over and it's not the computer's turn
              if (checkWin() == null && !(widget.isSinglePlayer))
                Text(
                  'It\'s ${currentPlayer == playerX ? 'X' : 'O'}\'s turn',
                  style: TextStyle(
                    fontSize: 24,
                    color:
                        currentPlayer == playerX ? playerXColor : playerOColor,
                  ),
                ),
              const SizedBox(height: 16),

              // Display the winner
              if (checkWin() != null)
                Column(
                  children: [
                    Text(
                      checkWin() == 'Tie'
                          ? 'It\'s a tie!'
                          : '${checkWin()} wins!',
                      style: TextStyle(
                        fontSize: 24,
                        color: checkWin() == playerX
                            ? playerXColor
                            : checkWin() == playerO
                                ? playerOColor
                                : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DefaultButton(
                      onPressed: () {
                        updateScores(checkWin());
                        resetBoard();
                      },
                      text: 'Play Again',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
