class DeafUser {
  String? name;
  String? email;
  String? district;
  String? currentEmployer;
  String? contact;
  String? yearsOfExperience;
  String? role;

  DeafUser(
      {this.name,
      this.email,
      this.district,
      this.currentEmployer,
      this.contact,
      this.yearsOfExperience,
      this.role});

  DeafUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    district = json['district'];
    currentEmployer = json['current_employer'];
    contact = json['contact'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> deafUser = new Map<String, dynamic>();
    deafUser['name'] = this.name;
    deafUser['email'] = this.email;
    deafUser['district'] = this.district;
    deafUser['current_employer'] = this.currentEmployer;
    deafUser['contact'] = this.contact;
    deafUser['years_of_experience'] = this.yearsOfExperience;
    deafUser['role'] = this.role;
    return deafUser;
  }
}

