class BillItem {
  final int id;
  final String name;
  final int quantity;
  final double price;

  BillItem({required this.id,required this.name, required this.quantity, required this.price});

  double get total => quantity * price;
}
