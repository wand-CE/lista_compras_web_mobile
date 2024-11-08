class ItemModel {
  int? id;
  String name;
  int quantity;
  int status;

  ItemModel({
    this.id,
    required this.name,
    required this.quantity,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'status': status,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      status: int.parse('${map['status']}'),
    );
  }
}
