import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/colorscheme.dart';

// Class containing the typography of the app
TextTheme dineTimeTypography = TextTheme(
  headline1: TextStyle(
    fontSize: 32,
    fontFamily: 'Futura PT',
    fontWeight: FontWeight.bold,
    color: dineTimeColorScheme.onBackground,
  ),
  subtitle1: TextStyle(
    fontSize: 20,
    fontFamily: 'Lato',
    color: dineTimeColorScheme.primary,
  ),
  bodyText1: TextStyle(
    fontSize: 20,
    fontFamily: 'Lato',
    color: dineTimeColorScheme.onSurface,
  ),
  bodyText2: TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: dineTimeColorScheme.onSurface,
  ),
  button: const TextStyle(
    fontSize: 20,
    fontFamily: 'Futura PT',
  ),
);
