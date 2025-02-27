import 'package:flutter/material.dart';

class TeamScreen extends StatefulWidget {
  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    _buildLevelContent(),
    _buildLevelContent(),
    _buildLevelContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Team',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTabButton('Level-1', 0),
              _buildTabButton('Level-2', 1),
              _buildTabButton('Level-3', 2),
            ],
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? Colors.red : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: _selectedIndex == index ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget _buildLevelContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '0',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Total number of registered', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 10),
          Text(
            '0',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Total number of rechargers', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 10),
          Text(
            '\$0.00',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Total recharge amount', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 10),
          Text(
            '\$0.00',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Total withdrawal amount', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
