library phosphor_flutter;

import 'package:flutter/widgets.dart';

/// Newer Flutter versions made [IconData] a `final` class, so it can no longer
/// be subclassed. Phosphor icons are therefore plain [IconData] values now.
typedef PhosphorIconData = IconData;
typedef PhosphorFlatIconData = IconData;
