import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final RxInt currentPage = 0.obs;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => controller.completeOnboarding(),
            child: Text(
              'Skip',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: const Color(0xFF6B5603),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                currentPage.value = index;
              },
              children: [
                // First Page
                _buildOnboardingPage(
                  currentPage: currentPage,
                  pageIndex: 0,
                  image: 'assets/images/onboarding1.png',
                  title: 'Explore the world in Your\npalms',
                  description: 'Discover flights, hotels, cars, and tours — all in one\nseamless travel app.',
                ),
                // Second Page
                _buildOnboardingPage(
                  currentPage: currentPage,
                  pageIndex: 1,
                  image: 'assets/images/onboarding2.png',
                  title: 'Smart Travel Starts Here',
                  description: 'Our 24/7 AI assistant finds the best deals and\n guides you every step of your journey.',
                ),

                // Third Page (optional)
                _buildOnboardingPage(
                  currentPage: currentPage,
                  pageIndex: 2,
                  image: 'assets/images/onboarding3.png',
                  title: 'Earn More. Travel More.',
                  description: 'Get loyalty points, exclusive offers, and\n personalized recommendations tailored for you.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 62),

          // Continue Button
          Obx(() => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: 327,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (currentPage.value < 2) {
                    // Go to next page
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    controller.completeOnboarding();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFECD08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  currentPage.value < 2 ? 'Continue' : 'Get Start',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF3A3A3A),
                  ),
                ),
              ),
            ),
          )),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage({
    required RxInt currentPage,
    required int pageIndex,
    required String image,
    required String title,
    required String description,
  }) {
    return Column(
      children: [
        const SizedBox(height: 24),

        // Image with rounded corners
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27.5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              image,
              height: 336,
              width: 320,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 38),

        // Page Indicator
    Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 166.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
    _buildIndicator(currentPage.value == 0),
    const SizedBox(width: 8),
    _buildIndicator(currentPage.value == 1),
    const SizedBox(width: 8),
    _buildIndicator(currentPage.value == 2),
            ],
          ),
        )),
        const SizedBox(height: 32),

        // Title
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Color(0xFF0D0D12),
            height: 1.5,
          ),
        ),

        const SizedBox(height: 16),

        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: const Color(0xFF818898),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      width: isActive ? 10 : 8,
      height: isActive ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFB49206) : const Color(0xFFDFE1E7),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}