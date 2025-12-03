import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/location_service.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  Position? _position;
  bool _isLoading = false;
  String _error = '';
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    Position? pos = await LocationService.getCurrentPosition();

    if (!mounted) {
      return;
    }

    if (pos == null) {
      setState(() {
        _isLoading = false;
        _error = 'Location not available. Please enable GPS / permission.';
      });
    } else {
      setState(() {
        _position = pos;
        _isLoading = false;
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(pos.latitude, pos.longitude),
              zoom: 16,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live Tracker',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF020617),
      ),
      backgroundColor: const Color(0xFF050816),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: later open NewActivityScreen with current position
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add_location_alt_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Location',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildStatusCard(),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _loadLocation,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Location'),
            ),

            const SizedBox(height: 16),

            _buildMapSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    if (_isLoading) {
      return Card(
        child: SizedBox(
          height: 100,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Getting GPS location...'),
              ],
            ),
          ),
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_error, style: const TextStyle(color: Colors.redAccent)),
        ),
      );
    }

    if (_position == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No location yet. Tap "Refresh Location".'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Latitude / Longitude',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text('Lat: ${_position!.latitude.toStringAsFixed(6)}'),
            Text('Lng: ${_position!.longitude.toStringAsFixed(6)}'),
            const SizedBox(height: 8),
            Text(
              'Accuracy: ${_position!.accuracy.toStringAsFixed(1)} m',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    const double mapHeight = 260;

    if (_position == null) {
      return SizedBox(
        height: mapHeight,
        child: Card(
          child: Center(
            child: Text(
              'Map will show once location is available.',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ),
      );
    }

    final LatLng target = LatLng(_position!.latitude, _position!.longitude);

    final Set<Marker> markers = <Marker>{
      Marker(
        markerId: const MarkerId('current'),
        position: target,
        infoWindow: const InfoWindow(title: 'You are here'),
      ),
    };

    return SizedBox(
      height: mapHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: target, zoom: 16),
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: markers,
          compassEnabled: true,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
      ),
    );
  }
}
