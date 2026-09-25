import 'package:flutter/material.dart';
import 'package:medium_weather_app/constants/colors.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onGeolocate,
    this.isLoading = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onGeolocate;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Row(
        children: [
          const Icon(Icons.search, color: AppColors.faded),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search location...',
                hintStyle: TextStyle(color: AppColors.faded),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          ),
          const SizedBox(
            height: 24,
            child: VerticalDivider(
              color: AppColors.muted,
              thickness: 2,
              width: 16,
            ),
          ),
          IconButton(
            tooltip: 'Use my location',
            icon: const Icon(Icons.near_me, color: AppColors.muted),
            onPressed: onGeolocate,
          ),
        ],
      ),
      bottom: isLoading
          ? const PreferredSize(
              preferredSize: Size.fromHeight(2),
              child: LinearProgressIndicator(
                minHeight: 2,
                color: Colors.white,
                backgroundColor: AppColors.background,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (isLoading ? 2 : 0));
}
