class OrderModel {
  String? orderId;
  String? orderDateTime;
  String? waterId;
  String? userId;
  String? userName;
  String? empId;
  String? brandWater;
  String? price;
  String? size;
  String? amount;
  String? distance;
  String? transport;
  String? sum;
  String? status;
  String? paymentStatus;

  OrderModel(
      {this.orderId,
        this.orderDateTime,
        this.waterId,
        this.userId,
        this.userName,
        this.empId,
        this.brandWater,
        this.price,
        this.size,
        this.amount,
        this.distance,
        this.transport,
        this.sum,
        this.status,
        this.paymentStatus});

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderDateTime = json['order_date_time'];
    waterId = json['water_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    empId = json['emp_id'];
    brandWater = json['brand_water'];
    price = json['price'];
    size = json['size'];
    amount = json['amount'];
    distance = json['distance'];
    transport = json['transport'];
    sum = json['sum'];
    status = json['status'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_date_time'] = this.orderDateTime;
    data['water_id'] = this.waterId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['emp_id'] = this.empId;
    data['brand_water'] = this.brandWater;
    data['price'] = this.price;
    data['size'] = this.size;
    data['amount'] = this.amount;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    data['sum'] = this.sum;
    data['status'] = this.status;
    data['payment_status'] = this.paymentStatus;
    return data;
  }
}
