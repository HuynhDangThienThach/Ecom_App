
import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';

import '../../../../utils/constants/image_strings.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final Gemini gemini = Gemini.instance;

  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'Thach');
  final ChatUser _geminiChatUser = ChatUser(
      id: '2',
      firstName: 'Bác Sĩ AI',
      profileImage:
          "https://thumbs.dreamstime.com/z/cheerful-doctor-ai-generated-avatar-physician-cheerful-doctor-ai-generated-avatar-physician-stethoscope-therapist-ai-286004439.jpg");

  List<ChatMessage> message = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(TImages.bgDoctorAI),
            fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const TAppBar(
          showBackArrow: true,
          title: Padding(
              padding: EdgeInsets.only(left: 60.0), child: Text("Bác Sĩ AI", style: TextStyle(color: Colors.black),)),
        ),
        body: Column(
          children: [
            Expanded(
              child: DashChat(
                currentUser: _currentUser,
                messageOptions: const MessageOptions(
                  currentUserContainerColor: Colors.black,
                  containerColor: Color.fromRGBO(0, 166, 126, 1),
                  textColor: Colors.white,
                ),
                inputOptions: InputOptions(
                    trailing: [
                      IconButton(
                          onPressed: sendMediaMessage,
                          icon: const Icon(Icons.image)
                      )
                    ]
                ),
                onSend: getChatResponse,
                messages: message,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getChatResponse(ChatMessage chatMessage) async {
    // Thêm câu hỏi của user vào danh sách tin nhắn
    setState(() {
      message = [chatMessage, ...message];
    });

    // Thêm một tin nhắn "ảo" để hiển thị loading animation
    ChatMessage loadingMessage = ChatMessage(
      user: _geminiChatUser,
      createdAt: DateTime.now(),
      text: 'Đang trả lời...',  // Tin nhắn tạm thời hiển thị trạng thái loading
    );

    setState(() {
      message = [loadingMessage, ...message];
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }

      // Biến chứa câu trả lời đầy đủ
      String response = '';

      // Sử dụng await để nhận câu trả lời từ Gemini
      await for (var event in gemini.streamGenerateContent(question, images: images)) {
        response += event.content?.parts
            ?.fold("", (previous, current) => "$previous ${current.text}") ?? '';
      }

      // Khi đã nhận đủ câu trả lời, thay thế loadingMessage bằng câu trả lời thực
      setState(() {
        message = [
          ChatMessage(
            user: _geminiChatUser,
            createdAt: DateTime.now(),
            text: response,  // Nội dung câu trả lời từ Gemini
          ),
          ...message.where((msg) => msg != loadingMessage),  // Xóa tin nhắn "Đang trả lời..."
        ];
      });
    } catch (e) {
      print(e);
      setState(() {
        // Trong trường hợp có lỗi, thay thế loadingMessage bằng thông báo lỗi
        message = [
          ChatMessage(
            user: _geminiChatUser,
            createdAt: DateTime.now(),
            text: 'Đã xảy ra lỗi. Vui lòng thử lại sau.',  // Thông báo lỗi
          ),
          ...message.where((msg) => msg != loadingMessage),  // Xóa tin nhắn "Đang trả lời..."
        ];
      });
    }
  }



  void sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (file != null) {
      // Hiển thị hộp thoại để người dùng nhập câu hỏi trước khi gửi ảnh
      TextEditingController questionController = TextEditingController();

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Đặt câu hỏi'),
            content: TextField(
              controller: questionController,
              decoration: const InputDecoration(hintText: "Nhập câu hỏi của bạn..."),
            ),
            actions: [
              TextButton(
                child: const Text('Hủy'),
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại mà không gửi ảnh
                },
              ),
              TextButton(
                child: const Text('Gửi'),
                onPressed: () {
                  Navigator.of(context).pop(questionController.text);  // Trả về câu hỏi
                },
              ),
            ],
          );
        },
      ).then((question) {
        // Nếu người dùng nhập câu hỏi và nhấn "Gửi"
        if (question != null && question.isNotEmpty) {
          // Gửi ảnh kèm với câu hỏi
          ChatMessage chatMessage = ChatMessage(
            user: _currentUser,
            createdAt: DateTime.now(),
            text: question,  // Câu hỏi từ người dùng
            medias: [
              ChatMedia(
                url: file.path,
                fileName: "",
                type: MediaType.image,
              )
            ],
          );
          getChatResponse(chatMessage);
        }
      });
    }
  }

}
