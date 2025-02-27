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
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          SizedBox(height: 10),
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
         // SizedBox(height: 5),
        ],
      ),
    );
  }


  // Hierarchy Section with Tree Design
  Widget _buildHierarchySection() {
    return Column(
      children: [
         Text('REWARDS', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontWeight: FontWeight.bold)),

        Container(
          color: Colors.red,
          padding: const EdgeInsets.all(10),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
             // Text('REWARDS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('LEVEL 1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('LEVEL 2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('LEVEL 3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
             // Text('', style: TextStyle(fontWeight: FontWeight.bold)),
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
            // First Image (Top)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white // Light mode: white background
                    : Colors.grey[200]!, // Dark mode: light gray background
                borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
              ),
              child: Image.asset(
                'assets/images/people.png',
                width: 80,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),

            // Second Row (Two Images with Arrows)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Icon(Icons.arrow_downward, color: Colors.red),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[200]!,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/images/people.png',
                        width: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 80),
                Column(
                  children: [
                    const Icon(Icons.arrow_downward, color: Colors.red),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[200]!,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/images/people.png',
                        width: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Third Row (Six Images with Arrows)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return Column(
                  children: [
                    const Icon(Icons.arrow_downward, color: Colors.red, size: 20),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[200]!,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/images/people.png',
                        width: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 20),

            // Fourth Row (Twelve Images with Arrows)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(12, (index) {
                return Column(
                  children: [
                    const Icon(Icons.arrow_downward, color: Colors.red, size: 15),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[200]!,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/images/people.png',
                        width: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 20),
         Text(
          'APPLICABLE FOR DEPOSIT & WITHDRAWAL',
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color,),
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
