import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'dart:convert';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../core/widgets/fv_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class EditAvatarController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final LocalStorageService _storageService = Get.find<LocalStorageService>();
  
  final selectedAvatarUrl = ''.obs;
  final isPicking = false.obs;
  
  final List<String> presetAvatars = [
    'https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&q=80&w=200&h=200',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=200&h=200',
    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=200&h=200',
    'https://images.unsplash.com/photo-1607746882042-944635dfe10e?auto=format&fit=crop&q=80&w=200&h=200',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200&h=200',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200&h=200',
    'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=200&h=200',
    'https://images.unsplash.com/photo-1633332755192-727a05c4013d?auto=format&fit=crop&q=80&w=200&h=200',
  ];

  @override
  void onInit() {
    super.onInit();
    final user = _authService.currentUser.value;
    if (user != null && user.avatarUrl != null) {
      selectedAvatarUrl.value = user.avatarUrl!;
    }
  }
  
  Future<void> pickFromGallery() async {
    isPicking.value = true;
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(toolbarTitle: 'Crop Avatar', lockAspectRatio: true),
          IOSUiSettings(title: 'Crop Avatar', aspectRatioLockEnabled: true),
          WebUiSettings(context: Get.context!),
        ],
      );
      if (cropped != null) {
        final bytes = await XFile(cropped.path).readAsBytes();
        selectedAvatarUrl.value = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      }
    } catch (_) {
      Get.snackbar('Avatar', 'Could not select that image. Please try again.');
    } finally {
      isPicking.value = false;
    }
  }

  void selectAvatar(String url) {
    selectedAvatarUrl.value = url;
  }
  
  Future<void> saveAvatar() async {
    final user = _authService.currentUser.value;
    if (user == null || selectedAvatarUrl.value.isEmpty) return;
    
    final updatedUser = user.copyWith(avatarUrl: selectedAvatarUrl.value);
    await _storageService.saveUser(updatedUser);
    _authService.currentUser.value = updatedUser;
    
    Get.back();
  }
}

class EditAvatarView extends StatelessWidget {
  const EditAvatarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<EditAvatarController>() ? Get.find<EditAvatarController>() : Get.put(EditAvatarController());
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Edit Avatar', style: AppTypography.headingMedium),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            tooltip: 'Choose photo',
            icon: FVIcon(PhosphorIconsRegular.image, color: AppColors.primary),
            onPressed: controller.pickFromGallery,
          ),
          IconButton(
            tooltip: 'Save avatar',
            icon: FVIcon(PhosphorIconsRegular.check, color: AppColors.primary),
            onPressed: controller.saveAvatar,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          children: [
            Obx(() => controller.selectedAvatarUrl.value.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: FVImage(
                      imageUrl: controller.selectedAvatarUrl.value,
                      width: 110,
                      height: 110,
                      isCircular: true,
                    ),
                  )),
            Expanded(
              child: Obx(() => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                itemCount: controller.presetAvatars.length,
                itemBuilder: (context, index) {
                  final url = controller.presetAvatars[index];
                  final isSelected = controller.selectedAvatarUrl.value == url;
                  return GestureDetector(
                    onTap: () => controller.selectAvatar(url),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.lg),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected ? AppShadows.primaryGlow : [],
                      ),
                      child: FVImage(
                        imageUrl: url,
                        isCircular: true,
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
