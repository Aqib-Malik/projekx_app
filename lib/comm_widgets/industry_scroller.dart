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
              TyperAnimatedText('Software Development'),
              TyperAnimatedText('Construction'),
              TyperAnimatedText('Janitorial'),
              TyperAnimatedText('Filmmaking'),
              TyperAnimatedText('Finance'),
              TyperAnimatedText('Healthcare'),
              TyperAnimatedText('Retail'),
              TyperAnimatedText('Education'),
              TyperAnimatedText('Logistics'),
              TyperAnimatedText('Marketing'),
              TyperAnimatedText('Hospitality'),
              TyperAnimatedText('Fashion'),
              TyperAnimatedText('Govt Contracting'),
              TyperAnimatedText('Telecommunications'),
              TyperAnimatedText('Insurance'),
              TyperAnimatedText('Defense'),
              TyperAnimatedText('Agriculture'),
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
