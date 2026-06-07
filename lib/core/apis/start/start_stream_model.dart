class StartStreamModel {
  final int accountId;
  final String name;
  final String description;
  final String layoutType;

  StartStreamModel({
    required this.accountId,
    required this.name,
    required this.description,
    required this.layoutType,
  });

  Map<String, dynamic> toJson() {
    return {
      "account_id": accountId,
      "name": name,
      "description": description,
      "layout_type": layoutType,
    };
  }
}