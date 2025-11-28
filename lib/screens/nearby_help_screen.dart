import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NearbyHelpScreen extends StatefulWidget {
  const NearbyHelpScreen({super.key});

  @override
  State<NearbyHelpScreen> createState() => _NearbyHelpScreenState();
}

class _NearbyHelpScreenState extends State<NearbyHelpScreen> {
  List<Map<String, dynamic>> _places = [];
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _getNearbyPlaces();
  }

  Future<void> _getNearbyPlaces() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _error = 'Please enable location services.';
        _loading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _error = 'Location permission denied.';
          _loading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _error = 'Location permissions permanently denied.';
        _loading = false;
      });
      return;
    }

    // ← NEW 2025 WAY ↓
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // meters
      ),
    );
    // ← END NEW WAY

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=${position.latitude},${position.longitude}'
      '&radius=10000'
      '&keyword=mental+health|therapist|counseling|psychologist'
      '&key=${dotenv.env['GOOGLE_PLACES_API_KEY']}',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _places = (data['results'] as List).take(10).map((p) => {
              'name': p['name'] ?? 'Unknown',
              'vicinity': p['vicinity'] ?? 'No address',
              'rating': p['rating']?.toString() ?? 'N/A',
              'place_id': p['place_id'],
            }).toList();
        _loading = false;
      });
    } else {
      setState(() {
        _error = 'Failed to load places.';
        _loading = false;
      });
    }
  } catch (e) {
    setState(() {
      _error = 'Error: $e';
      _loading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF39FF14)));
    }
    if (_error.isNotEmpty) {
      return Center(child: Text(_error, style: GoogleFonts.inter(color: Colors.red)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _places.length,
      itemBuilder: (ctx, index) {
        return Card(
          color: const Color(0xFF1A1F2E),
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text(_places[index]['name'], style: GoogleFonts.inter(color: const Color(0xFF39FF14))),
            subtitle: Text(_places[index]['vicinity'], style: GoogleFonts.inter()),
            trailing: Text('★ ${_places[index]['rating']}', style: GoogleFonts.inter()),
            onTap: () async {
              final mapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=${_places[index]['name']}&query_place_id=${_places[index]['place_id']}');
              if (await canLaunchUrl(mapsUrl)) {
                await launchUrl(mapsUrl);
              }
            },
          ),
        );
      },
    );
  }
}