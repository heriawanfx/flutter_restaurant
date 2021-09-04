import 'package:flutter_restaurant/data/api/api_service.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/utils/state_provider.dart';
import 'package:flutter_restaurant/utils/result_state.dart';

class ListProvider extends StateProvider {
  ListProvider() {
    fetchRestaurants();
  }

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => this._restaurants;

  bool _isSearchMode = false;
  bool get isSearchMode => this._isSearchMode;
  void setSearchMode(bool active) {
    this._isSearchMode = active;

    if (!active) {
      setQuery("");
      fetchRestaurants();
    } else {
      notifyListeners();
    }
  }

  String _query = "";
  String get query => this._query;
  void setQuery(String value) {
    this._query = value;
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    state = ResultState.Loading;
    notifyListeners();

    try {
      final result = await ApiService().getRestaurants(_query);

      state = ResultState.Success;
      _restaurants = result;
    } catch (e) {
      state = ResultState.Error;
      error = "Error: $e";
    } finally {
      notifyListeners();
    }
  }
}
