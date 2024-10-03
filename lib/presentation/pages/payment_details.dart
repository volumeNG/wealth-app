import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wealth/presentation/font_sizes.dart';
import 'package:wealth/presentation/pages/homepage.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/order/model/BankModel.dart';
import '../../features/order/requests/order_requests.dart';
import '../colors.dart';

class BankModelNotifier extends StateNotifier<BankModel> {
  BankModelNotifier() : super(BankModel());

  void setBankModel(BankModel bankModel) {
    state = bankModel;
  }

  void clearBankModel() {
    state = BankModel();
  }
}

final bankModelProvider =
    StateNotifierProvider.autoDispose<BankModelNotifier, BankModel>(
        (ref) => BankModelNotifier());

class PaymentDetails extends ConsumerStatefulWidget {
  const PaymentDetails({Key? key, required this.accountType}) : super(key: key);

  final String accountType;

  @override
  ConsumerState<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends ConsumerState<PaymentDetails> {
  BankModel selectedBank = BankModel();

  @override
  void initState() {
    super.initState();
  }

  _disposeProvider() {
    ref.invalidate(bankModelProvider);
    ref.read(bankModelProvider.notifier).clearBankModel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BankModel _selectedBankModel = ref.watch(bankModelProvider);

    final width = MediaQuery.of(context).size.width;
    AsyncValue<List<BankModel>> fetchBanks =
        ref.watch(getBanks(widget.accountType == "ngn" ? "naira" : "usd"));

    var paymentModel = ref.read(payment_provider.notifier).state;

    if (widget.accountType != "ngn") {
      fetchBanks.when(
          data: (data) {
            if (data.isNotEmpty) {
              paymentModel.bankId = data[0].id!;
              // ref.read(bankModelProvider.notifier).setBankModel(data[0]);
            } else {}
          },
          error: (error, _) {},
          loading: () {});
    }

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Scaffold(
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          child: BTN(
            width: width,
            text: "Paid",
            onTap: () {
              if (_selectedBankModel.id != null) {
                paymentModel.bankId = _selectedBankModel.id!;
              }
              context.push("/payment_made");
            },
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: Text(
            "Payments",
            style: secondaryHeader,
          ),
          leading: InkWell(
            onTap: () {
              ref.read(bankModelProvider.notifier).clearBankModel();
              Navigator.of(context).pop();
            },
            child: Container(
              width: 38.sp,
              height: 38.sp,
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 1),
              decoration: BoxDecoration(
                color: appBarIcon,
                border: Border.all(
                  color: const Color(0xffDDC9BB),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              child: Center(
                child: Icon(Icons.arrow_back_ios_new, size: 15.sp),
              ),
            ),
          ),
        ),
        body: widget.accountType == "ngn"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 49.sp,
                  ),
                  Text(
                    "Payment With Bank",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff333333),
                      fontSize: text__md,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  fetchBanks.when(
                    data: (data) {
                      if (data.isNotEmpty) {
                        selectedBank = data[0];
                        if (_selectedBankModel.id == null ||
                            !data.contains(_selectedBankModel)) {
                          Future(() {
                            ref
                                .read(bankModelProvider.notifier)
                                .setBankModel(data[0]);
                          });
                        }

                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Color(0xffE3E7E7),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36.sp,
                                    height: 30.sp,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: _selectedBankModel.logoOfBank !=
                                                    null &&
                                                _selectedBankModel
                                                    .logoOfBank!.isNotEmpty
                                            ? NetworkImage(
                                                _selectedBankModel.logoOfBank!)
                                            : AssetImage(
                                                    "assets/images/firstbank.png")
                                                as ImageProvider,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12.sp,
                                  ),
                                  Expanded(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        canvasColor: Colors.white,
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<BankModel>(
                                          isExpanded: false,
                                          focusColor: Colors.white,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff444446),
                                          ),
                                          dropdownColor:
                                              const Color(0xffccc5c5),
                                          elevation: 0,
                                          value: data.firstWhere(
                                            (bank) =>
                                                bank.id ==
                                                _selectedBankModel.id,
                                            orElse: () => data[0],
                                          ),
                                          onChanged: (BankModel? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                selectedBank = newValue;
                                                ref
                                                    .read(bankModelProvider
                                                        .notifier)
                                                    .setBankModel(newValue);
                                              });
                                            }
                                          },
                                          items: data.map(
                                            (bank) {
                                              return DropdownMenuItem<
                                                  BankModel>(
                                                value: bank,
                                                child: Text(
                                                  bank.name!,
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: text__normal,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Container(); // Return empty container if data is empty
                      }
                    },
                    error: (error, _) {
                      return Text("Error fetching banks: $error");
                    },
                    loading: () {
                      return const Center(
                        child: SpinKitCubeGrid(
                          size: 20,
                          color: blackGrey,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 9.5.sp,
                  ),
                  Row(
                    children: [
                      const ImageIcon(
                        color: Color(0xff41CE8E),
                        AssetImage(
                          "assets/images/shield.png",
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "100% Secured payments",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: Color(0xff444444),
                          fontSize: text__md,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.sp,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff3F3F3F1A),
                          blurRadius: 20,
                          offset: Offset(0, 0),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account Name",
                          style: greyStyle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          _selectedBankModel.accountName ?? "",
                          style: importantText,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Account Number",
                          style: greyStyle,
                        ),
                        const SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedBankModel.accountNumber ?? "",
                              style: importantText,
                            ),
                            IconButton(
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(
                                      text: _selectedBankModel.accountNumber ??
                                          ""),
                                );
                                showCustomSnackBar(
                                    context, 'Account number copied');
                              },
                              icon: const Icon(
                                Icons.copy,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Bank Address",
                          style: greyStyle,
                        ),
                        const SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                _selectedBankModel.bankAddress ?? "",
                                style: importantText,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(
                                    text: _selectedBankModel.bankAddress ?? "",
                                  ),
                                );
                                showCustomSnackBar(
                                    context, 'Bank address copied');
                              },
                              icon: const Icon(
                                Icons.copy,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Beneficiary phone number:",
                          style: greyStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedBankModel.beneficiaryPhoneNumber ?? "",
                              style: importantText,
                            ),
                            IconButton(
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(
                                      text: _selectedBankModel
                                              .beneficiaryPhoneNumber ??
                                          ""),
                                );
                                showCustomSnackBar(
                                    context, 'Phone number copied');
                              },
                              icon: const Icon(
                                Icons.copy,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Email",
                          style: greyStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "sales@wealthapp.live",
                              style: importantText,
                            ),
                            IconButton(
                              onPressed: () async {
                                await launchUrlString(
                                    'mailto:sales@wealthapp.live');
                                await Clipboard.setData(
                                  const ClipboardData(
                                      text: "sales@wealthapp.live"),
                                );
                              },
                              icon: const Icon(
                                Icons.email_outlined,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )
            : fetchBanks.when(
                data: (data) {
                  if (data.isNotEmpty) {
                    selectedBank = data[0];
                    if (_selectedBankModel.id == null ||
                        !data.contains(_selectedBankModel)) {
                      Future(() {
                        ref
                            .read(bankModelProvider.notifier)
                            .setBankModel(data[0]);
                      });
                    }

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                "Payment With Bank",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff333333),
                                  fontSize: text__md,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10.sp,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  border: Border.all(
                                    width: 1,
                                    color: blackGrey,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36.sp,
                                      height: 30.sp,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: _selectedBankModel
                                                          .logoOfBank !=
                                                      null &&
                                                  _selectedBankModel
                                                      .logoOfBank!.isNotEmpty
                                              ? NetworkImage(_selectedBankModel
                                                  .logoOfBank!)
                                              : const AssetImage(
                                                      "assets/images/firstbank.png")
                                                  as ImageProvider,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.sp,
                                    ),
                                    Expanded(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: Colors.white,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<BankModel>(
                                            isExpanded: false,
                                            focusColor: Colors.white,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff444446),
                                            ),
                                            dropdownColor: Color(0xffccc5c5),
                                            elevation: 0,
                                            value: data.firstWhere(
                                              (bank) =>
                                                  bank.id ==
                                                  _selectedBankModel.id,
                                              orElse: () => data[0],
                                            ),
                                            onChanged: (BankModel? newValue) {
                                              if (newValue != null) {
                                                setState(() {
                                                  selectedBank = newValue;
                                                  ref
                                                      .read(bankModelProvider
                                                          .notifier)
                                                      .setBankModel(newValue);
                                                });
                                              }
                                            },
                                            items: data.map(
                                              (bank) {
                                                return DropdownMenuItem<
                                                    BankModel>(
                                                  value: bank,
                                                  child: Text(
                                                    bank.name!,
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: text__normal,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  ImageIcon(
                                    color: Color(0xff41CE8E),
                                    AssetImage(
                                      "assets/images/shield.png",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "100% Secured payments",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff444444),
                                      fontSize: text__md,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.sp,
                              ),
                              Container(
                                padding: const EdgeInsets.all(15),
                                margin: EdgeInsets.symmetric(vertical: 20.sp),
                                // margin: EdgeInsets.all(1),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3F3F1A8E),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                    )
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Account Name",
                                      style: greyStyle,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      _selectedBankModel.accountName ?? "",
                                      style: importantText,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Account Number",
                                      style: greyStyle,
                                    ),
                                    SizedBox.shrink(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _selectedBankModel.accountNumber ??
                                              "",
                                          style: importantText,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await Clipboard.setData(
                                              ClipboardData(
                                                  text: _selectedBankModel
                                                          .accountNumber ??
                                                      ""),
                                            );
                                            showCustomSnackBar(context,
                                                'Account number copied');
                                          },
                                          icon: Icon(
                                            Icons.copy,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Bank Address",
                                      style: greyStyle,
                                    ),
                                    SizedBox.shrink(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            _selectedBankModel.bankAddress ??
                                                "",
                                            style: importantText,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await Clipboard.setData(
                                              ClipboardData(
                                                text: _selectedBankModel
                                                        .bankAddress ??
                                                    "",
                                              ),
                                            );
                                            showCustomSnackBar(
                                                context, 'Bank address copied');
                                          },
                                          icon: Icon(
                                            Icons.copy,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Sort Code",
                                      style: greyStyle,
                                    ),
                                    SizedBox.shrink(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _selectedBankModel.shortCode ?? "",
                                          style: importantText,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await Clipboard.setData(
                                              ClipboardData(
                                                  text: _selectedBankModel
                                                          .shortCode ??
                                                      ""),
                                            );
                                            showCustomSnackBar(
                                                context, 'Sort code copied');
                                          },
                                          icon: Icon(
                                            Icons.copy,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Swift code",
                                      style: greyStyle,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _selectedBankModel.swiftCode ?? "",
                                          style: importantText,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await Clipboard.setData(
                                              ClipboardData(
                                                  text: _selectedBankModel
                                                          .swiftCode ??
                                                      ""),
                                            );
                                            showCustomSnackBar(
                                                context, 'Swift code copied');
                                          },
                                          icon: const Icon(
                                            Icons.copy,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Beneficiary phone number:",
                                      style: greyStyle,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _selectedBankModel
                                                  .beneficiaryPhoneNumber ??
                                              "",
                                          style: importantText,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await Clipboard.setData(
                                              ClipboardData(
                                                  text: _selectedBankModel
                                                          .beneficiaryPhoneNumber ??
                                                      ""),
                                            );
                                            showCustomSnackBar(
                                                context, 'Phone number copied');
                                          },
                                          icon: const Icon(
                                            Icons.copy,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Email",
                                      style: greyStyle,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "sales@wealthapp.live",
                                          style: importantText,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await launchUrlString(
                                                'mailto:sales@wealthapp.live');
                                            await Clipboard.setData(
                                              const ClipboardData(
                                                  text: "sales@wealthapp.live"),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.email_outlined,
                                            size: 20,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(); // Return empty container if data is empty
                  }
                },
                error: (error, _) {
                  return Text("Error fetching banks: $error");
                },
                loading: () {
                  return Center(
                    child: SpinKitCubeGrid(
                      size: 20,
                      color: blackGrey,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

TextStyle greyStyle = GoogleFonts.poppins(
  color: Color(0xff6B6B6F),
  fontSize: 12.sp,
);

TextStyle importantText = GoogleFonts.poppins(
  fontWeight: FontWeight.w400,
  color: Color(0xff282829),
  fontSize: text__md,
);

void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration:
          Duration(milliseconds: 500), // You can change the duration as needed
    ),
  );
}
