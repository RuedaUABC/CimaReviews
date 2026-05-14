import 'package:flutter/material.dart';

class CimaNavigationScaffold extends StatelessWidget {
  const CimaNavigationScaffold({
    super.key,
    required this.currentIndex,
    required this.child,
    this.floatingActionButton,
  });

  final int currentIndex;
  final Widget child;
  final Widget? floatingActionButton;

  static const _routes = ['/home', '/events', '/profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          if (index == currentIndex) {
            return;
          }
          Navigator.pushReplacementNamed(context, _routes[index]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Eventos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
