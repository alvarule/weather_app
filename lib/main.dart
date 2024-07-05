import 'package:flutter/material.dart'; // Flutter material package for UI components
import 'package:provider/provider.dart'; // Package for state management
import 'package:weather_app/providers/weather_provider.dart'; // Weather provider for fetching weather data
import 'package:weather_app/screens/home.dart'; // Home screen of the app

void main() {
  runApp(const MyApp()); // Run the MyApp widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide WeatherProvider to the widget tree
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
      ],
      child: MaterialApp(
        title: 'Weather App',
        // Define the app's theme
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 21, 21, 21),
          secondaryHeaderColor: const Color.fromARGB(255, 118, 118, 118),
          cardColor: Colors.white,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color.fromARGB(255, 21, 21, 21),
            selectionHandleColor: Color.fromARGB(255, 21, 21, 21),
            selectionColor: Color.fromARGB(104, 21, 21, 21),
          ),
        ),
        // Set the home screen of the app
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false, // Disable the debug banner
      ),
    );
  }
}
