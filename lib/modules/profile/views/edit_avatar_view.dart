import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../core/widgets/fv_icon.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../data/services/auth_service.dart';

class AvatarItem {
  final String id;
  final String url;
  final String name;
  final String gender; // 'boy' | 'girl'
  final String category; // 'Anime', 'Gaming', 'Cyberpunk', 'Idol'

  const AvatarItem({
    required this.id,
    required this.url,
    required this.name,
    required this.gender,
    required this.category,
  });
}

class EditAvatarController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final LocalStorageService _storageService = Get.find<LocalStorageService>();

  final RxString selectedAvatarUrl = ''.obs;
  final RxString selectedFilter = 'All'.obs;
  final RxBool isPicking = false.obs;

  final List<String> filterOptions = const [
    'All',
    'Boys',
    'Girls',
    'Anime',
    'Gaming',
    'Cyberpunk',
  ];

  // 3D / Illustrated Character Avatars (Boys & Girls Mix)
  final List<AvatarItem> presetAvatars = const [
    // ── BOYS ──
    AvatarItem(
      id: 'b1',
      name: 'Gamer Boy (Shadow)',
      gender: 'boy',
      category: 'Gaming',
      url: 'https://api.dicebear.com/7.x/adventurer/png?seed=Shadow&backgroundColor=b6e3f4,c0aede,d1d4f9',
    ),
    AvatarItem(
      id: 'b2',
      name: 'Cyber Shinobi',
      gender: 'boy',
      category: 'Cyberpunk',
      url: 'https://api.dicebear.com/7.x/adventurer/png?seed=Felix&backgroundColor=c0aede,d1d4f9',
    ),
    AvatarItem(
      id: 'b3',
      name: 'Anime Swordsman',
      gender: 'boy',
      category: 'Anime',
      url: 'https://api.dicebear.com/7.x/adventurer/png?seed=Alex&backgroundColor=ffd5dc,d1d4f9',
    ),
    AvatarItem(
      id: 'b4',
      name: 'Cap Gamer Boy',
      gender: 'boy',
      category: 'Gaming',
      url: 'https://api.dicebear.com/7.x/avataaars/png?seed=Jack&backgroundColor=b6e3f4,ffd5dc',
    ),
    AvatarItem(
      id: 'b5',
      name: 'Mecha Ronin',
      gender: 'boy',
      category: 'Cyberpunk',
      url: 'https://api.dicebear.com/7.x/bottts/png?seed=CyberKnight&backgroundColor=b6e3f4,c0aede',
    ),
    AvatarItem(
      id: 'b6',
      name: 'Hoodie Gamer',
      gender: 'boy',
      category: 'Gaming',
      url: 'https://api.dicebear.com/7.x/adventurer/png?seed=Lucas&backgroundColor=ffd5dc,ffdfbf',
    ),
    AvatarItem(
      id: 'b7',
      name: 'Neon Samurai',
      gender: 'boy',
      category: 'Anime',
      url: 'https://api.dicebear.com/7.x/adventurer/png?seed=Ryan&backgroundColor=d1d4f9,c0aede',
    ),
    AvatarItem(
      id: 'b8',
      name: 'Astro Pilot',
      gender: 'boy',
      category: 'Gaming',
      url: 'https://api.dicebear.com/7.x/bottts/png?seed=AstroBoy&backgroundColor=c0aede,b6e3f4',
    ),
    AvatarItem(
      id: 'b9',
      name: 'Dragon Knight',
      gender: 'boy',
      category: 'Anime',
      url: 'https://api.dicebear.com/7.x/adventurer/png?seed=Oliver&backgroundColor=ffd5dc,d1d4f9',
    ),

    // ── GIRLS ──
    AvatarItem(
      id: 'g1',
      name: 'Cyber Gamer Girl',
      gender: 'girl',
      category: 'Gaming',
      url: 'https://api.dicebear.com/7.x/adventurer/png?seed=Zoe&backgroundColor=ffd5dc,ffdfbf',
    ),
    AvatarItem(
      id: 'g2',
      name: 'Sakura Anime Girl',
      gender: 'girl',
      category: 'Anime',
      url: 'https://api.dicebear.com/7.x/lorelei/png?seed=Sakura&backgroundColor=ffd5dc,c0aede',
    ),
    AvatarItem(
      id: 'g3',
      name: 'Neon Mage Girl',
      gender: 'girl',
      category: 'Gaming',
      url: 'https://api.dicebear.com/7.x/adventurer/png?seed=Luna&backgroundColor=b6e3f4,d1d4f9',
    ),
    AvatarItem(
      id: 'g4',
      name: 'K-Pop Idol Girl',
      gender: 'girl',
      category: 'Anime',
      url: 'https://api.dicebear.com/7.x/lorelei/png?seed=Misty&backgroundColor=ffd5dc,ffdfbf',
    ),
    AvatarItem(
      id: 'g5',
      name: 'Star Valkyrie',
      gender: 'girl',
      category: 'Cyberpunk',
      url: 'https://api.dicebear.com/7.x/adventurer/png?seed=Aria&backgroundColor=c0aede,d1d4f9',
    ),
    AvatarItem(
      id: 'g6',
      name: 'Cyber Hacker Girl',
      gender: 'girl',
      category: 'Cyberpunk',
      url: 'https://api.dicebear.com/7.x/bottts/png?seed=Nova&backgroundColor=ffd5dc,b6e3f4',
    ),
    AvatarItem(
      id: 'g7',
      name: 'Kawaii Gamer Girl',
      gender: 'girl',
      category: 'Gaming',
      url: 'https://api.dicebear.com/7.x/avataaars/png?seed=Chloe&backgroundColor=ffd5dc,c0aede',
    ),
    AvatarItem(
      id: 'g8',
      name: 'Shinobi Princess',
      gender: 'girl',
      category: 'Anime',
      url: 'https://api.dicebear.com/7.x/lorelei/png?seed=Hana&backgroundColor=d1d4f9,ffd5dc',
    ),
    AvatarItem(
      id: 'g9',
      name: 'Arcane Sorceress',
      gender: 'girl',
      category: 'Anime',
      url: 'https://api.dicebear.com/7.x/adventurer/png?seed=Maya&backgroundColor=b6e3f4,ffd5dc',
    ),
    AvatarItem(
      id: 'g10',
      name: 'Matrix Netrunner',
      gender: 'girl',
      category: 'Cyberpunk',
      url: 'https://api.dicebear.com/7.x/adventurer/png?seed=Sophia&backgroundColor=c0aede,ffdfbf',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    final user = _authService.currentUser.value;
    if (user != null && user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      selectedAvatarUrl.value = user.avatarUrl!;
    } else {
      selectedAvatarUrl.value = presetAvatars.first.url;
    }
  }

  List<AvatarItem> get filteredAvatars {
    final filter = selectedFilter.value;
    if (filter == 'All') return presetAvatars;
    if (filter == 'Boys') return presetAvatars.where((a) => a.gender == 'boy').toList();
    if (filter == 'Girls') return presetAvatars.where((a) => a.gender == 'girl').toList();
    return presetAvatars.where((a) => a.category.toLowerCase() == filter.toLowerCase()).toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void selectAvatar(String url) {
    selectedAvatarUrl.value = url;
  }

  Future<void> pickImage(ImageSource source) async {
    isPicking.value = true;
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );
      if (picked == null) return;

      try {
        final cropped = await ImageCropper().cropImage(
          sourcePath: picked.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(toolbarTitle: 'Crop Avatar', lockAspectRatio: true),
            IOSUiSettings(title: 'Crop Avatar', aspectRatioLockEnabled: true),
          ],
        );
        if (cropped != null) {
          final bytes = await XFile(cropped.path).readAsBytes();
          selectedAvatarUrl.value = 'data:image/jpeg;base64,${base64Encode(bytes)}';
          return;
        }
      } catch (_) {
        final bytes = await picked.readAsBytes();
        selectedAvatarUrl.value = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        return;
      }

      final bytes = await picked.readAsBytes();
      selectedAvatarUrl.value = 'data:image/jpeg;base64,${base64Encode(bytes)}';
    } catch (_) {
      Get.snackbar('Avatar', 'Could not load the selected image. Please try again.');
    } finally {
      isPicking.value = false;
    }
  }

  Future<void> saveAvatar() async {
    final user = _authService.currentUser.value;
    if (user == null || selectedAvatarUrl.value.isEmpty) return;

    final updatedUser = user.copyWith(avatarUrl: selectedAvatarUrl.value);
    await _storageService.saveUser(updatedUser);
    _authService.currentUser.value = updatedUser;

    Get.back();
    Get.rawSnackbar(
      title: 'Avatar Updated',
      message: 'Your profile picture has been updated successfully.',
      icon: const FVIcon(PhosphorIconsFill.checkCircle, color: Colors.green),
      backgroundColor: AppColors.card,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(AppSpacing.md),
      borderRadius: 14,
      duration: const Duration(seconds: 2),
    );
  }
}

