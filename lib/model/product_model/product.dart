class Product {
  int marketId;
  String title;
  String brand;
  String description;
  String conditions;
  bool delivery;
  String deliveryCharge;
  bool warranty;
  String warrantyPeriod;
  String contactPerson;
  String contactNo;
  String address;
  int price;
  bool negotiable;
  String expirationDate;
  String addedDate;
  String location;
  String marketPictureUrl;
  bool sold;
  bool historyStatus;
  bool hiddenPost;
  double averageRating;

  Product({
    required this.marketId,
    required this.title,
    required this.brand,
    required this.description,
    required this.conditions,
    required this.delivery,
    required this.deliveryCharge,
    required this.warranty,
    required this.warrantyPeriod,
    required this.contactPerson,
    required this.contactNo,
    required this.address,
    required this.price,
    required this.negotiable,
    required this.expirationDate,
    required this.addedDate,
    required this.location,
    required this.marketPictureUrl,
    required this.sold,
    required this.historyStatus,
    required this.hiddenPost,
    required this.averageRating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      marketId: json['marketId'] ?? 0,
      title: json['title'] ?? '',
      brand: json['brand'] ?? '',
      description: json['description'] ?? '',
      conditions: json['conditions'] ?? '',
      delivery: json['delivery'] ?? false,
      deliveryCharge: json['deliveryCharge'] ?? '',
      warranty: json['warranty'] ?? false,
      warrantyPeriod: json['warrantyPeriod'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      contactNo: json['contactNo'] ?? '',
      address: json['address'] ?? '',
      price: json['price'] ?? 0,
      negotiable: json['negotiable'] ?? false,
      expirationDate: json['expirationDate'] ?? '',
      addedDate: json['addedDate'] ?? '',
      location: json['location'] ?? '',
      marketPictureUrl: json['marketPictureUrl'] ?? '',
      sold: json['sold'] ?? false,
      historyStatus: json['historyStatus'] ?? false,
      hiddenPost: json['hiddenPost'] ?? false,
      averageRating: json['averageRating'] ?? 0.0,
    );
  }
}
