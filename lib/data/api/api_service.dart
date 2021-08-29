import 'dart:convert';
import 'package:flutter_restaurant/common/constant.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static ApiService? _instance;

  ApiService._internal() {
    _instance = this;
  }

  factory ApiService() => _instance ?? ApiService._internal();

  Future<List<Restaurant>> getRestaurants(String query) async {
    Uri uri = Uri.https(Constant.baseUrl, Constant.pathList, {'q': query});
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = jsonDecode(response.body);
      List<dynamic> array = jsonBody['restaurants'];
      Iterable<Restaurant> iterable =
          array.map((item) => Restaurant.fromJson(item));
      List<Restaurant> list = iterable.toList();
      return list;
    } else {
      throw Exception("Ada masalah dalam memuat data");
    }
  }

  Future<Restaurant> getRestaurantDetail(String restaurantId) async {
    Uri uri =
        Uri.https(Constant.baseUrl, "${Constant.pathDetail}/$restaurantId");
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = jsonDecode(response.body);
      Map<String, dynamic> json = jsonBody['restaurant'];
      Restaurant obj = Restaurant.fromJson(json);
      return obj;
    } else {
      throw Exception("Ada masalah dalam memuat data");
    }
  }
}
