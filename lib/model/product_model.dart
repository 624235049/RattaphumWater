class ProductModel {
  String? waterId;
  String? waterImage;
  String? brandName;
  String? size;
  String? quantity;
  String? price;

  ProductModel(
      {this.waterId,
        this.waterImage,
        this.brandName,
        this.size,
        this.quantity,
        this.price});

  ProductModel.fromJson(Map<String, dynamic> json) {
    waterId = json['water_id'];
    waterImage = json['waterImg'];
    brandName = json['brand_name'];
    size = json['size'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['water_id'] = this.waterId;
    data['waterImg'] = this.waterImage;
    data['brand_name'] = this.brandName;
    data['size'] = this.size;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    return data;
  }
}
