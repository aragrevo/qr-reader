import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_reader/models/scan_model.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({Key? key}) : super(key: key);

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType _mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)?.settings.arguments as ScanModel;

    final CameraPosition initialPoint = setInitialPoint(scan);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coordenadas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(setInitialPoint(scan)));
            },
          ),
        ],
      ),
      body: GoogleMap(
        markers: _buildMarkers(scan),
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        mapType: _mapType,
        initialCameraPosition: initialPoint,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.layers_outlined),
        onPressed: () {
          setState(() {
            _mapType =
                _mapType == MapType.normal ? MapType.hybrid : MapType.normal;
          });
        },
      ),
    );
  }

  CameraPosition setInitialPoint(ScanModel scan) {
    return CameraPosition(
      target: scan.getLatLng(),
      zoom: 14.4746,
    );
  }

  Set<Marker> _buildMarkers(ScanModel scan) {
    // ignore: prefer_collection_literals
    Set<Marker> markers = Set<Marker>();
    markers.add(Marker(
      markerId: const MarkerId('geo-location'),
      position: scan.getLatLng(),
      icon: BitmapDescriptor.defaultMarker,
    ));
    return markers;
  }
}
