import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/blocs/preorderbag/preorderbag_bloc.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/preorders/preorderbag.dart'
    as p;
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'preorderoption.dart';

class PreorderMenu extends StatelessWidget {
  final String restaurantName;
  final List<MenuItem> menu;
  final PopUpLocation nextLocation;
  final PreorderBagBloc preorderBagBloc;
  const PreorderMenu({
    Key? key,
    required this.restaurantName,
    required this.menu,
    required this.nextLocation,
    required this.preorderBagBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    List<Widget> columnChildren = [];
    for (MenuItem menuItem in menu) {
      columnChildren.add(const SizedBox(
        height: 10.0,
      ));
      columnChildren.add(PreorderOption(
        menuItem: menuItem,
        clientStorage: services.clientStorage,
        preorderBagBloc: preorderBagBloc,
      ));
      columnChildren.add(
        const SizedBox(height: 12.0),
      );
    }
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      expand: false,
      builder: (_, controller) => Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      "View Card",
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
                'Our Menu',
                style: dineTimeTypography.headlineMedium,
              ),
            ),
            const SizedBox(height: 5.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: columnChildren,
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            viewPreorderButton(context),
          ],
        ),
      ),
    );
  }

  Widget viewPreorderButton(BuildContext context) {
    ButtonStyle style = ElevatedButton.styleFrom(
      foregroundColor: dineTimeColorScheme.onPrimary,
      disabledBackgroundColor: dineTimeColorScheme.onSurface,
      disabledForegroundColor: dineTimeColorScheme.primary,
      backgroundColor: dineTimeColorScheme.primary,
      textStyle: dineTimeTypography.headlineSmall,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ); // 50 px height, inf width
    return BlocBuilder<PreorderBagBloc, PreorderBagState>(
        bloc: preorderBagBloc,
        builder: (context, state) {
          if (state is PreorderBagData) {
            int totalQuantity = 0;
            num totalPrice = 0;
            for (PreorderItem? preorderItem in state.preorderBag.bag) {
              totalQuantity += preorderItem!.quantity;
              totalPrice += preorderItem.item.itemPrice * preorderItem.quantity;
            }
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 40,
                child: Opacity(
                  opacity: 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        context: context,
                        builder: (context) => p.PreorderBag(
                          restaurantName: restaurantName,
                          nextLocation: nextLocation,
                          preorderBagBloc: preorderBagBloc,
                        ),
                      );
                    },
                    style: style,
                    child: Row(
                      children: [
                        Image.asset(
                          'lib/assets/cart_white.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "View Pre-Order",
                          style: dineTimeTypography.bodySmall?.copyWith(
                            color: dineTimeColorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "$totalQuantity",
                              style: dineTimeTypography.bodySmall?.copyWith(
                                color: dineTimeColorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "\$$totalPrice",
                          style: dineTimeTypography.bodySmall?.copyWith(
                            color: dineTimeColorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
