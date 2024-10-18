import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/features/shop/screens/chatBot/chatBot.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import 'doctorList.dart';

class ProfileDsScreen extends StatelessWidget {
  const ProfileDsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          "Dược Sĩ Tư Vấn",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DoctorList(),
            const SizedBox(height: 10),
            Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Dịch vụ tư vấn 24/7',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.support_agent, color: TColors.primary),
                                const SizedBox(width: 10),
                                Text(
                                  'Tư vấn bệnh lý và thuốc',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              textAlign: TextAlign.justify,
                              'Đội ngũ trợ lý ảo thông minh của chúng tôi được tích hợp công nghệ AI tiên tiến, luôn sẵn sàng hỗ trợ bạn 24/7 về các vấn đề liên quan đến bệnh lý và hướng dẫn sử dụng thuốc đúng cách. Với BotAI, bạn có thể nhanh chóng nhận được câu trả lời chính xác cho các thắc mắc của mình thông qua kênh chat trực tuyến.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 10),
                            // Thêm thông tin chi tiết liên hệ
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Get.to(() => const ChatBotScreen());
                                  },
                                  icon: Image.asset(
                                    TImages.robot,
                                    width: 28,
                                    height: 28
                                  ),
                                  label: const Text('Kết nối với trợ lý AI'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 10.0),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Thêm giờ làm việc
                            Row(
                              children: [
                                const Icon(Icons.schedule, color: TColors.primary),
                                const SizedBox(width: 10),
                                Text(
                                  'Giờ làm việc: Phục vụ 24/7',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      )
    );
  }
}

