import 'package:flutter/material.dart';

class WebBoardPage extends StatelessWidget {
  const WebBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ตัวอย่างข้อมูลโพสต์
    final posts = [
      {
        "title": "วิธีป้องกันการโจมตีแบบ Phishing ในองค์กรขนาดใหญ่ ปี 2024",
        "preview":
        "ในบทความนี้เราจะมาศึกษาเทคนิคที่ใช้ในการป้องกันข้อมูลสำคัญจากการโจมตีผ่านลิงก์แนบอีเมล...",
        "comments": "24",
        "likes": "156",
        "views": "1.2k",
        "category": "ความปลอดภัยในองค์กร",
      },
      {
        "title": "อัปเดตช่องโหว่ความปลอดภัยรายสัปดาห์",
        "preview":
        "สรุปประเด็นสำคัญเกี่ยวกับ Zero-day exploits ที่เพิ่งถูกค้นพบ...",
        "comments": "8",
        "likes": "42",
        "views": "850",
        "category": "ข่าวสารและกิจกรรม",
      },
      {
        "title": "แชร์ประสบการณ์การใช้ Cloud Storage อย่างไรให้ปลอดภัย",
        "preview":
        "การเก็บข้อมูลบนคลาวด์ให้ปลอดภัยนั้นไม่ยาก เพียงทำตามขั้นตอนการเข้ารหัส...",
        "comments": "56",
        "likes": "210",
        "views": "3.4k",
        "category": "การจัดการและพัฒนา",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Web Board"),
        actions: [
          TextButton(onPressed: () {}, child: const Text("Solutions")),
          TextButton(onPressed: () {}, child: const Text("Security")),
          TextButton(onPressed: () {}, child: const Text("Pricing")),
          TextButton(onPressed: () {}, child: const Text("Support")),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Sign Up"),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post["title"]!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(post["preview"]!,
                      style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.comment, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text("${post["comments"]}"),
                      const SizedBox(width: 16),
                      Icon(Icons.thumb_up, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text("${post["likes"]}"),
                      const SizedBox(width: 16),
                      Icon(Icons.visibility, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text("${post["views"]}"),
                      const Spacer(),
                      Chip(
                        label: Text(post["category"]!),
                        backgroundColor: Colors.blue[50],
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
