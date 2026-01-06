import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../home/controllers/home_controller.dart';  // HomeController থেকে tours নিচ্ছি

class ToursView extends GetView<HomeController> {
  const ToursView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEDE5A),
        title: Text(
          'Popular Tours',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.tours.isEmpty) {
          return const Center(
            child: Text(
              'No tours available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.tours.length,
          itemBuilder: (context, index) {
            final tour = controller.tours[index];
            final imageUrl = tour['image'] as String?;

            return InkWell(
              onTap: () => controller.onTourTap(index),
              borderRadius: BorderRadius.circular(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ট্যুরের ছবি
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl ?? '',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: Colors.grey[300],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey[300],
                          height: 180,
                          child: const Icon(Icons.landscape, size: 60, color: Colors.grey),
                        ),
                      ),
                    ),

                    // ট্যুরের ইনফো
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ট্যুরের নাম
                          Text(
                            tour['name'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),

                          // রেটিং + দিনের সংখ্যা
                          Row(
                            children: [
                              const Icon(Icons.star, size: 18, color: Color(0xFFFFC107)),
                              const SizedBox(width: 6),
                              Text(
                                '${tour['rating']}',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                              const SizedBox(width: 6),
                              Text(
                                '${tour['days']} Days',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // প্রাইস
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              tour['price'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2196F3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}