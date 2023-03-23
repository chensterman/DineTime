import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/colorscheme.dart';

// Class containing the typography of the app
TextTheme dineTimeTypography = TextTheme(
  headlineLarge: TextStyle(
    fontSize: 32,
    fontFamily: 'Futura PT',
    color: dineTimeColorScheme.onBackground,
  ),
  headlineMedium: TextStyle(
    fontSize: 24,
    fontFamily: 'Futura PT',
    color: dineTimeColorScheme.onBackground,
  ),
  headlineSmall: TextStyle(
    fontSize: 20,
    fontFamily: 'Futura PT',
    color: dineTimeColorScheme.onBackground,
  ),
  titleSmall: TextStyle(
    fontSize: 20,
    fontFamily: 'Futura PT',
    color: dineTimeColorScheme.primary,
  ),
  displayMedium: TextStyle(
    fontSize: 18,
    fontFamily: 'Futura PT',
    color: dineTimeColorScheme.onBackground,
  ),
  displaySmall: TextStyle(
    fontSize: 14,
    fontFamily: 'Futura PT',
    color: dineTimeColorScheme.primary,
  ),
  bodyLarge: TextStyle(
    fontSize: 18,
    fontFamily: 'Lato',
    color: dineTimeColorScheme.onBackground,
  ),
  bodyMedium: TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: dineTimeColorScheme.onBackground,
  ),
  bodySmall: TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: dineTimeColorScheme.onBackground,
  ),
);
