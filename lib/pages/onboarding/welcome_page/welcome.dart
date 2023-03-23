import 'package:dinetime_mobile_mvp/pages/root/routing_page/routing.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/pages/root/home_page/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Page to conclude onboarding process
class Welcome extends StatelessWidget {
  const Welcome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    return Scaffold(
      backgroundColor: dineTimeColorScheme.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Image(
                    width: 50.0,
                    height: 50.0,
                    image: AssetImage('lib/assets/dinetime-white.png'),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Welcome to DineTime.",
                    style: dineTimeTypography.headlineLarge?.copyWith(
                      color: dineTimeColorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  Text(
                    "Discover food you can't",
                    style: dineTimeTypography.bodyLarge?.copyWith(
                      color: dineTimeColorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    "find anywhere else.",
                    style: dineTimeTypography.bodyLarge?.copyWith(
                      color: dineTimeColorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 60.0),
                  ButtonOutlined(
                    text: "It's DineTime!",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => const Routing(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
