import 'package:flutter/cupertino.dart';
import 'package:flutter_restaurant/data/api/api_service.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/data/response/result_state.dart';

class ListProvider extends ChangeNotifier {
  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => this._restaurants;

  ResultState _state = ResultState.Loading;
  ResultState get state => this._state;

  String? _message = "Empty Data";
  String? get message => this._message;

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
      _message = 'Error: $e';
    } finally {
      notifyListeners();
    }
  }
}
