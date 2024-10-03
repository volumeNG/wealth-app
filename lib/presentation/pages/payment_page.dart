import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:wealth/features/order/model/UsdRate.dart';
import 'package:wealth/features/order/model/ordered_model.dart';
import 'package:wealth/presentation/pages/homepage.dart';
import 'package:wealth/presentation/pages/payment_made.dart';
import 'package:wealth/presentation/pages/sign_up.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';
import 'package:wealth/presentation/pages/widgets/currency_selection.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';
import '../../features/order/requests/order_requests.dart';
import '../colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../font_sizes.dart';

//todo: This is the flow if the property type is crowndfunding then the user is going to go the thhe paystack
// todo: If the flow is that it is a current location then you go make manual payments and upload the receipt
// todo: If the flow is a flipping, you make the request, the user input their details and then the pop up shows but they aren't allowed to pay as the design states.

// final hasVisited = StateProvider<bool>((ref) => false);
final totalAmount = StateProvider<dynamic>((ref) => 0.0);
final totalAmountLeft = StateProvider<dynamic>((ref) => 0.0);

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({Key? key, this.paymentType}) : super(key: key);

  final String? paymentType;

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  String usd = "ngn";
  final GlobalKey _key = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final shareController = TextEditingController();
  double usdRate = 0;

  ///This is to make payment
  ///using paystack with the [amountText] and [id]
  ///as string arguments
  makePaystackCrowdFundPayment(String amountText, String id) async {
    final response;
    if (amountText.isNotEmpty) {
      try {
        final double amount = double.parse(amountText);

        if (int.parse(shareController.text) > 100) {
          showErrorDialog(context, "Shares cannot exceed 100%");
        } else if (ref.read(totalAmountLeft.notifier).state <
            double.parse(amountController.text)) {
          showErrorDialog(context, "Payment exceeds funds left to be raised");
        } else {
          if (usd == "ngn" && amount < 1500000) {
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
                    // Text(
                    //   "Submitting Information",
                    //   style: TextStyle(
                    //       fontSize: 17,
                    //       color: Colors.black12,
                    //       fontWeight: FontWeight.w500),
                    // ),
                  ],
                ),
              ),
            );
            response = await crowdFundPayment(
                amount: double.parse(amountText), crowdFundId: id);
            context.loaderOverlay.hide();
            if (response["success"] == false) {
              showErrorDialog(context, response["message"]);
            } else {
              OrderedModel responseModel =
                  OrderedModel.fromJson(response["data"]);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaystackPopup(
                    paystackCheckoutUrl: responseModel.paystackUrl!,
                  ),
                ),
              );
            }
          } else if (usd == "usd" && amount < 2000) {
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
            response = await crowdFundPayment(
                amount: double.parse(amountText), crowdFundId: id);
            context.loaderOverlay.hide();
            if (response["success"] == false) {
              showErrorDialog(context, response["message"]);
            } else {
              OrderedModel responseModel =
                  OrderedModel.fromJson(response["data"]);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaystackPopup(
                    paystackCheckoutUrl: responseModel.paystackUrl!,
                  ),
                ),
              );
            }
          } else if (usd == "ngn" && amount >= 1500000) {
            context.push("/payment/ngn");
            ref.read(amountPaid.notifier).state = amount;
          } else if (usd == "usd" && amount > 2000) {
            context.push("/payment/usd");
            ref.read(amountPaid.notifier).state = amount;
          } else {
            showErrorDialog(context,
                "Please select naira or dollar and input your naira equivalent");
          }
        }
      } catch (e) {
        print("Invalid amount format: $e");
      }
    }
  }

  startCurrentLocationPayment() async {
    if (usd == "usd") {
      context.push("/payment/usd");
    } else {
      context.push("/payment/ngn");
    }
  }

  startFlippingLocationPayment() async {
    if (usd == "usd") {
      context.push("/payment/usd");
    } else {
      context.push("/payment/ngn");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final paymentProvider = ref.watch(payment_provider.notifier).state;
    final String amountText = amountController.value.text;
    final totalCost = ref.read(totalAmount.notifier).state;

    clearValues() {
      shareController.clear();
      amountController.clear();
    }

    calculateShare(String amount) {
      double amountNumber = double.parse(amount);
      double share = (amountNumber / totalCost) * 100;
      shareController.text = share.toStringAsFixed(0);
    }

    calculateNairaAmount(String share) {
      double shareValue = double.parse(share);
      if (shareValue <= 100) {
        double amountNumber = (shareValue / 100) * totalCost;
        amountController.text = amountNumber.toStringAsFixed(0);
      } else {
        showErrorDialog(context, "Share cannot exceed 100%");
        clearValues();
      }
    }

    calculateUsdAmount(String share) {
      if (usdRate > 1) {
        double shareValue = double.parse(share);
        if (shareValue < 100) {
          double amountNumber = ((shareValue / 100) * totalCost) / usdRate;
          amountController.text = amountNumber.toStringAsFixed(0);
        } else {
          showErrorDialog(context, "Share cannot exceed 100%");
          clearValues();
        }
      } else {
        showErrorDialog(context, "Please try again later");
      }
    }

    calculateUsdShare(String amount) {
      if (usdRate > 1) {
        double amountValue = double.parse(amount);
        double share = ((amountValue * usdRate) / totalCost) * 100;
        shareController.text = share.toStringAsFixed(0);
      } else {
        showErrorDialog(context, "Please try again later");
      }

      // clearValues();
    }

    Future getUsdCurrentRate() async {
      AsyncValue<UsdRate> getUsdRateValue = ref.watch(getUsdRate);
      getUsdRateValue.when(
          data: (data) {
            usdRate = data.data!.dollarRate!.toDouble();
          },
          error: (error, _) {},
          loading: () {});
    }

    getUsdCurrentRate();

    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          child: BTN(
              width: width,
              text: "Pay Now",
              onTap: () {
                final String amountText = amountController.value.text;
                if (amountText.isNotEmpty) {
                  try {
                    if (paymentProvider.type == "homepage") {
                      makePaystackCrowdFundPayment(
                          amountText, paymentProvider.id);
                    } else if (paymentProvider.type == "current") {
                      startCurrentLocationPayment();
                    } else if (paymentProvider.type == "flipping") {
                      startFlippingLocationPayment();
                    }
                  } catch (e) {
                    print("Invalid amount format: $e");
                  }
                } else {
                  InAppNotification.show(
                    child: Center(
                      child: Container(
                        width: width * 0.9,
                        child: Center(
                          child: Text(
                            "Please input share or currency amount",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: Colors.red.withOpacity(0.99),
                        ),
                      ),
                    ),
                    context: context,
                    duration: Duration(seconds: 2),
                    onTap: () => {},
                  );
                }
              }),
        ),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: Text(
            "Payments",
            style: secondaryHeader,
          ),
          leading: InkWell(
            onTap: () {
              // ref.invalidate(pa);
              context.pop();
            },
            child: Container(
              width: 38.sp,
              height: 38.sp,
              padding:
              EdgeInsets.symmetric(vertical: 0, horizontal: 1),
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                "Which currency do you want to pay?",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Color(0xff333333),
                  fontSize: text__md,
                ),
              ),
              SizedBox(height: 10.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        usd = "usd";
                        amountController.text = "";
                        shareController.text = "";
                      });
                      if (amountController.text.isNotEmpty) {
                        if (int.parse(amountController.text) < 1500000 &&
                            paymentProvider.type == "homepage") {
                        } else {
                          setState(() {
                            usd = "usd";
                          });
                        }
                      }
                    },
                    child: Currency(
                        width: width,
                        usd: usd == "usd",
                        asset: "dollar",
                        type: "usd"),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        usd = "ngn";
                        amountController.text = "";
                        shareController.text = "";
                      });
                    },
                    child: Currency(
                        width: width,
                        usd: usd != "usd",
                        asset: usd == "ngn" ? "naira" : "orange_naira",
                        type: "naira"),
                  ),
                ],
              ),
              SizedBox(height: 20.sp),
              Form(
                key: _key,
                child: Row(
                  mainAxisAlignment: widget.paymentType! == "current"
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    widget.paymentType! == "current"
                        ? SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Share",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff6B6B6F),
                                  fontSize: text__md,
                                ),
                              ),
                              SizedBox(height: 4.sp),
                              Container(
                                height: 50,
                                width: width * 0.23,
                                child: TextFormField(
                                  onTapOutside: (PointerDownEvent event) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  controller: shareController,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: secondaryColor,
                                    fontSize: text__normal,
                                  ),
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.number,
                                  // readOnly: amountController.text.isNotEmpty,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      usd == "ngn"
                                          ? calculateNairaAmount(value)
                                          : calculateUsdAmount(value);
                                    }
                                  },
                                  cursorColor: softBlack,
                                  decoration: InputDecoration(
                                    prefix: SizedBox(width: 6.sp),
                                    suffixIcon: Icon(
                                      Icons.percent,
                                      size: 20.sp,
                                    ),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: blackGrey,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: softBlack,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You ${widget.paymentType! == "current" ? "want" : "have"} to pay",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            color: Color(0xff6B6B6F),
                          ),
                        ),
                        SizedBox(height: 4.sp),
                        Container(
                          height: 50,
                          width: widget.paymentType! == "current"
                              ? width * 0.85
                              : width * 0.62,
                          child: TextFormField(
                            onTapOutside: (PointerDownEvent event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: amountController,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff4E4F50),
                              fontSize: text__normal,
                            ),
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.number,
                            // readOnly: shareController.text.isNotEmpty,
                            onChanged: (value) {
                              usd == "ngn"
                                  ? calculateShare(value)
                                  : calculateUsdShare(value);
                            },
                            cursorColor: softBlack,
                            decoration: InputDecoration(
                              prefixIcon: ImageIcon(
                                usd == "ngn"
                                    ? AssetImage("assets/images/naira_grey.png")
                                    : AssetImage(
                                        "assets/images/dollar-currency-symbol.png"),
                                size: 24.sp,
                                color: Colors.black,
                              ),
                              contentPadding: EdgeInsets.all(5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: blackGrey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: softBlack,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: width * 0.175,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xffF4F4F4),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/error_info.png",
                          scale:4.5.sp,
                        ),
                        Container(
                          padding: EdgeInsets.all(0),
                          width: width * 0.7,
                          margin: EdgeInsets.only(left: 5,top: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Payment Info",
                                style: secondaryHeader,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6.sp,
                    ),
                    Text(
                      "If you want to transfer more than 1.5 million, you have to make a manual payment.",
                      style: greyText,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaystackPopup extends ConsumerWidget {
  const PaystackPopup({Key? key, required this.paystackCheckoutUrl})
      : super(key: key);

  final String paystackCheckoutUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void clearAndNavigate(String path) {
      while (context.canPop() == true) {
        context.pop();
      }
      context.pushReplacement(path);
    }

    return WillPopScope(
      onWillPop: () async {
        clearAndNavigate('/initial_page');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Paystack Popup'),
        ),
        body: WebView(
          initialUrl: paystackCheckoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
