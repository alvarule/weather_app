import 'dart:convert'; 
import 'package:intl/intl.dart';
import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http; 
import 'package:shared_preferences/shared_preferences.dart'; 

class WeatherProvider extends ChangeNotifier {
  // Private variable to store the city name
  String? _city = "";
  
  // Getter to retrieve the city name
  String? get city => _city;

  // Map to store the fetched weather data
  Map weatherData = {};

  // Constructor to load the last searched city from shared preferences
  WeatherProvider() {
    _loadLastSearchedCity();
  }

  // Method to set the city name and save it to shared preferences
  void setCity(String city) async {
    _city = city;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSearchedCity', city);
    notifyListeners(); // Notify listeners after setting the city
  }

  // Method to load the last searched city from shared preferences
  Future<void> _loadLastSearchedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _city = prefs.getString('lastSearchedCity');
    notifyListeners(); // Notify listeners after loading the city
  }

  // Method to fetch weather data from the API
  Future<String> fetchWeatherData() async {
    try {
      // Get the current date
      DateTime now = DateTime.now();

      // Format the date
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      // Construct the API URL
      final url = Uri.https(
        "weather.visualcrossing.com",
        "VisualCrossingWebServices/rest/services/timeline/$_city/$formattedDate/$formattedDate",
        {
          "unitGroup": "metric",
          "include": "current",
          "key": "8HTEBSHM4RGYAPSEF8VUE4FWM",
          "contentType": "json",
        },
      );

      // Make the HTTP GET request
      final response = await http.get(url);

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the response data
        final responseData = json.decode(response.body);

        // Extract and store relevant weather data
        weatherData["resolvedAddress"] = responseData["resolvedAddress"];
        weatherData["address"] = responseData["address"];
        weatherData["temp"] = responseData["currentConditions"] != null
            ? responseData["currentConditions"]["temp"]
            : responseData["days"][0]["temp"];
        weatherData["conditions"] = responseData["currentConditions"] != null
            ? responseData["currentConditions"]["conditions"]
            : responseData["days"][0]["conditions"];
        weatherData["icon"] = responseData["currentConditions"] != null
            ? responseData["currentConditions"]["icon"]
            : responseData["days"][0]["icon"];
        weatherData["humidity"] = responseData["currentConditions"] != null
            ? responseData["currentConditions"]["humidity"]
            : responseData["days"][0]["humidity"];
        weatherData["windspeed"] = responseData["currentConditions"] != null
            ? responseData["currentConditions"]["windspeed"]
            : responseData["days"][0]["windspeed"];

        notifyListeners(); // Notify listeners about the update

        return '';
      } else if (response.statusCode == 400) {
        // Return an error message for a bad request
        return "Please enter a valid city name";
      } else {
        // Return a generic error message for other errors
        return "Something went wrong! Please try again";
      }
    } catch (e) {
      // Catch and return any exceptions that occur
      return "Something went wrong! Please try again";
    }
  }
}
