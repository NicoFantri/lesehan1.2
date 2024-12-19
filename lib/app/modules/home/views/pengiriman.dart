import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/home_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_card.dart';
import 'package:permission_handler/permission_handler.dart';
import '../views/chat_view.dart'; // A

class PengirimanView extends StatefulWidget {
  const PengirimanView({Key? key}) : super(key: key);

  @override
  _PengirimanViewState createState() => _PengirimanViewState();
}

class _PengirimanViewState extends State<PengirimanView> {
  late GoogleMapController _mapController;

  // Simulated current user location (Jakarta area)
  final Rx<LatLng> _currentPosition = Rx(LatLng(-6.2088, 106.8456));

  // Simulated restaurant location
  final Rx<LatLng> _restaurantPosition = Rx(LatLng(-6.2146, 106.8451));

  // Delivery destination
  final Rx<LatLng> _deliveryDestination = Rx(LatLng(-6.2037, 106.8479));

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  void _requestPermissions() async {
    if (await Permission.location
        .request()
        .isGranted) {
      print("Permission granted");
    } else {
      print("Permission denied");
    }
  }

  @override
  void initState() {
    super.initState();
    _createMarkers();
    _createDeliveryRoute();
    _requestPermissions();
  }

  void _createMarkers() {
    _markers.addAll([
      Marker(
        markerId: MarkerId('current_location'),
        position: _currentPosition.value,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Lokasi Anda'),
      ),
      Marker(
        markerId: MarkerId('restaurant'),
        position: _restaurantPosition.value,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'Restoran'),
      ),
      Marker(
        markerId: MarkerId('delivery_destination'),
        position: _deliveryDestination.value,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(title: 'Tujuan Pengiriman'),
      ),
    ]);
  }

  void _createDeliveryRoute() {
    List<LatLng> routePoints = _generateRoutePoints(
        _currentPosition.value,
        _restaurantPosition.value,
        _deliveryDestination.value
    );

    _polylines.add(
      Polyline(
        polylineId: PolylineId('delivery_route'),
        points: routePoints,
        color: AppColors.primary,
        width: 5,
      ),
    );
  }

  List<LatLng> _generateRoutePoints(LatLng start, LatLng restaurant,
      LatLng destination) {
    return [
      start,
      LatLng((start.latitude + restaurant.latitude) / 2,
          (start.longitude + restaurant.longitude) / 2),
      restaurant,
      LatLng((restaurant.latitude + destination.latitude) / 2,
          (restaurant.longitude + destination.longitude) / 2),
      destination
    ];
  }

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(height: 10),
                        _buildMapSection(),
                        SizedBox(height: 20),
                        _buildCourierProfileCard(),
                        SizedBox(height: 20),
                        _buildDeliveryInfoCard(),
                        SizedBox(height: 20),
                        _buildTrackingButton(),
                        SizedBox(height: 40), // Additional spacing
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Get.back(),
          ),
          Text(
            "Pengiriman Pesanan",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 48), // Placeholder untuk menjaga keseimbangan
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Obx(() =>
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition.value,
                zoom: 13,
              ),
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: _markers,
              polylines: _polylines,
              zoomControlsEnabled: true,
            )),
      ),
    );
  }

  void _handleChatWithCourier() {
    // Navigate to the ChatView
    Get.to(() => ChatView());
  }

  Widget _buildCourierProfileCard() {
    return CustomCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Profil Kurir"),
          SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/kurir.png'),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Budi Setiawan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      "Motor - B 1234 XYZ",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildContactButton(
                    icon: Icons.chat,
                    onPressed: _handleChatWithCourier, // Updated to navigate to chat
                  ),
                  SizedBox(width: 8),
                  _buildContactButton(
                    icon: Icons.call,
                    onPressed: _handleCallCourier,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required VoidCallback onPressed
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primary),
        onPressed: onPressed,
        iconSize: 24,
      ),
    );
  }


  void _handleCallCourier() {
    Get.snackbar(
      'Error',
      'Tidak dapat melakukan panggilan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDeliveryInfoCard() {
    return CustomCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Informasi Pengiriman"),
          SizedBox(height: 12),
          _buildDeliveryInfoRow(
              Icons.location_on,
              "Alamat Pengiriman",
              "Jl. Merdeka No. 123, Jakarta Pusat"
          ),
          SizedBox(height: 8),
          _buildDeliveryInfoRow(
              Icons.local_shipping,
              "Estimasi Pengiriman",
              "30-45 Menit"
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingButton() {
    return ElevatedButton(
      onPressed: _handleTrackOrder,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 56),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        "Lacak Pesanan Detail",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleTrackOrder() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Status Pengiriman",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 20),
            _buildTrackingStep("Pesanan Diproses", true),
            _buildTrackingStep("Menunggu Kurir", true),
            _buildTrackingStep("Dalam Perjalanan", true),
            _buildTrackingStep("Sedang Diantar", false),
            _buildTrackingStep("Sampai Tujuan", false),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildTrackingStep(String title, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? AppColors.primary : Colors.grey[300],
            ),
            child: isCompleted
                ? Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: isCompleted ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
