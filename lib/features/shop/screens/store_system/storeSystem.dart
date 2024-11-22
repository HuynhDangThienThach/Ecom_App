import 'package:flutter/material.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../map/screen/map_page.dart';
class StoreSystem extends StatefulWidget {
  const StoreSystem({super.key});

  @override
  State<StoreSystem> createState() => _StoreSystemState();
}

class _StoreSystemState extends State<StoreSystem> {
  final List<Map<String, dynamic>> mediquickList =[
    {
      "name": "Nhà thuốc Mediquick 1",
      "phone": "1800 599 964",
      "address": "Nha Thuoc, Phố Hàng Buồm, Phường Hàng Buồm, Khu phố cổ, Quận Hoàn Kiếm, Thành phố Hà Nội, 11010, Việt Nam",
      "hours": "07:00:00 - 21:30:00",
      "distance": "3km",
    },
    {
      "name": "Nhà thuốc Mediquick 2",
      "phone": "1800 599 964",
      "address": "Nha Thuoc, Đường Tô Hiến Thành, Phường Phước Mỹ, Quận Sơn Trà, Thành phố Đà Nẵng, 02363, Việt Nam",
      "hours": "07:00:00 - 21:30:00",
      "distance": "0.95km"
    },
    {
      "name": "Nhà thuốc Mediquick 3",
      "phone": "1800 599 964",
      "address": "Nha Thuoc, Đường Nguyễn Văn Thoại, Phường Mỹ An, Quận Ngũ Hành Sơn, Thành phố Đà Nẵng, 50507, Việt Nam",
      "hours": "07:00:00 - 21:30:00",
      "distance": "0.95km"
    },
    {
      "name": "Nhà thuốc Mediquick 4",
      "phone": "1800 599 964",
      "address": "Nhà Thuốc Tây Số 58, Đường Phạm Văn Đồng, Phường Hiệp Bình Chánh, Thành phố Thủ Đức, Thành phố Hồ Chí Minh, 50000, Việt Nam",
      "hours": "07:00:00 - 21:30:00",
      "distance": "0.95km"
    },
    {
      "name": "Nhà thuốc Mediquick 5",
      "phone": "1800 599 964",
      "address": "Nhà Thuốc Tây Số 48, Đường Số 17, Phường Hiệp Bình Chánh, Thành phố Thủ Đức, Thành phố Hồ Chí Minh, 50000, Việt Nam",
      "hours": "07:00:00 - 21:30:00",
      "distance": "0.95km"
    },
    {
      "name": "Nhà thuốc Mediquick 6",
      "phone": "1800 599 964",
      "address": "Nhà Thuốc Khanh, Quốc lộ 13, Phường Hiệp Bình Chánh, Thành phố Thủ Đức, Thành phố Hồ Chí Minh, 50000, Việt Nam",
      "hours": "07:00:00 - 21:30:00",
      "distance": "0.95km"
    },

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text("Hệ thống nhà thuốc"),
        showBackArrow: true,
      ),
      body:Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        color: Colors.grey[200],
        child:   SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Danh sách hệ thống nhà thuốc", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 10,),
              ...mediquickList.map((mediquick) => buildMediquickCard(mediquick)).toList(),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildMediquickCard(Map<String, dynamic> mediquick) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Text(
                mediquick['name'],
                style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              const Divider(thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.call),
                  Text(mediquick['phone']),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      const phoneNumber = '1800599964';
                      final url = Uri(scheme: 'tel', path: phoneNumber);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: const Icon(Icons.call, color: Colors.blue),
                  ),
                ],
              ),
              const Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on),
                  Expanded(
                    child: Text(
                      mediquick['address'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.watch_later_outlined),
                  Text(mediquick['hours']),
                ],
              ),
              const Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.map),
                  Text(mediquick['distance']),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Map_Page(mediQuickAddress: mediquick['address']),
                        ),
                      );
                    },
                    child: const Icon(Icons.map, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

