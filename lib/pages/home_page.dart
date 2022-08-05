import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/pages/weather_detail.dart';
import 'package:flutter_weather_app/states/weather_cubit.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  late final TextEditingController _controller;
  bool _isCityNameEmpty = true;
  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(
        () => setState(() => _isCityNameEmpty = _controller.text.isEmpty));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showSnackbar(String s) {
    snackbarKey.currentState?.showSnackBar(SnackBar(content: Text(s)));
  }

  void _useCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar("Location service disabled");
      return;
    }
    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar("We have no permission to do it so");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _showSnackbar("We have no permission to do it so");
      return;
    }
    Position pos = await _geolocatorPlatform.getCurrentPosition();
    if (!mounted) return;
    BlocProvider.of<WeatherCubit>(context).fetchWeatherByLongLat(pos);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WeatherDetail(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: snackbarKey,
        appBar: AppBar(
          title: const Text("Search City"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Please enter city name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "City Name",
                    label: Text('City Name'),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _isCityNameEmpty
                    ? null
                    : () {
                        BlocProvider.of<WeatherCubit>(context)
                            .fetchWeather(_controller.text);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const WeatherDetail(),
                          ),
                        );
                      },
                child: const Text("Search"),
              ),
              ElevatedButton(
                  onPressed: _useCurrentPosition,
                  child: const Text("Use current position"))
            ],
          ),
        ));
  }
}
