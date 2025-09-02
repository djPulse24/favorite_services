import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final bool isFavorite;

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    this.isFavorite = false,
  });

  Service copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    String? category,
    bool? isFavorite,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, name, description, imageUrl, price, category, isFavorite];
}