import 'package:flutter/material.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/constants/colors.dart';

class DoctorList extends StatelessWidget {
  DoctorList({super.key});
  final List<Map<String, String>> items = [
    {
      'name': 'DS. Trần Minh Nhật',
      'review': 'Dược sĩ',
      'Slogan': 'Tận tâm với công việc, tận tình với bệnh nhân',
      'image':
      'https://cdn.thegioididong.com/med/doctor/Tra%CC%82%CC%80n-Minh-Nha%CC%A3%CC%82t-1200x1200.jpg'
    },
    {
      'name': 'DS. Đỗ Hương Giang',
      'review': 'Dược sĩ',
      'Slogan': 'Tận tâm với công việc, tận tình với bệnh nhân',
      'image':
      'https://cdn.thegioididong.com/med/doctor/do-huong-giang-ctv-1200x1200.jpg'
    },
    {
      'name': 'DS. Lê Thị Phương',
      'review': 'Dược sĩ',
      'Slogan': 'Tận tâm với công việc, tận tình với bệnh nhân',
      'image':
      'https://cdn.thegioididong.com/med/doctor/Le-Thi-Phuong-1-1200x1200.jpg'
    },
    {
      'name': 'DS. Huỳnh Thị Yến Nhi',
      'review': 'Dược sĩ',
      'Slogan': 'Tận tâm với công việc, tận tình với bệnh nhân',
      'image':
      'https://cdn.thegioididong.com/med/doctor/huynh-thi-yen-nhi-tts-1200x1200.jpg'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 370,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            width: 250,
            margin: const EdgeInsets.only(right: 10),
            child: Card(
              elevation: 12,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(items[index]['image']!),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      items[index]['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.group,
                          color: TColors.primary,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          items[index]['review']!,
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Text(
                      items[index]['Slogan']!,
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    // Thêm hai nút Nhắn tin và Gọi điện
                Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        const url = 'https://zalo.me/0393741706';
                        final Uri uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: TColors.primary1,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: AssetImage(TImages.zalo), width: 28, height: 28),
                          Text(
                            'Kết nối Zalo',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        const phoneNumber = '1800599964';
                        final url = Uri(scheme: 'tel', path: phoneNumber);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: TColors.error,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.call, color: Colors.white),
                          SizedBox(width: 3),
                          Text(
                            'Hotline: 1800 599 964',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
