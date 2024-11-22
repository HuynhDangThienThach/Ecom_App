import 'package:flutter/material.dart';

class NotifyCationScreen extends StatelessWidget {
  const NotifyCationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
      ),
      body: ListView.builder(
        itemCount: 10, // số lượng thông báo giả định
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.medical_services, color: Colors.blueAccent),
              title: Text('Tên thuốc - Thông báo $index'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nội dung thông báo liên quan đến thuốc.'),
                  Text(
                    'Thời gian: ${DateTime.now().subtract(Duration(minutes: index * 10)).toString()}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Thao tác khác nếu cần
                },
              ),
              onTap: () {
                // Chuyển đến chi tiết thông báo
              },
            ),
          );
        },
      ),
    );
  }
}
