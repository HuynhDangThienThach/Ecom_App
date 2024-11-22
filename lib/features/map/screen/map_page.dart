import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t_store/features/map/screen/maker_data.dart';
import 'package:http/http.dart' as http;

class Map_Page extends StatefulWidget {
  final String? mediQuickAddress;
  const Map_Page({super.key, this.mediQuickAddress});

  @override
  State<Map_Page> createState() => _Map_PageState();
}

class _Map_PageState extends State<Map_Page> {
  final MapController _mapController = MapController();
  final List<MakerData> _makerData = [];
  final List<Marker> _maker = [];
  LatLng? _selectedPosition;
  LatLng? _mylocation;
  LatLng? _draggedPosition;
  bool _isDragging = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResult = [];
  bool _isSearching = false;

  // Get current location
  Future<Position> _determinePosition() async{
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error("Location services are disabled");
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error("Location permissions are denied");
      }
    }
    if(permission == LocationPermission.deniedForever){
      return Future.error("Location permissions are permanently denied");
    }
    return await Geolocator.getCurrentPosition();
  }

  // Show currently location
  void _showCurrentLocation() async{
    try{
      Position position = await _determinePosition();
      LatLng currentLating = LatLng(position.latitude, position.longitude);
      _mapController.move(currentLating, 15.0);
    } catch (e){
      print(e);
    }
  }

  // add maker on selected location anywhere you want to
  void _addMaker(LatLng position, String title, String description) async {
    setState(() {
      final markerData = MakerData(position: position, title: title, description: description);
      _makerData.add(markerData);
      _maker.add(
        Marker(
          point: position,
          width: 200,
          height: 200,
          child: GestureDetector(
            onTap: () => _showMrkerInfo(markerData),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                  size: 40,
                ),
              ],
            ),
          ),
        ),
      );
    });

    // Lưu dữ liệu Marker vào SharedPreferences
    await _saveMarkersToSharedPreferences();
  }

  Future<void> _saveMarkersToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final markerList = _makerData.map((marker) {
      return {
        'lat': marker.position.latitude,
        'lng': marker.position.longitude,
        'title': marker.title,
        'description': marker.description,
      };
    }).toList();
    prefs.setString('markers', jsonEncode(markerList)); // Lưu danh sách marker dưới dạng JSON
  }


  // Show maker dialog
  void _showMarkerDialog(BuildContext context, LatLng potision){
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Thêm địa điểm"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: "Tên địa điểm"),
          ),

        ],
      ),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text("Hủy")),
        TextButton(
            onPressed: (){
              _addMaker(potision, titleController.text, descController.text);
              Navigator.pop(context);
            },
            child: const Text("Lưu")),
      ],
    ));
  }

  // Show marker info when tapped
  // add featured
  void _showMrkerInfo(MakerData markerData){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(markerData.title),
          content: Text(markerData.description),
          actions: [
            IconButton(
                onPressed: (){
                  Navigator.pop(context);
                }, icon: const Icon(Icons.close)
            )
          ],
        ));
  }


  // Search feature
  Future<void> _searchPlaces(String query) async{
    if(query.isEmpty){
      setState(() {
        _searchResult =[];
      });
      return;
    }
    final url = "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5";
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    if (data.isNotEmpty){
      setState(() {
        _searchResult = data;
      });
    } else{
      setState(() {
        _searchResult =[];
      });
    }
  }

  // move to specific location
  void _moveToLocation(double lat, double lon){
    LatLng location = LatLng(lat, lon);
    _mapController.move(location, 15.0);
    setState(() {
      _selectedPosition = location;
      _searchResult = [];
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener((){
      _searchPlaces(_searchController.text);
    });

    if (widget.mediQuickAddress != null) {
      _searchController.text = widget.mediQuickAddress!;
      _searchPlaces(widget.mediQuickAddress!);
    }
    _loadMarkersFromSharedPreferences();
  }

  Future<void> _loadMarkersFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final markerString = prefs.getString('markers');

    if (markerString != null) {
      final List<dynamic> markerList = jsonDecode(markerString);
      setState(() {
        for (var markerJson in markerList) {
          final position = LatLng(markerJson['lat'], markerJson['lng']);
          final title = markerJson['title'];
          final description = markerJson['description'];

          final markerData = MakerData(position: position, title: title, description: description);
          _makerData.add(markerData);

          _maker.add(
            Marker(
              point: position,
              width: 200,
              height: 200,
              child: GestureDetector(
                onTap: () => _showMrkerInfo(markerData),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(
                      Icons.location_on,
                      color: Colors.redAccent,
                      size: 40,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      });
    }
  }
  // Future<void> _clearMarkers() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('markers');
  //   setState(() {
  //     _makerData.clear();
  //     _maker.clear();
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialZoom: 13.0,
                onTap: (tapPosition, latLng){
                 setState(() {
                   _selectedPosition = latLng;
                   _draggedPosition = _selectedPosition;
                 });
                }
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                MarkerLayer(markers: _maker),
                if(_isDragging && _draggedPosition !=null)
                  MarkerLayer(markers: [
                    Marker(
                      point: _draggedPosition!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.indigo,
                        size: 40,
                      ),
                    )
                  ]
                  ),
                if(_mylocation !=null)
                  MarkerLayer(markers: [
                    Marker(
                      point: _mylocation!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 40,
                      ),
                    )
                  ]
                  )
              ]
          ),
          // Search widget
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: Column(
              children: [
                SizedBox(
                  height: 55,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm địa điểm",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _isSearching ? IconButton(onPressed: (){
                        _searchController.clear();
                        setState(() {
                          _isSearching = false;
                          _searchResult = [];
                        });
                      }, icon: const Icon(Icons.clear)): null
                    ),
                    onTap: (){
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
                ),
                if(_isSearching && _searchResult.isNotEmpty)
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResult.length,
                      itemBuilder: (ctx, index){
                        final place = _searchResult[index];
                        return ListTile(
                          title: Text(
                            place['display_name'],
                          ),
                          onTap: (){
                            final lat = double.parse(place['lat']);
                            final lon = double.parse(place['lon']);
                            _moveToLocation(lat, lon);
                          },
                        );
                      },
                    ),
                  )
              ],
            )
          ),
          /// add Location button
          _isDragging == false ? Positioned(
              bottom: 20,
              left: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                onPressed: (){
                  setState(() {
                    _isDragging = true;
                  });
              },
              child: const Icon(Icons.add_location)
          ),
          ): Positioned(
              bottom: 20,
              left: 20,
              child: FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  onPressed: (){
                    setState(() {
                      _isDragging = false;
                    });
                  },
                  child: const Icon(Icons.add_location)
              ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _isDragging = true;
                    });
                  },
                  child: const Icon(Icons.add_location),
                ),
                // const SizedBox(height: 10),
                // FloatingActionButton(
                //   backgroundColor: Colors.redAccent,
                //   foregroundColor: Colors.white,
                //   onPressed: () async {
                //     await _clearMarkers(); // Gọi hàm xóa marker
                //   },
                //   child: const Icon(Icons.delete),
                // ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo,
                  onPressed: _showCurrentLocation,
                  child: const Icon(Icons.location_searching_rounded),
                ),
                if(_isDragging)
                  Padding(padding: const EdgeInsets.only(top: 20),
                    child:  FloatingActionButton(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      onPressed: (){
                        if(_draggedPosition != null){
                          // adding marker
                          _showMarkerDialog(context, _draggedPosition!);
                        }
                        setState(() {
                          _isDragging = false;
                          _draggedPosition = null;
                        });
                      },
                      child: const Icon(Icons.check),
                    ),
                  )
              ],
            )
          )
        ],
      ),
    );
  }
}
