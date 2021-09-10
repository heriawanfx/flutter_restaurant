import 'dart:convert';

import 'package:flutter_restaurant/data/api/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

void main() {
  group('restaurant service', () {
    test('expect first list item is Melting Pot', () async {
      final client = MockClient((request) async {
        final jsonMap = {
          "error": false,
          "message": "success",
          "count": 20,
          "restaurants": [
            {
              "id": "rqdv5juczeskfw1e867",
              "name": "Melting Pot",
              "description":
                  "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
              "pictureId": "14",
              "city": "Medan",
              "rating": 4.2
            }
          ]
        };

        return http.Response(jsonEncode(jsonMap), 200);
      });

      final apiService = ApiService();
      apiService.client = client;

      final results = await apiService.getRestaurants();
      expect(results.length, 1);
      expect(results[0].name, "Melting Pot");
    });

    test('expect first category from Melting Pot is Italia', () async {
      final client = MockClient((request) async {
        final jsonMap = {
          "error": false,
          "message": "success",
          "restaurant": {
            "id": "rqdv5juczeskfw1e867",
            "name": "Melting Pot",
            "description":
                "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
            "city": "Medan",
            "address": "Jln. Pandeglang no 19",
            "pictureId": "14",
            "categories": [
              {"name": "Italia"},
              {"name": "Modern"}
            ],
            "menus": {
              "foods": [
                {"name": "Paket rosemary"},
                {"name": "Toastie salmon"}
              ],
              "drinks": [
                {"name": "Es krim"},
                {"name": "Sirup"}
              ]
            },
            "rating": 4.2,
            "customerReviews": [
              {
                "name": "Ahmad",
                "review": "Tidak rekomendasi untuk pelajar!",
                "date": "13 November 2019"
              }
            ]
          }
        };

        return http.Response(jsonEncode(jsonMap), 200);
      });

      final apiService = ApiService();
      apiService.client = client;

      final detail =
          await apiService.getRestaurantDetail("rqdv5juczeskfw1e867");
      expect(detail.categories?[0].name, "Italia");
    });
  });
}
