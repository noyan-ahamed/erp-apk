class SupplierModel {
  final int? id;
  final String name;
  final String? companyName;
  final String email;
  final String mobileNumber;
  final String? tinNumber;
  final String? address;
  final String? paymentTerms;
  final String? status;
  final String? rating;
  final String? bankAccount;
  final String? bkashNo;
  final String? createdAt;

  SupplierModel({this.id, required this.name, this.companyName, required this.email,
    required this.mobileNumber, this.tinNumber, this.address, this.paymentTerms,
    this.status, this.rating, this.bankAccount, this.bkashNo, this.createdAt});


  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'],
      name: json['name'],
      companyName: json['company_name'],
      email: json['email'],
      mobileNumber: json['mobileNumber'],
      tinNumber: json['tin_number'],
      address: json['address'],
      paymentTerms: json['payment_terms'],
      status: json['status'],
      rating: json['rating'],
      bankAccount: json['bank_account'],
      bkashNo: json['bkashNo'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'company_name': companyName,
      'email': email,
      'mobileNumber': mobileNumber,
      'tin_number': tinNumber,
      'address': address,
      'payment_terms': paymentTerms,
      'status': status,
      'rating': rating,
      'bank_account': bankAccount,
      'bkashNo': bkashNo,
      'created_at': createdAt,
    };
  }


}