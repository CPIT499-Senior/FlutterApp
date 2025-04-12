import 'package:flutter/material.dart';
import 'MissionDetails.dart';

class PreviousMissions extends StatelessWidget {
  final String username;

  const PreviousMissions({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/login_bg.png',
            fit: BoxFit.cover,
          ),

          // Main Content
          Column(
            children: [
              // Top White Banner with Profile
              Container(
                height: 130,
                color: Colors.white.withOpacity(0.6),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 60, color: Colors.black),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          'Welcome',
                          style: TextStyle(fontSize: 25, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(25, 20, 25, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Previous missions:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  children: [
                    _missionCard('Mission01', '19.7672904, 46.0550221', 35, '10/12/2025', context),
                    _missionCard('Mission02', '29.7670004, 16.0569621', 25, '20/12/2025', context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _missionCard(String title, String coordinates, int detected, String date, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title: ($coordinates)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('Detected landmine: $detected'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(date, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MissionDetails(
                          missionName: title,
                          fromLat: 19.7672904,
                          fromLng: 46.0550221,
                          toLat: 29.7670004,
                          toLng: 16.0569621,
                          landminesDetected: detected,
                          missionDate: date,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Show more',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
