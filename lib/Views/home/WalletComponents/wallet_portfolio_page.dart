// import 'package:crypto_coin/Views/home/WalletComponents/wallet_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../Utilities/global_variables.dart';
//
// class WalletPortfolioPage extends StatelessWidget {
//   WalletPortfolioPage({super.key});
//   final WalletController controller = Get.put(WalletController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 24),
//             _buildBalanceSection(),
//             const SizedBox(height: 24),
//             _buildActionButtons(),
//             const SizedBox(height: 24),
//             _buildMyAssetsSection(),
//           ],
//         ),
//       ),
//       // bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }
//
//   Widget _buildBalanceSection() {
//     return Column(
//       children: [
//         Center(
//             child: Container(
//           decoration: BoxDecoration(
//             color: Colors.orange,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//           child: const Text('USDT 100%',
//               style:
//                   TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         )),
//         const SizedBox(height: 20),
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             SizedBox(
//               width: 180,
//               height: 180,
//               child: CircularProgressIndicator(
//                 value: 1,
//                 strokeWidth: 12,
//                 backgroundColor: Colors.grey.shade300,
//                 color: Colors.orange,
//               ),
//             ),
//             Column(
//               children: [
//                 const Icon(Icons.visibility, color: Colors.grey),
//                 const Text('My Balance',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 Text('\$${totalAssetsInUSDT.toStringAsFixed(2)}',
//                     style:
//                         const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                 const Text('+2.60%',
//                     style: TextStyle(color: Colors.green, fontSize: 16)),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildActionButton(Icons.add, 'Deposit'),
//         const SizedBox(width: 40),
//         _buildActionButton(Icons.attach_money, 'Withdraw'),
//       ],
//     );
//   }
//
//   Widget _buildActionButton(IconData icon, String label) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 32,
//           backgroundColor: Colors.blue,
//           child: Icon(icon, color: Colors.white, size: 32),
//         ),
//         const SizedBox(height: 8),
//         Text(label,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }
//
//   Widget _buildMyAssetsSection() {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('My Assets',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//             const Divider(),
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundColor: Colors.orange.shade100,
//                   child:
//                       const Icon(Icons.currency_bitcoin, color: Colors.orange),
//                 ),
//                 const SizedBox(width: 16),
//                 const Text('USDT',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const Spacer(),
//                 const Text('\$30,113.80',
//                     style: TextStyle(color: Colors.green, fontSize: 16)),
//                 const SizedBox(width: 8),
//                 const Text('+2.76%', style: TextStyle(color: Colors.green)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
