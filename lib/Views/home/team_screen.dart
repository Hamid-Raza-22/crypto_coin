import 'package:flutter/material.dart';
import '../../Components/custom_appbar.dart';
import '../../Utilities/global_variables.dart';
class TeamScreen extends StatefulWidget {
  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Content for Level-1', style: TextStyle(fontSize: 20))),
    Center(child: Text('Content for Level-2', style: TextStyle(fontSize: 20))),
    Center(child: Text('Content for Level-3', style: TextStyle(fontSize: 20))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton('Level-1', 0),
                _buildTabButton('Level-2', 1),
                _buildTabButton('Level-3', 2),
              ],
            ),
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedIndex == index ? Colors.white : Colors.grey.shade300,
          foregroundColor: _selectedIndex == index ? Colors.black : Colors.grey,
          elevation: 0,
          side: BorderSide(color: Colors.grey.shade400),
        ),
        child: Text(text),
      ),
    );
  }
}
