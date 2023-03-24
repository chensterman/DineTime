// Place fonts/event_ticket.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: event_ticket
//      fonts:
//       - asset: fonts/event_ticket.ttf
import 'package:flutter/widgets.dart';

class EventTicket {
  EventTicket._();

  static const String _fontFamily = 'event_ticket';

  static const IconData vector = IconData(0xe900, fontFamily: _fontFamily);
}
