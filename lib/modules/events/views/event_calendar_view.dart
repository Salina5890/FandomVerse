import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/event_calendar_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EventCalendarView extends GetView<EventCalendarController> {
  const EventCalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Event Calendar', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Simplified Calendar view (just a placeholder for a real calendar widget like table_calendar)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            color: AppColors.card,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(icon: FVIcon(PhosphorIconsRegular.caretLeft, color: AppColors.textPrimary), onPressed: controller.previousMonth),
                    Obx(() => Text(
                      DateFormat('MMMM yyyy').format(controller.selectedDate.value),
                      style: AppTypography.headingSmall.copyWith(color: AppColors.textPrimary),
                    )),
                    IconButton(icon: FVIcon(PhosphorIconsRegular.caretRight, color: AppColors.textPrimary), onPressed: controller.nextMonth),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Days of week
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((d) => 
                    Text(d, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary))
                  ).toList(),
                ),
                const SizedBox(height: AppSpacing.md),
                // Calendar grid
                Builder(builder: (context) {
                  final month = controller.selectedDate.value;
                  final first = DateTime(month.year, month.month, 1);
                  final days = DateTime(month.year, month.month + 1, 0).day;
                  final leading = first.weekday % 7;
                  final total = leading + days;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
                    itemCount: total,
                    itemBuilder: (context, index) {
                      if (index < leading) return const SizedBox.shrink();
                      final day = index - leading + 1;
                      final date = DateTime(month.year, month.month, day);
                      final isSelected = date.year == controller.selectedDate.value.year && date.month == controller.selectedDate.value.month && date.day == controller.selectedDate.value.day;
                      return GestureDetector(
                        onTap: () => controller.updateEventsForDate(date),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.transparent, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Text('$day', style: AppTypography.bodyMedium.copyWith(color: isSelected ? Colors.white : AppColors.textPrimary)),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
          
          Expanded(
            child: Obx(() {
              if (controller.eventsForSelectedDate.isEmpty) {
                return Center(
                  child: Text('No events for this date.', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                itemCount: controller.eventsForSelectedDate.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final event = controller.eventsForSelectedDate[index];
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
                          width: 100,
                          height: 100,
                          borderRadius: AppSpacing.sm,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.sm),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  '${event.location.city}, ${event.location.country}',
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  DateFormat('h:mm a').format(event.startDate),
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
              );
            }),
          ),
        ],
      ),
    );
  }
}
