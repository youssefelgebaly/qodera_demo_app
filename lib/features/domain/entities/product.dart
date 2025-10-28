import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final double? price;
  final double? discountPercentage;
  final double? rating;
  final int? stock;
  final String? brand;
  final String? category;
  final String? thumbnail;
  final List? images;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fake() {
    return Product(
      id: 0,
      title: 'Loading...',
      description: 'Loading description...',
      price: 0,
      discountPercentage: 0,
      rating: 0,
      stock: 0,
      brand: 'Loading brand...',
      category: 'Loading category...',
      thumbnail: 'https://via.placeholder.com/150/eeeeee/cccccc?text=Loading',
      images: const [],
    );
  }
  @override
  List get props => [
    id,
    title,
    description,
    price,
    discountPercentage,
    rating,
    stock,
    brand,
    category,
    thumbnail,
    images,
  ];
}
