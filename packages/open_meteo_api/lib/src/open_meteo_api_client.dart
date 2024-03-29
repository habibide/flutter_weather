/*import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_meteo_api/open_meteo_api.dart';

/// Exception thrown when locationSearch fails.
class LocationRequestFailure implements Exception {}

/// Exception thrown when the provided location is not found.
class LocationNotFoundFailure implements Exception {}

/// Exception thrown when getWeather fails.
class WeatherRequestFailure implements Exception {}

/// Exception thrown when weather for provided location is not found.
class WeatherNotFoundFailure implements Exception {}

/// {@template open_meteo_api_client}
/// Dart API Client which wraps the [Open Meteo API](https://open-meteo.com).
/// {@endtemplate}
class OpenMeteoApiClient {
  /// {@macro open_meteo_api_client}
  OpenMeteoApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrlWeather = 'api.open-meteo.com';
  static const _baseUrlGeocoding = 'geocoding-api.open-meteo.com';

  final http.Client _httpClient;

  /// Finds a [Location] `/v1/search/?name=(query)`.
  Future<Location> locationSearch(String query) async {
    final locationRequest = Uri.https(
      _baseUrlGeocoding,
      '/v1/search',
      {'name': query, 'count': '1'},
    );

    final locationResponse = await _httpClient.get(locationRequest);

    if (locationResponse.statusCode != 200) {
      throw LocationRequestFailure();
    }

    final locationJson = jsonDecode(locationResponse.body) as Map;

    if (!locationJson.containsKey('results')) throw LocationNotFoundFailure();

    final results = locationJson['results'] as List;

    if (results.isEmpty) throw LocationNotFoundFailure();

    return Location.fromJson(results.first as Map<String, dynamic>);
  }

  /// Fetches [Weather] for a given [latitude] and [longitude].
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weatherRequest = Uri.https(_baseUrlWeather, 'v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current_weather': 'true'
    });

    final weatherResponse = await _httpClient.get(weatherRequest);

    if (weatherResponse.statusCode != 200) {
      throw WeatherRequestFailure();
    }

    final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;

    if (!bodyJson.containsKey('current_weather')) {
      throw WeatherNotFoundFailure();
    }

    final weatherJson = bodyJson['current_weather'] as Map<String, dynamic>;

    return Weather.fromJson(weatherJson);
  }
}*/

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:open_meteo_api/open_meteo_api.dart';

/// Exception thrown when locationSearch fails.
class LocationRequestFailure implements Exception {}

/// Exception thrown when the provided location is not found.
class LocationNotFoundFailure implements Exception {}

/// Exception thrown when getWeather fails.
class WeatherRequestFailure implements Exception {}

/// Exception thrown when weather for the provided location is not found.
class WeatherNotFoundFailure implements Exception {}

class OpenMeteoApiClient {
  static const _baseUrlWeather = 'api.open-meteo.com';
  static const _baseUrlGeocoding = 'geocoding-api.open-meteo.com';

  final Dio _dio;

  OpenMeteoApiClient({Dio? dio}) : _dio = dio ?? Dio();

  Future<Location> locationSearch(String query) async {
    Response response;
    try {
      response = await _dio.get(
        'https://$_baseUrlGeocoding/v1/search',
        queryParameters: {'name': query, 'count': '1'},
      );
    } catch (e) {
      throw LocationRequestFailure();
    }

    if (response.statusCode != 200) {
      throw LocationRequestFailure();
    }

    final location = response.data;

    if (!location.containsKey('results')) throw LocationNotFoundFailure();

    final results = location['results'];

    if (results.isEmpty) throw LocationNotFoundFailure();

    return Location.fromJson(results.first);
  }

  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    Response response;
    try {
      response = await _dio.get(
        'https://$_baseUrlWeather/v1/forecast',
        queryParameters: {
          'latitude': '$latitude',
          'longitude': '$longitude',
          'current_weather': 'true'
        },
      );
    } catch (e) {
      // Handle Dio errors here
      throw WeatherRequestFailure();
    }
      if (response.statusCode != 200) {
        throw WeatherRequestFailure();
      }

      final bodyJson = response.data;

      if (!bodyJson.containsKey('current_weather')) {
        throw WeatherNotFoundFailure();
      }

      final weatherJson = bodyJson['current_weather'];

      return Weather.fromJson(weatherJson);

  }


}

