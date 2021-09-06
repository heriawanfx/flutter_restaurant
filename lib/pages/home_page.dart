import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/constant.dart';
import 'package:flutter_restaurant/common/navigation.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/pages/detail_page.dart';
import 'package:flutter_restaurant/provider/detail_provider.dart';
import 'package:flutter_restaurant/utils/result_state.dart';
import 'package:flutter_restaurant/provider/list_provider.dart';
import 'package:flutter_restaurant/widgets/error_state_widget.dart';
import 'package:flutter_restaurant/widgets/refresh_action_button.dart';
import 'package:flutter_restaurant/widgets/restaurant_grid_item.dart';
import 'package:flutter_restaurant/widgets/restaurant_list_item.dart';
import 'package:flutter_restaurant/widgets/text_icon.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

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
    RefreshActionButton(
      onRefresh: () {
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
  switch (provider.state) {
    case ResultState.Loading:
      return Center(child: const CircularProgressIndicator());
    case ResultState.Error:
      return ErrorStateWidget(onTryAgain: () {
        provider.fetchRestaurants();
      });
    case ResultState.Success:
      final List<Restaurant> restaurants = provider.restaurants;

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

Widget _buildListItem(BuildContext context, List<Restaurant> restaurants) {
  return GridView.count(
    crossAxisCount: 2,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    padding: const EdgeInsets.all(4),
    children: restaurants.map((item) {
      return RestaurantGridItem(restaurant: item);
    }).toList(),
  );
}
