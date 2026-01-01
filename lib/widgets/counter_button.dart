import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CounterButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CounterButton({super.key, required this.onPressed});

  @override
  State<CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;

  // To handle the scale effect on press
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _rippleController.forward(from: 0.0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: () => setState(() => _isPressed = false),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Ripple Animations
          _buildRipple(0.0),
          _buildRipple(0.5),

          // Main Button
          AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(
                  28,
                ), // roughly 2rem rounded-3xl
                border: Border.all(
                  color: _isPressed
                      ? AppColors.primary.withOpacity(0.4)
                      : AppColors.primary.withOpacity(0.3),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Gradient overlay on hover/active (simplified as persistent low opacity or active state)
                  if (_isPressed)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF23482F), Color(0xFF112217)],
                        ),
                      ),
                    ),

                  // Fingerprint Icon
                  Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      transform: Matrix4.translationValues(
                        0,
                        _isPressed ? 4 : 0,
                        0,
                      ),
                      child: const Icon(
                        Icons
                            .fingerprint, // Standard material icon close enough
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRipple(double delayEnd) {
    // A simplified ripple that fades out and expands
    // For a continuous ripple like in CSS 'infinite', we'd loop it.
    // The CSS says 'animation: ripple 2s linear infinite'.
    // Let's try to mimic that endless pulsing if that's the intent,
    // or just trigger on click. Design implies "infinite" which suggests a breathing effect or
    // constant attention grabber. But usually zikirmatik ripples on click.
    // However, the CSS `animation: ripple 2s linear infinite` DOES imply constant rippling.
    // Let's implement constant rippling.

    return RepaintBoundary(
      child: _PulsingRipple(delayStart: delayEnd), // reusing simpler logic
    );
  }
}

class _PulsingRipple extends StatefulWidget {
  final double delayStart;
  const _PulsingRipple({required this.delayStart});

  @override
  State<_PulsingRipple> createState() => _PulsingRippleState();
}

class _PulsingRippleState extends State<_PulsingRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    Future.delayed(
      Duration(milliseconds: (widget.delayStart * 1000).toInt()),
      () {
        if (mounted) _controller.repeat();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final val = _controller.value;
        final opacity = 0.8 * (1 - val); // Fade out
        final scale = 1.0 + (1.5 * val); // Grow to 2.5x

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape:
                    BoxShape.circle, // CSS says border-radius: 50% for ripple
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
