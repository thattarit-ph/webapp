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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(article["title"] as String,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Content
            Text(article["content"] as String,
                style: const TextStyle(fontSize: 16)),
            const Divider(height: 32),

            // Comments
            const Text("ความคิดเห็น",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            for (var comment in article["comments"] as List)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(comment as String),
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

            // Buttons: ส่ง + ยกเลิก
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    commentController.clear();
                  },
                  child: const Text("ยกเลิก"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (commentController.text.isNotEmpty) {
                        (article["comments"] as List)
                            .add(commentController.text);
                        commentController.clear();
                      }
                    });
                  },
                  child: const Text("ส่งความคิดเห็น"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
