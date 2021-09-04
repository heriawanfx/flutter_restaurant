import 'package:flutter/cupertino.dart';
import 'package:flutter_restaurant/data/db/database_helper.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';

class DatabaseProvider extends ChangeNotifier {
  DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  void _getFavorites() async {
    _favorites = await databaseHelper.getFavorites();
    notifyListeners();
  }

  Future<bool> isFavorited(Restaurant restaurant) async {
    final bookmarkedArticle = await databaseHelper.getFavorited(restaurant);
    return bookmarkedArticle.isNotEmpty;
  }

  void toggleFavorite(Restaurant restaurant, bool isFavorited) {
    try {
      if (isFavorited) {
        databaseHelper.removeFavorite(restaurant);
      } else {
        databaseHelper.insertFavorite(restaurant);
      }
    } catch (e) {
      print("Error on toggleFavorite : $e");
    } finally {
      notifyListeners();
    }
  }
}
