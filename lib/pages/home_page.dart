import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/utils/result_state.dart';
import 'package:flutter_restaurant/provider/list_provider.dart';
import 'package:flutter_restaurant/widgets/restaurant_tile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const String title = 'Beranda';

  @override
  Widget build(BuildContext context) {
    return Consumer<ListProvider>(builder: (context, provider, _) {
      return WillPopScope(
        onWillPop: () async {
          if (provider.isSearchMode) {
            context.read<ListProvider>().setSearchMode(false);
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: provider.isSearchMode
                ? _buildSearchBar(context)
                : _buildDefaultTitleBar(context),
            leadingWidth: provider.isSearchMode ? 56 : 0,
            leading: provider.isSearchMode
                ? _buildBackLeading(context)
                : _buildDefaultLeading(),
            actions: provider.isSearchMode
                ? _buildSearchAction(context)
                : _buildDefaultAction(context),
          ),
          body: _buildFuture(context, provider),
        ),
      );
    });
  }
}

Widget _buildDefaultLeading() {
  return SizedBox();
}

Widget _buildBackLeading(BuildContext context) {
  return BackButton(onPressed: () {
    context.read<ListProvider>().setSearchMode(false);
  });
}

Widget _buildDefaultTitleBar(BuildContext context) {
  return const Text(HomePage.title);
}

Widget _buildSearchBar(BuildContext context) {
  return TextField(
    textInputAction: TextInputAction.search,
    autofocus: true,
    cursorColor: Colors.white,
    decoration: InputDecoration(
      hintText: "Cari Restoran atau Menu...",
      border: InputBorder.none,
      hintStyle: TextStyle(color: Colors.white54),
    ),
    style: TextStyle(color: Colors.white, fontSize: 16.0),
    onSubmitted: (query) {
      context.read<ListProvider>().setQuery(query);
    },
  );
}

List<Widget> _buildDefaultAction(BuildContext context) {
  return <Widget>[
    IconButton(
      icon: const Icon(Icons.search_outlined),
      onPressed: () {
        context.read<ListProvider>().setSearchMode(true);
      },
    ),
    IconButton(
      icon: const Icon(Icons.refresh_outlined),
      onPressed: () {
        context.read<ListProvider>().fetchRestaurants();
      },
    ),
  ];
}

List<Widget> _buildSearchAction(BuildContext context) {
  return <Widget>[
    IconButton(
      icon: const Icon(Icons.close_outlined),
      onPressed: () {
        context.read<ListProvider>().setSearchMode(false);
      },
    ),
  ];
}

Widget _buildFuture(BuildContext context, ListProvider provider) {
  if (provider.state == ResultState.Error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.running_with_errors_outlined,
            color: Colors.red,
            size: 100,
          ),
          SizedBox(height: 16),
          Text(
            "Ada masalah saat memuat data",
          ),
          SizedBox(height: 16),
          OutlinedButton(
              onPressed: () {
                provider.fetchRestaurants();
              },
              child: const Text("Coba Lagi"))
        ],
      ),
    );
  }

  if (provider.state == ResultState.Success) {
    final List<Restaurant>? restaurants = provider.restaurants;

    if (restaurants != null) {
      if (restaurants.isEmpty) {
        return Center(
          child: Text(provider.isSearchMode
              ? "Restoran tidak ditemukan"
              : "Restoran tidak tersedia"),
        );
      }

      return _buildListItem(context, restaurants);
    }
  }

  return Center(child: const CircularProgressIndicator());
}

Widget _buildListItem(BuildContext context, List<Restaurant> restaurants) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final _restaurant = restaurants[index];

        return RestaurantTile(restaurant: _restaurant);
      });
}
