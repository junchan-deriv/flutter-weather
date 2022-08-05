import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/states/weather_cubit.dart';
import 'package:flutter_weather_app/states/weather_state.dart';
import 'package:flutter_weather_app/widgets/weather_information.dart';

class WeatherDetail extends StatelessWidget {
  const WeatherDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WeatherCubit cubit = BlocProvider.of<WeatherCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather Detail',
        ),
      ),
      body: Center(
        child: BlocBuilder<WeatherCubit, WeatherState>(
            bloc: cubit,
            builder: (context, state) {
              if (state is WeatherLoading) {
                return const CircularProgressIndicator();
              }
              if (state is WeatherLoaded) {
                return WeatherInformation(weatherModel: state.weatherModel);
              }
              return Text(state is WeatherError ? state.errorMessage : "");
            }),
      ),
    );
  }
}
