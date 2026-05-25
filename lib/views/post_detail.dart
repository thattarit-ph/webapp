import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatefulWidget {
  final String threadId;
  const PostDetail({super.key, required this.threadId});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final commentController = TextEditingController();

  // mock data
  final Map<String, Map<String, dynamic>> mockArticles = {
    "mock1": {
      "title": "วิธีป้องกันการโจมตีแบบ Phishing ในองค์กรขนาดใหญ่ ปี 2024",
      "content": "รายละเอียดของบทความนี้...",
      "comments": [
        "การใช้ FIDO2 ดีมากครับ เพิ่มความปลอดภัยได้จริง",
        "องค์กรควรทำ Phishing Simulation บ่อย ๆ",
        "MFA เป็นสิ่งจำเป็นในยุคนี้"
      ]
    },
    "mock2": {
      "title": "แชร์ประสบการณ์การใช้ Cloud Storage",
      "content": "การเข้ารหัสข้อมูลและ IAM ช่วยให้ปลอดภัยขึ้น...",
      "comments": ["เห็นด้วยครับ", "ควรใช้ Zero Trust ด้วย"]
    }
  };

  @override
  Widget build(BuildContext context) {
    final article = mockArticles[widget.threadId];

    if (article == null) {
      return const Scaffold(
        body: Center(child: Text("ไม่พบกระทู้ที่เลือก")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("รายละเอียดกระทู้")),
        body: StreamBuilder<DocumentSnapshot>(
          // ดึงข้อมูลกระทู้เดียวตาม threadId ที่ถูกส่งมา
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

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(article["title"] ?? "",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // Content
                  Text(article["content"] ?? "", style: const TextStyle(fontSize: 16)),
                  const Divider(height: 32),

                  // Comments Section
                  const Text("ความคิดเห็น", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  if (commentsList.isEmpty)
                    const Text("ยังไม่มีความคิดเห็น เป็นคนแรกที่คอมเมนต์สิ!", style: TextStyle(color: Colors.grey)),

                  for (var comment in commentsList)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(comment.toString()),
                      ),
                    ),

                  const SizedBox(height: 20),

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
                          if (commentController.text.isNotEmpty) {
                            final newComment = commentController.text.trim();
                            commentController.clear();

                            // อัปเดตข้อมูลลง Firestore: เพิ่มข้อความลงใน Array และบวกเลขคอมเมนต์
                            await FirebaseFirestore.instance.collection('posts').doc(widget.threadId).update({
                              "comments": FieldValue.arrayUnion([newComment]), // เอาเข้า Array
                              "comments_count": FieldValue.increment(1), // บวกตัวเลขโชว์หน้าแรก 1
                            });
                          }
                        },
                        child: const Text("ส่งความคิดเห็น"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
    );
  }
}
