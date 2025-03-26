import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionDetails extends StatelessWidget {
  final String missionName;
  final double fromLat, fromLng, toLat, toLng;
  final int landminesDetected;
  final String missionDate;

  const MissionDetails({
    Key? key,
    required this.missionName,
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
    required this.landminesDetected,
    required this.missionDate,
  }) : super(key: key);

  // Function to open Google Maps
  void _openGoogleMaps() async {
    final Uri googleMapsUri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&origin=$fromLat,$fromLng&destination=$toLat,$toLng&travelmode=driving",
    );

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    } else {
      throw 'Could not open Google Maps.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Optional AppBar; remove if you want a pure full‐screen look
      appBar: AppBar(
        title: Text(missionName),

      ),
      body: Stack(
        children: [
          // 1) Full-screen background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/map.png',
              fit: BoxFit.cover,
            ),
          ),
          // 2) Bottom-left info box
          Positioned(
            left: 20,
            bottom: 20,
            child: Container(
              width: 300, // adjust width to match your design
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildMissionInfo(),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the actual mission-info layout inside the box
  Widget _buildMissionInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$missionName:',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // FROM lat/long
        Text(
          'FROM $fromLat\nTO   $toLat',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        // Landmines detected
        Text(
          '$landminesDetected Landmines were detected!',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // Follow safe path
        const Text(
          'Follow the safe path to avoid landmines',
          style: TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        // DIRECTIONS Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
          ),
          onPressed: _openGoogleMaps,
          child: const Text(
            'DIRECTIONS',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
