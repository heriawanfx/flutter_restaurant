import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/db/database_helper.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  void _getFavorites() async {
    _favorites = await databaseHelper.getFavorites();
    _state = ResultState.Success;
    notifyListeners();
  }

  void addBookmark(Restaurant restaurant) async {
    try {
      final success = await databaseHelper.insertFavorite(restaurant);
      if (success) {
        _getFavorites();
      } else {
        _state = ResultState.Error;
        _message = 'Gagal menambah favorite';
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(Restaurant restaurant) async {
    final bookmarkedArticle = await databaseHelper.getFavorited(restaurant.id!);
    return bookmarkedArticle.isNotEmpty;
  }

  void removeFavorite(Restaurant restaurant) async {
    try {
      final success = await databaseHelper.removeFavorite(restaurant.id!);
      if (success) {
        _getFavorites();
      } else {
        _state = ResultState.Error;
        _message = 'Gagal menambah favorite';
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
