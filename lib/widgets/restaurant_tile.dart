import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/constant.dart';
import 'package:flutter_restaurant/common/navigation.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/pages/detail_page.dart';
import 'package:flutter_restaurant/provider/detail_provider.dart';
import 'package:flutter_restaurant/widgets/text_icon.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({
    Key? key,
    required Restaurant restaurant,
  })  : _restaurant = restaurant,
        super(key: key);

  final Restaurant _restaurant;

  @override
  Widget build(BuildContext context) {
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
          TextIcon(iconData: Icons.room_outlined, text: "${_restaurant.city}"),
          TextIcon(
              iconData: Icons.star_outline_outlined,
              text: "${_restaurant.rating}")
        ],
      ),
      onTap: () {
        Navigation.pushNamed(DetailPage.routeName);
        context.read<DetailProvider>().setSelectedId("${_restaurant.id}");
      },
    );
  }
}
