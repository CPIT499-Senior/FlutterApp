
import 'package:flutter/material.dart';

import 'MissionDetails.dart';

class PreviousMissions extends StatelessWidget {
  const PreviousMissions({super.key});

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.cover,
              ),
            ),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50), // Adjust for status bar
                // Profile Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, size: 40, color: Colors.black),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GHAIDA ALQURASHI',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Welcome',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Previous missions:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                // Mission Cards
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title: ($coordinates)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('Detected landmine: $detected'),
              ],
            ),
            Column(
              children: [
                Text(date, style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to MissionDetailsPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MissionDetails(
                          missionName: "Mission01",
                          fromLat: 19.7672904,
                          fromLng: 46.0550221,
                          toLat: 29.7670004,
                          toLng: 16.0569621,
                          landminesDetected: 34,
                          missionDate: "20/12/2025",
                        ),
                      ),
                    );

                  },
                  child: Text(
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
