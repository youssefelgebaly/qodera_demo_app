import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qodera_demo_app/core/theme/app_colors.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_bloc.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_event.dart';

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.discountBadge,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () {
              context.read<ProductBloc>().add(LoadProducts());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,

              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              shadowColor: AppColors.primary,
            ),
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text(
              'Retry',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
