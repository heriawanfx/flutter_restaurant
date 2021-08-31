import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/constant.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/data/response/result_state.dart';
import 'package:flutter_restaurant/pages/detail_page.dart';
import 'package:flutter_restaurant/provider/detail_provider.dart';
import 'package:flutter_restaurant/provider/list_provider.dart';
import 'package:flutter_restaurant/utils/context_helper.dart';
import 'package:flutter_restaurant/widgets/text_icon.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    context.read<ListProvider>().fetchRestaurants();

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
            titleSpacing: 10,
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
  return const Text(Constant.appName);
}

Widget _buildSearchBar(BuildContext context) {
  return TextField(
    autofocus: true,
    cursorColor: Colors.white,
    decoration: InputDecoration(
      hintText: "Cari Restoran atau Menu...",
      border: InputBorder.none,
      hintStyle: TextStyle(color: Colors.white54),
    ),
    style: TextStyle(color: Colors.white, fontSize: 16.0),
    onChanged: (query) {
      Future.delayed(Duration(seconds: 2), () {
        context.read<ListProvider>().setQuery(query);
      });
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
  return <Widget>[];
}

Widget _buildFuture(BuildContext context, ListProvider provider) {
  if (provider.state == ResultState.Error) {
    context.showSnackbar("${provider.message}");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.running_with_errors_outlined,
            color: Colors.red,
            size: 40,
          ),
          Text(
            "Ada masalah saat memuat data",
            style: TextStyle(color: Colors.red),
          ),
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

        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: Hero(
            tag: "${_restaurant.id}",
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: "${Constant.baseImageUrl}/${_restaurant.pictureId}",
              fit: BoxFit.cover,
              width: 70,
            ),
          ),
          title: Text(
            "${_restaurant.name}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Column(
            children: [
              TextIcon(
                  iconData: Icons.room_outlined, text: "${_restaurant.city}"),
              TextIcon(
                  iconData: Icons.star_outline_outlined,
                  text: _restaurant.rating.toString())
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, DetailPage.routeName);
            context.read<DetailProvider>().setSelectedId(_restaurant.id!);
          },
        );
      });
}
