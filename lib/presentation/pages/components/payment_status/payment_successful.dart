import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentSuccessful extends StatefulWidget {
  const PaymentSuccessful({Key? key}) : super(key: key);

  @override
  State<PaymentSuccessful> createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
  // late String formattedNumber;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // formattedNumber = NumberFormat('#,###,###').format(widget.fundRaised);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Fund Transfer Completed"),
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Order Id"),
                  ],
                ),
                Row(
                  children: [
                    Text("Order Date"),
                  ],
                ),
                Column(
                  children: [
                    Text("Paid Amount"),

                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
