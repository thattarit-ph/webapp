import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatefulWidget {
  final String threadId;
  const PostDetail({super.key, required this.threadId});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ดึง UID ของผู้ใช้งานปัจจุบันที่กำลังเปิดแอปอยู่
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("รายละเอียดกระทู้")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').doc(widget.threadId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("ไม่พบกระทู้ที่เลือก หรือกระทู้ถูกลบไปแล้ว"));
          }

          final article = snapshot.data!.data() as Map<String, dynamic>;
          final commentsList = article["comments"] as List<dynamic>? ?? [];
          final bool canComment = article["canComment"] ?? true;

          // ดึง ID ของคนสร้างกระทู้มาจาก Firestore
          final String? authorId = article["authorId"];

          // เช็กเงื่อนไขว่าผู้ใช้งานปัจจุบันคือเจ้าของกระทู้ใช่หรือไม่
          final bool isOwner = currentUserId != null && currentUserId == authorId;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                    article["title"] ?? "",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 12),

                // Content
                Text(
                    article["content"] ?? "",
                    style: const TextStyle(fontSize: 16)
                ),
                const Divider(height: 32),

                // Comments Section
                const Text(
                    "ความคิดเห็น",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 12),

                if (commentsList.isEmpty)
                  const Text("ยังไม่มีความคิดเห็น", style: TextStyle(color: Colors.grey)),

                for (var comment in commentsList)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(comment.toString()),
                    ),
                  ),

                const SizedBox(height: 20),

                // 🟢 ส่วนปุ่มจัดการสำหรับ "เจ้าของกระทู้" เท่านั้น
                if (isOwner) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      icon: Icon(canComment ? Icons.comments_disabled : Icons.comment),
                      label: Text(canComment ? "ปิดคอมเมนต์" : "เปิดคอมเมนต์"),
                      onPressed: () async {
                        await FirebaseFirestore.instance.collection('posts').doc(widget.threadId).update({
                          "canComment": !canComment, // สลับค่าจาก true เป็น false หรือ false เป็น true
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // 🟢 ส่วนจัดการกล่องคอมเมนต์ตามสถานะ canComment (ทุกคนเห็นตามการตั้งค่าของเจ้าของ)
                if (canComment) ...[
                  // Comment Box
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      labelText: "เขียนความคิดเห็นของคุณ...",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => commentController.clear(),
                        child: const Text("ยกเลิก"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          // เช็กกันเหนียวว่ามีคนล็อกอินอยู่ ถึงจะให้คอมเมนต์ได้
                          if (currentUserId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("กรุณาล็อกอินก่อนแสดงความคิดเห็น")),
                            );
                            return;
                          }

                          if (commentController.text.isNotEmpty) {
                            final newComment = commentController.text.trim();
                            commentController.clear();

                            await FirebaseFirestore.instance.collection('posts').doc(widget.threadId).update({
                              "comments": FieldValue.arrayUnion([newComment]),
                              "comments_count": FieldValue.increment(1),
                            });
                          }
                        },
                        child: const Text("ส่งความคิดเห็น"),
                      ),
                    ],
                  ),
                ] else ...[
                  // ป้ายเตือนผู้ใช้งานเมื่อกระทู้นี้ถูกปิดคอมเมนต์
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                            "กระทู้นี้ถูกปิดการแสดงความคิดเห็นโดยผู้สร้าง",
                            style: TextStyle(color: Colors.black54)
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}