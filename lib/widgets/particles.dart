import 'dart:math' as math;

import 'package:flutter/material.dart';

/// particles.js replacement for the hero backdrop:
/// 34 particles, circle shape, opacity .28, size 3, speed 1.1,
/// line_linked at distance 140 with opacity .14, plus the `grab` hover mode.
class ParticleField extends StatefulWidget {
  const ParticleField({
    super.key,
    this.count = 34,
    this.colors = const [Color(0xFF2A5EE8), Color(0xFF12B8E0), Color(0xFF6E5CF0)],
    this.linkColor = const Color(0xFF2A5EE8),
    this.linkDistance = 140,
    this.speed = 1.1,
  });

  final int count;
  final List<Color> colors;
  final Color linkColor;
  final double linkDistance;
  final double speed;

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _Particle {
  _Particle(this.pos, this.vel, this.radius, this.color, this.opacity);
  Offset pos;
  Offset vel;
  final double radius;
  final Color color;
  final double opacity;
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ticker =
      AnimationController(vsync: this, duration: const Duration(days: 1))..repeat();
  final _rng = math.Random(7);
  List<_Particle> _particles = [];
  Size _size = Size.zero;
  Offset? _pointer;
  Duration _last = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker.addListener(_step);
  }

  void _seed(Size size) {
    _particles = List.generate(widget.count, (_) {
      final angle = _rng.nextDouble() * math.pi * 2;
      return _Particle(
        Offset(_rng.nextDouble() * size.width, _rng.nextDouble() * size.height),
        Offset(math.cos(angle), math.sin(angle)) * widget.speed,
        1 + _rng.nextDouble() * 2,
        widget.colors[_rng.nextInt(widget.colors.length)],
        0.1 + _rng.nextDouble() * 0.18,
      );
    });
  }

  void _step() {
    final now = _ticker.lastElapsedDuration ?? Duration.zero;
    final dt = ((now - _last).inMicroseconds / 16666).clamp(0.0, 3.0);
    _last = now;
    if (_size == Size.zero || _particles.isEmpty) return;

    for (final p in _particles) {
      var next = p.pos + p.vel * dt;
      // out_mode: 'out' — wrap around the edges
      if (next.dx < -10) next = Offset(_size.width + 10, next.dy);
      if (next.dx > _size.width + 10) next = Offset(-10, next.dy);
      if (next.dy < -10) next = Offset(next.dx, _size.height + 10);
      if (next.dy > _size.height + 10) next = Offset(next.dx, -10);
      p.pos = next;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (size != _size) {
          _size = size;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _seed(size));
          });
        }
        return MouseRegion(
          opaque: false,
          onHover: (e) => _pointer = e.localPosition,
          onExit: (_) => _pointer = null,
          child: CustomPaint(
            size: size,
            painter: _ParticlePainter(
              particles: _particles,
              pointer: _pointer,
              linkColor: widget.linkColor,
              linkDistance: widget.linkDistance,
            ),
          ),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.particles,
    required this.pointer,
    required this.linkColor,
    required this.linkDistance,
  });

  final List<_Particle> particles;
  final Offset? pointer;
  final Color linkColor;
  final double linkDistance;

  @override
  void paint(Canvas canvas, Size size) {
    final linkPaint = Paint()..strokeWidth = 1;

    for (var i = 0; i < particles.length; i++) {
      for (var j = i + 1; j < particles.length; j++) {
        final d = (particles[i].pos - particles[j].pos).distance;
        if (d < linkDistance) {
          linkPaint.color =
              linkColor.withValues(alpha: 0.14 * (1 - d / linkDistance));
          canvas.drawLine(particles[i].pos, particles[j].pos, linkPaint);
        }
      }
    }

    // interactivity.modes.grab — brighter links to the cursor
    if (pointer != null) {
      for (final p in particles) {
        final d = (p.pos - pointer!).distance;
        if (d < linkDistance) {
          linkPaint.color = linkColor.withValues(alpha: 0.3 * (1 - d / linkDistance));
          canvas.drawLine(p.pos, pointer!, linkPaint);
        }
      }
    }

    final dot = Paint();
    for (final p in particles) {
      dot.color = p.color.withValues(alpha: p.opacity + 0.1);
      canvas.drawCircle(p.pos, p.radius, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

/// `--gradient-mesh` — three soft radial tints behind the hero and the CTA band.
class MeshBackground extends StatelessWidget {
  const MeshBackground({super.key, required this.colors, this.opacity = 1});

  final List<Color> colors;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.7, -0.6),
            radius: 0.9,
            colors: [colors[0], colors[0].withValues(alpha: 0)],
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.7, -0.8),
              radius: 0.8,
              colors: [colors[1], colors[1].withValues(alpha: 0)],
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.5, 0.6),
                radius: 0.7,
                colors: [colors[2], colors[2].withValues(alpha: 0)],
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
