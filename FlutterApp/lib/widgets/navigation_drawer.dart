import 'package:flutter/material.dart';

class CustomNavigationDrawer extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const CustomNavigationDrawer({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  _CustomNavigationDrawerState createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  bool _isExpanded = false;

  void _handleMouseEnter(bool isEntering) {
    setState(() {
      _isExpanded = isEntering;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleMouseEnter(true),
      onExit: (_) => _handleMouseEnter(false),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(31),
        child: Container(
          width: _isExpanded ? 250 : 70,
          color: const Color(0xFF7A40F2),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: [
                    _buildDrawerItem(0, Icons.home, 'Home'),
                    _buildDrawerItem(1, Icons.lightbulb_outline, 'Light Control'),
                    _buildDrawerItem(2, Icons.schedule, 'Lighting Schedule'),
                    _buildDrawerItem(3, Icons.videocam, 'Security Cameras'),
                    _buildDrawerItem(4, Icons.tv, 'Advertisement Schedule'),
                    _buildDrawerItem(5, Icons.thermostat, 'Environmental Sensors'),
                    _buildDrawerItem(6, Icons.bar_chart, 'Historical Data'),
                    _buildDrawerItem(7, Icons.exit_to_app, 'Exit'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String title) {
    bool isSelected = widget.selectedIndex == index;
    return ListTile(
      selected: isSelected,
      selectedTileColor: const Color(0xFFF9F9F9),
      leading: Icon(icon, color: isSelected ? Colors.black : Colors.white),
      title: _isExpanded ? Text(title, style: TextStyle(color: isSelected ? Colors.black : Colors.white)) : null,
      onTap: () => widget.onDestinationSelected(index),
    );
  }
}
