import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import '/pages/customer_pages/findyourfood_page/widgets/content/aboutandstory.dart';
import 'package:url_launcher/url_launcher.dart';
import 'buy_ticket.dart';

class EventDisplay extends StatelessWidget {
  const EventDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final Services services = Provider.of<Services>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: height * 0.2,
                  width: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/food1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: dineTimeColorScheme.primary,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Conchas and Cocktails",
                        style: dineTimeTypography.headlineMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'US  ·  Mexican  ·  \$\$',
                        style: dineTimeTypography.bodyMedium?.copyWith(
                          color: dineTimeColorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Image(
                              image:
                                  AssetImage('lib/assets/Bakescapade_logo.png'),
                              height: 40,
                              width: 40),
                          const SizedBox(width: 15.0),
                          Text("Bakescapade",
                              style: dineTimeTypography.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: 10.0),
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
                              image: AssetImage(
                                  'lib/assets/locationsmallgrey.png'),
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
                      AboutAndStory(
                        restaurantBio:
                            "We wanted to create something super special for you.. and well, the stars aligned and we found a business that embraced COMMUNITY and diversity as much we do. That company is @waterwayscruises . We've partnered up with them to bring you an event of a lifetime...",
                      ),
                      const SizedBox(height: 10.0),
                      const Divider(),
                      const SizedBox(height: 10.0),
                      Text(
                        'Location',
                        style: dineTimeTypography.headlineSmall,
                      ),
                      const SizedBox(height: 10.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          height: 60.0,
                          width: double.infinity,
                          color: dineTimeColorScheme.primary,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 2.0,
                                    bottom: 2.0),
                                child: SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text overflow works by wrapping text under Flexible widget
                                      Flexible(
                                        child: Text(
                                          '11/22',
                                          style: dineTimeTypography.bodyMedium
                                              ?.copyWith(
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text overflow works by wrapping text under Flexible widget
                                        Flexible(
                                          child: Text(
                                            "Seattle Fremont Brewery",
                                            style: dineTimeTypography.bodyMedium
                                                ?.copyWith(
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Flexible(
                                          child: Text(
                                            "1.3 mi  ·  3:00 PM - 6:00 PM PST",
                                            style: dineTimeTypography.bodySmall
                                                ?.copyWith(
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: InkWell(
                                  onTap: () => launchUrl(Uri.parse(
                                      'https://www.google.com/maps/search')),
                                  child: Container(
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        // Display image based on availability of user uploaded image
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            'lib/assets/location_arrow_grey.png'),
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Divider(),
                      const SizedBox(height: 10.0),
                      Text(
                        'Additional Information',
                        style: dineTimeTypography.headlineSmall,
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: InkWell(
                              onTap: () => launchUrl(Uri.parse(
                                  'https://www.google.com/maps/search')),
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    // Display image based on availability of user uploaded image
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'lib/assets/instagram_orange.png'),
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: InkWell(
                              onTap: () => launchUrl(Uri.parse(
                                  'https://www.google.com/maps/search')),
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    // Display image based on availability of user uploaded image
                                    fit: BoxFit.fill,
                                    image: AssetImage('lib/assets/website.png'),
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: InkWell(
                              onTap: () => launchUrl(Uri.parse(
                                  'https://www.google.com/maps/search')),
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    // Display image based on availability of user uploaded image
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'lib/assets/email_orange.png'),
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Positioned(
                            bottom: 20.0,
                            child: Container(
                              width: 150.0,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ButtonFilled(
                                isDisabled: false,
                                text: "Buy Ticket",
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) => BuyTicket(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
