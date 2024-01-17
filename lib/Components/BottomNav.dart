// BottomNav.dart
import 'package:flutter/material.dart';
import 'package:news1/Provider/BottomNavProvider.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<BottomNavBarProvider>(context);

    return BottomNavigationBar(
      currentIndex: navProvider.currentIndex,
      onTap: (index) {
        navProvider.updateIndex(index, context);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
      ],
    );
  }
}
