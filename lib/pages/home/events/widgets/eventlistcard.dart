import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/event.dart';
import 'package:dinetime_mobile_mvp/pages/home/event_display_page/event_display.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

// Cards that display list items in saved
class EventListCard extends StatelessWidget {
  final Customer customer;
  final Event event;
  const EventListCard({
    super.key,
    required this.customer,
    required this.event,
  });

  final double _cardHeight = 75.0;

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        width: 70,
        height: _cardHeight,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 233, 233, 233).withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            // Tappable portion of card
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => const EventDisplay(),
                  ),
                );
              },
              child: SizedBox(
                height: _cardHeight,
                child: Row(
                  children: <Widget>[
                    // Restaurant logo
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        width: 55.0,
                        height: 55.0,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: FutureBuilder(
                          future: services.clientStorage
                              .getPhoto(event.eventLogoRef),
                          builder: ((context,
                              AsyncSnapshot<ImageProvider<Object>?> snapshot) {
                            if (snapshot.hasError) {
                              return Container();
                              // On success
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return LogoDisplay(
                                  width: 40.0,
                                  height: 40.0,
                                  image: snapshot.data!);
                              // On loading
                            } else {
                              return const LogoDisplay(
                                width: 40.0,
                                height: 40.0,
                                isLoading: true,
                              );
                            }
                          }),
                        ),
                      ),
                    ),
                    // Name, cuisine, pricing, distance portion
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text overflow works by wrapping text under Flexible widget
                              Flexible(
                                child: Text(
                                  "March 12, 2023 at 6:00 PM PST",
                                  style: dineTimeTypography.displaySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  event.eventName,
                                  style: dineTimeTypography.displayMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  event.restaurantName,
                                  style: dineTimeTypography.bodySmall?.copyWith(
                                    color: dineTimeColorScheme.onSurface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
