import 'package:flutter/material.dart';

class CustomNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const CustomNavigationRail({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      leading: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/profile.jpg'), // Thay đổi đường dẫn nếu cần
          ),
          SizedBox(height: 16),
        ],
      ),
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Icons.home),
          selectedIcon: Icon(Icons.home, color: Colors.white),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.lightbulb_outline),
          selectedIcon: Icon(Icons.lightbulb, color: Colors.white),
          label: Text('Light Control'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.schedule),
          selectedIcon: Icon(Icons.schedule, color: Colors.white),
          label: Text('Lighting Schedule'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.videocam),
          selectedIcon: Icon(Icons.videocam, color: Colors.white),
          label: Text('Security Cameras'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.tv),
          selectedIcon: Icon(Icons.tv, color: Colors.white),
          label: Text('Advertisement Schedule'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.thermostat),
          selectedIcon: Icon(Icons.thermostat, color: Colors.white),
          label: Text('Environmental Sensors'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.bar_chart),
          selectedIcon: Icon(Icons.bar_chart, color: Colors.white),
          label: Text('Historical Data'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.exit_to_app),
          selectedIcon: Icon(Icons.exit_to_app, color: Colors.white),
          label: Text('Exit'),
        ),
      ],
    );
  }
}
