import 'package:flutter/cupertino.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';

class labelText extends StatelessWidget {
  const labelText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: flippingLabelHeader,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
