  import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:projekx_app/common/colors.dart';

Widget buildEmptyState(BuildContext context,title) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
              'assets/Empty box.json', 
               width: 150,
              height: 150,
              repeat: true,
            ),
          const SizedBox(height: 12),
           Text(title,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
         
        ],
      ),
    );
  }