class QuickCustomerCreateRequest {

  final String name;
  final String email;
  final String? companyName;
  final String mobileNumber;
  final String? address;

  QuickCustomerCreateRequest({
    required this.name,
    required this.email,
    this.companyName,
    required this.mobileNumber,
    this.address,
  });

  Map<String, dynamic> toJson() {

    return {
      "name": name,
      "email": email,
      "companyName": companyName,
      "mobileNumber": mobileNumber,
      "address": address,
    };
  }
}