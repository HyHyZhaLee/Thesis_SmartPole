import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/AppFunction/global_variables.dart';
import 'Widgets/navigation_rail.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'AppFunction/mqtt_manager.dart';
import 'pages/home_page.dart';
import 'pages/light_control_page.dart';
import 'pages/lighting_schedule_page.dart';
import 'pages/security_cameras_page.dart';
import 'pages/advertisement_schedule_page.dart';
import 'pages/environmental_sensors_page.dart';
import 'pages/historical_data_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    MqttManager(); // Initialize MQTT Manager
    global_databaseReference = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: DATABASE_URL,
    ).ref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Mulish',
        primaryColor: const Color(0xFFF9F9F9),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: const Color(0xFF7A40F2),
          selectedIconTheme: IconThemeData(color: Colors.white),
          selectedLabelTextStyle: TextStyle(color: Colors.white),
          unselectedIconTheme: IconThemeData(color: Colors.white70),
          unselectedLabelTextStyle: TextStyle(color: Colors.white70),
        ),
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomePage(),
    LightControlPage(),
    LightingSchedulePage(),
    SecurityCamerasPage(),
    AdvertisementSchedulePage(),
    EnvironmentalSensorsPage(),
    HistoricalDataPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          CustomNavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _pages.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
