import 'package:flutter/cupertino.dart';
import 'package:flutter_restaurant/data/api/api_service.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/utils/result_state.dart';

class ListProvider extends ChangeNotifier {
  ListProvider() {
    fetchRestaurants();
  }

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => this._restaurants;

  ResultState _state = ResultState.Loading;
  ResultState get state => this._state;

  String? _error = "Ada masalah";
  String? get error => this._error;

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
    _state = ResultState.Loading;
    notifyListeners();

    try {
      final result = await ApiService().getRestaurants(_query);

      _state = ResultState.Success;
      _restaurants = result;
    } catch (e) {
      _state = ResultState.Error;
      _error = "$e";
    } finally {
      notifyListeners();
    }
  }
}
