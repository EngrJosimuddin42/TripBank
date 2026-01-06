import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
      child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         children: [
            SizedBox(height: 363.h),
           Image.asset('assets/images/tripbank.png',height: 86.h,width: 108.w),
            SizedBox(height: 271.h),
           Text('Version 1.0',style:GoogleFonts.inter(fontWeight:  FontWeight.w400,fontSize: 14.sp,color:Color(0xFFDFE1E7)))
         ],
        )
      ),
      ),
    );
  }
}
