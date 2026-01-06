import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tours_booking_controller.dart';

class ToursBookingView extends GetView<ToursBookingController> {
  const ToursBookingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToursBookingView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ToursBookingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
