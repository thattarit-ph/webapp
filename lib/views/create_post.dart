import 'package:flutter/material.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreateThreadPageState();
}

class _CreateThreadPageState extends State<CreatePost> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("สร้างกระทู้ใหม่")),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "แบ่งปันความรู้และประสบการณ์ด้านความปลอดภัยของคุณ",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),

                // Thread Title
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "หัวข้อกระทู้",
                    hintText: "ระบุหัวข้อที่คุณต้องการแบ่งปัน...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Thread Content
                TextField(
                  controller: contentController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: "เนื้อหา",
                    hintText: "เขียนรายละเอียดของกระทู้นี้ที่นี่...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: เชื่อม Firebase Firestore
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("บันทึกกระทู้เรียบร้อย")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text("บันทึก"),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("ยกเลิก"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
