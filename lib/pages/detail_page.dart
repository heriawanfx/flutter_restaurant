import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_restaurant/common/constant.dart';
import 'package:flutter_restaurant/common/global.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/provider/favorite_provider.dart';
import 'package:flutter_restaurant/utils/result_state.dart';
import 'package:flutter_restaurant/provider/detail_provider.dart';
import 'package:flutter_restaurant/widgets/error_state_widget.dart';
import 'package:flutter_restaurant/widgets/text_icon.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailPage extends StatelessWidget {
  static const routeName = '/detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DetailProvider>(builder: (context, provider, _) {
        switch (provider.state) {
          case ResultState.Loading:
            return Center(
              child: const CircularProgressIndicator(),
            );
          case ResultState.Error:
            return ErrorStateWidget(
              onTryAgain: () => provider.fetchRestaurantDetail(),
            );
          case ResultState.Success:
            final _restaurant = provider.restaurant;
            final _menu = _restaurant?.menus;
            final _foods = _menu?.foods;
            final _drinks = _menu?.drinks;
            final _reviews = _restaurant?.customerReviews;

            if (_restaurant == null) {
              return Center(
                child: Text("Restaurant tidak tersedia"),
              );
            }

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  _buildSliverAppBar(_restaurant),
                ];
              },
              body: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _buildDescription(_restaurant),
                  ),
                  _buildGroupList(_foods, Type.Food),
                  _buildGroupList(_drinks, Type.Drink),
                  _reviews == null || _reviews.isEmpty
                      ? Container()
                      : _buildReviewList(context, _reviews)
                ],
              ),
            );
        }
      }),
    );
  }

  Widget _buildSliverAppBar(Restaurant restaurant) {
    return Consumer<FavoriteProvider>(
      builder: (context, provider, _) {
        return FutureBuilder(
          future: provider.isFavorited(restaurant),
          builder: (context, snapshot) {
            bool isFavorited = snapshot.hasData && snapshot.data == true;
            return SliverAppBar(
                title: Text("${restaurant.name}"),
                pinned: true,
                expandedHeight: 250,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: "${restaurant.pictureId}",
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image:
                              "${Constant.baseImageUrl}/${restaurant.pictureId}",
                          fit: BoxFit.cover,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, 0.5),
                            end: Alignment(0.0, 0.0),
                            colors: [
                              Color(0x00000000),
                              Color(0x88000000),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      provider.toggleFavorite(restaurant, isFavorited);
                      if (!isFavorited) {
                        showSnackbar(
                          "Restoran ini telah difavoritkan",
                          isSuccess: true,
                        );
                      } else {
                        showSnackbar("Favorit telah dihapus");
                      }
                    },
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_outline,
                    ),
                  )
                ]);
          },
        );
      },
    );
  }
}

Widget _buildDescription(Restaurant _restaurant) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "${_restaurant.name}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.red,
        ),
      ),
      SizedBox(height: 4),
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
          size: 15),
      SizedBox(
        height: 16,
      ),
      Text(
        "Kategori",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      _restaurant.categories == null || _restaurant.categories?.isEmpty == true
          ? Container()
          : Container(
              height: 50,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: _restaurant.categories == null
                    ? []
                    : _restaurant.categories!.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ActionChip(
                            label: Text("${category.name}"),
                            onPressed: () {},
                          ),
                        );
                      }).toList(),
              ),
            )
    ],
  );
}

enum Type { Food, Drink }

Widget _buildGroupList(List<Name>? list, Type type) {
  if (list == null) {
    return SizedBox(height: 0);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 16,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          type == Type.Food ? "Makanan" : "Minuman",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      Container(
        height: 120,
        child: ListView.builder(
            padding: const EdgeInsets.only(left: 13),
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return InkWell(
                highlightColor: Colors.black.withOpacity(0.1),
                splashColor: Colors.black.withOpacity(0.1),
                onTap: () {
                  showSnackbar("Fitur ini belum tersedia");
                },
                child: Card(
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
                          type == Type.Food
                              ? Icons.ramen_dining_outlined
                              : Icons.local_cafe_outlined,
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        child: Text(
                          "${list[index].name}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.bottomLeft,
                      ),
                    ]),
                  ),
                ),
              );
            }),
      ),
    ],
  );
}

Widget _buildReviewList(BuildContext context, List<CustomerReview> reviews) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 16,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          "Ulasan Pengguna",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      ListView.builder(
          shrinkWrap: true,
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final _review = reviews[index];

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              title: Text(
                "${_review.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Column(
                children: [
                  TextIcon(
                    iconData: Icons.comment_outlined,
                    text: _review.review,
                  ),
                  TextIcon(
                    iconData: Icons.calendar_today_outlined,
                    text: _review.date,
                  )
                ],
              ),
            );
          }),
    ],
  );
}
