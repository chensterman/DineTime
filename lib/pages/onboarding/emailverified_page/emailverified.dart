// import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
// import 'package:dinetime_mobile_mvp/services/analytics.dart';
// import 'package:dinetime_mobile_mvp/services/auth.dart';
// import 'package:dinetime_mobile_mvp/services/database.dart';
// import 'package:dinetime_mobile_mvp/services/location.dart';
// import 'package:dinetime_mobile_mvp/services/storage.dart';
// import 'package:dinetime_mobile_mvp/pages/onboarding/locationpreferences_page/locationpreferences.dart';
// import 'package:dinetime_mobile_mvp/pages/onboarding/welcome_page/welcome.dart';
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:provider/provider.dart';

// // Page confirming email has been verified
// class EmailVerified extends StatelessWidget {
//   const EmailVerified({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final locationPermission = Provider.of<PermissionStatus>(context);
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20.0),
//                 const ProgressBar(percentCompletion: 0.4),
//                 const SizedBox(height: 100.0),
//                 Text(
//                   "Email Verified.",
//                   style: dineTimeTypography.headlineLarge,
//                 ),
//                 const SizedBox(height: 30.0),
//                 Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         'Your email has been ',
//                         style: dineTimeTypography.bodySmall?.copyWith(
//                           color: dineTimeColorScheme.onSurface,
//                         ),
//                       ),
//                       Text(
//                         'successfully ',
//                         style: dineTimeTypography.bodySmall?.copyWith(
//                           color: dineTimeColorScheme.primary,
//                         ),
//                       ),
//                       Text(
//                         'verified!',
//                         style: dineTimeTypography.bodySmall?.copyWith(
//                           color: dineTimeColorScheme.onSurface,
//                         ),
//                       ),
//                     ]),
//                 const SizedBox(height: 45.0),
//                 // Go to next page on press
//                 ButtonFilled(
//                   isDisabled: false,
//                   text: "Continue",
//                   onPressed: () {
//                     if (locationPermission == PermissionStatus.denied) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           fullscreenDialog: true,
//                           builder: (context) => const LocationPreferences(),
//                         ),
//                       );
//                     } else {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           fullscreenDialog: true,
//                           builder: (context) => const Welcome(),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
