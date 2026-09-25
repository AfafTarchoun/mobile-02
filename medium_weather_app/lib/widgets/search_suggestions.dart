import 'package:flutter/material.dart';
import 'package:medium_weather_app/constants/colors.dart';
import 'package:medium_weather_app/models/geo_location.dart';

class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onSelected,
    required this.onDismiss,
  });

  final List<GeoLocation> suggestions;
  final ValueChanged<GeoLocation> onSelected;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: AppColors.surface,
          elevation: 4,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: suggestions.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Colors.white24, height: 1),
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                final subtitle = suggestion.subtitle;
                return ListTile(
                  leading: const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.muted,
                  ),
                  title: Text(
                    suggestion.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: subtitle.isEmpty
                      ? null
                      : Text(
                          subtitle,
                          style: const TextStyle(color: AppColors.muted),
                        ),
                  onTap: () => onSelected(suggestion),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDismiss,
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}
