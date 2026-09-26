import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/fv_icon.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../../../data/models/content_model.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/product_model.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminModerationView extends StatefulWidget {
  const AdminModerationView({super.key});

  @override
  State<AdminModerationView> createState() => _AdminModerationViewState();
}

class _AdminModerationViewState extends State<AdminModerationView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AdminDashboardController controller = Get.isRegistered<AdminDashboardController>()
      ? Get.find<AdminDashboardController>()
      : Get.put(AdminDashboardController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: controller.moderationTabIndex.value.clamp(0, 2),
    );
    _tabController.addListener(() {
      controller.moderationTabIndex.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Content & Events Moderation'),
        leading: IconButton(
          icon: const FVIcon(PhosphorIconsRegular.caretLeft),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Get.offNamed(AppRoutes.adminDashboard);
            }
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTypography.headingSmall,
          tabs: const [
            Tab(text: 'Content (Posts)'),
            Tab(text: 'Events'),
            Tab(text: 'Merchandise'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PostsTab(controller: controller),
          _EventsTab(controller: controller),
          _MerchandiseTab(controller: controller),
        ],
      ),
    );
  }
}

// Posts management tab
class _PostsTab extends StatelessWidget {
  final AdminDashboardController controller;
  const _PostsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final posts = controller.posts;
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${posts.length} Total Posts', style: AppTypography.headingSmall),
                FVButton(
                  text: 'Add New Post',
                  icon: const FVIcon(PhosphorIconsBold.plus, color: Colors.white, size: 16),
                  onPressed: () => _openPostForm(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: posts.isEmpty
                ? const Center(child: Text('No posts available.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final post = posts[i];
                      final dateFormatted = DateFormat('MMM d, yyyy').format(post.createdAt);

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 72,
                                height: 72,
                                color: AppColors.surface,
                                child: post.imageUrl != null && post.imageUrl!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: post.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) => const FVIcon(PhosphorIconsRegular.image, size: 28),
                                      )
                                    : const FVIcon(PhosphorIconsRegular.article, size: 28),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.headingSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.rose.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          post.fandomName ?? 'Anime',
                                          style: TextStyle(
                                            color: AppColors.rose,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        dateFormatted,
                                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Edit & Delete Icons
                            IconButton(
                              icon: FVIcon(PhosphorIconsRegular.pencilSimple, size: 18, color: AppColors.primary),
                              tooltip: 'Edit Post',
                              onPressed: () => _openPostForm(context, existing: post),
                            ),
                            IconButton(
                              icon: FVIcon(PhosphorIconsRegular.trash, size: 18, color: AppColors.error),
                              tooltip: 'Delete Post',
                              onPressed: () => _confirmDelete(
                                context,
                                title: 'Delete Post',
                                message: 'Are you sure you want to delete "${post.title}"?',
                                onConfirm: () => controller.deletePost(post.id),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  void _openPostForm(BuildContext context, {ContentModel? existing}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final catCtrl = TextEditingController(text: existing?.fandomName ?? 'Anime');
    final bodyCtrl = TextEditingController(text: existing?.body ?? '');
    final imgCtrl = TextEditingController(text: existing?.imageUrl ?? '');

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                existing == null ? 'Add New Post' : 'Edit Post',
                style: AppTypography.headingMedium,
              ),
              const SizedBox(height: 16),
              FVTextField(label: 'Post Title', controller: titleCtrl),
              const SizedBox(height: 12),
              FVTextField(label: 'Fandom Category (e.g. Anime, Gaming)', controller: catCtrl),
              const SizedBox(height: 12),
              FVTextField(label: 'Content Body', controller: bodyCtrl, maxLines: 4),
              const SizedBox(height: 12),
              FVTextField(label: 'Image URL / Upload link', controller: imgCtrl),
              const SizedBox(height: 20),
              FVButton(
                text: existing == null ? 'Publish Post' : 'Update Post',
                onPressed: () {
                  if (titleCtrl.text.trim().isEmpty || bodyCtrl.text.trim().isEmpty) {
                    Get.snackbar('Required Fields', 'Please enter a title and content body.');
                    return;
                  }
                  if (existing == null) {
                    controller.addPost(
                      title: titleCtrl.text,
                      fandomCategory: catCtrl.text,
                      body: bodyCtrl.text,
                      imageUrl: imgCtrl.text,
                    );
                  } else {
                    controller.editPost(
                      id: existing.id,
                      title: titleCtrl.text,
                      fandomCategory: catCtrl.text,
                      body: bodyCtrl.text,
                      imageUrl: imgCtrl.text,
                    );
                  }
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

// Events management tab
class _EventsTab extends StatelessWidget {
  final AdminDashboardController controller;
  const _EventsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final events = controller.events;
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${events.length} Upcoming Events', style: AppTypography.headingSmall),
                FVButton(
                  text: 'Add New Event',
                  icon: const FVIcon(PhosphorIconsBold.plus, color: Colors.white, size: 16),
                  onPressed: () => _openEventForm(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: events.isEmpty
                ? const Center(child: Text('No events available.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final event = events[i];
                      final dateFormatted = DateFormat('EEE, MMM d, yyyy').format(event.eventDate);

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.cyan.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: FVIcon(PhosphorIconsRegular.calendarBlank, color: AppColors.cyan, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.headingSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      FVIcon(PhosphorIconsRegular.mapPin, size: 14, color: AppColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(event.city, style: AppTypography.bodySmall),
                                      const SizedBox(width: 12),
                                      FVIcon(PhosphorIconsRegular.clock, size: 14, color: AppColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          dateFormatted,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: FVIcon(PhosphorIconsRegular.pencilSimple, size: 18, color: AppColors.primary),
                              tooltip: 'Edit Event',
                              onPressed: () => _openEventForm(context, existing: event),
                            ),
                            IconButton(
                              icon: FVIcon(PhosphorIconsRegular.trash, size: 18, color: AppColors.error),
                              tooltip: 'Delete Event',
                              onPressed: () => _confirmDelete(
                                context,
                                title: 'Delete Event',
                                message: 'Are you sure you want to delete "${event.title}"?',
                                onConfirm: () => controller.deleteEvent(event.id),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  void _openEventForm(BuildContext context, {EventModel? existing}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final cityCtrl = TextEditingController(text: existing?.city ?? '');
    final linkCtrl = TextEditingController(text: existing?.ticketLink ?? '');
    DateTime selectedDate = existing?.eventDate ?? DateTime.now().add(const Duration(days: 14));

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                existing == null ? 'Add New Event' : 'Edit Event',
                style: AppTypography.headingMedium,
              ),
              const SizedBox(height: 16),
              FVTextField(label: 'Event Title', controller: titleCtrl),
              const SizedBox(height: 12),
              FVTextField(label: 'City (e.g. Tokyo, San Diego)', controller: cityCtrl),
              const SizedBox(height: 12),
              FVTextField(label: 'Ticket Link / Registration URL', controller: linkCtrl),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Event Date'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                trailing: const FVIcon(PhosphorIconsRegular.calendar),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                  }
                },
              ),
              const SizedBox(height: 20),
              FVButton(
                text: existing == null ? 'Create Event' : 'Save Changes',
                onPressed: () {
                  if (titleCtrl.text.trim().isEmpty || cityCtrl.text.trim().isEmpty) {
                    Get.snackbar('Required Fields', 'Please enter event title and city.');
                    return;
                  }
                  if (existing == null) {
                    controller.addEvent(
                      title: titleCtrl.text,
                      city: cityCtrl.text,
                      date: selectedDate,
                      ticketLink: linkCtrl.text,
                    );
                  } else {
                    controller.editEvent(
                      id: existing.id,
                      title: titleCtrl.text,
                      city: cityCtrl.text,
                      date: selectedDate,
                      ticketLink: linkCtrl.text,
                    );
                  }
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

// Merchandise catalog moderation tab
class _MerchandiseTab extends StatelessWidget {
  final AdminDashboardController controller;
  const _MerchandiseTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final products = controller.products;
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${products.length} Products', style: AppTypography.headingSmall),
                FVButton(
                  text: 'Add New Product',
                  icon: const FVIcon(PhosphorIconsBold.plus, color: Colors.white, size: 16),
                  onPressed: () => _openProductForm(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('No merchandise items.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final product = products[i];

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 64,
                                height: 64,
                                color: AppColors.surface,
                                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: product.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) => const FVIcon(PhosphorIconsRegular.package, size: 28),
                                      )
                                    : const FVIcon(PhosphorIconsRegular.package, size: 28),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.headingSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: AppColors.accent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '• ${product.categoryName ?? 'Apparel'}',
                                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: FVIcon(PhosphorIconsRegular.pencilSimple, size: 18, color: AppColors.primary),
                              tooltip: 'Edit Product',
                              onPressed: () => _openProductForm(context, existing: product),
                            ),
                            IconButton(
                              icon: FVIcon(PhosphorIconsRegular.trash, size: 18, color: AppColors.error),
                              tooltip: 'Delete Product',
                              onPressed: () => _confirmDelete(
                                context,
                                title: 'Delete Product',
                                message: 'Are you sure you want to delete "${product.name}"?',
                                onConfirm: () => controller.deleteProduct(product.id),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  void _openProductForm(BuildContext context, {ProductModel? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final priceCtrl = TextEditingController(text: existing != null ? existing.price.toStringAsFixed(2) : '');
    final catCtrl = TextEditingController(text: existing?.categoryName ?? 'Collectibles');
    final imgCtrl = TextEditingController(text: existing?.imageUrl ?? '');

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                existing == null ? 'Add New Product' : 'Edit Product',
                style: AppTypography.headingMedium,
              ),
              const SizedBox(height: 16),
              FVTextField(label: 'Product Name', controller: nameCtrl),
              const SizedBox(height: 12),
              FVTextField(
                label: 'Price (\$USD)',
                controller: priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              FVTextField(label: 'Category (Apparel, Figures, etc.)', controller: catCtrl),
              const SizedBox(height: 12),
              FVTextField(label: 'Image URL', controller: imgCtrl),
              const SizedBox(height: 20),
              FVButton(
                text: existing == null ? 'Add Product' : 'Save Changes',
                onPressed: () {
                  final price = double.tryParse(priceCtrl.text) ?? 19.99;
                  if (nameCtrl.text.trim().isEmpty) {
                    Get.snackbar('Required Fields', 'Please enter a product name.');
                    return;
                  }
                  if (existing == null) {
                    controller.addProduct(
                      name: nameCtrl.text,
                      price: price,
                      category: catCtrl.text,
                      imageUrl: imgCtrl.text,
                    );
                  } else {
                    controller.editProduct(
                      id: existing.id,
                      name: nameCtrl.text,
                      price: price,
                      category: catCtrl.text,
                      imageUrl: imgCtrl.text,
                    );
                  }
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

void _confirmDelete(
  BuildContext context, {
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) {
  Get.defaultDialog(
    title: title,
    titleStyle: AppTypography.headingMedium,
    middleText: message,
    middleTextStyle: AppTypography.bodyMedium,
    textConfirm: 'Delete',
    textCancel: 'Cancel',
    confirmTextColor: Colors.white,
    buttonColor: AppColors.error,
    onConfirm: () {
      Get.back();
      onConfirm();
    },
  );
}
