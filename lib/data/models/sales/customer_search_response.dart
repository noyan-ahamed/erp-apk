class CustomerSearchResponse {

  final int id;
  final String name;
  final String email;
  final String? companyName;
  final String mobileNumber;
  final String? address;

  CustomerSearchResponse({
    required this.id,
    required this.name,
    required this.email,
    this.companyName,
    required this.mobileNumber,
    this.address,
  });

  factory CustomerSearchResponse.fromJson(
      Map<String, dynamic> json,
      ) {

    return CustomerSearchResponse(
      id: json["id"],
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      companyName: json["companyName"],
      mobileNumber: json["mobileNumber"] ?? "",
      address: json["address"],
    );
  }
}