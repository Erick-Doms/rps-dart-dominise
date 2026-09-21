import 'dart:io';

/// The moves a player is allowed to choose.
const List<String> validMoves = ['rock', 'paper', 'scissors'];

/// Prompts for a player's name using [prompt].
///
/// Returns [defaultName] when the input is null or empty.
String getPlayerName(String prompt, String defaultName) {
  stdout.write('$prompt ');
  final String? input = stdin.readLineSync();
  final String? trimmed = input?.trim();

  if (trimmed == null || trimmed.isEmpty) {
    return defaultName;
  }
  return trimmed;
}

/// Cleans up [input] and checks it against [validMoves].
///
/// Returns the cleaned move if it is valid, or null if it is not.
String? validateMove(String? input) {
  final String? cleaned = input?.trim().toLowerCase();

  if (cleaned != null && validMoves.contains(cleaned)) {
    return cleaned;
  }
  return null;
}

/// Asks [playerName] for a move and keeps asking until it is valid.
///
/// Returns the validated move (always one of [validMoves]).
String getMove(String playerName) {
  while (true) {
    stdout.write('$playerName, enter your move (rock, paper, scissors): ');
    final String? move = validateMove(stdin.readLineSync());

    if (move != null) {
      return move;
    }
    print('Invalid move. Please type rock, paper, or scissors.');
  }
}

/// Prints 30 blank lines so the previous player's move scrolls out of view.
void hideScreen() {
  for (int i = 0; i < 30; i++) {
    print('');
  }
}

/// Decides the winner of one round.
///
/// Returns the winning player's name, or null when the round is a draw.
String? decideWinner(
  String player1Name,
  String move1,
  String player2Name,
  String move2,
) {
  if (move1 == move2) {
    return null;
  }

  final bool player1Wins = (move1 == 'rock' && move2 == 'scissors') ||
      (move1 == 'paper' && move2 == 'rock') ||
      (move1 == 'scissors' && move2 == 'paper');

  return player1Wins ? player1Name : player2Name;
}

/// Prints the current score for both players.
void printScores(String name1, int score1, String name2, int score2) {
  print('Score -> $name1: $score1 | $name2: $score2');
}

/// Decides the overall winner from the final scores.
///
/// Returns the winner's name, or null when the scores are tied.
String? decideOverallWinner(
  String name1,
  int score1,
  String name2,
  int score2,
) {
  if (score1 > score2) {
    return name1;
  }
  if (score2 > score1) {
    return name2;
  }
  return null;
}

/// Runs the two-player Rock, Paper, Scissors game until the user quits.
void main() {
  print('=== Rock, Paper, Scissors ===');

  final String player1Name =
      getPlayerName('Player 1, enter your name:', 'Player 1');
  String player2Name = getPlayerName('Player 2, enter your name:', 'Player 2');

  // Keep the names distinct so scores are tracked correctly.
  if (player2Name.toLowerCase() == player1Name.toLowerCase()) {
    player2Name = '$player2Name (2)';
  }

  int player1Score = 0;
  int player2Score = 0;
  int round = 0;
  String? playAgain;

  do {
    round++;
    print('\n--- Round $round ---');

    final String move1 = getMove(player1Name);
    hideScreen();
    final String move2 = getMove(player2Name);

    print('\n$player1Name chose $move1.');
    print('$player2Name chose $move2.');

    final String? winner =
        decideWinner(player1Name, move1, player2Name, move2);
    print('Round winner: ${winner ?? "nobody, it is a draw"}');

    if (winner == player1Name) {
      player1Score++;
    } else if (winner == player2Name) {
      player2Score++;
    }

    printScores(player1Name, player1Score, player2Name, player2Score);

    stdout.write('\nPlay another round? (y/n): ');
    playAgain = stdin.readLineSync();
  } while ((playAgain ?? 'n').trim().toLowerCase() != 'n');

  print('\n=== Final Results ===');
  printScores(player1Name, player1Score, player2Name, player2Score);

  final String? overallWinner = decideOverallWinner(
    player1Name,
    player1Score,
    player2Name,
    player2Score,
  );
  print('Overall winner: ${overallWinner ?? "nobody, the game is tied"}');
}