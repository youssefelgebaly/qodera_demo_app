import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qodera_demo_app/core/constants/api_constants.dart';
import 'package:qodera_demo_app/core/di/injection_container.dart' as di;
import 'package:qodera_demo_app/core/theme/app_colors.dart';
import 'package:qodera_demo_app/features/domain/entities/category.dart';
import 'package:qodera_demo_app/features/domain/entities/product.dart';
import 'package:qodera_demo_app/features/presentation/widgets/error_state_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/carousel_section.dart';
import '../widgets/category_list.dart';
import '../widgets/product_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocProvider(
          create: (_) => di.sl<ProductBloc>()..add(LoadProducts()),
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductError) {
                return ErrorStateWidget(message: state.message);
              }

              final bool isMainLoading = state is ProductLoading;
              final bool isSearchLoading = state is SearchLoading;

              final List<Product> products = (state is ProductLoaded)
                  ? state.products
                  : (state is SearchLoaded)
                  ? state.products
                  : List.generate(6, (_) => Product.fake());

              final List<Categories> categories = (state is ProductLoaded)
                  ? state.categories
                  : List.generate(
                      5,
                      (_) =>
                          Categories(name: 'Loading......', slug: '', url: ''),
                    );

              return CustomScrollView(
                slivers: [
                  const HomeHeaderWidget(),

                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        if (state is! SearchLoaded && !isSearchLoading) ...[
                          const CarouselSection(
                            images: ApiConstants.carouselList,
                          ),
                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Categories',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Skeletonizer(
                            enabled: isMainLoading,
                            child: CategoryList(categories: categories),
                          ),
                          const SizedBox(height: 20),
                        ],

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            isSearchLoading
                                ? ''
                                : 'Products (${products.length})',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Skeletonizer(
                          enabled: isMainLoading || isSearchLoading,
                          child: ProductList(
                            products: (isMainLoading || isSearchLoading)
                                ? List.generate(6, (_) => Product.fake())
                                : products,
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
