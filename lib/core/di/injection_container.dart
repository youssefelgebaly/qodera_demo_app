import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:qodera_demo_app/features/data/datasources/product_remote_data_source.dart';
import 'package:qodera_demo_app/features/data/repositories/product_repository_impl.dart';
import 'package:qodera_demo_app/features/domain/repositories/product_repository.dart';
import 'package:qodera_demo_app/features/domain/usecases/get_products.dart';
import 'package:qodera_demo_app/features/domain/usecases/get_products_by_category.dart';
import 'package:qodera_demo_app/features/domain/usecases/search_products.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future init() async {
  // BLoC
  sl.registerFactory(
    () => ProductBloc(
      getProducts: sl(),
      searchProducts: sl(),
      getProductsByCategory: sl(),
      repository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => SearchProducts(sl()));
  sl.registerLazySingleton(() => GetProductsByCategory(sl()));
  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  // Data sources
  sl.registerLazySingleton(() => ProductRemoteDataSource(sl()));

  // External
  sl.registerLazySingleton(() => Dio());
}
