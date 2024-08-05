class FinanceModel {
  final int? financeId;
  final String financeTitle;
  final String financeType;
  final String total;
  final String createdAt;

  FinanceModel({
    this.financeId,
    required this.financeTitle,
    required this.financeType,
    required this.total,
    required this.createdAt,
  });

  factory FinanceModel.fromMap(Map<String, dynamic> json) => FinanceModel(
        financeId: json["financeId"],
        financeTitle: json["financeTitle"],
        financeType: json["financeType"],
        total: json["total"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toMap() => {
        "financeId": financeId,
        "financeTitle": financeTitle,
        "financeType": financeType,
        "total": total,
        "createdAt": createdAt,
      };
}