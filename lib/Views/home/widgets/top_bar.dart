part of '../wallet_screen.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.margin,
  });

  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/images/menu.png',
              width: 28,
              color: Colors.black,
            ),
          ),
          Flexible(
            child: Image.asset(
              'assets/images/logo.png',
              height: 24, // Adjust the height as needed
              fit: BoxFit.cover,
            ),
          ),
          Text("Crypto Coin",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.indigoAccent
          ),),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/user.png'),
          )
        ],
      ),
    );
  }
}
