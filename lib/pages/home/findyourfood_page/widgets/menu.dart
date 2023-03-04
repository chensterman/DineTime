import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/menuoption.dart';

class Menu extends StatelessWidget {
  final List<r.MenuItem> menu;
  const Menu({
    Key? key,
    required this.menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    List<Widget> columnChildren = [];
    for (r.MenuItem menuItem in menu) {
      columnChildren.add(MenuOption(
        itemName: menuItem.itemName,
        itemDesc: menuItem.itemDescription,
        price: menuItem.itemPrice,
        itemImageRef: menuItem.itemImageRef,
        dietaryTags: menuItem.dietaryTags,
        clientStorage: services.clientStorage,
        paddingValue: 15.0,
      ));
      columnChildren.add(
        const Divider(
          color: Color.fromARGB(95, 158, 158, 158),
          height: 1,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Menu',
          style: dineTimeTypography.headlineMedium,
        ),
        const SizedBox(
          height: 10,
        ),
        menu.isEmpty
            ? Text(
                'No menu items.',
                style: dineTimeTypography.bodyMedium?.copyWith(
                  color: dineTimeColorScheme.onSurface,
                ),
              )
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: dineTimeColorScheme.onSurface, width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: columnChildren,
                ),
              ),
      ],
    );
  }

//   Widget menuButton(BuildContext context) {
//     Services services = Provider.of<Services>(context);
//     List<Widget> columnChildren = [];
//     for (r.MenuItem menuItem in menu) {
//       columnChildren.add(const SizedBox(
//         height: 10.0,
//       ));
//       columnChildren.add(MenuOption(
//         itemName: menuItem.itemName,
//         itemDesc: menuItem.itemDescription,
//         price: menuItem.itemPrice,
//         itemImageRef: menuItem.itemImageRef,
//         dietaryTags: menuItem.dietaryTags,
//         clientStorage: services.clientStorage,
//         paddingValue: 0,
//       ));
//       columnChildren.add(
//         const SizedBox(height: 12.0),
//       );
//       columnChildren.add(
//         const Divider(
//           color: Color.fromARGB(95, 158, 158, 158),
//           height: 1,
//         ),
//       );
//     }
//     return Padding(
//       padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
//       child: InkWell(
//         onTap: () {
//           showModalBottomSheet(
//             isScrollControlled: true,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(10),
//               ),
//             ),
//             context: context,
//             builder: (context) => menuDialog(context, columnChildren),
//           );
//         },
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: Container(
//             width: 135,
//             height: 25,
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
//               shape: BoxShape.rectangle,
//             ),
//             child: Center(
//               child: Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Image(
//                         image: AssetImage('lib/assets/view_menu.png'),
//                         height: 10,
//                         width: 10),
//                     const SizedBox(width: 5),
//                     Text(
//                       "View full menu",
//                       style: Theme.of(context).textTheme.subtitle1?.copyWith(
//                           fontSize: 10.0,
//                           color: Theme.of(context).colorScheme.primary,
//                           fontFamily: 'Lato'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget menuDialog(BuildContext context, List<Widget> columnChildren) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.85,
//       child: DraggableScrollableSheet(
//         initialChildSize: 1.0,
//         builder: (_, controller) => Padding(
//           padding: const EdgeInsets.all(25.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Row(
//                       children: [
//                         const Image(
//                             image: AssetImage('lib/assets/back_arrow.png'),
//                             height: 12,
//                             width: 12),
//                         const SizedBox(width: 10),
//                         Text(
//                           "Go Back",
//                           style: Theme.of(context)
//                               .textTheme
//                               .subtitle1
//                               ?.copyWith(
//                                   fontSize: 12.0,
//                                   fontFamily: 'Lato',
//                                   color: dineTimeColorScheme.primary),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 25.0),
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: Text(
//                     'Our Menu',
//                     style: Theme.of(context).textTheme.headline1?.copyWith(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.w500,
//                         ),
//                   ),
//                 ),
//                 const SizedBox(height: 5.0),
//                 Scrollbar(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: columnChildren,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
}
