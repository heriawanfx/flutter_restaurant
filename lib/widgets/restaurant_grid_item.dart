import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/constant.dart';
import 'package:flutter_restaurant/common/navigation.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/pages/detail_page.dart';
import 'package:flutter_restaurant/provider/detail_provider.dart';
import 'package:flutter_restaurant/widgets/text_icon.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

class RestaurantGridItem extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantGridItem({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FadeInImage.memoryNetwork(
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: kTransparentImage,
            image: "${Constant.baseImageUrl}/${restaurant.pictureId}"),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.0, 0.0),
              end: Alignment(0.0, 0.5),
              colors: [
                Color(0x00000000),
                Color(0x88000000),
              ],
            ),
          ),
          child: Container(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 55,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${restaurant.name}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15),
                  ),
                  TextIcon(
                      iconData: Icons.room_outlined,
                      text: "${restaurant.city}",
                      color: Colors.white.withOpacity(0.7)),
                  TextIcon(
                      iconData: Icons.star_outline_outlined,
                      text: "${restaurant.rating}",
                      color: Colors.white.withOpacity(0.7))
                ],
              ),
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: Colors.black.withOpacity(0.1),
            splashColor: Colors.black.withOpacity(0.1),
            onTap: () {
              Navigation.pushNamed(DetailPage.routeName);
              context.read<DetailProvider>().setSelectedId("${restaurant.id}");
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ),
      ],
    );
  }
}
