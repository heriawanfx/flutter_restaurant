import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/database_provider.dart';
import 'package:flutter_restaurant/widgets/restaurant_tile.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  static const String title = 'Favorit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, _) {
        if (provider.favorites.isNotEmpty) {
          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              return RestaurantTile(restaurant: provider.favorites[index]);
            },
          );
        } else {
          return Center(
            child: Text("Belum ada restoran yang difavoritkan"),
          );
        }
      },
    );
  }
}
