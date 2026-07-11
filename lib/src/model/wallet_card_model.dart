class WalletCardModel {
  final String number;
  final String fullName;
  final String expiry;
  final String cvv;
  final int colorIndex;

  WalletCardModel({
    required this.number,
    required this.fullName,
    required this.expiry,
    required this.cvv,
    required this.colorIndex,
  });

  Map<String, dynamic> toJson() => {
    'number': number,
    'fullName': fullName,
    'expiry': expiry,
    'cvv': cvv,
    'colorIndex': colorIndex,
  };

  factory WalletCardModel.fromJson(Map<String, dynamic> json) => WalletCardModel(
    number: json['number'],
    fullName: json['fullName'],
    expiry: json['expiry'],
    cvv: json['cvv'],
    colorIndex: json['colorIndex'],
  );
}