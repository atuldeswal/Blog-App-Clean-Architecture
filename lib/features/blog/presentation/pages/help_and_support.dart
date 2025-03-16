import 'package:blog_app/features/blog/presentation/widgets/faq_item.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const HelpSupportPage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  FaqItem(
                    question: "How do I reset my password?",
                    answer:
                        "Go to the login page, tap 'Forgot Password', and follow the instructions sent to your email.",
                  ),
                  FaqItem(
                    question: "How can I update my profile?",
                    answer:
                        "Go to 'Edit Profile' in the settings and update your details. Make sure to save your changes.",
                  ),
                  FaqItem(
                    question: "How do I contact customer support?",
                    answer:
                        "You can reach out via email at support@blogapp.com or use the 'Contact Us' button below.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  launchUrl(Uri.parse("mailto:hunnydeswal2@gmail.com"));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.gradient2,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Contact Us",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}