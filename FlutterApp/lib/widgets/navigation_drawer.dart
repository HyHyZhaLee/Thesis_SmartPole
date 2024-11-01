import 'package:flutter/material.dart';
import 'package:flutter_app/AppFunction/global_variables.dart';

const double space_between_icon = 30.0;
const double space = 10.0;

class CustomNavigationDrawer extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const CustomNavigationDrawer({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

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
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    _widthAnimation = Tween<double>(begin: 103 - space, end: 349).animate(_animationController);
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
          margin: USE_BORDER_RADIUS ? const EdgeInsets.all(10) : const EdgeInsets.all(0),
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
                            margin: const EdgeInsets.only(top: 67),
                            child: _buildDrawerItem(0, Icons.home, 'Home',
                              clickedIconPath: 'lib/Assets/icons/page_icons/home_clicked.png',
                              unclickedIconPath: 'lib/Assets/icons/page_icons/home_unclicked.png',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 705,
                          child: ListView(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: space_between_icon, top: space_between_icon),
                                child: _buildDrawerItem(1, Icons.apps, 'Main Dashboard',
                                  clickedIconPath: 'lib/Assets/icons/page_icons/MainDashboard_clicked.png',
                                  unclickedIconPath: 'lib/Assets/icons/page_icons/MainDashboard_unclicked.png',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: space_between_icon),
                                child: _buildDrawerItem(2, Icons.lightbulb_outline, 'Light Control',
                                  clickedIconPath: 'lib/Assets/icons/page_icons/LightControl_clicked.png',
                                  unclickedIconPath: 'lib/Assets/icons/page_icons/LightControl_unclicked.png',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: space_between_icon),
                                child: _buildDrawerItem(3, Icons.schedule, 'Lighting Schedule',
                                  clickedIconPath: 'lib/Assets/icons/page_icons/LightingSchedule_clicked.png',
                                  unclickedIconPath: 'lib/Assets/icons/page_icons/LightingSchedule_unclicked.png',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: space_between_icon),
                                child: _buildDrawerItem(4, Icons.videocam, 'Security Cameras',
                                  clickedIconPath: 'lib/Assets/icons/page_icons/sercurity_clicked.png',
                                  unclickedIconPath: 'lib/Assets/icons/page_icons/sercurity_unclicked.png',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: space_between_icon),
                                child: _buildDrawerItem(5, Icons.tv, 'Advertisement Schedule',
                                  clickedIconPath: 'lib/Assets/icons/page_icons/advertisement_clicked.png',
                                  unclickedIconPath: 'lib/Assets/icons/page_icons/advertisement_unclicked.png',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: space_between_icon),
                                child: _buildDrawerItem(6, Icons.thermostat, 'Environmental Sensors',
                                  clickedIconPath: 'lib/Assets/icons/page_icons/environment_clicked.png',
                                  unclickedIconPath: 'lib/Assets/icons/page_icons/environment_unclicked.png',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: space_between_icon),
                                child: _buildDrawerItem(7, Icons.bar_chart, 'Historical Data',
                                  clickedIconPath: 'lib/Assets/icons/page_icons/historical_clicked.png',
                                  unclickedIconPath: 'lib/Assets/icons/page_icons/historical_unclicked.png',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 102,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: space_between_icon),
                            child: _buildDrawerItem(8, Icons.info, 'More Information',
                              clickedIconPath: 'lib/Assets/icons/page_icons/moreInformation_clicked.png',
                              unclickedIconPath: 'lib/Assets/icons/page_icons/moreInformation_unclicked.png',
                            ),
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

  Widget _buildDrawerItem(int index, IconData? icon, String title, {String? clickedIconPath, String? unclickedIconPath}) {
    bool isSelected = widget.selectedIndex == index;
    return ListTile(
      selected: isSelected,
      selectedTileColor: const Color(0xFFF9F9F9),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: clickedIconPath != null && unclickedIconPath != null
            ? Image.asset(
          isSelected ? clickedIconPath : unclickedIconPath,
          width: 35,
          height: 35,
        )
            : Icon(icon, color: Colors.white, size: 23),
      ),
      title: _isExpanded
          ? Text(
        title,
        style: TextStyle(fontSize: 20, color: isSelected ? Colors.black : Colors.white),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      )
          : null,
      onTap: () => widget.onDestinationSelected(index),
    );
  }
}
