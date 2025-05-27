import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeAndTemp extends StatelessWidget {
  final BoxConstraints constraints;
  final String time;
  final String temperature;

  const TimeAndTemp({
    Key? key,
    required this.constraints,
    required this.time,
    required this.temperature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: constraints.maxWidth * 0.21,
      height: constraints.maxHeight * 0.11,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleMedium!,
        child: Row(
          children: [
            Text(time),
            const Spacer(),
            SvgPicture.asset(
              "assets/icons/sun.svg",
              height: 32,
            ),
            const SizedBox(width: 4),
            Text(temperature),
          ],
        ),
      ),
    );
  }
}
