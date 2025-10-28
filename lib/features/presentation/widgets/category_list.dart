import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qodera_demo_app/core/theme/app_colors.dart';
import 'package:qodera_demo_app/features/domain/entities/category.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_bloc.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_event.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_state.dart';

class CategoryList extends StatelessWidget {
  final List<Categories> categories;

  const CategoryList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        int? selectedIndex;
        if (state is ProductLoaded) {
          selectedIndex = state.selectedCategoryIndex;
        }
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context.read<ProductBloc>().add(
                    LoadProductsByCategory(categories[index].slug, index),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: selectedIndex == index
                        ? AppColors.primary
                        : AppColors.cardBackground,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    categories[index].name.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: selectedIndex == index
                          ? AppColors.categoryText
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
