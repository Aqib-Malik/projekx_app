import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class IndustryScroller extends StatelessWidget {
  const IndustryScroller({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF7839FF), Color(0xFFB980FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: SizedBox(
        height: 36,
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.white, // Required for ShaderMask
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText('Insurance'),
              TyperAnimatedText('Telecommunications'),
              TyperAnimatedText('Agriculture'),
              TyperAnimatedText('Defense'),
              TyperAnimatedText('Government Contracting'),
              TyperAnimatedText('Food and Beverage'),
              TyperAnimatedText('Customer Service'),
              TyperAnimatedText('Fashion'),
              TyperAnimatedText('Real Estate'),
              TyperAnimatedText('Business Development'),
              TyperAnimatedText('Human Resources'),
              TyperAnimatedText('Data Science'),
              TyperAnimatedText('Aerospace'),
              TyperAnimatedText('Marketing'),
              TyperAnimatedText('Hospitality'),
              TyperAnimatedText('Data Engineering'),
              TyperAnimatedText('Logistics'),
              TyperAnimatedText('Management Consulting'),
              TyperAnimatedText('Education'),
              TyperAnimatedText('Retail'),
              TyperAnimatedText('Healthcare'),
              TyperAnimatedText('Finance'),
              TyperAnimatedText('Filmmaking'),
              TyperAnimatedText('Janitorial'),
              TyperAnimatedText('Construction'),
              TyperAnimatedText('Software Development'),
            ],

            isRepeatingAnimation: true,
            repeatForever: true,
            pause: const Duration(milliseconds: 1000),

            // speed: const Duration(milliseconds: 70),
          ),
        ),
      ),
    );
  }
}
