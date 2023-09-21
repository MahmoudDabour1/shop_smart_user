// import 'package:flutter/material.dart';
//
// import '../../../core/widgets/heart_button_widget.dart';
//
// class ProductsDetailsWidget extends StatelessWidget {
//   const ProductsDetailsWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(3.0),
//       child: Column(
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 flex: 5,
//                 child: Text(
//                   "Title",
//                   maxLines: 2,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//               Flexible(
//                 flex: 2,
//                 child: HeartButtonWidget(),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Flexible(
//                   flex: 3,
//                   child: Text(
//                     "166.5\$",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 18,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
//                 Flexible(
//                   child: Material(
//                     borderRadius: BorderRadius.circular(16),
//                     color: Colors.blue,
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(16),
//                       onTap: () {},
//                       child: const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Icon(
//                           Icons.add_shopping_cart_outlined,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//         ],
//       ),
//     );
//   }
// }
