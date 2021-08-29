import 'package:flutter/cupertino.dart';
import 'package:flutter_restaurant/data/api/api_service.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/data/response/result_state.dart';

class DetailProvider extends ChangeNotifier {
  Restaurant? _restaurant;
  Restaurant? get restaurant => this._restaurant;

  String? _message = "Empty Data";
  String? get message => this._message;

  String _selectedId = "";
  String? get selectedId => this._selectedId;

  void setSelectedId(String value) {
    this._selectedId = value;
    notifyListeners();
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
      _message = 'Error: $e';
    } finally {
      notifyListeners();
    }
  }
}
