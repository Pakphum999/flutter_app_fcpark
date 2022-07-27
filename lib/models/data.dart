class Data {
  String? image;
  String? name;
  String? email;
  String? username;
  String? password;
  String? confirmPassword;
  String? phoneNumber;

  Data(
      {this.image,
        this.name,
        this.email,
        this.username,
        this.password,
        this.confirmPassword,
        this.phoneNumber});

  Data.fromJson(Map<String, dynamic> json) {
    image = json ['Image'];
    name = json['Name'];
    email = json['Email'];
    username = json['Username'];
    password = json['Password'];
    confirmPassword = json['Confirm_password'];
    phoneNumber = json['Phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data ['Image'] = this.image;
    data['Name'] = this.name;
    data['Email'] = this.email;
    data['Username'] = this.username;
    data['Password'] = this.password;
    data['Confirm_password'] = this.confirmPassword;
    data['Phone_number'] = this.phoneNumber;
    return data;
  }
}