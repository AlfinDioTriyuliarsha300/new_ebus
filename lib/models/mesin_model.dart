class MesinModel {
  final int id;
  final String namaMesin;

  MesinModel({
    required this.id,
    required this.namaMesin,
  });

  factory MesinModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MesinModel(
      id: json["id"],
      namaMesin: json["nama_mesin"] ?? "",
    );
  }
}