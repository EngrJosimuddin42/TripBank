import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/point_loyalty_controller.dart';

class PointLoyaltyView extends GetView<PointLoyaltyController> {
  const PointLoyaltyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TripBank Rewards'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
              Get.back();
          },
        ),
      ),
      body: const Center(
        child: Text(
          'PointLoyaltyView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
