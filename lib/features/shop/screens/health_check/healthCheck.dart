import 'package:flutter/material.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/utils/constants/text_strings.dart';

import '../../../../utils/constants/colors.dart';
import 'healthQuiz.dart';

class HealthCheck extends StatefulWidget {
  const HealthCheck({super.key});

  @override
  State<HealthCheck> createState() => _HealthCheckState();
}

class _HealthCheckState extends State<HealthCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text("Kiểm tra sức khỏe"),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthQuiz(title: "Đánh giá nguy cơ mắc bệnh hen suyễn", evaluationType: 0,)));
                        },
                        child: Container(
                          height: 280,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: TColors.orangeAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 60, child: Image.asset("assets/icons/health/Phoi_icon.png")),
                              Text("Kiểm tra", style: TextStyle(color: Colors.grey[900], fontSize: 15)),
                              const Text("Đánh giá nguy cơ mắc bệnh hen suyễn", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthQuiz(title: "Đánh giá nguy cơ mắc bệnh phổi tắc nghẽn mạn tính", evaluationType: 1,)));
                        },
                        child: Container(
                          height: 280,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: TColors.yellowAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 60, child: Image.asset("assets/icons/health/Phoi_icon.png", color: Colors.yellow[700])),
                              Text("Kiểm tra", style: TextStyle(color: Colors.grey[900], fontSize: 15)),
                              const Text("Đánh giá nguy cơ mắc bệnh phổi tắc nghẽn mạn tính", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthQuiz(title: "Đánh giá nguy cơ lạm dụng thuốc cắt cơn hen", evaluationType: 2,)));
                        },
                        child: Container(
                          height: 280,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: TColors.accent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 60,child: Image.asset("assets/icons/health/camthuoc_icon.png"),),
                              Text("Kiểm tra", style: TextStyle(color: Colors.grey[900], fontSize: 15),),
                              const Text("Đánh giá nguy cơ lạm dụng thuốc cắt cơn hen", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthQuiz(title: "Đánh giá nguy cơ bệnh trào ngược dạ dày và thực quản", evaluationType: 3,)));
                        },
                        child: Container(
                          height: 280,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: TColors.pinkAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 60,child: Image.asset("assets/icons/health/DaDay_icon.png"),),
                              Text("Kiểm tra", style: TextStyle(color: Colors.grey[900], fontSize: 15),),
                              const Text("Đánh giá nguy cơ bệnh trào ngược dạ dày và thực quản", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                const Divider(height: 20,thickness: 10,),
                const SizedBox(height: 10,),
                const Text("Kiểm tra sức khỏe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                const SizedBox(height: 10,),
                const Text(TTexts.subTitleHealCheck, textAlign: TextAlign.justify, style: TextStyle(fontSize: 15),),
                const SizedBox(height: 10,),
                const Text("Miễn trừ trách nhiệm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                const SizedBox(height: 10,),
                const Text(TTexts.subTitleDisclaimer, textAlign: TextAlign.justify, style: TextStyle(fontSize: 15),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
