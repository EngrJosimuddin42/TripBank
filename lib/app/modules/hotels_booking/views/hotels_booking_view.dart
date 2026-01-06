import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/hotels_booking_controller.dart';

class HotelsBookingView extends GetView<HotelsBookingController> {
  const HotelsBookingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HotelsBookingView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HotelsBookingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
