import 'package:flutter/material.dart';

class DetalisScreenRice extends StatelessWidget {
  const DetalisScreenRice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // أيقونة الرجوع
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new_outlined, size: 30),
              ),
              const SizedBox(height: 10),

              // صورة الموز داخل دائرة
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Rice",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33691E), // لون أخضر غامق
                  ),
                ),
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(
                      'images/Rectangle 4344.png'), // ضع الصورة المناسبة
                ),
              ]),
              const SizedBox(height: 10),

              // قسم Seed Preparation
              const Text(
                "Seed Preparation :",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Bananas are usually propagated through suckers or tissue culture rather than seeds because most commercial banana varieties (such as Cavendish) do not have viable seeds. However, in some wild or non-commercial varieties, seeds can be used.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 15),

              // قسم Seed Treatment
              const Text(
                "Seed Treatment :",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Banana seeds have a hard coat and require treatments for germination, including soaking in warm water or diluted acid, exposure to hot water, fungicide application, and hormonal treatment with GA3.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 15),

              // قسم Important Notes
              const Text(
                "Important Notes",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Most cultivated banana varieties do not reproduce by seeds but through suckers or tissue culture.\n\n"
                "If working with wild banana varieties, germination can take a long time (sometimes several months).\n\n"
                "Tissue culture is the most common method for producing healthy and uniform banana seedlings.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
