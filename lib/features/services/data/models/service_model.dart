import 'package:hive/hive.dart';
import '../../domain/entities/service.dart';

part 'service_model.g.dart';

@HiveType(typeId: 0)
class ServiceModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final String category;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
  });

  factory ServiceModel.fromEntity(Service service) {
    return ServiceModel(
      id: service.id,
      name: service.name,
      description: service.description,
      imageUrl: service.imageUrl,
      price: service.price,
      category: service.category,
    );
  }

  Service toEntity({bool isFavorite = false}) {
    return Service(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      price: price,
      category: category,
      isFavorite: isFavorite,
    );
  }
}