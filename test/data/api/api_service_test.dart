import 'package:flutter_restaurant/common/constant.dart';
import 'package:flutter_restaurant/data/api/api_service.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('getRestaurants', () {
    test('returns restaurant list when the http call completes successfully',
        () async {
      final client = MockClient();

      Uri uri = Uri.https(Constant.baseUrl, Constant.pathList);
      when(client.get(uri)).thenAnswer((_) async {
        final response = http.Response(
            '{"error": false,"message": "success","count": 0,"restaurants": []}',
            200);
        return response;
      });

      expect(await ApiService().getRestaurants(), isA<List<Restaurant>>());
    });
  });
}
