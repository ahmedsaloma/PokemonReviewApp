import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

/// A shared scaffold that wraps every main screen and shows
/// the bottom navigation bar with the correct tab highlighted.
class AppScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.backgroundColor,
  });

  /// Map the current route path to a nav-bar index.
  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/pokemon')) return 1;
    if (location.startsWith('/categories')) return 2;
    if (location.startsWith('/countries')) return 3;
    if (location.startsWith('/owners')) return 4;
    if (location.startsWith('/reviewers')) return 5;
    return 0; // '/home' and fallback
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/pokemon');
        break;
      case 2:
        context.go('/categories');
        break;
      case 3:
        context.go('/countries');
        break;
      case 4:
        context.go('/owners');
        break;
      case 5:
        context.go('/reviewers');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: appBar,
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (i) => _onTap(context, i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon_outlined),
            activeIcon: Icon(Icons.catching_pokemon),
            label: 'Pokémon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category_rounded),
            label: 'Types',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public_outlined),
            activeIcon: Icon(Icons.public_rounded),
            label: 'Regions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Owners',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review_outlined),
            activeIcon: Icon(Icons.rate_review_rounded),
            label: 'Reviewers',
          ),
        ],
      ),
    );
  }
}
