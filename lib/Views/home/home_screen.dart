import 'package:crypto_coin/Views/home/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Components/custom_appbar.dart';
import '../../Utilities/global_variables.dart';
import '../app_colors.dart';
import '../setting_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RateItem rateItem = RateItem(
      flagImage: 'assets/images/flags/united-states.png',
      name: 'America',
      currency: 'USD',
      difference: 2,
      rateInCents: 597500,
      rateHistory: [
        500000, 517500, 507500, 525500, 520000, 515500, 565500,
        569500, 574500, 589000, 599000, 597500,
      ],
      rateColor: AppColors.usdRateColor,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        imageUrl: logo, // Adjust to the actual logo path
        title: 'Crypto Coin',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const PortfolioBalanceHeader(),
          const SizedBox(height: 70),
          Expanded(
            child: AssetContainer(rateItem: rateItem),
          ),
        ],
      ),
    );
  }
}

class PortfolioBalanceHeader extends StatelessWidget {
  const PortfolioBalanceHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Portfolio Balance',
          style: TextStyle(
            fontFamily: 'Readex Pro',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.2,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        Text(
          '\$2,760.23',
          style: TextStyle(
            fontFamily: 'Readex Pro',
            fontSize: 30,
            fontWeight: FontWeight.w600,
            height: 1.2,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        Text(
          '+2.60%',
          style: TextStyle(
            fontFamily: 'Readex Pro',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class AssetContainer extends StatelessWidget {
  const AssetContainer({Key? key, required this.rateItem}) : super(key: key);

  final RateItem rateItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),

        border: Border(top: BorderSide(color: Colors.grey.shade400, width: 1.0),)
      ),
      child: Column(
        children: [
          const AssetContainerHeader(),
          AssetDetails(rateItem: rateItem),
          const SizedBox(height: 20),
          const CenterText(),
          const SizedBox(height: 30),
          const HistoryDetails(),
        ],
      ),
    );
  }
}

class AssetContainerHeader extends StatelessWidget {
  const AssetContainerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Assets',
            style: TextStyle(
              fontFamily: 'Readex Pro',
              fontSize: 12,
              fontWeight: FontWeight.w200,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {

                  // Handle search action
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                  // Handle settings action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AssetDetails extends StatelessWidget {
  const AssetDetails({Key? key, required this.rateItem}) : super(key: key);

  final RateItem rateItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Image.asset(
            rateItem.flagImage!,
            width: 46,
            height: 46,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rateItem.name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                rateItem.currency,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: AppColors.currencyColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 80,
          height: 40,
          child: MiniChart(
            ratesHistory: rateItem.rateHistory,
            rateColor: rateItem.rateColor,
          ),
        ),
        const SizedBox(width: 40),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              rateItem.difference > 0
                  ? '+${rateItem.difference}'
                  : '${rateItem.difference}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: rateItem.difference > 0
                    ? AppColors.positiveRate
                    : AppColors.negativeRate,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${rateItem.rateInCents / 100}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
      ],


    );


  }
}

class CenterText extends StatelessWidget {
  const CenterText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // const Divider(color: Colors.grey, ),

            Text(
      'Transaction History',
      style: TextStyle(
        fontFamily: 'Readex Pro',
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    ),
          ]);
  }
}

class HistoryDetails extends StatelessWidget {
  const HistoryDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HistoryHeader(),
        const HistoryItem(price: '500000', amount: '50', time: '12:00'),
        const HistoryItem(price: '517500', amount: '75', time: '12:30'),
        const HistoryItem(price: '507500', amount: '60', time: '13:00'),       const HistoryItem(price: '500000', amount: '50', time: '12:00'),
        const HistoryItem(price: '517500', amount: '75', time: '12:30'),
        const HistoryItem(price: '507500', amount: '60', time: '13:00'),       const HistoryItem(price: '500000', amount: '50', time: '12:00'),
        const HistoryItem(price: '507500', amount: '60', time: '13:00'),
      ],
    );
  }
}

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: const [
          Text(
            'Price',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Readex Pro',
              fontSize: 12,
            ),
          ),
          Text(
            'Amount',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Readex Pro',
              fontSize: 12,
            ),
          ),
          Text(
            'Time',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Readex Pro',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    Key? key,
    required this.price,
    required this.amount,
    required this.time,
  }) : super(key: key);

  final String price;
  final String amount;
  final String time;

  @override
  Widget build(BuildContext context) {
    return
      Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(price,style: TextStyle(fontSize: 12),),
          Text(amount,style: TextStyle(fontSize: 12)),
          Text(time,style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
