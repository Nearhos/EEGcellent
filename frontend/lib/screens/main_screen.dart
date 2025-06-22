import 'package:flutter/material.dart';
import 'package:gauge/screens/progress_screen.dart';
import 'package:gauge/screens/tracking_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _screenIndex = 0;

  static const List<Widget> _screens = [
    TrackingScreen(),
    ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(_screenIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Tracking",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Progress",
          ),
        ],
        onTap: (value) {
          setState(() {
            _screenIndex = value;
          });
        },
        currentIndex: _screenIndex,
        backgroundColor:
            Theme.of(context).colorScheme.primary,
        selectedItemColor:
            Theme.of(
              context,
            ).colorScheme.onPrimaryContainer,
        unselectedItemColor:
            Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
