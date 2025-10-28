import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qodera_demo_app/core/theme/app_colors.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_bloc.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_event.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_state.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  bool _isSearching = false;

  static const Duration _debounceDuration = Duration(milliseconds: 500);

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    setState(() => _isSearching = query.isNotEmpty);

    _debounce = Timer(_debounceDuration, () {
      final bloc = context.read<ProductBloc>();
      if (query.isNotEmpty) {
        bloc.add(SearchProductsEvent(query));
      }
    });
  }

  void _clearSearch() {
    _controller.clear();
    setState(() => _isSearching = false);
    _focusNode.unfocus();
    context.read<ProductBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final bool isLoading = state is SearchLoading;
        final bool isEmpty = _controller.text.trim().isEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[isEmpty ? 200 : 100],
            borderRadius: BorderRadius.circular(16),

            boxShadow: [
              if (!isEmpty)
                BoxShadow(
                  color: AppColors.shadowMedium,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.surfaceDark),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.surfaceDark,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: isLoading
                    ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : _isSearching
                    ? IconButton(
                        key: const ValueKey('cancel'),
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.surfaceDark,
                        ),
                        onPressed: _clearSearch,
                      )
                    : const SizedBox(
                        key: ValueKey('empty'),
                        width: 0,
                        height: 0,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
