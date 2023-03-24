import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FulfillmentButton extends StatefulWidget {
  final String preorderId;
  final bool fulfilled;
  const FulfillmentButton({
    required this.preorderId,
    required this.fulfilled,
    Key? key,
  }) : super(key: key);

  @override
  State<FulfillmentButton> createState() => _FulfillmentButtonState();
}

class _FulfillmentButtonState extends State<FulfillmentButton> {
  late bool fulfilled;
  String stringNotFulfilled = "Mark as fulfilled";
  String stringFulfilled = "Completed";

  @override
  void initState() {
    fulfilled = widget.fulfilled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    return ButtonFilled(
      isDisabled: fulfilled,
      text: fulfilled ? stringFulfilled : stringNotFulfilled,
      onPressed: () {
        services.clientDB.preorderUpdate(widget.preorderId, !fulfilled);
        setState(() {
          fulfilled = !fulfilled;
        });
      },
    );
  }
}
