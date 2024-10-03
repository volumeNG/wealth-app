import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:wealth/features/order/requests/order_requests.dart';
import 'package:wealth/presentation/pages/sign_up.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';
import 'package:wealth/presentation/pages/widgets/input_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/flipping/requests/flipping_requests.dart';
import '../../features/order/model/BankModel.dart';
import '../colors.dart';
import '../font_sizes.dart';
import 'homepage.dart';

final amountPaid = StateProvider<double>((ref) => 0.0);

class PaymentMade extends ConsumerStatefulWidget {
  const PaymentMade({Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentMade> createState() => _PaymentMadeState();
}

class _PaymentMadeState extends ConsumerState<PaymentMade> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _bankName = TextEditingController();
  TextEditingController _accountNumber = TextEditingController();
  File paymentReciept = new File("");
  var willPop = Future<bool>.value(true);

  Future<void> picksinglefile() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['jpg', 'pdf', 'doc', 'jpeg', 'png'],
    // );

    final ImagePicker _picker = ImagePicker();

    // Allow the user to pick an image from the gallery
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      // Set to ImageSource.camera to allow camera input
      imageQuality: 80,
      // Compress image quality (optional)
      maxWidth: 800,
      // Resize to a maximum width (optional)
      maxHeight: 800, // Resize to a maximum height (optional)
    );

    // If no image is selected
    if (image == null) return;

    File result = File(image.path);
    if (result != null) {
      // paymentReciept = File(result.files.single.path!);
      paymentReciept = File(result.path);
    } else {
      print("No file selected");
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final payment = ref.read(payment_provider.notifier).state;
    AsyncValue<List<BankModel>> fetchBanks = ref.watch(getBanks("naira"));
    if (payment.bankId == null) {
      fetchBanks.when(
          data: (data) {
            if (data.isNotEmpty) {
              payment.bankId = data[0].id!;
            } else {}
          },
          error: (error, _) {},
          loading: () {});
    }

    submitOrder() async {
      context.loaderOverlay.show(
        widget: const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: linkTextOrange,
                backgroundColor: Colors.white,
                strokeWidth: 5,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
      String paymentUrl;
      var recieptUrl = null;
      var response;
      if (paymentReciept.path.isNotEmpty) {
        recieptUrl = await imagesToBeHosted(paymentReciept);
      }
      if (payment.type == "current") {
        response = await makeCurrentLocationPayment(
            propertyId: payment.id,
            bankName: _bankName.text,
            contactNumber: _phoneNumber.text,
            accountNumber: _accountNumber.text,
            wealthBankId: payment.bankId!,
            paymentRecieptUrl: recieptUrl);
      } else if (payment.type == "homepage") {
        response = await makeManualCrowdFundOrder(
            propertyId: payment.id,
            bankName: _bankName.text,
            contactNumber: _phoneNumber.text,
            accountNumber: _accountNumber.text,
            wealthBankId: payment.bankId!,
            amount: ref.read(amountPaid.notifier).state,
            paymentRecieptUrl: recieptUrl);
      } else if (payment.type == "flipping") {
        response = await makeManualFlippingOrder(
            propertyId: payment.id,
            bankName: _bankName.text,
            contactNumber: _phoneNumber.text,
            accountNumber: _accountNumber.text,
            wealthBankId: payment.bankId!,
            paymentRecieptUrl: recieptUrl);
      } else {
        response = null;
      }
      context.loaderOverlay.hide();
      if (response != null) {
        setState(() {
          willPop = Future<bool>.value(false);
        });
        if (response["success"]) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              title: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color(0xffEEEEEE),
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Image.asset("assets/images/hand.png"),
                ),
              ),
              content: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "This ",
                  style: GoogleFonts.poppins(
                      color: secondaryTextColor,
                      fontSize: text__sm,
                      fontWeight: FontWeight.w400),
                  children: [
                    TextSpan(
                      text:
                          "payment/interest is currently being reviewed. Once the processing is complete, you will receive a notification from our customer care representative. If you have any questions, please feel free to call us at ",
                      style: GoogleFonts.poppins(),
                    ),
                    TextSpan(
                      text: "08027057730 or 08082072259 ",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: text__md),
                    ),
                    TextSpan(
                      text: "or chat with our support team.",
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ),
              actions: [
                BTN(
                    width: MediaQuery.of(context).size.width * 0.9,
                    onTap: () {
                      ref.invalidate(payment_provider);
                      context.go('/initial_page');
                    },
                    text: "Homepage")
              ],
            ),
          );
        } else {
          setState(() {
            willPop = Future<bool>.value(true);
          });
          showErrorDialog(context, response["message"]);
        }
      } else {
        setState(() {
          willPop = Future<bool>.value(false);
        });
        showErrorDialog(context, "Please try again later");
      }
      setState(() {
        willPop = Future<bool>.value(false);
      });
    }

    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        return willPop;
      },
      child: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 38.sp,
                height: 38.sp,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 1),
                child: Center(
                  child: Icon(Icons.arrow_back_ios_new, size: 15.sp),
                ),
                decoration: BoxDecoration(
                  color: appBarIcon,
                  border: Border.all(
                    color: Color(0xffDDC9BB),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: BTN(
              width: width,
              text: "Submit",
              onTap: () => {
                if (_formKey.currentState!.validate()) {submitOrder()}
                // context.push("/payment")
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  PaymentDetailsField(
                    controller: _name,
                    title: 'Name',
                    hintText: 'Enter your name',
                  ),
                  SizedBox(
                    height: 12.sp,
                  ),
                  PaymentDetailsField(
                    controller: _email,
                    title: 'Your Email Address',
                    hintText: 'Enter email address',
                  ),
                  SizedBox(
                    height: 12.sp,
                  ),
                  PaymentDetailsField(
                    controller: _phoneNumber,
                    title: 'Your Contact Number',
                    hintText: 'Enter contact number',
                  ),
                  SizedBox(
                    height: 12.sp,
                  ),
                  PaymentDetailsField(
                    controller: _bankName,
                    title: 'Your Bank Name',
                    hintText: 'Enter bank name',
                  ),
                  SizedBox(
                    height: 12.sp,
                  ),
                  PaymentDetailsField(
                    controller: _accountNumber,
                    title: 'Your Account Number',
                    hintText: 'Enter account number',
                  ),
                  SizedBox(
                    height: 12.sp,
                  ),
                  Text(
                    "Payment Receipt (optional)",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Color(0xff4B3425),
                    ),
                  ),
                  paymentReciept.path.isEmpty
                      ? const SizedBox.shrink()
                      : Container(
                          padding: EdgeInsets.all(5.sp),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 0),
                          decoration: BoxDecoration(
                            color: serenityGreen.withOpacity(0.9),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                  GestureDetector(
                    onTap: () {
                      picksinglefile();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        image: DecorationImage(
                            image: AssetImage("assets/images/upload.png"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentDetailsField extends StatelessWidget {
  const PaymentDetailsField({
    super.key,
    required this.controller,
    required this.title,
    required this.hintText,
  });

  final TextEditingController controller;
  final String title;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: Color(0xff4B3425),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 5.sp,
        ),
        InputField(
            controller: controller,
            // keyboardType: TextInputType.phone,
            inputTitle: "",
            hintText: hintText),
      ],
    );
  }
}
