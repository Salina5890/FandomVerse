import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../controllers/ai_helper_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AiHelperView extends StatelessWidget {
  const AiHelperView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AiHelperController>() ? Get.find<AiHelperController>() : Get.put(AiHelperController());
    final textController = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  FVIcon(PhosphorIconsRegular.sparkle, color: AppColors.primaryLight),
                  const SizedBox(width: 8),
                  Text('AI Fan Helper', style: AppTypography.headingMedium),
                  const Spacer(),
                  IconButton(
                    icon: const FVIcon(PhosphorIconsRegular.x),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.border, height: 1),
            
            // Chat History
            Expanded(
              child: Obx(() => ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: controller.chatHistory.length + (controller.isTyping.value ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  if (index == controller.chatHistory.length && controller.isTyping.value) {
                    return _buildTypingIndicator();
                  }

                  final msg = controller.chatHistory[index];
                  final isAi = msg['role'] == 'ai';
                  
                  return Align(
                    alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isAi ? AppColors.card : AppColors.primary,
                        borderRadius: BorderRadius.circular(16).copyWith(
                          bottomLeft: Radius.circular(isAi ? 0 : 16),
                          bottomRight: Radius.circular(isAi ? 16 : 0),
                        ),
                        border: isAi ? Border.all(color: AppColors.border) : null,
                      ),
                      child: Text(
                        msg['text'] ?? '',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isAi ? AppColors.textPrimary : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              )),
            ),

            // Suggested Questions
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  _buildSuggestedQuestion('What is a Hashira?', controller),
                  const SizedBox(width: 8),
                  _buildSuggestedQuestion('Find upcoming events', controller),
                  const SizedBox(width: 8),
                  _buildSuggestedQuestion('How do badges work?', controller),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Input Area
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
                color: AppColors.surface,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'Ask anything...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.card,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: (val) {
                        controller.sendMessage(val);
                        textController.clear();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const FVIcon(PhosphorIconsRegular.paperPlaneTilt, color: Colors.white, size: 20),
                      onPressed: () {
                        controller.sendMessage(textController.text);
                        textController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedQuestion(String text, AiHelperController controller) {
    return ActionChip(
      label: Text(text, style: AppTypography.caption),
      backgroundColor: AppColors.surface,
      side: BorderSide(color: AppColors.border),
      onPressed: () => controller.askSuggestedQuestion(text),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16).copyWith(bottomLeft: const Radius.circular(0)),
          border: Border.all(color: AppColors.border),
        ),
        child: Text('...', style: TextStyle(fontSize: 16, color: AppColors.textSecondary, letterSpacing: 2)),
      ),
    );
  }
}
