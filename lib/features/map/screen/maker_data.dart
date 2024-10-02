import 'package:latlong2/latlong.dart';
class MakerData{
  final LatLng position;
  final String title;
  final String description;

  MakerData(
    {required this.position, required this.title, required this.description}
  );
}