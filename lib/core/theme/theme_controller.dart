import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../storage/local_storage_service.dart';

/// Owns light/dark mode. Persisted in Hive (settings box).
///
/// AppColors is a set of runtime getters, so after flipping the flag we swap
/// the ThemeData and mark the element tree dirty; no navigation state is lost.
class ThemeController extends GetxService {
  final LocalStorageService _storage = Get.find<LocalStorageService>();
  final RxBool isDark = true.obs;

  ThemeController init() {
    final saved = _storage.getString(AppConstants.keyTheme);
    isDark.value = saved != 'light';
    AppColors.isDark = isDark.value;
    return this;
  }

  ThemeData get themeData => AppTheme.build();

  void setDark(bool dark) {
    if (isDark.value == dark) return;
    isDark.value = dark;
    AppColors.isDark = dark;
    _storage.setString(AppConstants.keyTheme, dark ? 'dark' : 'light');
    Get.changeTheme(AppTheme.build());
    SchedulerBinding.instance.addPostFrameCallback((_) => _rebuildAll());
  }

  void toggle() => setDark(!isDark.value);

  void _rebuildAll() {
    void visit(Element el) {
      el.markNeedsBuild();
      el.visitChildren(visit);
    }

    WidgetsBinding.instance.rootElement?.visitChildren(visit);
  }
}