class EditAvatarView extends StatelessWidget {
  const EditAvatarView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<EditAvatarController>()
        ? Get.find<EditAvatarController>()
        : Get.put(EditAvatarController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Choose Avatar'),
        centerTitle: true,
        leading: IconButton(
          icon: const FVIcon(PhosphorIconsRegular.caretLeft),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton.icon(
            onPressed: controller.saveAvatar,
            icon: const FVIcon(PhosphorIconsRegular.check, color: Colors.white, size: 18),
            label: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Top Active Avatar Preview + Camera Upload Button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: AppSpacing.pagePadding),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                // Circular Preview
                Obx(() => Container(
                  width: 90,
                  height: 90,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: FVImage(
                    imageUrl: controller.selectedAvatarUrl.value,
                    width: 84,
                    height: 84,
                    isCircular: true,
                  ),
                )),
                const SizedBox(width: 18),
                // Upload Buttons
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Profile Preview', style: AppTypography.headingSmall),
                      const SizedBox(height: 4),
                      Text(
                        'Select a preset or upload your own',
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _uploadButton(
                            icon: PhosphorIconsRegular.image,
                            label: 'Gallery',
                            onTap: () => controller.pickImage(ImageSource.gallery),
                          ),
                          const SizedBox(width: 8),
                          _uploadButton(
                            icon: PhosphorIconsRegular.camera,
                            label: 'Camera',
                            onTap: () => controller.pickImage(ImageSource.camera),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Gender & Category Filter Chips
          SizedBox(
            height: 52,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: 10),
              scrollDirection: Axis.horizontal,
              itemCount: controller.filterOptions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = controller.filterOptions[index];
                return Obx(() {
                  final isSelected = controller.selectedFilter.value == filter;
                  return FilterChip(
                    selected: isSelected,
                    label: Text(filter),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                    backgroundColor: AppColors.card,
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    onSelected: (_) => controller.setFilter(filter),
                  );
                });
              },
            ),
          ),

          // Avatars Grid (Boys & Girls Mix)
          Expanded(
            child: Obx(() {
              final avatars = controller.filteredAvatars;
              return GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: avatars.length,
                itemBuilder: (context, index) {
                  final avatar = avatars[index];
                  final isSelected = controller.selectedAvatarUrl.value == avatar.url;

                  return GestureDetector(
                    onTap: () => controller.selectAvatar(avatar.url),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 76,
                              height: 76,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: isSelected ? AppColors.primaryGradient : null,
                                border: isSelected
                                    ? null
                                    : Border.all(color: AppColors.border, width: 2),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.45),
                                          blurRadius: 12,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : const [],
                              ),
                              child: FVImage(
                                imageUrl: avatar.url,
                                width: 70,
                                height: 70,
                                isCircular: true,
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.background, width: 2),
                                  ),
                                  child: const FVIcon(
                                    PhosphorIconsFill.checkCircle,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          avatar.name,
                          style: AppTypography.caption.copyWith(
                            color: isSelected ? AppColors.primaryLight : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
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

  Widget _uploadButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FVIcon(icon, size: 14, color: AppColors.primaryLight),
            const SizedBox(width: 5),
            Text(label, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
