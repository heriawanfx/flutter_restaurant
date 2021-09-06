import 'package:flutter_restaurant/provider/list_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should contain 20 item', () {
    // arrange
    final listProvider = ListProvider();
    final total = 20;
    // act
    listProvider.fetchRestaurants();
    // assert
    final result = listProvider.restaurants.length;
    expect(result, total);
  });
}
