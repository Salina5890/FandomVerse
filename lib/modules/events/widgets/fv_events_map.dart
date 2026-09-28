import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/fv_icon.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../data/models/event_model.dart';

enum MapTileStyle {
  dark,
  voyager,
  osm,
}

class FVEventsMap extends StatefulWidget {
  final List<EventModel> events;
  final Position? userPosition;
  final EventModel? selectedEvent;
  final ValueChanged<EventModel?>? onEventSelected;
  final VoidCallback? onRequestLocation;
  final bool isLocationLoading;
  final double initialZoom;
  final double? initialLatitude;
  final double? initialLongitude;
  final bool allowFullscreenToggle;
  final bool isFullscreen;
  final VoidCallback? onToggleFullscreen;

  const FVEventsMap({
    super.key,
    required this.events,
    this.userPosition,
    this.selectedEvent,
    this.onEventSelected,
    this.onRequestLocation,
    this.isLocationLoading = false,
    this.initialZoom = 4.0,
    this.initialLatitude,
    this.initialLongitude,
    this.allowFullscreenToggle = true,
    this.isFullscreen = false,
    this.onToggleFullscreen,
  });

  @override
  State<FVEventsMap> createState() => _FVEventsMapState();
}

class _FVEventsMapState extends State<FVEventsMap> with SingleTickerProviderStateMixin {
  late double _zoom;
  late double _centerLat;
  late double _centerLon;
  EventModel? _selectedEvent;
  MapTileStyle _tileStyle = MapTileStyle.dark;
  bool _useGoogleMaps = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _zoom = widget.initialZoom;
    _selectedEvent = widget.selectedEvent;

