import 'package:flutter/material.dart';
import 'package:webapp/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;



  Future<void> login() async {
    try {
      // 1. ส่งคำสั่งให้ Firebase ตรวจสอบการเข้าสู่ระบบ
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. เช็กว่าหน้าจอนี้ยังเปิดอยู่หรือไม่ (สำคัญมาก! ต้องมีกันแอปเด้ง)
      if (!mounted) return;

      // 3. เอา userCredential มาเช็กว่ามีข้อมูลผู้ใช้ส่งกลับมาจริงๆ ใช่ไหม
      if (userCredential.user != null) {

        // แจ้งเตือนว่าสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("เข้าสู่ระบบสำเร็จ!")),
        );

        // 4. สั่งสลับหน้าไปยังหน้า HomeScreen ทันที
        // (ใช้ pushReplacement เพื่อไม่ให้กดปุ่ม Back กลับมาหน้า Login ได้อีก)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WebBoardPage()),
        );

      }

    } on FirebaseAuthException catch (e) {
      // ดักจับ Error เฉพาะของ Firebase เพื่อเอามาแปลเป็นภาษาไทยให้ผู้ใช้เข้าใจง่ายๆ
      String errorMessage = "เกิดข้อผิดพลาด";

      if (e.code == 'user-not-found') {
        errorMessage = "ไม่พบผู้ใช้งานนี้ในระบบ กรุณาสมัครสมาชิก";
      } else if (e.code == 'wrong-password') {
        errorMessage = "รหัสผ่านไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง";
      } else if (e.code == 'invalid-email') {
        errorMessage = "รูปแบบอีเมลไม่ถูกต้อง";
      } else if (e.code == 'user-disabled') {
        errorMessage = "บัญชีผู้ใช้นี้ถูกระงับการใช้งาน";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );

    } catch (e) {
      // ดักจับข้อผิดพลาดทั่วไปอื่นๆ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // พื้นหลังสีฟ้าอ่อน
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
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
                  "เข้าสู่ระบบ",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "กรอกข้อมูลเพื่อเข้าสู่บัญชีของคุณ",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
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
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    labelText: "รหัสผ่าน",
                    hintText: "********",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                     await login();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("เข้าสู่ระบบ", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 10),

                // Forgot Password
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () {
                //       // TODO: ไปหน้า Reset Password
                //     },
                //     child: const Text("ลืมรหัสผ่าน?"),
                //   ),
                // ),
                //const SizedBox(height: 10),

                // Link to Register
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text("ยังไม่มีบัญชี? "),
                //     TextButton(
                //       onPressed: () {
                //         // TODO: ไปหน้า Register
                //       },
                //       child: const Text("สมัครสมาชิก"),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
