import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String productId;
  final String name;
  final int price;
  int qty;

  Product({required this.productId, required this.name, required this.price, required this.qty});

  factory Product.initial() => Product(productId: "", name: "", price: 0, qty: 0);

  Product copyWith({String? productId, String? name, int? price, int? qty}) {
    return Product(
      name: name ?? this.name,
      productId: productId ?? this.productId,
      price: price ?? this.price,
      qty: qty ?? this.qty,
    );
  }

  @override
  List<Object?> get props => [productId, name, price, qty];
}
