import 'package:flutter/material.dart';

import '../models/weather_models.dart';

class WeatherInformation extends StatelessWidget {
  final WeatherModel weatherModel;
  const WeatherInformation({Key? key, required this.weatherModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.pink,
                width: 20,
              ),
              borderRadius: BorderRadius.circular(
                15,
              ),
            ),
            child: Image.network(
              "https://openweathermap.org/img/wn/${weatherModel.weather.first.icon}@2x.png",
              isAntiAlias: true,
              height: 300,
            ),
          ),
          ListTile(
            title: Text(
              weatherModel.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(weatherModel.weather.first.description),
                Text('Current: ${weatherModel.main.temp} °C'),
                Text('Highest: ${weatherModel.main.tempMax} °C'),
                Text('Lowest: ${weatherModel.main.tempMin} °C')
              ],
            ),
          )
        ],
      ),
    );
  }
}
