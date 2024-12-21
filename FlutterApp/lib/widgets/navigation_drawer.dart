import 'package:flutter/material.dart';
import 'package:flutter_app/AppFunction/global_variables.dart';

const double space_between_icon = 45.0;
const double space = 10.0;
const space_before_white_panel = 32.0;
const space_before_icon = 24.0;
const closed_width = 110.0;
const opened_width = 349.0;

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

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 40),
      vsync: this,
    );
    _widthAnimation =
        Tween<double>(begin: closed_width - space, end: opened_width)
            .animate(_animationController);
  }

  void _handleMouseEnter(bool isEntering) {
    setState(() {
      _isExpanded = isEntering;
      isEntering
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: USE_BORDER_RADIUS
              ? const EdgeInsets.all(10)
              : const EdgeInsets.all(0),
          child: MouseRegion(
            onEnter: (_) => _handleMouseEnter(true),
            onExit: (_) => _handleMouseEnter(false),
            child: ClipRRect(
              borderRadius: USE_BORDER_RADIUS
                  ? BorderRadius.circular(31)
                  : BorderRadius.circular(0),
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
                            margin: const EdgeInsets.only(top: 0),
                            child: _buildDrawerItem(
                              0,
                              Icons.home,
                              'Home',
                              clickedIconPath:
                                  'lib/Assets/icons/page_icons/home_clicked.png',
                              unclickedIconPath:
                                  'lib/Assets/icons/page_icons/home_unclicked.png',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Expanded(
                          flex: 705,
                          child: ListView(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: space_between_icon,
                                    top: space_between_icon),
                                child: _buildDrawerItem(
                                  1,
                                  Icons.apps,
                                  'Main Dashboard',
                                  clickedIconPath:
                                      'lib/Assets/icons/page_icons/MainDashboard_clicked.png',
                                  unclickedIconPath:
                                      'lib/Assets/icons/page_icons/MainDashboard_unclicked.png',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: space_between_icon),
                                child: _buildDrawerItem(
                                  2,
                                  Icons.lightbulb_outline,
                                  'Light Control',
                                  clickedIconPath:
                                      'lib/Assets/icons/page_icons/LightControl_clicked.png',
                                  unclickedIconPath:
                                      'lib/Assets/icons/page_icons/LightControl_unclicked.png',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: space_between_icon),
                                child: _buildDrawerItem(
                                  3,
                                  Icons.schedule,
                                  'Lighting Schedule',
                                  clickedIconPath:
                                      'lib/Assets/icons/page_icons/LightingSchedule_clicked.png',
                                  unclickedIconPath:
                                      'lib/Assets/icons/page_icons/LightingSchedule_unclicked.png',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: space_between_icon),
                                child: _buildDrawerItem(
                                  4,
                                  Icons.thermostat,
                                  'Security Camera',
                                  clickedIconPath:
                                      'lib/Assets/icons/page_icons/sercurity_clicked.png',
                                  unclickedIconPath:
                                      'lib/Assets/icons/page_icons/sercurity_unclicked.png',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: space_between_icon),
                                child: _buildDrawerItem(
                                  5,
                                  Icons.bar_chart,
                                  'Historical Data',
                                  clickedIconPath:
                                      'lib/Assets/icons/page_icons/historical_clicked.png',
                                  unclickedIconPath:
                                      'lib/Assets/icons/page_icons/historical_unclicked.png',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 102,
                          child: Container(
                            margin: const EdgeInsets.only(
                                bottom: space_between_icon),
                            child: _buildDrawerItem(
                              8,
                              Icons.info,
                              'More Information',
                              clickedIconPath:
                                  'lib/Assets/icons/page_icons/moreInformation_clicked.png',
                              unclickedIconPath:
                                  'lib/Assets/icons/page_icons/moreInformation_unclicked.png',
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

  Widget _buildDrawerItem(int index, IconData? icon, String title,
      {String? clickedIconPath, String? unclickedIconPath}) {
    bool isSelected = widget.selectedIndex == index;

    return Row(
      children: [
        Container(
          width: space_before_white_panel - space,
          decoration: BoxDecoration(
            color: PRIMARY_PANEL_COLOR, // Màu nền cho box bên trái
          ),
        ),
        Expanded(
          child: Container(
            color: isSelected
                ? const Color(0xFFF9F9F9)
                : Colors.transparent, // Màu nền chỉ cho ListTile
            child: ListTile(
              contentPadding: EdgeInsets.only(
                  left: space_before_icon - space), // Căn trái cho ListTile
              selected: isSelected,
              selectedTileColor:
                  Colors.transparent, // Xóa màu nền mặc định khi chọn
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (clickedIconPath != null && unclickedIconPath != null)
                    Image.asset(
                      isSelected ? clickedIconPath : unclickedIconPath,
                      width: 26,
                      height: 23,
                    )
                  else
                    Icon(icon,
                        color: isSelected ? Colors.black : Colors.white,
                        size: 23),
                  const SizedBox(width: 19), // Khoảng trống giữa icon và text
                ],
              ),
              title: _isExpanded
                  ? Text(
                      title,
                      style: TextStyle(
                          fontSize: 20,
                          color:
                              isSelected ? PRIMARY_BLACK_COLOR : Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )
                  : null,
              onTap: () => widget.onDestinationSelected(index),
            ),
          ),
        ),
      ],
    );
  }
}
