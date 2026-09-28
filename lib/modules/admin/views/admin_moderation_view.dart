import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/models/content_model.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/product_model.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../theme/admin_theme.dart';

class AdminModerationView extends StatefulWidget {
  const AdminModerationView({super.key});

  @override
  State<AdminModerationView> createState() => _AdminModerationViewState();
}

class _AdminModerationViewState extends State<AdminModerationView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AdminDashboardController controller =
      Get.isRegistered<AdminDashboardController>()
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
    _tabController.addListener(
      () => controller.moderationTabIndex.value = _tabController.index,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HoloScaffold(
      title: 'MODERATION',
      leading: IconButton(
        icon: Icon(
          PhosphorIconsRegular.caretLeft,
          color: AdminTheme.textPrimary,
        ),
        onPressed: () => Navigator.of(context).canPop()
            ? Navigator.of(context).pop()
            : Get.offNamed(AppRoutes.adminDashboard),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(18, 4, 18, 8),
            decoration: BoxDecoration(
              color: AdminTheme.bgPanelRaised,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: AdminTheme.holoBorder,
              ),
              labelColor: AdminTheme.bgDeep,
              unselectedLabelColor: AdminTheme.textSecondary,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Posts'),
                Tab(text: 'Events'),
                Tab(text: 'Merch'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _PostsTab(controller: controller),
                _EventsTab(controller: controller),
                _MerchTab(controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabHeader extends StatelessWidget {
  final String label;
  final VoidCallback onAdd;
  final String addLabel;
  const _TabHeader({
    required this.label,
    required this.onAdd,
    required this.addLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AdminTheme.mono(
              size: 12,
              color: AdminTheme.textFaint,
              w: FontWeight.w700,
            ),
          ),
          HoloIconAction(
            icon: PhosphorIconsBold.plus,
            color: AdminTheme.cyan,
            tooltip: addLabel,
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}

// ── Posts ─────────────────────────────────────────────────────────────────
class _PostsTab extends StatelessWidget {
  final AdminDashboardController controller;
  const _PostsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final posts = controller.posts;
      return Column(
        children: [
          _TabHeader(
            label: '${posts.length} TOTAL POSTS',
            addLabel: 'Add Post',
            onAdd: () => _openPostForm(context),
          ),
          Expanded(
            child: posts.isEmpty
                ? Center(child: Text('No posts yet.', style: AdminTheme.mono()))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final post = posts[i];
                      final date = DateFormat('MMM d, yyyy')
                          .format(post.createdAt);
                      return HoloPanel(
                        glowColor: AdminTheme.violet,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 60,
                                height: 60,
                                color: AdminTheme.bgPanelRaised,
                                child:
                                    post.imageUrl != null &&
                                        post.imageUrl!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: post.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) => Icon(
                                          PhosphorIconsRegular.image,
                                          color: AdminTheme.textFaint,
                                        ),
                                      )
                                    : Icon(
                                        PhosphorIconsRegular.article,
                                        color: AdminTheme.textFaint,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AdminTheme.body(w: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      HoloBadge(
                                        text: post.fandomName ?? 'General',
                                        color: AdminTheme.violet,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        date,
                                        style: AdminTheme.mono(size: 10.5),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                HoloIconAction(
                                  icon: PhosphorIconsRegular.pencilSimple,
                                  color: AdminTheme.amber,
                                  tooltip: 'Edit',
                                  onPressed: () =>
                                      _openPostForm(context, existing: post),
                                ),
                                const SizedBox(height: 6),
                                HoloIconAction(
                                  icon: PhosphorIconsRegular.trash,
                                  color: AdminTheme.red,
                                  tooltip: 'Delete',
                                  onPressed: () => showHoloConfirm(
                                    title: 'Delete Post',
                                    message: 'Delete "${post.title}"?',
                                    confirmLabel: 'Delete',
                                    onConfirm: () =>
                                        controller.deletePost(post.id),
                                  ),
                                ),
                              ],
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
    final catCtrl = TextEditingController(
      text: existing?.fandomName ?? 'Anime',
    );
    final bodyCtrl = TextEditingController(text: existing?.body ?? '');
    final imgCtrl = TextEditingController(text: existing?.imageUrl ?? '');

    showHoloSheet(
      context: context,
      title: existing == null ? 'Add New Post' : 'Edit Post',
      children: [
        HoloTextField(label: 'Post Title', controller: titleCtrl),
        const SizedBox(height: 12),
        HoloTextField(label: 'Fandom Category', controller: catCtrl),
        const SizedBox(height: 12),
        HoloTextField(label: 'Content Body', controller: bodyCtrl, maxLines: 4),
        const SizedBox(height: 12),
        HoloTextField(label: 'Image URL', controller: imgCtrl),
        const SizedBox(height: 20),
        HoloButton(
          label: existing == null ? 'Publish Post' : 'Update Post',
          icon: PhosphorIconsBold.checkCircle,
          onPressed: () {
            if (titleCtrl.text.trim().isEmpty || bodyCtrl.text.trim().isEmpty) {
              Get.snackbar(
                'Required Fields',
                'Enter a title and content body.',
              );
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
    );
  }
}

// ── Events ────────────────────────────────────────────────────────────────
class _EventsTab extends StatelessWidget {
  final AdminDashboardController controller;
  const _EventsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final events = controller.events;
      return Column(
        children: [
          _TabHeader(
            label: '${events.length} UPCOMING EVENTS',
            addLabel: 'Add Event',
            onAdd: () => _openEventForm(context),
          ),
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Text('No events yet.', style: AdminTheme.mono()),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final event = events[i];
                      final date = DateFormat('EEE, MMM d, yyyy')
                          .format(event.eventDate);
                      return HoloPanel(
                        glowColor: AdminTheme.magenta,
                        child: Row(
                          children: [
                            HoloIconBox(
                              icon: PhosphorIconsRegular.calendarBlank,
                              color: AdminTheme.magenta,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AdminTheme.body(w: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${event.city} · $date',
                                    style: AdminTheme.mono(size: 11),
                                  ),
                                ],
                              ),
                            ),
                            HoloIconAction(
                              icon: PhosphorIconsRegular.pencilSimple,
                              color: AdminTheme.amber,
                              tooltip: 'Edit',
                              onPressed: () =>
                                  _openEventForm(context, existing: event),
                            ),
                            const SizedBox(width: 6),
                            HoloIconAction(
                              icon: PhosphorIconsRegular.trash,
                              color: AdminTheme.red,
                              tooltip: 'Delete',
                              onPressed: () => showHoloConfirm(
                                title: 'Delete Event',
                                message: 'Delete "${event.title}"?',
                                confirmLabel: 'Delete',
                                onConfirm: () =>
                                    controller.deleteEvent(event.id),
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
    DateTime selectedDate =
        existing?.eventDate ?? DateTime.now().add(const Duration(days: 14));

    showHoloSheet(
      context: context,
      title: existing == null ? 'Add New Event' : 'Edit Event',
      children: [
        HoloTextField(label: 'Event Title', controller: titleCtrl),
        const SizedBox(height: 12),
        HoloTextField(label: 'City', controller: cityCtrl),
        const SizedBox(height: 12),
        HoloTextField(label: 'Ticket Link', controller: linkCtrl),
        const SizedBox(height: 12),
        StatefulBuilder(
          builder: (context, setSheetState) => HoloPanel(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Event Date', style: AdminTheme.body(size: 13)),
              subtitle: Text(
                DateFormat('yyyy-MM-dd').format(selectedDate),
                style: AdminTheme.mono(size: 12, color: AdminTheme.cyan),
              ),
              trailing: Icon(
                PhosphorIconsRegular.calendar,
                color: AdminTheme.cyan,
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now().add(const Duration(days: 730)),
                );
                if (picked != null) setSheetState(() => selectedDate = picked);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        HoloButton(
          label: existing == null ? 'Create Event' : 'Save Changes',
          icon: PhosphorIconsBold.checkCircle,
          onPressed: () {
            if (titleCtrl.text.trim().isEmpty || cityCtrl.text.trim().isEmpty) {
              Get.snackbar('Required Fields', 'Enter event title and city.');
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
    );
  }
}

// ── Merchandise ───────────────────────────────────────────────────────────
class _MerchTab extends StatelessWidget {
  final AdminDashboardController controller;
  const _MerchTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final products = controller.products;
      return Column(
        children: [
          _TabHeader(
            label: '${products.length} PRODUCTS',
            addLabel: 'Add Product',
            onAdd: () => _openProductForm(context),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Text(
                      'No merchandise yet.',
                      style: AdminTheme.mono(),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final product = products[i];
                      return HoloPanel(
                        glowColor: AdminTheme.amber,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 54,
                                height: 54,
                                color: AdminTheme.bgPanelRaised,
                                child:
                                    product.imageUrl != null &&
                                        product.imageUrl!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: product.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) => Icon(
                                          PhosphorIconsRegular.package,
                                          color: AdminTheme.textFaint,
                                        ),
                                      )
                                    : Icon(
                                        PhosphorIconsRegular.package,
                                        color: AdminTheme.textFaint,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AdminTheme.body(w: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: AdminTheme.mono(
                                          size: 12,
                                          color: AdminTheme.amber,
                                          w: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        product.categoryName ?? 'General',
                                        style: AdminTheme.mono(size: 11),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            HoloIconAction(
                              icon: PhosphorIconsRegular.pencilSimple,
                              color: AdminTheme.amber,
                              tooltip: 'Edit',
                              onPressed: () =>
                                  _openProductForm(context, existing: product),
                            ),
                            const SizedBox(width: 6),
                            HoloIconAction(
                              icon: PhosphorIconsRegular.trash,
                              color: AdminTheme.red,
                              tooltip: 'Delete',
                              onPressed: () => showHoloConfirm(
                                title: 'Delete Product',
                                message: 'Delete "${product.name}"?',
                                confirmLabel: 'Delete',
                                onConfirm: () =>
                                    controller.deleteProduct(product.id),
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
    final priceCtrl = TextEditingController(
      text: existing != null ? existing.price.toStringAsFixed(2) : '',
    );
    final catCtrl = TextEditingController(
      text: existing?.categoryName ?? 'Collectibles',
    );
    final imgCtrl = TextEditingController(text: existing?.imageUrl ?? '');

    showHoloSheet(
      context: context,
      title: existing == null ? 'Add New Product' : 'Edit Product',
      children: [
        HoloTextField(label: 'Product Name', controller: nameCtrl),
        const SizedBox(height: 12),
        HoloTextField(
          label: 'Price (USD)',
          controller: priceCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 12),
        HoloTextField(label: 'Category', controller: catCtrl),
        const SizedBox(height: 12),
        HoloTextField(label: 'Image URL', controller: imgCtrl),
        const SizedBox(height: 20),
        HoloButton(
          label: existing == null ? 'Add Product' : 'Save Changes',
          icon: PhosphorIconsBold.checkCircle,
          onPressed: () {
            final price = double.tryParse(priceCtrl.text) ?? 19.99;
            if (nameCtrl.text.trim().isEmpty) {
              Get.snackbar('Required', 'Enter a product name.');
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
    );
  }
}
