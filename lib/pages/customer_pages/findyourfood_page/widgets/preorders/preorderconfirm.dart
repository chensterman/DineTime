import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

class PreorderConfirm extends StatefulWidget {
  final String restaurantName;
  final num totalPrice;
  const PreorderConfirm({
    Key? key,
    required this.restaurantName,
    required this.totalPrice,
  }) : super(key: key);

  @override
  State<PreorderConfirm> createState() => _PreorderConfirmState();
}

class _PreorderConfirmState extends State<PreorderConfirm> {
  @override
  Widget build(BuildContext context) {
    //Mock Data
    ButtonStyle style = ElevatedButton.styleFrom(
      foregroundColor: dineTimeColorScheme.onPrimary,
      disabledBackgroundColor: dineTimeColorScheme.onSurface,
      disabledForegroundColor: dineTimeColorScheme.primary,
      backgroundColor: dineTimeColorScheme.primary,
      textStyle: dineTimeTypography.headlineSmall,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ); // 50 px height, inf width
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      expand: false,
      builder: (_, controller) => Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    widget.restaurantName,
                    textAlign: TextAlign.center,
                    style: dineTimeTypography.headlineLarge
                        ?.copyWith(color: dineTimeColorScheme.primary),
                  ),
                  // const SizedBox(height: 2),
                  // Text(
                  //   'Your Order is #609',
                  //   textAlign: TextAlign.center,
                  //   style: Theme.of(context).textTheme.headline1?.copyWith(
                  //         fontSize: 28.0,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  // ),
                  const SizedBox(height: 15.0),
                  const Image(
                      image: AssetImage('lib/assets/preordercheck.png'),
                      height: 80,
                      width: 80),
                  const SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                    child: Text(
                      "Congrats! You have skipped the line. Please complete your payment at ${widget.restaurantName}. You can check order details at the pre-orders tab.",
                      textAlign: TextAlign.center,
                      style: dineTimeTypography.bodyMedium?.copyWith(
                        color: dineTimeColorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Text(
                    "Sub Total",
                    style: dineTimeTypography.headlineMedium,
                  ),
                  const Spacer(),
                  Text(
                    widget.totalPrice.toString(),
                    style: dineTimeTypography.headlineMedium?.copyWith(
                      color: dineTimeColorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 30.0),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Positioned(
                  bottom: 40.0,
                  child: SizedBox(
                    width: 180,
                    height: 50,
                    child: Opacity(
                      opacity: 0.9,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: style,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Return to Home",
                              style: dineTimeTypography.bodyMedium?.copyWith(
                                color: dineTimeColorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
