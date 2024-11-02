// lib/widgets/fade_out_text.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FadeOutText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;

  const FadeOutText({
    Key? key,
    required this.text,
    this.style,
    this.maxLines = 3,
  }) : super(key: key);

  @override
  _FadeOutTextState createState() => _FadeOutTextState();
}

class _FadeOutTextState extends State<FadeOutText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.style ??
        GoogleFonts.roboto(
          fontSize: 16,
          color: Colors.black87,
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        // TextPainter ile metnin boyutunu ölçüyoruz
        final textSpan = TextSpan(text: widget.text, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflow = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Text(
                  widget.text,
                  style: textStyle,
                  maxLines: _isExpanded ? null : widget.maxLines,
                  overflow: _isExpanded ? TextOverflow.visible : TextOverflow.clip,
                ),
                if (!(_isExpanded) && isOverflow)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Theme.of(context).scaffoldBackgroundColor,
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (isOverflow)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    _isExpanded ? 'Azalt' : 'Devamını Gör',
                    style: GoogleFonts.roboto(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
