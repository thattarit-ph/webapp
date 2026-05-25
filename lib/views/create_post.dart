import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          "สร้างกระทู้ใหม่",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
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
                  "แบ่งปันความรู้และประสบการณ์",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 20),

                // Thread Title
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
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
                        // 1. ตรวจสอบว่ากรอกข้อมูลครบไหม
                        if (titleController.text.isEmpty ||
                            contentController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("กรุณากรอกข้อมูลให้ครบถ้วน"),
                            ),
                          );
                          return;
                        }

                        // 2. ดึงข้อมูล User ปัจจุบันที่ล็อกอินอยู่
                        final currentUser = FirebaseAuth.instance.currentUser;

                        // ตรวจสอบกันเหนียวว่า User ล็อกอินอยู่จริงๆ
                        if (currentUser == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("กรุณาล็อกอินก่อนตั้งกระทู้"),
                            ),
                          );
                          return;
                        }

                        try {
                          // 3. โยนข้อมูลขึ้น Collection ที่ชื่อว่า 'posts' พร้อมข้อมูลคนโพสต์
                          await FirebaseFirestore.instance.collection('posts').add({
                            "title": titleController.text.trim(),
                            "content": contentController.text.trim(),
                            "preview": contentController.text.length > 50
                                ? "${contentController.text.substring(0, 50)}..."
                                : contentController.text,
                            // เขียนแบบย่อให้อ่านง่ายขึ้น
                            "comments_count": 0,
                            //"likes": 0,
                            "views": 0,
                            //"category": "ทั่วไป",
                            "comments": [],
                            "canComment": true,
                            "createdAt": FieldValue.serverTimestamp(),

                            // 🟢 ส่วนที่เพิ่มเข้ามาเพื่อให้รู้ว่าใครสร้างกระทู้
                            "authorId": currentUser.uid,
                            // เก็บ UID ไว้ใช้อ้างอิง (สำคัญมาก)
                            "authorName":
                                currentUser.displayName ?? "ผู้ใช้งานทั่วไป",
                            // เก็บชื่อ

                          });

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("บันทึกกระทู้เรียบร้อย"),
                            ),
                          );
                          Navigator.pop(context); // กลับไปหน้าแรก
                        } catch (e) {
                          log("message : $e");
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
