class UserModel {
  String? id;
  String? chooseType;
  String? avatar;
  String? name;
  String? user;
  String? password;
  String? phone;
  String? address;
  String? lat;
  String? lng;
  String? token;

  UserModel(
      {this.id,
        this.chooseType,
        this.avatar,
        this.name,
        this.user,
        this.password,
        this.phone,
        this.address,
        this.lat,
        this.lng,
        this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chooseType = json['ChooseType'];
    avatar = json['Avatar'];
    name = json['Name'];
    user = json['User'];
    password = json['Password'];
    phone = json['Phone'];
    address = json['Address'];
    lat = json['Lat'];
    lng = json['Lng'];
    token = json['Token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ChooseType'] = this.chooseType;
    data['Avatar'] = this.avatar;
    data['Name'] = this.name;
    data['User'] = this.user;
    data['Password'] = this.password;
    data['Phone'] = this.phone;
    data['Address'] = this.address;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    data['Token'] = this.token;
    return data;
  }
}
