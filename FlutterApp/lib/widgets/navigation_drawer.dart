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

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _widthAnimation = Tween<double>(begin: 118, end: 349).animate(_animationController);
  }

  void _handleMouseEnter(bool isEntering) {
    setState(() {
      _isExpanded = isEntering;
      isEntering ? _animationController.forward() : _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: EdgeInsets.all(10),
          child: MouseRegion(
            onEnter: (_) => _handleMouseEnter(true),
            onExit: (_) => _handleMouseEnter(false),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(31),
              child: AnimatedBuilder(
                animation: _widthAnimation,
                builder: (context, child) {
                  return Container(
                    width: _widthAnimation.value,
                    color: const Color(0xFF7A40F2),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Expanded(
                          flex: 190,
                          child: Container(
                            margin: EdgeInsets.only(top: 67),
                            child: _buildDrawerItem(0, Icons.home, 'Home'),
                          ),
                        ),
                        Expanded(
                          flex: 705,
                          child: ListView(
                            children: [
                              _buildDrawerItem(1, Icons.apps, 'Main Dashboard'),
                              _buildDrawerItem(2, Icons.lightbulb_outline, 'Light Control'),
                              _buildDrawerItem(3, Icons.schedule, 'Lighting Schedule'),
                              _buildDrawerItem(4, Icons.videocam, 'Security Cameras'),
                              _buildDrawerItem(5, Icons.tv, 'Advertisement Schedule'),
                              _buildDrawerItem(6, Icons.thermostat, 'Environmental Sensors'),
                              _buildDrawerItem(7, Icons.bar_chart, 'Historical Data'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 102,
                          child: Container(
                            child: _buildDrawerItem(8, Icons.exit_to_app, 'Exit'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
      title: _isExpanded
          ? Text(
        title,
        style: TextStyle(color: isSelected ? Colors.black : Colors.white),
        overflow: TextOverflow.ellipsis, // Thêm dòng này để xử lý tràn chữ
        maxLines: 1, // Giới hạn số dòng là 1
      )
          : null,
      onTap: () => widget.onDestinationSelected(index),
    );
  }

}
