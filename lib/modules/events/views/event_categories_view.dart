import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../data/services/seed_data_service.dart';

class EventCategoriesView extends StatefulWidget {
  const EventCategoriesView({Key? key}) : super(key: key);

  @override
  State<EventCategoriesView> createState() => _EventCategoriesViewState();
}

class _EventCategoriesViewState extends State<EventCategoriesView> {
  final List<String> categories = ['All', 'Convention', 'Concert', 'Cosplay', 'Screening', 'Meetup', 'Exhibition'];
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredEvents = selectedCategory == 'All' 
      ? SeedDataService.events 
      : SeedDataService.events.where((e) => e.eventType.toLowerCase() == selectedCategory.toLowerCase()).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Event Categories', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: AppSpacing.sm),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => selectedCategory = category);
                      }
                    },
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary,
                    labelStyle: AppTypography.chipLabel.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.borderSubtle,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: filteredEvents.isEmpty
                ? Center(
                    child: Text('No events found for $selectedCategory', 
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    itemCount: filteredEvents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(AppSpacing.sm),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Row(
                          children: [
                            FVImage(
                              imageUrl: event.imageUrl ?? 'https://images.unsplash.com/photo-1501281668745-f7f25e954c9e?w=800&q=80',
                              width: 120,
                              height: 100,
                              borderRadius: AppSpacing.sm,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      '${event.location.city}, ${event.location.country}',
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      DateFormat('MMM dd • h:mm a').format(event.startDate),
                                      style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