    _calculateInitialCenter();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant FVEventsMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedEvent != oldWidget.selectedEvent) {
      _selectedEvent = widget.selectedEvent;
      if (_selectedEvent != null && _selectedEvent!.hasLocation) {
        _animateTo(_selectedEvent!.latitude!, _selectedEvent!.longitude!, math.max(_zoom, 10.0));
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _calculateInitialCenter() {
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _centerLat = widget.initialLatitude!;
      _centerLon = widget.initialLongitude!;
      return;
    }

    if (widget.userPosition != null) {
      _centerLat = widget.userPosition!.latitude;
      _centerLon = widget.userPosition!.longitude;
      return;
    }

    final validEvents = widget.events.where((e) => e.hasLocation).toList();
    if (validEvents.isNotEmpty) {
      double sumLat = 0;
      double sumLon = 0;
      for (final e in validEvents) {
        sumLat += e.latitude!;
        sumLon += e.longitude!;
      }
      _centerLat = sumLat / validEvents.length;
      _centerLon = sumLon / validEvents.length;
    } else {
      _centerLat = 15.0;
      _centerLon = 105.0; // Default Southeast Asia / Global view
    }
  }

  void _fitAllEvents() {
    final validEvents = widget.events.where((e) => e.hasLocation).toList();
    if (validEvents.isEmpty) return;

    double minLat = validEvents.first.latitude!;
    double maxLat = validEvents.first.latitude!;
    double minLon = validEvents.first.longitude!;
    double maxLon = validEvents.first.longitude!;

    for (final e in validEvents) {
      minLat = math.min(minLat, e.latitude!);
      maxLat = math.max(maxLat, e.latitude!);
      minLon = math.min(minLon, e.longitude!);
      maxLon = math.max(maxLon, e.longitude!);
    }

    setState(() {
      _centerLat = (minLat + maxLat) / 2;
      _centerLon = (minLon + maxLon) / 2;
      final latDiff = (maxLat - minLat).abs();
      final lonDiff = (maxLon - minLon).abs();
      final maxDiff = math.max(latDiff, lonDiff);

      if (maxDiff < 0.1) {
        _zoom = 13.0;
      } else if (maxDiff < 1.0) {
        _zoom = 10.0;
      } else if (maxDiff < 5.0) {
        _zoom = 7.0;
      } else if (maxDiff < 15.0) {
        _zoom = 5.0;
      } else {
        _zoom = 3.5;
      }
    });
  }

  void _animateTo(double lat, double lon, [double? zoom]) {
    setState(() {
      _centerLat = lat;
      _centerLon = lon;
      if (zoom != null) _zoom = zoom;
    });
  }

  // Mercator Projection helper
  double _lonToX(double lon, int z) => ((lon + 180.0) / 360.0 * (1 << z)) * 256.0;

  double _latToY(double lat, int z) {
    final clampedLat = lat.clamp(-85.0511, 85.0511);
    final sinLat = math.sin(clampedLat * math.pi / 180.0);
    return ((0.5 - math.log((1.0 + sinLat) / (1.0 - sinLat)) / (4.0 * math.pi)) * (1 << z)) * 256.0;
  }

  double _xToLon(double x, int z) {
    final worldWidth = (1 << z) * 256.0;
    return (x / worldWidth) * 360.0 - 180.0;
  }

  double _yToLat(double y, int z) {
    final worldHeight = (1 << z) * 256.0;
    final n = math.pi - 2.0 * math.pi * (y / worldHeight);
    final clampedN = n.clamp(-15.0, 15.0);
    final sinh = 0.5 * (math.exp(clampedN) - math.exp(-clampedN));
    return math.atan(sinh) * 180.0 / math.pi;
  }

  String _getTileUrl(int z, int x, int y) {
    final subdomains = ['a', 'b', 'c', 'd'];
    final s = subdomains[(x + y) % subdomains.length];
    switch (_tileStyle) {
      case MapTileStyle.voyager:
        return 'https://$s.basemaps.cartocdn.com/rastertiles/voyager/$z/$x/$y.png';
      case MapTileStyle.osm:
        return 'https://tile.openstreetmap.org/$z/$x/$y.png';
      case MapTileStyle.dark:
        return 'https://$s.basemaps.cartocdn.com/dark_all/$z/$x/$y.png';
    }
  }

  Future<void> _openGoogleMaps(EventModel event) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${event.latitude},${event.longitude}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Maps', 'Could not open Google Maps navigation.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasGoogleMapsKey = AppConstants.googleMapsApiKey != 'YOUR_GOOGLE_MAPS_API_KEY';

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.isFullscreen ? 0 : AppRadius.card),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          border: widget.isFullscreen ? null : Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            // Map Canvas
            if (_useGoogleMaps && hasGoogleMapsKey)
              _buildGoogleMapsView()
            else
              _buildCustomTileMapView(),

            // Top Status Bar / Fandom Radar Header
            Positioned(
              top: 10,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.borderSubtle),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.events.where((e) => e.hasLocation).length} Fandom Locations',
                          style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Style & Key controls
                  if (hasGoogleMapsKey)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        onTap: () => setState(() => _useGoogleMaps = !_useGoogleMaps),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            _useGoogleMaps ? 'Standard' : 'Google',
                            style: AppTypography.caption.copyWith(color: AppColors.primaryLight),
                          ),
                        ),
                      ),
                    ),
                  if (widget.allowFullscreenToggle && widget.onToggleFullscreen != null)
                    _circleIconBtn(
                      icon: widget.isFullscreen ? PhosphorIconsRegular.cornersIn : PhosphorIconsRegular.cornersOut,
                      tooltip: widget.isFullscreen ? 'Exit fullscreen' : 'Expand map',
                      onPressed: widget.onToggleFullscreen!,
                    ),
                ],
              ),
            ),

            // Floating Map Controls (Right Side)
            Positioned(
              right: 12,
              bottom: _selectedEvent != null ? 180 : 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _circleIconBtn(
                    icon: PhosphorIconsRegular.plus,
                    tooltip: 'Zoom in',
                    onPressed: () {
                      if (_zoom < 18.0) {
                        setState(() => _zoom = math.min(18.0, _zoom + 1.0));
                      }
                    },
                  ),
                  const SizedBox(height: 6),
                  _circleIconBtn(
                    icon: PhosphorIconsRegular.minus,
                    tooltip: 'Zoom out',
                    onPressed: () {
                      if (_zoom > 2.0) {
                        setState(() => _zoom = math.max(2.0, _zoom - 1.0));
                      }
                    },
                  ),
                  const SizedBox(height: 6),
                  _circleIconBtn(
                    icon: PhosphorIconsRegular.navigationArrow,
                    tooltip: 'My Location',
                    color: widget.userPosition != null ? AppColors.primaryLight : null,
                    isLoading: widget.isLocationLoading,
                    onPressed: () {
                      if (widget.userPosition != null) {
                        _animateTo(
                          widget.userPosition!.latitude,
                          widget.userPosition!.longitude,
                          math.max(_zoom, 12.0),
                        );
                      } else {
                        widget.onRequestLocation?.call();
                      }
                    },
                  ),
                  const SizedBox(height: 6),
                  _circleIconBtn(
                    icon: PhosphorIconsRegular.arrowsOutCardinal,
                    tooltip: 'Fit all events',
                    onPressed: _fitAllEvents,
                  ),
                  const SizedBox(height: 6),
                  _circleIconBtn(
                    icon: PhosphorIconsRegular.stack,
                    tooltip: 'Change map style',
                    onPressed: _toggleTileStyle,
                  ),
                ],
              ),
            ),

            // Selected Event Card Pop-up (Bottom Overlay)
            if (_selectedEvent != null)
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: _buildEventCard(_selectedEvent!),
              ),
          ],
        ),
      ),
    );
  }

  void _toggleTileStyle() {
    setState(() {
      switch (_tileStyle) {
        case MapTileStyle.dark:
          _tileStyle = MapTileStyle.voyager;
          break;
        case MapTileStyle.voyager:
          _tileStyle = MapTileStyle.osm;
          break;
        case MapTileStyle.osm:
          _tileStyle = MapTileStyle.dark;
          break;
      }
    });
  }

  Widget _buildCustomTileMapView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewW = constraints.maxWidth;
        final viewH = constraints.maxHeight;
        final intZ = _zoom.floor().clamp(2, 18);

        final centerX = _lonToX(_centerLon, intZ);
        final centerY = _latToY(_centerLat, intZ);

        final minTileX = ((centerX - viewW / 2) / 256.0).floor();
        final maxTileX = ((centerX + viewW / 2) / 256.0).floor();
        final minTileY = ((centerY - viewH / 2) / 256.0).floor();
        final maxTileY = ((centerY + viewH / 2) / 256.0).floor();

        final maxTilesOnZ = 1 << intZ;

        return GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              final newCenterX = centerX - details.delta.dx;
              final newCenterY = centerY - details.delta.dy;
              _centerLon = _xToLon(newCenterX, intZ);
              _centerLat = _yToLat(newCenterY, intZ);
            });
          },
          onDoubleTap: () {
            setState(() {
              _zoom = math.min(18.0, _zoom + 1.0);
            });
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Grid background
              Container(color: _tileStyle == MapTileStyle.dark ? const Color(0xFF0F0E1A) : const Color(0xFFE5E9EC)),

              // Tile Layer
              for (int ty = minTileY; ty <= maxTileY; ty++)
                if (ty >= 0 && ty < maxTilesOnZ)
                  for (int tx = minTileX; tx <= maxTileX; tx++) ...[
                    Builder(builder: (context) {
                      final wrappedX = (tx % maxTilesOnZ + maxTilesOnZ) % maxTilesOnZ;
                      final left = viewW / 2 + (tx * 256.0 - centerX);
                      final top = viewH / 2 + (ty * 256.0 - centerY);
                      final tileUrl = _getTileUrl(intZ, wrappedX, ty);

                      return Positioned(
                        left: left,
                        top: top,
                        width: 256,
                        height: 256,
                        child: Image.network(
                          tileUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white10),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],

              // User Position Indicator (GPS Pulsing Beacon)
              if (widget.userPosition != null)
                Builder(builder: (context) {
                  final userX = _lonToX(widget.userPosition!.longitude, intZ);
                  final userY = _latToY(widget.userPosition!.latitude, intZ);
                  final posX = viewW / 2 + (userX - centerX);
                  final posY = viewH / 2 + (userY - centerY);

                  return Positioned(
                    left: posX - 18,
                    top: posY - 18,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withValues(alpha: 0.28),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.6),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),

              // Event Markers Layer
              for (final event in widget.events.where((e) => e.hasLocation))
                Builder(builder: (context) {
                  final evX = _lonToX(event.longitude!, intZ);
                  final evY = _latToY(event.latitude!, intZ);
                  final posX = viewW / 2 + (evX - centerX);
                  final posY = viewH / 2 + (evY - centerY);

                  final isSelected = _selectedEvent?.id == event.id;

                  // Skip drawing off-screen markers far outside viewport
                  if (posX < -60 || posX > viewW + 60 || posY < -60 || posY > viewH + 60) {
                    return const SizedBox.shrink();
                  }

                  return Positioned(
                    left: posX - 20,
                    top: posY - 38,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedEvent = event);
                        widget.onEventSelected?.call(event);
                        _animateTo(event.latitude!, event.longitude!);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Marker Body
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: EdgeInsets.all(isSelected ? 7 : 5),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.accent : AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: isSelected ? 2.5 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (isSelected ? AppColors.accent : AppColors.primary).withValues(alpha: 0.5),
                                  blurRadius: isSelected ? 12 : 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: FVIcon(
                              _getCategoryIcon(event.category),
                              color: Colors.white,
                              size: isSelected ? 20 : 16,
                            ),
                          ),
                          // Pin tip
                          CustomPaint(
                            size: const Size(10, 6),
                            painter: _TrianglePainter(
                              color: isSelected ? AppColors.accent : AppColors.primary,
                            ),
                          ),
                          // Event Name Tag when zoomed in or selected
                          if (isSelected || _zoom >= 9.0)
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isSelected ? AppColors.accent : AppColors.borderSubtle,
                                ),
                              ),
                              child: Text(
                                event.city,
                                style: AppTypography.caption.copyWith(
                                  fontSize: 10,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? AppColors.accent : AppColors.textPrimary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGoogleMapsView() {
    final markers = widget.events.where((e) => e.hasLocation).map((e) {
      return gmaps.Marker(
        markerId: gmaps.MarkerId(e.id),
        position: gmaps.LatLng(e.latitude!, e.longitude!),
        infoWindow: gmaps.InfoWindow(title: e.title, snippet: e.city),
        onTap: () {
          setState(() => _selectedEvent = e);
          widget.onEventSelected?.call(e);
        },
      );
    }).toSet();

    final center = widget.userPosition != null
        ? gmaps.LatLng(widget.userPosition!.latitude, widget.userPosition!.longitude)
        : gmaps.LatLng(_centerLat, _centerLon);

    return gmaps.GoogleMap(
      initialCameraPosition: gmaps.CameraPosition(target: center, zoom: _zoom),
      markers: markers,
      myLocationEnabled: widget.userPosition != null,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
    );
  }

  Widget _buildEventCard(EventModel event) {
    double? distKm;
    if (widget.userPosition != null && event.hasLocation) {
      final meters = Geolocator.distanceBetween(
        widget.userPosition!.latitude,
        widget.userPosition!.longitude,
        event.latitude!,
        event.longitude!,
      );
      distKm = meters / 1000.0;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FVImage(
                imageUrl: event.imageUrl ?? AppConstants.placeholderEvent,
                width: 64,
                height: 64,
                borderRadius: AppRadius.sm,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: AppTypography.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${event.venue}, ${event.city}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          DateFormat('MMM dd, yyyy').format(event.eventDate),
                          style: AppTypography.caption.copyWith(color: AppColors.accent),
                        ),
                        if (distKm != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '•  ${distKm.toStringAsFixed(1)} km away',
                            style: AppTypography.caption.copyWith(color: AppColors.primaryLight),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const FVIcon(PhosphorIconsRegular.x, size: 18),
                onPressed: () => setState(() => _selectedEvent = null),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    side: BorderSide(color: AppColors.primary),
                  ),
                  icon: const FVIcon(PhosphorIconsRegular.navigationArrow, size: 16),
                  label: const Text('Directions'),
                  onPressed: () => _openGoogleMaps(event),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  icon: const FVIcon(PhosphorIconsRegular.arrowRight, size: 16),
                  label: const Text('View Event'),
                  onPressed: () => Get.toNamed(AppRoutes.eventDetail.replaceFirst(':id', event.id)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIconBtn({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    Color? color,
    bool isLoading = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 6,
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : IconButton(
                padding: EdgeInsets.zero,
                icon: FVIcon(icon, size: 18, color: color ?? AppColors.textPrimary),
                onPressed: onPressed,
              ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('convention') || lower.contains('comic-con')) {
      return PhosphorIconsRegular.maskHappy;
    } else if (lower.contains('meetup') || lower.contains('fan')) {
      return PhosphorIconsRegular.usersThree;
    } else if (lower.contains('screening') || lower.contains('movie')) {
      return PhosphorIconsRegular.filmStrip;
    } else if (lower.contains('tournament') || lower.contains('game')) {
      return PhosphorIconsRegular.gameController;
    } else if (lower.contains('exhibition')) {
      return PhosphorIconsRegular.palette;
    }
    return PhosphorIconsRegular.mapPin;
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) => oldDelegate.color != color;
}
