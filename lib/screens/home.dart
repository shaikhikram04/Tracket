import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedItem = 0;

  void _selectItem(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cricket Stats Manager',
        ),
      ),
      drawer: const Drawer(),
      body: const Center(
        child: Text('No Match Schedule yet!'),
      ),
      floatingActionButton: IconButton(
        iconSize: 50,
        color: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.add_circle_sharp),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedItem,
        elevation: 8,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        onTap: _selectItem,
        selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_cricket),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Tournament',
          ),
        ],
      ),
    );
  }
}
