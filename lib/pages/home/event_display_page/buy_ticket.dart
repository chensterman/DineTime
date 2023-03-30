import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/findyourfood_page/widgets/preorders/preorderbag.dart'
    as p;
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyTicket extends StatelessWidget {
  const BuyTicket({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      expand: false,
      builder: (_, controller) => Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    const Image(
                        image: AssetImage('lib/assets/back_arrow.png'),
                        height: 12,
                        width: 12),
                    const SizedBox(width: 10),
                    Text(
                      "View Event",
                      style: dineTimeTypography.bodySmall
                          ?.copyWith(color: dineTimeColorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Buy Ticket',
                style: dineTimeTypography.headlineLarge,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Cocktails & Conchas',
                style: dineTimeTypography.bodyLarge?.copyWith(
                  color: dineTimeColorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Divider(),
            const SizedBox(height: 10.0),
            Text(
              'Event Details',
              style: dineTimeTypography.headlineSmall,
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Image(
                    image: AssetImage('lib/assets/locationsmallgrey.png'),
                    height: 18,
                    width: 18),
                const SizedBox(width: 15.0),
                Text(
                  "Seattle Waterways Cruises",
                  style: dineTimeTypography.bodyMedium?.copyWith(
                    color: dineTimeColorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Image(
                    image: AssetImage('lib/assets/calendar_grey.png'),
                    height: 18,
                    width: 18),
                const SizedBox(width: 15.0),
                Text(
                  "Mar. 13, 2023 at 12:00 PM - 3:00 PM PST",
                  style: dineTimeTypography.bodyMedium?.copyWith(
                    color: dineTimeColorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Image(
                    image: AssetImage('lib/assets/dollar_grey.png'),
                    height: 18,
                    width: 18),
                const SizedBox(width: 15.0),
                Text(
                  '\$25 per person',
                  style: dineTimeTypography.bodyMedium?.copyWith(
                    color: dineTimeColorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(),
            const SizedBox(height: 10.0),
            Text(
              'Disclaimer',
              style: dineTimeTypography.headlineSmall,
            ),
            const SizedBox(height: 10.0),
            Text(
              'To complete your ticket purchase, you will be redirected to our website where you can select the desired quantity. Once your payment is processed, you will receive an email confirmation receipt which you can present at the restaurant entrance as proof of purchase. ',
              style: dineTimeTypography.bodyMedium?.copyWith(
                color: dineTimeColorScheme.onSurface,
              ),
            ),
            Spacer(),
            viewPreorderButton(context),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget viewPreorderButton(BuildContext context) {
    ButtonStyle style = ElevatedButton.styleFrom(
      foregroundColor: dineTimeColorScheme.onPrimary,
      disabledForegroundColor: const Color(0xFFFFF6EC),
      backgroundColor: const Color(0xFFFFF6EC),
      textStyle: dineTimeTypography.headlineSmall,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 0.0,
    ); // 50 px height, inf width
    Services services = Provider.of<Services>(context);

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            launchUrl(
                Uri.parse('https://buy.stripe.com/test_28o5kz15lgF75Ta5kk'));
          },
          style: style,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Proceed to Checkout",
                style: dineTimeTypography.headlineSmall?.copyWith(
                  color: dineTimeColorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
