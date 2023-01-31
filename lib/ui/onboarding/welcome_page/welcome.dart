import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/ui/home/home_page/home.dart';
import 'package:flutter/material.dart';

// Page to conclude onboarding process
class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
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
                    image: AssetImage('lib/assets/dinetime-white.png'),
                  ),
                  const SizedBox(height: 50.0),
                  Text(
                    "Welcome to DineTime.",
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  const SizedBox(height: 50.0),
                  Text(
                    "Ready to discover new",
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    "and exciting places to eat?",
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  const SizedBox(height: 60.0),
                  ButtonOutlined(
                    text: "Let's Go!",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(),
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
