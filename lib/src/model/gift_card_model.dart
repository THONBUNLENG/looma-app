class GiftCardModel {
  final String title;
  final double amount;
  final DateTime validFrom;
  final DateTime validUntil;
  final String claimCode;
  final String description;
  final List<String> terms;
  final bool isActive;

  GiftCardModel({
    required this.title,
    required this.amount,
    required this.validFrom,
    required this.validUntil,
    required this.claimCode,
    required this.description,
    required this.terms,
    this.isActive = true,
  });

  // Sample data for development
  static List<GiftCardModel> get sampleData => [
    GiftCardModel(
      title: "Cash Voucher",
      amount: 5.0,
      validFrom: DateTime(2026, 7, 29),
      validUntil: DateTime(2026, 8, 28),
      claimCode: "37057213",
      description: "\$5 Welcome Gift to start your shopping journey!",
      terms: [
        "\$5 voucher just for you! As a thank you for registering.",
        "\$5 Voucher on min spend of \$15 only.",
        "Valid 30 days after registered.",
        "Online purchase only and other terms may apply."
      ],
      isActive: true,
    ),
    GiftCardModel(
      title: "Cash Voucher",
      amount: 8.0,
      validFrom: DateTime(2026, 8, 1),
      validUntil: DateTime(2026, 8, 5),
      claimCode: "AUGXTRA8",
      description: "\$8 voucher discount for \$100 purchase and above.",
      terms: [
        "\$8 voucher for August extra!",
        "Min spend of \$100.",
        "Valid for limited time.",
        "Online purchase only."
      ],
      isActive: false,
    ),
    GiftCardModel(
      title: "Cash Voucher",
      amount: 8.0,
      validFrom: DateTime(2026, 7, 26),
      validUntil: DateTime(2026, 7, 31),
      claimCode: "JULYXTRA8",
      description: "\$8 voucher discount for \$50 purchase and above.",
      terms: [
        "\$8 voucher for July extra!",
        "Min spend of \$50.",
        "Valid for limited time.",
        "Online purchase only."
      ],
      isActive: false,
    ),
    GiftCardModel(
      title: "Cash Voucher",
      amount: 5.0,
      validFrom: DateTime(2026, 7, 26),
      validUntil: DateTime(2026, 7, 31),
      claimCode: "JULYXTRA5",
      description: "\$5 voucher discount for \$35 purchase and above.",
      terms: [
        "\$5 voucher for July extra!",
        "Min spend of \$35.",
        "Valid for limited time.",
        "Online purchase only."
      ],
      isActive: false,
    ),
    GiftCardModel(
      title: "Cash Voucher",
      amount: 6.0,
      validFrom: DateTime(2026, 7, 21),
      validUntil: DateTime(2026, 7, 25),
      claimCode: "JULYXTRA6",
      description: "\$6 voucher discount for \$50 purchase and above.",
      terms: [
        "\$6 voucher for July extra!",
        "Min spend of \$50.",
        "Valid for limited time.",
        "Online purchase only."
      ],
      isActive: false,
    ),
    GiftCardModel(
      title: "Cash Voucher",
      amount: 4.0,
      validFrom: DateTime(2026, 7, 21),
      validUntil: DateTime(2026, 7, 25),
      claimCode: "JULYXTRA4",
      description: "\$4 voucher discount for \$35 purchase and above.",
      terms: [
        "\$4 voucher for July extra!",
        "Min spend of \$35.",
        "Valid for limited time.",
        "Online purchase only."
      ],
      isActive: false,
    ),
    GiftCardModel(
      title: "Cash Voucher",
      amount: 9.0,
      validFrom: DateTime(2026, 7, 11),
      validUntil: DateTime(2026, 7, 15),
      claimCode: "MYJULY9",
      description: "\$9 voucher discount for \$50 purchase.",
      terms: [
        "\$9 voucher for My July!",
        "Min spend of \$50.",
        "Valid for limited time.",
        "Online purchase only."
      ],
      isActive: false,
    ),
  ];
}
