import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/presentation/pages/game_page.dart';
import 'package:tic_tac_toe/presentation/widgets/default_button.dart';
import 'package:tic_tac_toe/providers/theme.dart';

/// Menu page widget to select the game mode (single player or two players)
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // select the game mode
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.brightness_2
                  : Icons.brightness_5,
            ),
            onPressed: () {
              // change the theme
              Provider.of<ThemeProvider>(context, listen: false).changeTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GamePage(isSinglePlayer: true),
                  ),
                );
              },
              text: 'Single Player',
            ),
            const SizedBox(height: 16),
            DefaultButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GamePage(isSinglePlayer: false),
                  ),
                );
              },
              text: 'Two Players',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
