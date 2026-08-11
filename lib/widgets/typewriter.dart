import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Typed.js replacement for the rotating role line:
/// `typeSpeed: 48, backSpeed: 28, backDelay: 1400, loop: true, cursorChar: '_'`.
class Typewriter extends StatefulWidget {
  const Typewriter({
    super.key,
    required this.strings,
    required this.style,
    this.typeSpeed = const Duration(milliseconds: 48),
    this.backSpeed = const Duration(milliseconds: 28),
    this.backDelay = const Duration(milliseconds: 1400),
    this.cursorChar = '_',
  });

  final List<String> strings;
  final TextStyle style;
  final Duration typeSpeed;
  final Duration backSpeed;
  final Duration backDelay;
  final String cursorChar;

  @override
  State<Typewriter> createState() => _TypewriterState();
}

class _TypewriterState extends State<Typewriter> with SingleTickerProviderStateMixin {
  int _index = 0;
  int _chars = 0;
  bool _deleting = false;
  Timer? _timer;

  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _schedule(widget.typeSpeed);
  }

  void _schedule(Duration d) {
    _timer?.cancel();
    _timer = Timer(d, _tick);
  }

  void _tick() {
    if (!mounted) return;
    final current = widget.strings[_index];

    if (!_deleting) {
      if (_chars < current.length) {
        setState(() => _chars++);
        _schedule(widget.typeSpeed);
      } else {
        _deleting = true;
        _schedule(widget.backDelay);
      }
    } else {
      // smartBackspace: keep the shared prefix with the next string
      final next = widget.strings[(_index + 1) % widget.strings.length];
      var shared = 0;
      while (shared < current.length &&
          shared < next.length &&
          current[shared] == next[shared]) {
        shared++;
      }
      if (_chars > shared) {
        setState(() => _chars--);
        _schedule(widget.backSpeed);
      } else {
        _deleting = false;
        _index = (_index + 1) % widget.strings.length;
        _schedule(widget.typeSpeed);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = widget.strings[_index].substring(0, _chars);
    return RichText(
      text: TextSpan(
        style: widget.style,
        children: [
          TextSpan(text: text),
          WidgetSpan(
            child: FadeTransition(
              opacity: _blink,
              child: Text(
                widget.cursorChar,
                style: widget.style.copyWith(color: t.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single syntax-highlighted run inside the code window.
class CodeToken {
  const CodeToken(this.text, this.kind);
  final String text;
  final CodeTokenKind kind;
}

enum CodeTokenKind { plain, keyword, type, string, comment }

/// Types a pre-tokenised code snippet in character by character, preserving
/// per-token colours — the `contentType: 'html'` Typed.js instance in the
/// original.
class TypedCode extends StatefulWidget {
  const TypedCode({
    super.key,
    required this.tokens,
    this.charDelay = const Duration(milliseconds: 8),
    this.startDelay = const Duration(milliseconds: 500),
    this.style,
  });

  final List<CodeToken> tokens;
  final Duration charDelay;
  final Duration startDelay;
  final TextStyle? style;

  @override
  State<TypedCode> createState() => _TypedCodeState();
}

class _TypedCodeState extends State<TypedCode> {
  int _shown = 0;
  Timer? _timer;
  late final int _total =
      widget.tokens.fold(0, (sum, tk) => sum + tk.text.length);

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.startDelay, _start);
  }

  void _start() {
    _timer = Timer.periodic(widget.charDelay, (timer) {
      if (!mounted || _shown >= _total) {
        timer.cancel();
        return;
      }
      setState(() => _shown++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color _colorFor(CodeTokenKind kind, AppTokens t) => switch (kind) {
        CodeTokenKind.plain => t.ink,
        CodeTokenKind.keyword => t.accent2,
        CodeTokenKind.type => t.primary,
        CodeTokenKind.string => const Color(0xFF12B886),
        CodeTokenKind.comment => t.muted2,
      };

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final base = widget.style ??
        mono(TextStyle(fontSize: 12.6, height: 1.7, color: t.ink));

    final spans = <TextSpan>[];
    var budget = _shown;
    for (final token in widget.tokens) {
      if (budget <= 0) break;
      final take = budget >= token.text.length ? token.text.length : budget;
      spans.add(TextSpan(
        text: token.text.substring(0, take),
        style: base.copyWith(color: _colorFor(token.kind, t)),
      ));
      budget -= take;
    }

    return RichText(text: TextSpan(style: base, children: spans));
  }
}
