import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../widget/button.dart';
import '../../../widget/show_dialog.dart';

class EditAddressScreen extends StatefulWidget {
  final Map<String, dynamic> addressData;

  const EditAddressScreen({super.key, required this.addressData});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late LatLng _currentPosition;
  bool _isDefault = false;
  GoogleMapController? mapController;

  // --- Dark Map Style JSON ---
  final String darkMapStyle = '''
[
  { "elementType": "geometry", "stylers": [{ "color": "#212121" }] },
  { "elementType": "labels.icon", "stylers": [{ "visibility": "off" }] },
  { "elementType": "labels.text.fill", "stylers": [{ "color": "#757575" }] },
  { "elementType": "labels.text.stroke", "stylers": [{ "color": "#212121" }] },
  { "featureType": "administrative", "elementType": "geometry", "stylers": [{ "color": "#757575" }] },
  { "featureType": "road", "elementType": "geometry.fill", "stylers": [{ "color": "#2c2c2c" }] },
  { "featureType": "water", "elementType": "geometry", "stylers": [{ "color": "#000000" }] }
]
''';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.addressData['title']);
    _addressController = TextEditingController(
      text: widget.addressData['address'],
    );
    _isDefault = widget.addressData['isDefault'] ?? false;
    _currentPosition = const LatLng(11.5564, 104.9282);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _addressController.text =
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> _goToCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    LatLng newLatLng = LatLng(position.latitude, position.longitude);
    mapController?.animateCamera(CameraUpdate.newLatLngZoom(newLatLng, 16.0));
    await _getAddressFromLatLng(newLatLng);
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
        centerTitle: true,
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        title: TextWidget(
          "Edit Address".tr,
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 15.5,
            ),
            style: isDark ? darkMapStyle : null,
            onMapCreated: (controller) => mapController = controller,
            onCameraMove: (position) => _currentPosition = position.target,
            onCameraIdle: () => _getAddressFromLatLng(_currentPosition),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Icon(
                Icons.location_on,
                size: 50,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),

          // Floating Action Buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 75,
            right: 20,
            child: Column(
              children: [
                _buildMapActionButton(
                  context,
                  icon: Icons.delete_outline,
                  color: AppColor.mutedRed,
                  onTap: _confirmDelete,
                ),
                const SizedBox(height: 15),
                _buildMapActionButton(
                  context,
                  icon: Icons.my_location,
                  color: isDark ? Colors.white : Colors.black,
                  onTap: _goToCurrentLocation,
                ),
              ],
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.45,
            maxChildSize: 0.85,
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
                      "Address Details".tr,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    const Divider(height: 30),

                    _buildLabel(context, "Name Address".tr),
                    _buildTextField(context, _nameController, "e.g. Home".tr),

                    const SizedBox(height: 20),
                    _buildLabel(context, "Address Details".tr),
                    _buildTextField(
                      context,
                      _addressController,
                      "Location details".tr,
                      icon: Icons.location_on,
                    ),

                    CheckboxListTile(
                      value: _isDefault,
                      onChanged: (val) => setState(() => _isDefault = val!),
                      title: TextWidget(
                        "Set as default address".tr,
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: isDark ? Colors.white : Colors.black,
                      contentPadding: EdgeInsets.zero,
                    ),

                    const SizedBox(height: 20),
                    MyCustomButton(
                      text: 'Update Address'.tr,
                      onPressed: () {
                        final updatedData = {
                          "title": _nameController.text,
                          "address": _addressController.text,
                          "isDefault": _isDefault,
                        };
                        Navigator.pop(context, updatedData);
                      },
                      width: double.infinity,
                      height: 58,
                      borderRadius: 16,
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

  Widget _buildMapActionButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => StatusDialog(
        title: "Delete Address?".tr,
        message: "Are you sure you want to remove this address?".tr,
        btn1Text: "Cancel".tr,
        btn2Text: "Delete".tr,
        icon: Icons.delete_sweep,
        iconColor: AppColor.mutedRed,
        onBtn1Pressed: () => Navigator.pop(context),
        onBtn2Pressed: () {
          Navigator.pop(context);
          Navigator.pop(context, "deleted");
        },
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextWidget(
        text,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white70 : Colors.black,
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
