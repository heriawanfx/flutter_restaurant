import 'dart:convert';
import 'package:flutter_restaurant/common/constant.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;

class ApiService {
  Client client = Client();
  static ApiService? _instance;

  ApiService._internal() {
    this.client = Client();
    _instance = this;
  }

  factory ApiService() {
    return _instance ?? ApiService._internal();
  }

  Future<List<Restaurant>> getRestaurants({String query = ""}) async {
    String path = Constant.pathList;
    Map<String, dynamic>? queryParams = {};

    if (query.isNotEmpty) {
      path = Constant.pathSearch;
      queryParams = {'q': query};
    }

    Uri uri = Uri.https(Constant.baseUrl, path, queryParams);
    http.Response response = await client.get(uri);

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
    http.Response response = await client.get(uri);

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
