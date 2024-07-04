//provider for last city

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

//load last searched city from shared prefs
final lastSearchedCityProvider = StateNotifierProvider<LastSearchedCityNotifier, String>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LastSearchedCityNotifier(sharedPreferences);
});

class LastSearchedCityNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;
  static const String _key = 'last_searched_city';

  LastSearchedCityNotifier(this._prefs) : super(_prefs.getString(_key) ?? '');

  //set last searched city to shared prefs
  void setCity(String city) {
    _prefs.setString(_key, city);
    state = city;
  }
}