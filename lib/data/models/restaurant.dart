class Restaurant {
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    this.categories,
    this.menus,
    this.customerReviews,
  });

  String? id;
  String? name;
  String? description;
  String? city;
  String? address;
  String? pictureId;
  double? rating;
  List<Name>? categories = [];
  Menus? menus;
  List<CustomerReview>? customerReviews = [];

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      city: json["city"],
      address: json["address"],
      pictureId: json["pictureId"],
      rating: json["rating"].toDouble(),
      categories: json["categories"] == null
          ? null
          : List<Name>.from(json["categories"].map((x) => Name.fromJson(x))),
      menus: json["menus"] == null ? null : Menus.fromJson(json["menus"]),
      customerReviews: json["customerReviews"] == null
          ? null
          : List<CustomerReview>.from(json["customerReviews"].map((x) {
              return CustomerReview.fromJson(x);
            })),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "city": city,
      "address": address,
      "pictureId": pictureId,
      "menus": menus?.toJson(),
      "categories": categories == null
          ? null
          : List<dynamic>.from(categories!.map((x) => x.toJson())),
      "rating": rating,
      "customerReviews": customerReviews == null
          ? null
          : List<dynamic>.from(customerReviews!.map((x) => x.toJson())),
    };
  }

  factory Restaurant.fromDatabase(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      city: json["city"],
      address: json["address"],
      pictureId: json["pictureId"],
      rating: json["rating"].toDouble(),
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "city": city,
      "address": address,
      "pictureId": pictureId,
      "rating": rating,
    };
  }
}

class Name {
  Name({
    required this.name,
  });

  String name;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Menus {
  Menus({
    required this.foods,
    required this.drinks,
  });

  List<Name> foods;
  List<Name> drinks;

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods: List<Name>.from(json["foods"].map((x) => Name.fromJson(x))),
        drinks: List<Name>.from(json["drinks"].map((x) => Name.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
      };
}

class CustomerReview {
  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  String name;
  String review;
  String date;

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json["name"],
        review: json["review"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}
