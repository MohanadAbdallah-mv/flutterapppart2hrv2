import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str)["items"].map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  final int usersCode;
  final String usersName;
  final String? usersNameE;
  final String password;
  final dynamic mainStoreCode; // يمكن أن يكون null
  final int empCode;
  final int compEmpCode;
  final String jobDesc;
  final String? jobDescE;
  final String ntnltyDesc;
  final String? ntnltyDescE;
  final dynamic eMail; // يمكن أن يكون null
  final dynamic telephone1; // يمكن أن يكون null
  final String gender;
  final List<Link> links;

  User({
    required this.usersCode,
    required this.usersName,
    this.usersNameE,
    required this.password,
    this.mainStoreCode,
    required this.empCode,
    required this.compEmpCode,
    required this.jobDesc,
    this.jobDescE,
    required this.ntnltyDesc,
    this.ntnltyDescE,
    this.eMail,
    this.telephone1,
    required this.gender,
    required this.links,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    usersCode: json["UsersCode"],
    usersName: json["UsersName"],
    usersNameE: json["UsersNameE"],
    password: json["Password"],
    mainStoreCode: json["MainStoreCode"],
    empCode: json["EmpCode"],
    compEmpCode: json["CompEmpCode"],
    jobDesc: json["JobDesc"],
    jobDescE: json["JobDescE"],
    ntnltyDesc: json["NtnltyDesc"],
    ntnltyDescE: json["NtnltyDescE"],
    eMail: json["EMail"],
    telephone1: json["Telephone1"],
    gender: json["Gender"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "UsersCode": usersCode,
    "UsersName": usersName,
    "UsersNameE": usersNameE,
    "Password": password,
    "MainStoreCode": mainStoreCode,
    "EmpCode": empCode,
    "CompEmpCode": compEmpCode,
    "JobDesc": jobDesc,
    "JobDescE": jobDescE,
    "NtnltyDesc": ntnltyDesc,
    "NtnltyDescE": ntnltyDescE,
    "EMail": eMail,
    "Telephone1": telephone1,
    "Gender": gender,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
  };
}

class Link {
  final String rel;
  final String href;
  final String name;
  final String kind;

  Link({
    required this.rel,
    required this.href,
    required this.name,
    required this.kind,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    rel: json["rel"],
    href: json["href"],
    name: json["name"],
    kind: json["kind"],
  );

  Map<String, dynamic> toJson() => {
    "rel": rel,
    "href": href,
    "name": name,
    "kind": kind,
  };
}