class CartModel {
  int? id;
  String? gas_id;
  String? brand_water;
  String? price;
  String? amount;
  String? sum;
  String? distance;
  String? transport;

  CartModel(
      {this.id,
        this.gas_id,
        this.brand_water,
        this.price,
        this.amount,
        this.sum,
        this.distance,
        this.transport});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gas_id = json['gas_id'];
    brand_water = json['brand_water'];
    price = json['price'];
    amount = json['amount'];
    sum = json['sum'];
    distance = json['distance'];
    transport = json['transport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gas_id'] = this.gas_id;
    data['brand_water'] = this.brand_water;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    return data;
  }
}
