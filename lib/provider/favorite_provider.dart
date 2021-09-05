import 'package:flutter_restaurant/data/db/database_helper.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/provider/state_provider.dart';
import 'package:flutter_restaurant/utils/result_state.dart';

class FavoriteProvider extends StateProvider {
  DatabaseHelper databaseHelper;

  FavoriteProvider({required this.databaseHelper}) {
    loadFavorites();
  }

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  void loadFavorites() async {
    state = ResultState.Loading;
    notifyListeners();
    try {
      final result = await databaseHelper.getFavorites();

      state = ResultState.Success;
      _favorites = result;
    } catch (e) {
      state = ResultState.Error;
      error = "$e";
      print("Error : $e");
    } finally {
      notifyListeners();
    }
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
      loadFavorites();
    }
  }
}
