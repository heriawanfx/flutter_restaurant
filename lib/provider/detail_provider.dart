import 'package:flutter/cupertino.dart';
import 'package:flutter_restaurant/data/api/api_service.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/utils/result_state.dart';

class DetailProvider extends ChangeNotifier {
  Restaurant? _restaurant;
  Restaurant? get restaurant => this._restaurant;

  String? _error = "Ada masalah";
  String? get error => this._error;

  String _selectedId = "0";
  String? get selectedId => this._selectedId;

  void setSelectedId(String value) {
    this._selectedId = value;
    fetchRestaurantDetail();
  }

  ResultState _state = ResultState.Loading;
  ResultState get state => this._state;

  Future<void> fetchRestaurantDetail() async {
    _state = ResultState.Loading;
    notifyListeners();

    try {
      final result = await ApiService().getRestaurantDetail(_selectedId);

      _state = ResultState.Success;
      _restaurant = result;
    } catch (e) {
      _state = ResultState.Error;
      _error = "$e";
    } finally {
      notifyListeners();
    }
  }
}
