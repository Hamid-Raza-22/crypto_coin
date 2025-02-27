import 'package:flutter/material.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

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
        title: const Text(
          'Team',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _pages[_selectedIndex],
                  const SizedBox(height: 20),
                  _buildHierarchySection(),
                ],
              ),
            ),
          ),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '0',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total number of registered',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '0',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total number of rechargers',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '0',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total Bonus Earned',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }


  // Hierarchy Section with Tree Design
  Widget _buildHierarchySection() {
    return Column(
      children: [
        Container(
          color: Colors.red,
          padding: const EdgeInsets.all(10),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('REWARDS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('LEVEL 1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('LEVEL 2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('LEVEL 3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('\$1', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$0.5', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$0.25', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Tree Structure with Images and Arrows
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/people.png', width: 80),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Icon(Icons.arrow_downward, color: Colors.red),
                    Image.asset('assets/images/people.png', width: 60),
                  ],
                ),
                const SizedBox(width: 80),
                Column(
                  children: [
                    const Icon(Icons.arrow_downward, color: Colors.red),
                    Image.asset('assets/images/people.png', width: 60),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return Column(
                  children: [
                    const Icon(Icons.arrow_downward, color: Colors.red, size: 20),
                    Image.asset('assets/images/people.png', width: 40),
                  ],
                );
              }),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(12, (index) {
                return Column(
                  children: [
                    const Icon(Icons.arrow_downward, color: Colors.red, size: 15),
                    Image.asset('assets/images/people.png', width: 30),
                  ],
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'APPLICABLE FOR DEPOSIT & WITHDRAWAL',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text(
          'TERMS & CONDITIONS: SAME.',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
