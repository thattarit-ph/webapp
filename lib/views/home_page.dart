import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webapp/views/create_post.dart';
import 'package:webapp/views/post_detail.dart';

class WebBoardPage extends StatelessWidget {
  const WebBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          "กระทู้ของฉัน",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePost()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5),
                ),
              ),
              child: const Text(
                "สร้างกระทู้",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // ดึงข้อมูลจาก 'posts' เรียงจากใหม่ไปเก่า
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("ยังไม่มีกระทู้เลย เริ่มตั้งกระทู้แรกกันเถอะ!"),
            );
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final postDoc = posts[index];
              final post =
                  postDoc.data() as Map<String, dynamic>; // แปลงข้อมูลมาใช้

              return GestureDetector(
                onTap: () {
                  // ส่ง postDoc.id (รหัสเอกสารจริงใน Firestore) ไปหน้า Detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetail(threadId: postDoc.id),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post["title"] ?? "ไม่มีหัวข้อ",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post["preview"] ?? "",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.comment,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text("${post["comments_count"] ?? 0}"),
                            // ดึงตัวเลขจาก DB
                            const SizedBox(width: 16),
                            Icon(
                              Icons.thumb_up,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text("${post["likes"] ?? 0}"),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.visibility,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text("${post["views"] ?? 0}"),
                            const Spacer(),
                            Chip(
                              label: Text(post["category"] ?? "ทั่วไป"),
                              backgroundColor: Colors.blue[50],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(12),
        child: const Text(
          "© 2024 WebBoard Systems. All rights reserved.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
