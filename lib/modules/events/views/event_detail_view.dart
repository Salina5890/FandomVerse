import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/event_detail_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/fv_events_map.dart';

class EventDetailView extends StatelessWidget {
  const EventDetailView({super.key});

  Future<void> _openMaps(double latitude, double longitude) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Unable to open Maps', 'Please try again.');
    }
  }

  Future<void> _openDirections(double latitude, double longitude) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Unable to open Directions', 'Please try again.');
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Unable to open link', 'The ticket link could not be opened.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventId = Get.parameters['id'] ?? '';
    final controller = Get.isRegistered<EventDetailController>(tag: eventId)
        ? Get.find<EventDetailController>(tag: eventId)
        : Get.put(EventDetailController(eventId), tag: eventId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final event = controller.event.value;
        if (event == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FVIcon(PhosphorIconsRegular.calendarX, size: 64, color: AppColors.textTertiary),
                const SizedBox(height: 16),
                Text('Event not found', style: AppTypography.headingMedium),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // ── Hero Image ─────────────────────────────────
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: AppColors.surface,
              leading: _circleButton(
                icon: PhosphorIconsRegular.arrowLeft,
                onPressed: () => Get.back(),
              ),
              actions: [
                Obx(() => _circleButton(
                  icon: controller.isBookmarked.value
                      ? PhosphorIconsFill.bookmarkSimple
                      : PhosphorIconsRegular.bookmarkSimple,
                  onPressed: controller.toggleBookmark,
                )),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (event.imageUrl != null)
                      FVImage(
                        imageUrl: event.imageUrl!,
                        borderRadius: 0,
                        fit: BoxFit.cover,
                      ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color(0xCC0A0A0F),
                            AppColors.background,
                          ],
                          stops: [0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                    // Category badge
                    Positioned(
                      bottom: 16,
                      left: AppSpacing.pagePadding,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                        ),
                        child: Text(
                          event.category.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Event Details ──────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),

                    // Title
                    Text(
                      event.title,
                      style: AppTypography.headingXL.copyWith(height: 1.3),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Fandom badge
                    if (event.fandomName != null)
                      Text(
                        event.fandomName!,
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.cyan,
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Info Cards ──────────────────────────
                    _buildInfoCard(
                      icon: PhosphorIconsRegular.calendarBlank,
                      title: 'Date',
                      subtitle: _formatDateRange(
                        event.eventDate,
                        event.eventEndDate,
                      ),
                      accentColor: AppColors.accent,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildInfoCard(
                      icon: PhosphorIconsRegular.mapPin,
                      title: event.venue,
                      subtitle: event.address,
                      accentColor: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildInfoCard(
                      icon: PhosphorIconsRegular.buildings,
                      title: 'City',
                      subtitle: event.city,
                      accentColor: AppColors.cyan,
                    ),

                    if (event.attendeeCount != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      _buildInfoCard(
                        icon: PhosphorIconsRegular.users,
                        title: 'Expected Attendees',
                        subtitle: NumberFormat('#,###').format(event.attendeeCount),
                        accentColor: AppColors.primaryLight,
                      ),
                    ],

                    const SizedBox(height: AppSpacing.xl),

                    // Description
                    Text('About', style: AppTypography.headingLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      event.description,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Live Map ───────────────────────────────
                    if (event.hasLocation) ...[
                      Text('Location', style: AppTypography.headingLarge),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        height: 220,
                        width: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: FVEventsMap(
                          events: [event],
                          selectedEvent: event,
                          initialLatitude: event.latitude,
                          initialLongitude: event.longitude,
                          initialZoom: 13.0,
                          allowFullscreenToggle: false,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(spacing: 10, children: [
                        OutlinedButton.icon(
                          icon: const FVIcon(PhosphorIconsRegular.mapTrifold),
                          label: const Text('View on Map'),
                          onPressed: () => _openMaps(event.latitude!, event.longitude!),
                        ),
                        OutlinedButton.icon(
                          icon: const FVIcon(PhosphorIconsRegular.navigationArrow),
                          label: const Text('Get Directions'),
                          onPressed: () => _openDirections(event.latitude!, event.longitude!),
                        ),
                      ]),
                      const SizedBox(height: AppSpacing.xl),
                    ],

                    if (event.hasTicketLink) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const FVIcon(PhosphorIconsRegular.ticket),
                          label: const Text('Get Tickets'),
                          onPressed: () => _openUrl(event.ticketLink!),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ] else ...[
                      Text('Tickets unavailable', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // Status
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(
                          color: event.isUpcoming
                              ? AppColors.success.withValues(alpha: 0.3)
                              : AppColors.textTertiary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: event.isUpcoming
                                  ? AppColors.success
                                  : AppColors.textTertiary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            event.isUpcoming ? 'Upcoming' : 'Past Event',
                            style: AppTypography.labelMedium.copyWith(
                              color: event.isUpcoming
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        );
      }),

      // ── Bottom Action Buttons ────────────────────────
      bottomNavigationBar: Obx(() {
        final event = controller.event.value;
        if (event == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(color: AppColors.border),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                // RSVP button
                Expanded(
                  child: Obx(() => GestureDetector(
                    onTap: controller.toggleRsvp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: controller.isRsvped.value
                            ? null
                            : AppColors.primaryGradient,
                        color: controller.isRsvped.value
                            ? AppColors.card
                            : null,
                        borderRadius:
                            BorderRadius.circular(AppRadius.button),
                        border: controller.isRsvped.value
                            ? Border.all(color: AppColors.primary)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          controller.isRsvped.value
                              ? '✓ RSVP\'d'
                              : 'RSVP Now',
                          style: AppTypography.buttonMedium.copyWith(
                            color: controller.isRsvped.value
                                ? AppColors.primary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )),
                ),
                if (event.hasTicketLink) ...[
                  const SizedBox(width: 12),
                  // Tickets button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.snackbar(
                          'Tickets',
                          'Ticket link: ${event.ticketLink}',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius:
                              BorderRadius.circular(AppRadius.button),
                        ),
                        child: Center(
                          child: Text(
                            'Get Tickets',
                            style: AppTypography.buttonMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.7),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: FVIcon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: FVIcon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLarge),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateRange(DateTime start, DateTime? end) {
    final fmt = DateFormat('MMM dd, yyyy • hh:mm a');
    if (end != null) {
      return '${fmt.format(start)} — ${DateFormat('MMM dd').format(end)}';
    }
    return fmt.format(start);
  }
}

// Simple grid painter to simulate a map background

