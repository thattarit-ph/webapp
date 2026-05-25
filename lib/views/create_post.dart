import 'package:cloud_firestore/cloud_firestore.dart';
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
                      onPressed: () async {
                        // ตรวจสอบว่ากรอกข้อมูลครบไหม
                        if (titleController.text.isEmpty || contentController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบถ้วน")),
                          );
                          return;
                        }

                        try {
                          // โยนข้อมูลขึ้น Collection ที่ชื่อว่า 'posts'
                          await FirebaseFirestore.instance.collection('posts').add({
                            "title": titleController.text.trim(),
                            "content": contentController.text.trim(),
                            "preview": contentController.text.substring(0, contentController.text.length > 50 ? 50 : contentController.text.length) + "...", // ทำพรีวิวสั้นๆ
                            "comments_count": 0,
                            "likes": 0,
                            "views": 0,
                            "category": "ทั่วไป", // ตรงนี้อนาคตค่อยทำ Dropdown เลือกหมวดหมู่ได้
                            "comments": [], // สร้าง Array ว่างๆ ไว้รอรับคอมเมนต์
                            "createdAt": FieldValue.serverTimestamp(), // เก็บเวลาที่ตั้งกระทู้
                          });

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("บันทึกกระทู้เรียบร้อย")),
                          );
                          Navigator.pop(context); // กลับไปหน้าแรก

                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
                          );
                        }
                      },
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
