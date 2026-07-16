import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  GoogleMapController? mapController;
  final TextEditingController _nameController = TextEditingController(
    text: "Apartment",
  );
  final TextEditingController _addressController = TextEditingController();
  LatLng _currentPosition = const LatLng(11.5564, 104.9282);
  bool _isDefault = false;

  final String darkMapStyle = '''
[
  { "elementType": "geometry", "stylers": [{ "color": "#212121" }] },
  { "elementType": "labels.icon", "stylers": [{ "visibility": "off" }] },
  { "elementType": "labels.text.fill", "stylers": [{ "color": "#757575" }] },
  { "elementType": "labels.text.stroke", "stylers": [{ "color": "#212121" }] },
  { "featureType": "administrative", "elementType": "geometry", "stylers": [{ "color": "#757575" }] },
  { "featureType": "landscape", "elementType": "geometry", "stylers": [{ "color": "#212121" }] },
  { "featureType": "poi", "elementType": "geometry", "stylers": [{ "color": "#333333" }] },
  { "featureType": "road", "elementType": "geometry.fill", "stylers": [{ "color": "#2c2c2c" }] },
  { "featureType": "road", "elementType": "labels.text.fill", "stylers": [{ "color": "#8a8a8a" }] },
  { "featureType": "water", "elementType": "geometry", "stylers": [{ "color": "#000000" }] }
]
''';

  final String lightMapStyle = '''
[
  { "elementType": "geometry", "stylers": [{ "color": "#f5f5f5" }] },
  { "featureType": "landscape", "elementType": "geometry", "stylers": [{ "color": "#e0f4f1" }] },
  { "featureType": "water", "elementType": "geometry", "stylers": [{ "color": "#aadaff" }] }
]
''';

  MapType _currentMapType = MapType.normal;

  void _showMapTypeSelector(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          height: 240,
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 15),
              TextWidget(
                "Map Type",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _mapTypeItem(
                    "Default",
                    MapType.normal,
                    'https://i.sstatic.net/rUA7c.png',
                  ),
                  _mapTypeItem(
                    "Satellite",
                    MapType.satellite,
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMtNTbmYEibQQkk2v--nTlZs8D0KZaAWrYCw&s',
                  ),
                  _mapTypeItem(
                    "Terrain",
                    MapType.terrain,
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOYyx4JXs1SL410TfqkqzPpgK25gNKIepdCw&s',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _mapTypeItem(String title, MapType type, String imageUrl) {
    bool isSelected = _currentMapType == type;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() => _currentMapType = type);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 3,
              ),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextWidget(
            title,
            fontSize: 13,
            color: isSelected
                ? Colors.blue
                : (isDark ? Colors.white70 : Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);
    setState(() {});
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition, zoom: 16),
      ),
    );
    _getAddressFromLatLng(_currentPosition);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark p = placemarks[0];
        setState(
          () => _addressController.text =
              "${p.name}, ${p.street}, ${p.subLocality}, ${p.locality}",
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        title: TextWidget(
          "Add New Address",
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 15.5,
            ),
            style: _currentMapType == MapType.normal
                ? (isDark ? darkMapStyle : lightMapStyle)
                : null,
            onMapCreated: (controller) => mapController = controller,
            onCameraMove: (position) => _currentPosition = position.target,
            onCameraIdle: () => _getAddressFromLatLng(_currentPosition),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          // Custom Marker (Center Pin)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 50,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ],
              ),
            ),
          ),

          // Map Control Buttons
          Positioned(
            right: 20,
            bottom: MediaQuery.of(context).size.height * 0.48,
            child: Column(
              children: [
                _mapBtn(
                  Icons.layers_outlined,
                  () => _showMapTypeSelector(context),
                ),
                const SizedBox(height: 12),
                _mapBtn(
                  Icons.add,
                  () => mapController?.animateCamera(CameraUpdate.zoomIn()),
                ),
                const SizedBox(height: 12),
                _mapBtn(
                  Icons.remove,
                  () => mapController?.animateCamera(CameraUpdate.zoomOut()),
                ),
                const SizedBox(height: 12),
                _mapBtn(Icons.my_location, _determinePosition),
              ],
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.45,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF121212) : Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black54 : Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextWidget(
                      "Address Details",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    const Divider(height: 30),
                    _buildLabel(context, "Name Address"),
                    _buildTextField(context, _nameController, "e.g. Home"),
                    const SizedBox(height: 20),
                    _buildLabel(context, "Address Details"),
                    _buildTextField(
                      context,
                      _addressController,
                      "Location details",
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      value: _isDefault,
                      activeColor: isDark ? Colors.white : Colors.black,
                      onChanged: (val) => setState(() => _isDefault = val!),
                      title: TextWidget(
                        "Make this as the default address",
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.white : Colors.black,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        minimumSize: const Size(double.infinity, 58),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        final newAddress = {
                          "title": _nameController.text,
                          "address": _addressController.text,
                          "isDefault": _isDefault,
                        };
                        Navigator.pop(context, newAddress);
                      },
                      child: TextWidget(
                        "Add Address",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _mapBtn(IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onPressed: onTap,
      child: Icon(icon, color: isDark ? Colors.white : Colors.black, size: 20),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextWidget(
        label,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white70 : Colors.black87,
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
    String hint, {
    IconData? icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        prefixIcon: icon != null
            ? Icon(icon, color: isDark ? Colors.white54 : Colors.black54)
            : null,
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26),
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 16,
        ),
      ),
    );
  }
}
