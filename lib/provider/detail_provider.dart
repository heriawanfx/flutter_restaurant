import 'package:flutter_restaurant/data/api/api_service.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/utils/state_provider.dart';
import 'package:flutter_restaurant/utils/result_state.dart';

class DetailProvider extends StateProvider {
  Restaurant? _restaurant;
  Restaurant? get restaurant => this._restaurant;

  String _selectedId = "0";
  String? get selectedId => this._selectedId;

  void setSelectedId(String value) {
    this._selectedId = value;
    fetchRestaurantDetail();
  }

  Future<void> fetchRestaurantDetail() async {
    state = ResultState.Loading;
    notifyListeners();

    try {
      final result = await ApiService().getRestaurantDetail(_selectedId);

      state = ResultState.Success;
      _restaurant = result;
    } catch (e) {
      state = ResultState.Error;
      error = "Error: $e";
    } finally {
      notifyListeners();
    }
  }
}
