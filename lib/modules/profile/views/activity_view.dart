import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import '../../../app/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ActivityView extends StatelessWidget {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: ListView(
        children: [
          ListTile(
            leading: FVIcon(PhosphorIconsRegular.bookmarkSimple, color: AppColors.primary),
            title: Text('Saved content'),
            subtitle: Text('Your saved fandom content will appear here.'),
          ),
          ListTile(
            leading: FVIcon(PhosphorIconsRegular.shoppingBag, color: AppColors.cyan),
            title: Text('Store activity'),
            subtitle: Text('Your recent store activity will appear here.'),
          ),
        ],
      ),
    );
  }
}
