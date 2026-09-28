import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../modules/ai_helper/views/ai_helper_view.dart';
import 'fv_icon.dart';

/// Premium floating action button for triggering the AI Chatbot helper.
class FVAiFloatingButton extends StatefulWidget {
  final String? label;
  final String heroTag;

  const FVAiFloatingButton({
    super.key,
    this.label,
    this.heroTag = 'fv_ai_fab',
  });

  @override
  State<FVAiFloatingButton> createState() => _FVAiFloatingButtonState();
}

class _FVAiFloatingButtonState extends State<FVAiFloatingButton> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _animController.forward();
    await _animController.reverse();
    Get.bottomSheet(
      const AiHelperView(),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isExtended = widget.label != null;

    return Tooltip(
      message: 'Chat with AI Helper',
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Material(
          color: Colors.transparent,
          shape: isExtended ? const StadiumBorder() : const CircleBorder(),
          child: InkWell(
            onTap: _handleTap,
            customBorder: isExtended ? const StadiumBorder() : const CircleBorder(),
            splashColor: Colors.white.withValues(alpha: 0.2),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Container(
              padding: isExtended
                  ? const EdgeInsets.symmetric(horizontal: 18, vertical: 12)
                  : const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: isExtended ? BorderRadius.circular(30) : null,
                shape: isExtended ? BoxShape.rectangle : BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.28),
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.45),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FVIcon(
                    PhosphorIconsFill.chatCircleDots,
                    color: Colors.white,
                    size: 24,
                  ),
                  if (isExtended) ...[
                    const SizedBox(width: 8),
                    Text(
                      widget.label!,
                      style: AppTypography.buttonSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

