import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/icons.dart'; 
import 'package:weather_app/widgets/custom_text.dart'; 
import 'package:weather_app/widgets/weather_detail_card.dart'; 

class WeatherDetailsScreen extends StatefulWidget {
  const WeatherDetailsScreen({super.key});

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  // Boolean to track loading state
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, state, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          // Display the resolved address of the weather data
          title: CustomText(
            text: state.weatherData["resolvedAddress"],
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              // Refresh button to fetch the latest weather data
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await state.fetchWeatherData();
                setState(() {
                  _isLoading = false;
                });
              },
              icon: Icon(
                Icons.refresh_rounded,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        // Show loading indicator if data is being fetched
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Container(
                // Set gradient background based on weather conditions
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      if (state.weatherData["icon"] == "rain")
                        const Color.fromARGB(255, 202, 206, 254),
                      if (state.weatherData["icon"]
                          .toString()
                          .contains("clear"))
                        const Color.fromARGB(255, 249, 254, 171),
                      if (state.weatherData["icon"]
                          .toString()
                          .contains("cloudy"))
                        const Color.fromARGB(255, 196, 196, 196),
                      if (state.weatherData["icon"] == "rain")
                        const Color.fromARGB(255, 202, 206, 254),
                      if (state.weatherData["icon"]
                          .toString()
                          .contains("clear"))
                        const Color.fromARGB(255, 249, 254, 171),
                      if (state.weatherData["icon"]
                          .toString()
                          .contains("cloudy"))
                        const Color.fromARGB(255, 196, 196, 196),
                      Colors.white,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Display the address of the weather data
                      CustomText(
                        text: state.weatherData["address"],
                        fontSize: 20,
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 60),
                      // Display the weather icon
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Image.asset(
                          state.weatherData["icon"] == "rain"
                              ? WeatherIcon.rainy
                              : state.weatherData["icon"]
                                      .toString()
                                      .contains("cloudy")
                                  ? WeatherIcon.cloudy
                                  : WeatherIcon.sunny,
                          width: 100,
                        ),
                      ),
                      // Display the temperature
                      CustomText(
                        text: "${state.weatherData["temp"].toString()}°",
                        color: Theme.of(context).primaryColor,
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                      ),
                      // Display the weather conditions
                      CustomText(
                        text: state.weatherData["conditions"],
                        fontSize: 20,
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 60),
                      // Display weather details like wind speed and humidity
                      Row(
                        children: [
                          Expanded(
                            child: WeatherDetailCard(
                              icon: Icons.air,
                              title: "Wind",
                              value:
                                  "${state.weatherData["windspeed"].toString()} km/h",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: WeatherDetailCard(
                              icon: Icons.water_drop_outlined,
                              title: "Humidity",
                              value: "${state.weatherData["humidity"]}%",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
