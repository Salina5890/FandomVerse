import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_icon.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/events_controller.dart';
import '../widgets/fv_events_map.dart';

class NearbyEventsView extends StatelessWidget {
  const NearbyEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<EventsController>()
        ? Get.find<EventsController>()
        : Get.put(EventsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Event Discovery & Map'),
        actions: [
          Obx(() => IconButton(
                tooltip: controller.showMap.value ? 'Hide map' : 'Show map',
                icon: FVIcon(
                  controller.showMap.value
                      ? PhosphorIconsRegular.listBullets
                      : PhosphorIconsRegular.mapTrifold,
                  color: AppColors.primaryLight,
                ),
                onPressed: controller.toggleShowMap,
              )),
          Obx(() => IconButton(
                tooltip: controller.isMapExpanded.value ? 'Standard view' : 'Fullscreen map',
                icon: FVIcon(
                  controller.isMapExpanded.value
                      ? PhosphorIconsRegular.cornersIn
                      : PhosphorIconsRegular.cornersOut,
                  color: AppColors.textPrimary,
                ),
                onPressed: controller.toggleMapExpanded,
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Fullscreen Map View
        if (controller.isMapExpanded.value) {
          return Stack(
            children: [
              Positioned.fill(
                child: FVEventsMap(
                  events: controller.filteredEvents,
                  userPosition: controller.userPosition.value,
                  selectedEvent: controller.selectedEvent.value,
                  onEventSelected: controller.selectEvent,
                  onRequestLocation: controller.requestLocation,
                  isLocationLoading: controller.locationLoading.value,
                  isFullscreen: true,
                  onToggleFullscreen: controller.toggleMapExpanded,
                ),
              ),
              // Floating Filter Bar on top of map
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: _filters(controller, isFloating: true),
              ),
            ],
          );
        }

        // Standard Split / List View
        return Column(
          children: [
            _filters(controller),
            if (controller.locationMessage.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    const FVIcon(PhosphorIconsRegular.warningCircle, color: Colors.orange, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        controller.locationMessage.value,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(child: _content(context, controller)),
          ],
        );
      }),
    );
  }

  Widget _filters(EventsController c, {bool isFloating = false}) {
    final filterContent = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor: isFloating ? AppColors.surface.withValues(alpha: 0.92) : null,
              side: BorderSide(
                color: c.userPosition.value != null ? AppColors.primary : AppColors.border,
              ),
            ),
            onPressed: c.locationLoading.value ? null : c.requestLocation,
            icon: c.locationLoading.value
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : FVIcon(
                    PhosphorIconsRegular.navigationArrow,
                    size: 16,
                    color: c.userPosition.value != null ? AppColors.primaryLight : null,
                  ),
            label: Text(
              c.userPosition.value == null ? 'Use GPS' : 'GPS Active',
              style: TextStyle(
                color: c.userPosition.value != null ? AppColors.primaryLight : null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _menu('City', c.cities, c.selectedCity.value, c.setCity, isFloating),
          _menu('Type', c.types, c.selectedType.value, c.setType, isFloating),
          _menu('Fandom', c.fandoms, c.selectedFandom.value, c.setFandom, isFloating),
          PopupMenuButton<double>(
            onSelected: c.setMaxDistance,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 25, child: Text('Within 25 km')),
              PopupMenuItem(value: 50, child: Text('Within 50 km')),
              PopupMenuItem(value: 100, child: Text('Within 100 km')),
              PopupMenuItem(value: 500, child: Text('Within 500 km')),
              PopupMenuItem(value: 5000, child: Text('Any distance')),
            ],
            child: Chip(
              backgroundColor: isFloating ? AppColors.surface.withValues(alpha: 0.92) : null,
              label: Text(
                c.maxDistanceKm.value >= 5000
                    ? 'Distance'
                    : '≤ ${c.maxDistanceKm.value.toInt()} km',
              ),
            ),
          ),
          PopupMenuButton<EventSort>(
            onSelected: c.setSort,
            itemBuilder: (_) => const [
              PopupMenuItem(value: EventSort.nearest, child: Text('Nearest')),
              PopupMenuItem(value: EventSort.soonest, child: Text('Soonest')),
              PopupMenuItem(value: EventSort.popular, child: Text('Popular')),
            ],
            child: Chip(
              backgroundColor: isFloating ? AppColors.surface.withValues(alpha: 0.92) : null,
              label: const Text('Sort'),
            ),
          ),
        ],
      ),
    );

    if (!isFloating) return filterContent;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.75),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: filterContent,
    );
  }

  Widget _menu(
    String label,
    List<String> items,
    String value,
    ValueChanged<String> onChanged,
    bool isFloating,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: PopupMenuButton<String>(
        onSelected: onChanged,
        itemBuilder: (_) => items.map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
        child: Chip(
          backgroundColor: isFloating ? AppColors.surface.withValues(alpha: 0.92) : null,
          label: Text(value == 'All' ? label : value),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, EventsController c) {
    if (c.filteredEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FVIcon(PhosphorIconsRegular.mapPinLine, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: 12),
            Text('No nearby fandom events found.', style: AppTypography.headingSmall),
            const SizedBox(height: 6),
            Text('Try adjusting distance or filters.', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Live Interactive Map View
        if (c.showMap.value) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, 0, AppSpacing.pagePadding, AppSpacing.sm),
            child: SizedBox(
              height: 270,
              child: FVEventsMap(
                events: c.filteredEvents,
                userPosition: c.userPosition.value,
                selectedEvent: c.selectedEvent.value,
                onEventSelected: c.selectEvent,
                onRequestLocation: c.requestLocation,
                isLocationLoading: c.locationLoading.value,
                onToggleFullscreen: c.toggleMapExpanded,
              ),
            ),
          ),
        ],

        // List of Events
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            itemCount: c.filteredEvents.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (_, index) {
              final event = c.filteredEvents[index];
              final distance = c.distanceKm(event);
              final isSelected = c.selectedEvent.value?.id == event.id;

              return InkWell(
                onTap: () {
                  c.selectEvent(event);
                  Get.toNamed(AppRoutes.eventDetail.replaceFirst(':id', event.id));
                },
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.cardElevated : AppColors.card,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      FVImage(
                        imageUrl: event.imageUrl ?? AppConstants.placeholderEvent,
                        width: 105,
                        height: 125,
                        borderRadius: AppRadius.card,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      event.category,
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.primaryLight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (distance != null)
                                    Row(
                                      children: [
                                        FVIcon(
                                          PhosphorIconsRegular.navigationArrow,
                                          size: 12,
                                          color: AppColors.primaryLight,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          '${distance.toStringAsFixed(1)} km',
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.primaryLight,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                event.title,
                                style: AppTypography.labelLarge,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  FVIcon(PhosphorIconsRegular.mapPin, size: 13, color: AppColors.textTertiary),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${event.venue}, ${event.city}',
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  FVIcon(PhosphorIconsRegular.calendar, size: 13, color: AppColors.accent),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(event.eventDate),
                                    style: AppTypography.labelSmall.copyWith(color: AppColors.accent),
                                  ),
                                  const Spacer(),
                                  // Quick pin button to focus on map
                                  InkWell(
                                    onTap: () => c.selectEvent(event),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.borderSubtle),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          FVIcon(PhosphorIconsRegular.crosshair, size: 11, color: AppColors.primaryLight),
                                          const SizedBox(width: 3),
                                          Text('Map', style: AppTypography.caption.copyWith(fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
