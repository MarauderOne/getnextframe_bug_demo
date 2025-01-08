import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:getnextframe_bug_demo/listings.dart';
import 'package:getnextframe_bug_demo/strings_to_latlng.dart';
import 'package:getnextframe_bug_demo/themes.dart';

// Define a GlobalKey for MapPageState:
final GlobalKey<MapPageState> mapPageKey = GlobalKey<MapPageState>();

class MapPage extends StatefulWidget {
  final List<Map<String, dynamic>> listings;

  const MapPage({required this.listings, super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // For displaying the map markers
  GoogleMapController? _controller;

  @override
  void initState() {
    addAllMarkers();
    super.initState();
  }

  void addAllMarkers() {
    for (var listing in listings) {
      addMarker(listing);
    }
  }

  addMarker(listing) async {
    LatLng destinationLatLng = stringToLatLng(listing['latLng']);
    MarkerId markerId = MarkerId(listing['id'].toString());
    Color color = getCategoryColor('light', listing['primaryType']);
    BitmapDescriptor customMarker = await getColoredMarker(listing['primaryType'], color);

    Marker newMarker = Marker(
      markerId: markerId,
      position: destinationLatLng,
      icon: customMarker,
      visible: true,
      onTap: () {},
    );

    setState(() {
      markers[markerId] = newMarker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        rotateGesturesEnabled: false,
        compassEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapToolbarEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(52.199174, 0.140929),
          zoom: 14.3,
        ),
        markers: markers.values.toSet(),
      ),
    );
  }
}
