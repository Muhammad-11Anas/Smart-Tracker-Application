import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/activity_provider.dart';
import 'ui/screens/tracker_screen.dart';
import 'ui/screens/activity_list_screen.dart';
import 'ui/screens/settings_screen.dart';

void main() {
  runApp(const SmartTrackerApp());
}

class SmartTrackerApp extends StatelessWidget {
  const SmartTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActivityProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartTracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF050816),
          cardTheme: const CardThemeData(
            color: Color(0xFF0B1120),
            elevation: 4.0,
            margin: EdgeInsets.all(8),
          ),
        ),
        home: const MainShell(),
      ),
    );
  }
}

// ... MainShell etc. stays the same


class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const TrackerScreen(),
      const ActivityListScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF020617),
        currentIndex: _index,
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.white60,
        onTap: (i) {
          setState(() {
            _index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), label: 'Settings',
          ),
        ],
      ),
    );
  }
}
