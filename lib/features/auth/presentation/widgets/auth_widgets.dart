import 'package:flutter/material.dart';

class BlobDecoration extends StatelessWidget {
  final Color color;
  const BlobDecoration({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BlobPainter(color: color.withValues(alpha: 0.15)),
      child: const SizedBox(width: 180, height: 180),
    );
  }
}

class _BlobPainter extends CustomPainter {
  final Color color;
  const _BlobPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.05)
      ..cubicTo(
        size.width * 0.95, size.height * 0.0,
        size.width * 1.05, size.height * 0.55,
        size.width * 0.85, size.height * 0.85,
      )
      ..cubicTo(
        size.width * 0.65, size.height * 1.1,
        size.width * 0.1, size.height * 0.95,
        size.width * 0.05, size.height * 0.6,
      )
      ..cubicTo(
        size.width * -0.1, size.height * 0.25,
        size.width * 0.2, size.height * 0.1,
        size.width * 0.5, size.height * 0.05,
      )
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BlobPainter old) => old.color != color;
}

class PillButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;
  const PillButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: const StadiumBorder(),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  final String label;
  const FieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            letterSpacing: 0.8,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}
