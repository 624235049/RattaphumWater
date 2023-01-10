class CartModel {
  int? id;
  String? water_id;
  String? brand_water;
  String? price;
  String? size;
  String? amount;
  String? sum;
  String? distance;
  String? transport;

  CartModel(
      {this.id,
        this.water_id,
        this.brand_water,
        this.price,
        this.size,
        this.amount,
        this.sum,
        this.distance,
        this.transport});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    water_id = json['water_id'];
    brand_water = json['brand_water'];
    price = json['price'];
    size = json['size'];
    amount = json['amount'];
    sum = json['sum'];
    distance = json['distance'];
    transport = json['transport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['water_id'] = this.water_id;
    data['brand_water'] = this.brand_water;
    data['price'] = this.price;
    data['size'] = this.size;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    return data;
  }
}
