import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/cars_booking_controller.dart';

class CarsBookingView extends GetView<CarsBookingController> {
  const CarsBookingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CarsBookingView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CarsBookingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
