import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/constant.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/data/response/result_state.dart';
import 'package:flutter_restaurant/pages/detail_page.dart';
import 'package:flutter_restaurant/provider/detail_provider.dart';
import 'package:flutter_restaurant/provider/list_provider.dart';
import 'package:flutter_restaurant/widgets/custom_search_hint_delegate.dart';
import 'package:flutter_restaurant/widgets/text_icon.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    ListProvider provider = context.read<ListProvider>();
    provider.fetchRestaurants();

    return Scaffold(
        appBar: AppBar(
          title: const Text(Constant.appName),
          actions: [
            IconButton(
                onPressed: () {
                  context.read<ListProvider>().fetchRestaurants();
                },
                icon: Icon(Icons.refresh_outlined)),
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchHintDelegate());
                },
                icon: Icon(Icons.search_outlined))
          ],
        ),
        body: _buildFuture(context));
  }
}

Widget _buildFuture(BuildContext context) {
  return Consumer<ListProvider>(
    builder: (context, provider, _) {
      if (provider.state == ResultState.Error) {
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
                "${provider.message}",
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
              child: Text("Restaurant tidak tersedia"),
            );
          }

          return _buildListItem(context, restaurants);
        }
      }

      return Center(child: const CircularProgressIndicator());
    },
  );
}

Widget _buildListItem(BuildContext context, List<Restaurant> restaurants) {
  return ListView.builder(
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
