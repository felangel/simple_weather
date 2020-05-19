import 'package:flutter/material.dart';

import 'package:simple_weather/app/app.dart';
import 'package:simple_weather/service/service.dart';

typedef WeatherGetter = Future<Weather> Function(String query);

class WeatherPage extends StatefulWidget {
  const WeatherPage({
    Key key,
    @required this.getWeather,
    @required this.onWeatherChanged,
  }) : super(key: key);

  final WeatherGetter getWeather;
  final ValueSetter<Weather> onWeatherChanged;

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherState _state;

  @override
  void initState() {
    super.initState();
    _state = WeatherInitial();
  }

  Future<void> _onSearchPressed() async {
    final city = await Navigator.of(context).push(CitySearch.route());
    if (city?.isNotEmpty == true) {
      setState(() {
        _state = WeatherLoadInProgress();
        widget.getWeather(city).then((weather) {
          widget.onWeatherChanged(weather);
          setState(() => _state = WeatherLoadSuccess(weather));
        }).catchError((Object _) {
          widget.onWeatherChanged(null);
          setState(() => _state = WeatherLoadFailure());
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Weather'),
      ),
      body: Center(
        child: _WeatherView(state: _state),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: _onSearchPressed,
      ),
    );
  }
}

class _WeatherView extends StatelessWidget {
  const _WeatherView({Key key, @required this.state}) : super(key: key);

  final WeatherState state;

  @override
  Widget build(BuildContext context) {
    final weatherState = state;
    if (weatherState is WeatherInitial) {
      return const WeatherEmpty();
    } else if (weatherState is WeatherLoadInProgress) {
      return const WeatherLoading();
    } else if (weatherState is WeatherLoadSuccess) {
      return WeatherPopulated(weather: weatherState.weather);
    } else {
      return const WeatherError();
    }
  }
}
