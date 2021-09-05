import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/provider/favorite_provider.dart';
import 'package:flutter_restaurant/utils/result_state.dart';
import 'package:flutter_restaurant/widgets/error_state_widget.dart';
import 'package:flutter_restaurant/widgets/refresh_action_button.dart';
import 'package:flutter_restaurant/widgets/restaurant_tile.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  static const String title = 'Favorit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          RefreshActionButton(
            onRefresh: () {
              context.read<FavoriteProvider>().loadFavorites();
            },
          ),
        ],
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return Consumer<FavoriteProvider>(
      builder: (context, provider, _) {
        switch (provider.state) {
          case ResultState.Loading:
            return Center(child: const CircularProgressIndicator());
          case ResultState.Error:
            return ErrorStateWidget(onTryAgain: () {
              provider.loadFavorites();
            });
          case ResultState.Success:
            List<Restaurant> favorites = provider.favorites;
            if (favorites.isEmpty) {
              return Center(
                child: Text("Belum ada restoran yang difavoritkan"),
              );
            }

            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return RestaurantTile(restaurant: favorites[index]);
              },
            );
        }
      },
    );
  }
}
