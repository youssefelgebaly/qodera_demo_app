import 'package:equatable/equatable.dart';

class Categories extends Equatable {
  final String slug;
  final String name;
  final String url;

  const Categories({required this.slug, required this.name, required this.url});

  @override
  List<Object?> get props => [slug, name, url];
}
