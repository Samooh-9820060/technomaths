import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:technomaths/config/theme_notifier.dart';
import 'package:technomaths/config/themes.dart';

import 'extended_theme.dart';

class ThemeHelper {
  final BuildContext context;
  final bool listen;

  ThemeHelper(this.context, {this.listen = true});
  CustomTheme get currentTheme => themes[Provider.of<ThemeNotifier>(context, listen: listen).currentThemeKey]!;

  Color get primaryColor => currentTheme.themeData.colorScheme.primary;
  Color get secondaryColor => currentTheme.themeData.colorScheme.secondary;
  Color get errorColor => currentTheme.errorColor;
  Color get positiveColor => currentTheme.positiveColor;
  Color get progressBarBackground => currentTheme.progressBarBackground;
  Color get positiveColorLight => currentTheme.positiveColorLight;
  Color get positiveColorDark => currentTheme.positiveColorDark;
  Color get textColor => currentTheme.textColor;
  Color get btnTextColor => currentTheme.btnTextColor;
  Color get btnTextColorReverse => currentTheme.btnTextColorReverse;
  Color get backdropBackgroundColor => currentTheme.backdropBackgroundColor;
  Color get bestScoreBackground => currentTheme.bestScoreBackground;
  Color get buttonIndicatorColor => currentTheme.buttonIndicatorColor;
  Color get tableSurroundColor => currentTheme.tableSurroundColor;
  Color get headerColor => currentTheme.headerColor;
  Color get iconColor => currentTheme.iconColor;

}
