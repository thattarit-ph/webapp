import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool acceptTerms = false;

    return Scaffold(
      appBar: AppBar(title: const Text("สร้างบัญชีใหม่"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400, // กำหนดความกว้างฟอร์ม
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
                  "กรอกข้อมูลเพื่อเริ่มต้นใช้งาน",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),

                // Email
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "อีเมล",
                    hintText: "name@example.com",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "รหัสผ่าน",
                    hintText: "********",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // Checkbox Terms
                Row(
                  children: [
                    Checkbox(
                      value: acceptTerms,
                      onChanged: (value) {
                        // TODO: setState ถ้าใช้ StatefulWidget
                      },
                    ),
                    const Expanded(
                      child: Text("ฉันยอมรับ ข้อกำหนดและเงื่อนไข"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: เชื่อม Firebase Auth
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("บันทึกข้อมูลเรียบร้อย")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("บันทึก", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 15),

                // Link to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("มีบัญชีอยู่แล้ว? "),
                    TextButton(
                      onPressed: () {
                        // TODO: ไปหน้า Login
                      },
                      child: const Text("เข้าสู่ระบบ"),
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
