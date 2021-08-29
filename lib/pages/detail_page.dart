import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/constant.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/data/response/result_state.dart';
import 'package:flutter_restaurant/provider/detail_provider.dart';
import 'package:flutter_restaurant/widgets/text_icon.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailPage extends StatelessWidget {
  static const routeName = '/detail';

  @override
  Widget build(BuildContext context) {
    context.read<DetailProvider>().fetchRestaurantDetail();

    return Scaffold(
      body: Consumer<DetailProvider>(builder: (context, provider, _) {
        switch (provider.state) {
          case ResultState.Loading:
            return Center(child: const CircularProgressIndicator());
          case ResultState.Error:
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
          case ResultState.Success:
            final _restaurant = provider.restaurant;
            final _menu = _restaurant?.menus;
            final _foods = _menu?.foods;
            final _drinks = _menu?.drinks;

            if (_restaurant == null) {
              return Center(
                child: Text("Restaurant tidak tersedia"),
              );
            }

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [_buildSliverAppBar(_restaurant)];
              },
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: _buildDescription(_restaurant),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Foods",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    _buildFoodList(_foods),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Drinks",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    _buildDrinkList(_drinks),
                  ],
                ),
              ),
            );
        }
      }),
    );
  }

  SliverAppBar _buildSliverAppBar(Restaurant _restaurant) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 250,
      brightness: Brightness.dark,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
            tag: "${_restaurant.id}",
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: "${Constant.baseImageUrl}/${_restaurant.pictureId}",
              fit: BoxFit.cover,
            )),
      ),
      title: Text("${_restaurant.name}"),
    );
  }
}

Column _buildDescription(Restaurant _restaurant) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("${_restaurant.name}",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.blueGrey)),
      SizedBox(
        height: 4,
      ),
      Text(
        "${_restaurant.description}",
        textAlign: TextAlign.justify,
      ),
      SizedBox(
        height: 4,
      ),
      TextIcon(
        iconData: Icons.room_outlined,
        text: "${_restaurant.city}",
        size: 15,
      ),
      TextIcon(
          iconData: Icons.star_outline_outlined,
          text: _restaurant.rating.toString(),
          size: 15)
    ],
  );
}

Widget _buildFoodList(List<Name>? foods) {
  if (foods == null) {
    return SizedBox(
      height: 0,
    );
  }

  return Container(
    height: 120,
    child: ListView.builder(
        padding: const EdgeInsets.only(left: 13),
        scrollDirection: Axis.horizontal,
        itemCount: foods.length,
        itemBuilder: (context, index) {
          return _buildFoodCard(foods[index]);
        }),
  );
}

Card _buildFoodCard(Name food) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    child: Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[400],
      width: 120,
      child: Stack(children: [
        Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.ramen_dining_outlined,
              color: Colors.white,
            )),
        Align(
          child: Text(
            "${food.name}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.bottomLeft,
        ),
      ]),
    ),
  );
}

Widget _buildDrinkList(List<Name>? drinks) {
  if (drinks == null) {
    return SizedBox(
      height: 0,
    );
  }
  return Container(
    height: 120,
    child: ListView.builder(
        padding: const EdgeInsets.only(left: 13),
        scrollDirection: Axis.horizontal,
        itemCount: drinks.length,
        itemBuilder: (context, index) {
          return _buildDrinkCard(drinks[index]);
        }),
  );
}

Card _buildDrinkCard(Name drink) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    child: Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[400],
      width: 120,
      child: Stack(children: [
        Align(
          alignment: Alignment.topRight,
          child: Icon(
            Icons.local_cafe_outlined,
            color: Colors.white,
          ),
        ),
        Align(
          child: Text(
            "${drink.name}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.bottomLeft,
        ),
      ]),
    ),
  );
}
