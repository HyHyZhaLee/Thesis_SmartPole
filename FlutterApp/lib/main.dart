import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/AppFunction/global_variables.dart';
import 'package:flutter_app/widgets/navigation_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
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
  const MyApp({super.key});

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
        textTheme: GoogleFonts.mulishTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: const Color(0xFFF9F9F9),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),

      ),
      home: const DashboardScreen(),

    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1;

  static final List<Widget> _pages = <Widget>[
    const HomePage(),
    const HomePage(),
    const LightControlPage(),
    const LightingSchedulePage(),
    const SecurityCamerasPage(),
    const AdvertisementSchedulePage(),
    const EnvironmentalSensorsPage(),
    const HistoricalDataPage(),
    const HomePage()
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
          CustomNavigationDrawer(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
          ),
          Expanded(
            child: _pages.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
