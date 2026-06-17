class TicketModel {
  final int id;
  final int userId;
  final int busId;

  TicketModel({
    required this.id,
    required this.userId,
    required this.busId,
  });

  factory TicketModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TicketModel(
      id: json['id'],
      userId: json['user_id'],
      busId: json['bus_id'],
    );
  }
}