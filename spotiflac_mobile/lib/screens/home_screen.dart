import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();

  void _processUrl() {
    // Logic to call Services will go here
    final url = _urlController.text;
    if (url.isEmpty) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Processing: $url')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('SpotiFLAC', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to Settings
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Paste Spotify Link",
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _urlController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'https://open.spotify.com/track/...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Color(0xFF1DB954)),
                  onPressed: _processUrl,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
