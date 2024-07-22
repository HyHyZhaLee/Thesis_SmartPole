import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_app/AppFunction/global_variables.dart';
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
      duration: Duration(milliseconds: 50),
      vsync: this,
    );
    _widthAnimation = Tween<double>(begin: 103, end: 349).animate(_animationController);
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
          margin: USE_BORDER_RADIUS? EdgeInsets.all(10): EdgeInsets.all(0),
          child: MouseRegion(
            onEnter: (_) => _handleMouseEnter(true),
            onExit: (_) => _handleMouseEnter(false),
            child: ClipRRect(
              borderRadius: USE_BORDER_RADIUS ? BorderRadius.circular(31) : BorderRadius.circular(0),
              child: AnimatedBuilder(
                animation: _widthAnimation,
                builder: (context, child) {
                  return Container(
                    width: _widthAnimation.value,
                    color: PRIMARY_PANEL_COLOR,
                    child: Column(
                      children: <Widget>[
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
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: _buildDrawerItem(1, Icons.apps, 'Main Dashboard'),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: _buildDrawerItem(2, Icons.lightbulb_outline, 'Light Control'),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: _buildDrawerItem(3, Icons.schedule, 'Lighting Schedule'),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: _buildDrawerItem(4, Icons.videocam, 'Security Cameras'),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: _buildDrawerItem(5, Icons.tv, 'Advertisement Schedule'),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: _buildDrawerItem(6, Icons.thermostat, 'Environmental Sensors'),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: _buildDrawerItem(7, Icons.bar_chart, 'Historical Data'),
                              ),
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
      leading: Padding(
        //padding left 16
        padding: const EdgeInsets.only(left: 16),
        child: Icon(icon, color: Colors.white, size: 35),
      ),
      title: _isExpanded
          ? Text(
        title,
        style: TextStyle(fontSize: 20, color: isSelected ? Colors.black : Colors.white),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        //text size = 20

      )
          : null,
      onTap: () => widget.onDestinationSelected(index),
    );
  }

}
