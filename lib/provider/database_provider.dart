import 'package:flutter/cupertino.dart';
import 'package:flutter_restaurant/data/db/database_helper.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';

class DatabaseProvider extends ChangeNotifier {
  DatabaseHelper _databaseHelper;

  DatabaseProvider(this._databaseHelper) {
    _getFavorites();
  }

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  void _getFavorites() async {
    _favorites = await _databaseHelper.getFavorites();
    notifyListeners();
  }

  Future<bool> isFavorited(Restaurant restaurant) async {
    final bookmarkedArticle = await _databaseHelper.getFavorited(restaurant);
    return bookmarkedArticle.isNotEmpty;
  }

  void toggleFavorite(Restaurant restaurant, bool isFavorited) {
    try {
      if (isFavorited) {
        _databaseHelper.removeFavorite(restaurant);
      } else {
        _databaseHelper.insertFavorite(restaurant);
      }
    } catch (e) {
      print("Error on toggleFavorite : $e");
    } finally {
      notifyListeners();
    }
  }
}
