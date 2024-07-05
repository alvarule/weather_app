import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart'; 
import 'package:weather_app/screens/weather_details.dart'; 
import 'package:weather_app/utils/images.dart'; 
import 'package:weather_app/widgets/custom_text.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TextEditingController to manage the search input field
  final _searchController = TextEditingController();
  
  // Boolean to track loading state
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, state, child) {
          // Set the initial value of the search controller to the last searched city
          if (_searchController.text.isEmpty && state.city != null) {
            _searchController.text = state.city!;
          }
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo at the top
                  Padding(
                    padding: const EdgeInsets.all(42.0),
                    child: Image.asset(CustomImage.logo),
                  ),
                  // Main title
                  const CustomText(
                    text: "Get weather details for your City",
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 40),
                  // City search text field
                  TextField(
                    controller: _searchController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      hintText: "Search Your City",
                      hintStyle: GoogleFonts.poppins(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Search button with loading indicator
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : TextButton(
                            onPressed: () async {
                              // Check if the search field is not empty
                              if (_searchController.value.text.isNotEmpty) {
                                setState(() {
                                  _isLoading = true;
                                });
                                // Set the city in the state and fetch weather data
                                state.setCity(_searchController.value.text);
                                final resp = await state.fetchWeatherData();
                                if (resp.isEmpty) {
                                  // Navigate to the WeatherDetailsScreen if data is fetched successfully
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WeatherDetailsScreen(),
                                    ),
                                  );
                                } else {
                                  // Show error message in a snackbar if there is an error
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: CustomText(
                                        text: resp,
                                        color: Theme.of(context).cardColor,
                                      ),
                                    ),
                                  );
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              } else {
                                // Show message if the search field is empty
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: CustomText(
                                      text: "Please enter a city name",
                                      color: Theme.of(context).cardColor,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Theme.of(context).primaryColor,
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            child: CustomText(
                              text: "Search",
                              color: Theme.of(context).cardColor,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
