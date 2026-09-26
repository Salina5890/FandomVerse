import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/events_controller.dart';

class NearbyEventsView extends StatelessWidget {
  const NearbyEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<EventsController>() ? Get.find<EventsController>() : Get.put(EventsController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Event Discovery')),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        return Column(
          children: [
            _filters(controller),
            if (controller.locationMessage.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                child: Text(controller.locationMessage.value, style: AppTypography.bodySmall.copyWith(color: AppColors.warning)),
              ),
            Expanded(child: _content(context, controller)),
          ],
        );
      }),
    );
  }

  Widget _filters(EventsController c) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.sm),
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          OutlinedButton.icon(
            onPressed: c.locationLoading.value ? null : c.requestLocation,
            icon: const FVIcon(Icons.my_location),
            label: Text(c.userPosition.value == null ? 'Use location' : 'Location on'),
          ),
          const SizedBox(width: 8),
          _menu('City', c.cities, c.selectedCity.value, c.setCity),
          _menu('Type', c.types, c.selectedType.value, c.setType),
          _menu('Fandom', c.fandoms, c.selectedFandom.value, c.setFandom),
          PopupMenuButton<double>(
            onSelected: c.setMaxDistance,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 25, child: Text('Within 25 km')),
              PopupMenuItem(value: 50, child: Text('Within 50 km')),
              PopupMenuItem(value: 100, child: Text('Within 100 km')),
              PopupMenuItem(value: 500, child: Text('Within 500 km')),
              PopupMenuItem(value: 5000, child: Text('Any distance')),
            ],
            child: Chip(label: Text(c.maxDistanceKm.value >= 5000 ? 'Distance' : '≤ ${c.maxDistanceKm.value.toInt()} km')),
          ),
          PopupMenuButton<EventSort>(
            onSelected: c.setSort,
            itemBuilder: (_) => const [
              PopupMenuItem(value: EventSort.nearest, child: Text('Nearest')),
              PopupMenuItem(value: EventSort.soonest, child: Text('Soonest')),
              PopupMenuItem(value: EventSort.popular, child: Text('Popular')),
            ],
            child: const Chip(label: Text('Sort')),
          ),
        ]),
      );

  Widget _menu(String label, List<String> items, String value, ValueChanged<String> onChanged) => PopupMenuButton<String>(
        onSelected: onChanged,
        itemBuilder: (_) => items.map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
        child: Chip(label: Text(value == 'All' ? label : value)),
      );

  Widget _content(BuildContext context, EventsController c) {
    if (c.filteredEvents.isEmpty) return const Center(child: Text('No nearby fandom events found.'));
    return Column(children: [
      SizedBox(height: 250, child: _map(c)),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          itemCount: c.filteredEvents.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (_, index) {
            final event = c.filteredEvents[index];
            final distance = c.distanceKm(event);
            return InkWell(
              onTap: () => Get.toNamed(AppRoutes.eventDetail.replaceFirst(':id', event.id)),
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: Container(
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.border)),
                child: Row(children: [
                  FVImage(imageUrl: event.imageUrl ?? AppConstants.placeholderEvent, width: 100, height: 118, borderRadius: AppRadius.card),
                  Expanded(child: Padding(padding: const EdgeInsets.all(AppSpacing.sm), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(event.title, style: AppTypography.labelLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 5),
                    Text('${event.venue}, ${event.city}', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary), maxLines: 2),
                    const SizedBox(height: 5),
                    Text(DateFormat('MMM dd, yyyy').format(event.eventDate), style: AppTypography.labelSmall.copyWith(color: AppColors.accent)),
                    if (distance != null) Text('${distance.toStringAsFixed(1)} km away', style: AppTypography.caption.copyWith(color: AppColors.primaryLight)),
                  ]))),
                ]),
              ),
            );
          },
        ),
      ),
    ]);
  }

  Widget _map(EventsController c) {
    if (AppConstants.googleMapsApiKey == 'YOUR_GOOGLE_MAPS_API_KEY') {
      return Container(color: AppColors.surface, alignment: Alignment.center, padding: const EdgeInsets.all(24), child: Text('Google Maps API key required to display the live map.', textAlign: TextAlign.center, style: AppTypography.bodyMedium));
    }
    final markers = c.filteredEvents.where((e) => e.hasLocation).map((e) => Marker(
      markerId: MarkerId(e.id), position: LatLng(e.latitude!, e.longitude!),
      infoWindow: InfoWindow(title: e.title, snippet: e.city),
      onTap: () => Get.toNamed(AppRoutes.eventDetail.replaceFirst(':id', e.id)),
    )).toSet();
    final pos = c.userPosition.value;
    final center = pos != null ? LatLng(pos.latitude, pos.longitude) : const LatLng(20.0, 100.0);
    return GoogleMap(initialCameraPosition: CameraPosition(target: center, zoom: pos == null ? 3.5 : 10), markers: markers, myLocationEnabled: pos != null, myLocationButtonEnabled: true, zoomControlsEnabled: true);
  }
}
