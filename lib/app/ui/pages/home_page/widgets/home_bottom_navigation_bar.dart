import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNavigationBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF31ADA0),
      ),
      child: BottomNavigationBar(
        items: items,
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF59D999),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 45,
        backgroundColor: const Color(0xFF31ADA0),
      ),
    );
  }
}
