# Weather App

## Description

Weather App is a simple Flutter application that provides weather details for a searched city. It fetches real-time weather data from the Visual Crossing Weather API and displays the current temperature, conditions, humidity, and wind speed for the specified location.

## Features

- Search for weather details by city name.
- Display current weather conditions including temperature, humidity, and wind speed.
- Display appropriate weather icons based on current conditions.
- Save and load the last searched city using shared preferences.
- Refresh weather data on demand.

## Dependencies

- flutter: SDK for building cross-platform mobile apps.
- provider: State management package.
- http: For making HTTP requests.
- shared_preferences: For storing simple data on the device.
- intl: For date formatting.
- google_fonts: For custom fonts.

## Setup and Installation

Follow these steps to set up and run the Weather App on your local machine.

## Prerequisites

- Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
- Visual Studio Code or Android Studio (or any preferred IDE)
- Android/iOS Emulator or physical device for testing

## Steps

1. **Clone the repository:**

   ```sh
   git clone https://github.com/yourusername/weather_app.git
   cd weather_app

2. **Install dependencies:**

   ```sh
   flutter pub get

3. **Run the app:**

   ```sh
   flutter run -d <device_id>