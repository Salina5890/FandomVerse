import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/storage/local_storage_service.dart';

class EditBioController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final LocalStorageService _storageService = Get.find<LocalStorageService>();
  final bioController = TextEditingController();
  final charCount = 0.obs;
  final int maxChars = 300;

  @override
  void onInit() {
    super.onInit();
    final user = _authService.currentUser.value;
    if (user != null && user.bio != null) {
      bioController.text = user.bio!;
      charCount.value = user.bio!.length;
    }
    bioController.addListener(() {
      charCount.value = bioController.text.length;
    });
  }

  Future<void> saveBio() async {
    final user = _authService.currentUser.value;
    if (user == null) return;
    
    final updatedUser = user.copyWith(bio: bioController.text);
    await _storageService.saveUser(updatedUser);
    _authService.currentUser.value = updatedUser;
    Get.back();
  }

  @override
  void onClose() {
    bioController.dispose();
    super.onClose();
  }
}

class EditBioView extends StatelessWidget {
  const EditBioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<EditBioController>() ? Get.find<EditBioController>() : Get.put(EditBioController());
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Edit Bio', style: AppTypography.headingMedium),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          children: [
            FVTextField(
              label: 'Bio',
              hint: 'Write a short bio...',
              controller: controller.bioController,
              maxLines: 5,
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: Obx(() => Text(
                '${controller.charCount.value}/${controller.maxChars}',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              )),
            ),
            const SizedBox(height: AppSpacing.xl),
            FVButton(
              text: 'Save',
              onPressed: controller.saveBio,
              variant: FVButtonVariant.primary,
            ),
          ],
        ),
      ),
    );
  }
}
