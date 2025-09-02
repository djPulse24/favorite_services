import 'package:hive/hive.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/service_model.dart';

abstract class ServiceLocalDataSource {
  Future<List<ServiceModel>> getServices();
  Future<void> cacheServices(List<ServiceModel> services);
  Future<void> addFavorite(int serviceId);
  Future<void> removeFavorite(int serviceId);
  Future<List<int>> getFavoriteIds();
  Future<bool> isFavorite(int serviceId);
  Future<void> initializeServices();
}

class ServiceLocalDataSourceImpl implements ServiceLocalDataSource {
  final Box<ServiceModel> servicesBox;
  final Box<int> favoritesBox;

  ServiceLocalDataSourceImpl({
    required this.servicesBox,
    required this.favoritesBox,
  });

  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      return servicesBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to get services: $e');
    }
  }

  @override
  Future<void> cacheServices(List<ServiceModel> services) async {
    try {
      await servicesBox.clear();
      for (var service in services) {
        await servicesBox.put(service.id, service);
      }
    } catch (e) {
      throw CacheException('Failed to cache services: $e');
    }
  }

  @override
  Future<void> addFavorite(int serviceId) async {
    try {
      await favoritesBox.put(serviceId, serviceId);
    } catch (e) {
      throw CacheException('Failed to add favorite: $e');
    }
  }

  @override
  Future<void> removeFavorite(int serviceId) async {
    try {
      await favoritesBox.delete(serviceId);
    } catch (e) {
      throw CacheException('Failed to remove favorite: $e');
    }
  }

  @override
  Future<List<int>> getFavoriteIds() async {
    try {
      return favoritesBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to get favorites: $e');
    }
  }

  @override
  Future<bool> isFavorite(int serviceId) async {
    try {
      return favoritesBox.containsKey(serviceId);
    } catch (e) {
      throw CacheException('Failed to check favorite status: $e');
    }
  }

  @override
  Future<void> initializeServices() async {
    try {
      // Check if services are already initialized
      if (servicesBox.isNotEmpty) return;

      // Generate mock services
      final mockServices = _generateMockServices();
      await cacheServices(mockServices);
    } catch (e) {
      throw CacheException('Failed to initialize services: $e');
    }
  }

  List<ServiceModel> _generateMockServices() {
    return [
      ServiceModel(
        id: 1,
        name: 'Web Development',
        description: 'Build responsive and modern websites with latest technologies including React, Angular, and Vue.js',
        imageUrl: 'https://picsum.photos/200/200?random=1',
        price: 299.99,
        category: 'Development',
      ),
      ServiceModel(
        id: 2,
        name: 'Mobile App Development',
        description: 'Create native iOS and Android applications with Flutter, React Native, or native development',
        imageUrl: 'https://picsum.photos/200/200?random=2',
        price: 499.99,
        category: 'Development',
      ),
      ServiceModel(
        id: 3,
        name: 'UI/UX Design',
        description: 'Design beautiful and user-friendly interfaces with modern design principles and tools',
        imageUrl: 'https://picsum.photos/200/200?random=3',
        price: 199.99,
        category: 'Design',
      ),
      ServiceModel(
        id: 4,
        name: 'Digital Marketing',
        description: 'Boost your online presence with SEO, social media marketing, and content strategy',
        imageUrl: 'https://picsum.photos/200/200?random=4',
        price: 149.99,
        category: 'Marketing',
      ),
      ServiceModel(
        id: 5,
        name: 'Cloud Solutions',
        description: 'Scalable cloud infrastructure setup and deployment on AWS, Google Cloud, or Azure',
        imageUrl: 'https://picsum.photos/200/200?random=5',
        price: 399.99,
        category: 'Infrastructure',
      ),
      ServiceModel(
        id: 6,
        name: 'Data Analytics',
        description: 'Transform your data into actionable insights with advanced analytics and visualization',
        imageUrl: 'https://picsum.photos/200/200?random=6',
        price: 349.99,
        category: 'Analytics',
      ),
      ServiceModel(
        id: 7,
        name: 'Cybersecurity Consulting',
        description: 'Protect your business with comprehensive security audits and implementation strategies',
        imageUrl: 'https://picsum.photos/200/200?random=7',
        price: 449.99,
        category: 'Security',
      ),
      ServiceModel(
        id: 8,
        name: 'AI/ML Solutions',
        description: 'Implement artificial intelligence and machine learning solutions for your business needs',
        imageUrl: 'https://picsum.photos/200/200?random=8',
        price: 599.99,
        category: 'AI/ML',
      ),
      ServiceModel(
        id: 9,
        name: 'E-commerce Development',
        description: 'Build powerful online stores with payment integration and inventory management',
        imageUrl: 'https://picsum.photos/200/200?random=9',
        price: 379.99,
        category: 'E-commerce',
      ),
      ServiceModel(
        id: 10,
        name: 'DevOps Services',
        description: 'Streamline your development workflow with CI/CD pipelines and automation tools',
        imageUrl: 'https://picsum.photos/200/200?random=10',
        price: 329.99,
        category: 'DevOps',
      ),
    ];
  }
}