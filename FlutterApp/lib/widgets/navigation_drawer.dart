import 'package:flutter/material.dart';
import 'dart:math' as math;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Constraints for the drawer
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: MouseRegion(
            onEnter: (_) => _handleMouseEnter(true),
            onExit: (_) => _handleMouseEnter(false),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(31),
              child: Container(
                width: _isExpanded ? 349 : 118,
                color: const Color(0xFF7A40F2),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),  // Khoảng cách từ trên xuống nút Home
                    // Home button box
                    Expanded(
                      flex: 190,
                      child: Container(
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.blueAccent)
                        ),
                        margin: EdgeInsets.only(top: 67),
                        child: _buildDrawerItem(0, Icons.home, 'Home'),
                      ),
                    ),
                    // Other buttons box
                    Expanded(
                      flex: 705,
                      child: Container(
                        child: ListView(
                          children: [
                            _buildDrawerItem(2, Icons.lightbulb_outline, 'Light Control'),
                            _buildDrawerItem(3, Icons.schedule, 'Lighting Schedule'),
                            _buildDrawerItem(4, Icons.videocam, 'Security Cameras'),
                            _buildDrawerItem(5, Icons.tv, 'Advertisement Schedule'),
                            _buildDrawerItem(6, Icons.thermostat, 'Environmental Sensors'),
                            _buildDrawerItem(7, Icons.bar_chart, 'Historical Data'),
                          ],
                        ),
                      ),
                    ),
                    // Exit button box
                    Expanded(
                      flex: 102,
                      child: Container(
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.blueAccent)
                        ),
                        child: _buildDrawerItem(8, Icons.exit_to_app, 'Exit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String title) {
    bool isSelected = widget.selectedIndex == index;
    return ListTile(
      selected: isSelected,
      selectedTileColor: const Color(0xFFF9F9F9),
      leading: Icon(icon, color: Colors.white, size: 23),
      title: _isExpanded ? Text(title, style: TextStyle(color: isSelected ? Colors.black : Colors.white)) : null,
      onTap: () => widget.onDestinationSelected(index),
    );
  }
}
