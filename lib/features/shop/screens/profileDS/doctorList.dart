import 'package:flutter/material.dart';
import 'package:t_store/utils/constants/image_strings.dart';

import '../../../../utils/constants/colors.dart';

class DoctorList extends StatelessWidget {
  DoctorList({super.key});
  final List<Map<String, String>> items = [
    {
      'name': 'DS. Vinh Xuan',
      'review': '100% Hài lòng',
      'Slogan': 'Tận tâm với công việc, tận tình với bệnh nhân',
      'image':
      'https://cdn.nhathuoclongchau.com.vn/unsafe/https://cms-prod.s3-sgn09.fptcloud.com/Bac_si_Nguyen_Anh_Tuan_bca1a1ec8d.png'
    },
    {
      'name': 'DS. Vinh Xuan',
      'review': '100% Hài lòng',
      'Slogan': 'Tận tâm với công việc, tận tình với bệnh nhân',
      'image':
      'https://cdn.nhathuoclongchau.com.vn/unsafe/https://cms-prod.s3-sgn09.fptcloud.com/Bac_si_Nguyen_Anh_Tuan_bca1a1ec8d.png'
    },
    {
      'name': 'DS. Vinh Xuan',
      'review': '100% Hài lòng',
      'Slogan': 'Tận tâm với công việc, tận tình với bệnh nhân',
      'image':
      'https://cdn.nhathuoclongchau.com.vn/unsafe/https://cms-prod.s3-sgn09.fptcloud.com/Bac_si_Nguyen_Anh_Tuan_bca1a1ec8d.png'
    },
    {
      'name': 'DS. Vinh Xuan',
      'review': '100% Hài lòng',
      'Slogan': 'Tận tâm với công việc, tận tình với bệnh nhân',
      'image':
      'https://cdn.nhathuoclongchau.com.vn/unsafe/https://cms-prod.s3-sgn09.fptcloud.com/Bac_si_Nguyen_Anh_Tuan_bca1a1ec8d.png'
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
                          onPressed: () {
                            // Xử lý khi nhấn nút Nhắn tin
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: TColors.primary1
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(image: AssetImage(TImages.zalo), width: 28,
                                height: 28,),
                              Text('Kết nối Zalo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Xử lý khi nhấn nút Gọi điện
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: TColors.error // Màu đỏ
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.call, color: Colors.white,),
                              SizedBox(width: 3,),
                              Text('Hotline: 1800 599 964 ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ],
                    ),
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
