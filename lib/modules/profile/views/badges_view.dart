import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/routes/app_routes.dart';
import '../controllers/badges_controller.dart';

class BadgesView extends StatelessWidget {
  const BadgesView({super.key});
  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<BadgesController>() ? Get.find<BadgesController>() : Get.put(BadgesController());
    return Scaffold(appBar: AppBar(title: const Text('Fan Badges')), body: GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.pagePadding), itemCount: c.allBadges.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .9),
      itemBuilder: (_, i) { final b=c.allBadges[i]; return InkWell(onTap: ()=>Get.toNamed(AppRoutes.badgeDetail, parameters:{'id':b.id}), borderRadius: BorderRadius.circular(18), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card,borderRadius: BorderRadius.circular(18),border: Border.all(color: AppColors.border)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[Text(b.iconEmoji,style:const TextStyle(fontSize:44)),const SizedBox(height:10),Text(b.name,style:AppTypography.headingSmall,textAlign:TextAlign.center),const SizedBox(height:6),Text(b.rarity.toUpperCase(),style:AppTypography.caption.copyWith(color:AppColors.primaryLight)),const SizedBox(height:6),Text(c.isOwned(b.id)?'EARNED':'LOCKED',style:AppTypography.labelSmall.copyWith(color:c.isOwned(b.id)?AppColors.success:AppColors.textSecondary))]))); }
    ));
  }
}
