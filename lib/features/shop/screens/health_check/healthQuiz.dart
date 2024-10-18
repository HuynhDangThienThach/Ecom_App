import 'package:flutter/material.dart';
import 'package:t_store/features/shop/screens/health_check/quizResult.dart';

class HealthQuiz extends StatefulWidget {
  const HealthQuiz({super.key, required this.title, required this.evaluationType});

  final String title;
  @override
  State<HealthQuiz> createState() => _HealthQuizState();
  final int evaluationType;
}

class _HealthQuizState extends State<HealthQuiz> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Đây là danh sách các câu hỏi
  final List<List<Map<String, dynamic>>> questionSets = [
    [ // Set 1
      {'question': 'Bạn có thường xuyên gặp khó khăn khi thở hoặc cảm thấy thở khò khè không??', 'answer': null},
      {'question': 'Bạn có bị ho kéo dài, đặc biệt là vào ban đêm hoặc sáng sớm không?', 'answer': null},
      {'question': 'Có bất kỳ tác nhân nào cụ thể nào khiến triệu chứng của bạn nặng hơn không?', 'answer': null},
      {'question': 'Bạn có sử dụng thuốc hen suyễn hoặc máy hít (inhaler) không?', 'answer': null},
      {'question': 'Các triệu chứng của bạn có gây ảnh hưởng đến hoạt động hàng ngày, công việc, hoặc giấc ngủ của bạn không?', 'answer': null},
    ],
    [ // Set 2
      {'question': 'Bạn có hút thuốc lá hoặc đã từng hút thuốc không?', 'answer': null},
      {'question': 'Bạn có thường xuyên tiếp xúc với khói bụi, hóa chất độc hại, hoặc ô nhiễm không khí trong công việc hoặc môi trường sống không?', 'answer': null},
      {'question': 'Có người trong gia đình bạn (cha, mẹ, anh chị em) mắc bệnh phổi tắc nghẽn mạn tính hoặc các bệnh về phổi khác không?', 'answer': null},
      {'question': 'Bạn có thường xuyên gặp khó khăn khi thở, ho kéo dài, hoặc có đờm trong thời gian dài không?', 'answer': null},
      {'question': 'Bạn có cảm thấy khó thở khi thực hiện các hoạt động bình thường, như leo cầu thang hoặc đi bộ một quãng đường ngắn không?', 'answer': null},
    ],
    [ // Set 3
      {'question': 'Bạn có thường xuyên sử dụng thuốc cắt cơn hen (như thuốc hít beta-agonist) hơn so với hướng dẫn của bác sĩ không?', 'answer': null},
      {'question': 'Bạn có cảm thấy cần phải sử dụng thuốc cắt cơn nhiều hơn để kiểm soát triệu chứng hen suyễn của mình không?', 'answer': null},
      {'question': 'Khi gặp triệu chứng, bạn có sử dụng thuốc cắt cơn ngay lập tức mà không tham khảo ý kiến bác sĩ hoặc không thực hiện các biện pháp kiểm soát khác không?', 'answer': null},
      {'question': 'Bạn có từng trải qua cảm giác lo lắng hoặc khó chịu khi không có thuốc cắt cơn bên mình không?', 'answer': null},
      {'question': 'Bạn có gặp khó khăn trong việc kiểm soát triệu chứng hen suyễn bằng các biện pháp không phải thuốc (như thuốc chống viêm hoặc thay đổi lối sống) không?', 'answer': null},
    ],
    [ // Set 4
      {'question': 'Bạn có thường xuyên bị ợ nóng hoặc cảm giác cháy rát ở ngực không?', 'answer': null},
      {'question': 'Bạn có thường xuyên bị trào ngược thức ăn hoặc axit dạ dày lên miệng không?', 'answer': null},
      {'question': 'Có những yếu tố nào khiến triệu chứng của bạn nặng hơn không?', 'answer': null},
      {'question': 'Bạn có gặp phải các triệu chứng khác như ho khan, viêm họng, hoặc hôi miệng không?', 'answer': null},
      {'question': 'Bạn có gặp khó khăn khi nuốt thức ăn hoặc cảm thấy thức ăn bị mắc kẹt trong cổ họng không?', 'answer': null},
    ],
  ];

  // Get questions for the selected evaluation type
  List<Map<String, dynamic>> get questions => questionSets[widget.evaluationType];

  // Hàm xử lý câu trả lời
  void _setAnswer(bool answer) {
    setState(() {
      questions[_currentIndex]['answer'] = answer;
    });
  }

  // Hàm chuyển đến câu hỏi tiếp theo
  void _nextQuestion() {
    if (_currentIndex < questions.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() {
        _currentIndex++;
      });
    }
  }

  // Hàm quay lại câu hỏi trước
  void _previousQuestion() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() {
        _currentIndex--;
      });
    }
  }

  // Giao diện của mỗi câu hỏi
  Widget _buildQuestionPage(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hiển thị chỉ số câu hỏi
        Text(
          'Câu ${index + 1}/${questions.length}', // index + 1 để bắt đầu từ câu 1
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // Hiển thị câu hỏi
        Text(
          questions[index]['question'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        // Các nút Có/Không
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _setAnswer(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: questions[index]['answer'] == true
                    ? Colors.green
                    : Colors.white,
                foregroundColor: questions[index]['answer'] == true
                    ? Colors.white
                    : Colors.black,
              ),
              child: const Text('Có'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => _setAnswer(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: questions[index]['answer'] == false
                    ? Colors.red
                    : Colors.white,
                foregroundColor: questions[index]['answer'] == false
                    ? Colors.white
                    : Colors.black,
              ),
              child: const Text('Không'),
            ),
          ],
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionPage(index);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút Back
                _currentIndex > 0
                    ? ElevatedButton(
                  onPressed: _previousQuestion,
                  child: const Text('Back'),
                )
                    : const SizedBox.shrink(),
                // Nút Next hoặc Hoàn tất
                _currentIndex < questions.length - 1
                    ? ElevatedButton(
                  onPressed: _nextQuestion,
                  child: const Text('Next'),
                )
                    : ElevatedButton(
                  onPressed: () {
                    // Xử lý hoàn tất quiz
                    _completeQuiz();
                  },
                  child: const Text('Hoàn tất'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Hàm xử lý hoàn tất quiz
  void _completeQuiz() {
    // Ở đây bạn có thể chuyển sang giao diện khác hoặc xử lý kết quả
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
            questions: questions, title: widget.title,
        ),
      ),
    );
  }
}


