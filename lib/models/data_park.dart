class Data_park {
  String? email;
  String? Image;
  String? parkingName;
  String? name;
  String? phoneNumber;
  double? latitude;
  double? longitude;
  String? carTotal;
  String? carCTotal;
  String? status;

  Data_park(
      {this.email,
        this.Image,
        this.parkingName,
        this.name,
        this.phoneNumber,
        this.latitude,
        this.longitude,
        this.carTotal,
        this.carCTotal,
        this.status});

  Data_park.fromJson(Map<String, dynamic> json) {
    email = json['Email'];
    Image = json['Image'];
    parkingName = json['parkingName'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    carTotal = json['carTotal'];
    carCTotal = json['carCTotal'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email'] = this.email;
    data['Image'] = this.Image;
    data['parkingName'] = this.parkingName;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['carTotal'] = this.carTotal;
    data['carCTotal'] = this.carCTotal;
    data['status'] = this.status;
    return data;
  }
}