import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/app_theme.dart';
import 'package:school_cafteria/core/constants/font_manager.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/features/account/presentation/pages/Account/loginpage.dart';
import 'package:school_cafteria/features/products/presentation/bloc/products_bloc.dart'
    as pb;
import 'package:school_cafteria/features/balance/presentation/bloc/balance_bloc.dart'
    as bb;
import 'package:school_cafteria/features/products/presentation/pages/history/invoices.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/navigation.dart';
import '../../../../core/network/api.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../products/presentation/pages/ban_products/banned_products_page.dart';
import '../../../products/presentation/pages/day_products/products_search_by_price.dart';
import '../../../products/presentation/pages/day_products/school_days_xd.dart';
import '../../domain/entities/user.dart';
import '../bloc/account/account_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.user}) : super(key: key);
  User user;
  final balance = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final weeklyBalance = TextEditingController();
  final formKey1 = GlobalKey<FormState>();

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<HomePage> {
  // static final customCacheaManager = Config
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<bb.BalanceBloc, bb.BalanceState>(
            listener: (context, state) {
              if (state is bb.SuccessMsgState) {
                Fluttertoast.showToast(
                    msg: state.message,
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: Colors.green,
                    textColor: Colors.white);
                List<String> accessTokens = [];
                for (var school in widget.user.schools!) {
                  accessTokens.add(school.accessToken!);
                }
                BlocProvider.of<AccountBloc>(context)
                    .add(RefreshEvent(accessTokens));
              }
            },
          ),
          BlocListener<AccountBloc, AccountState>(
            listener: (context, state) {
              if (state is ErrorMsgState) {
                SnackBarMessage().showErrorSnackBar(
                    message: state.message, context: context);
              } else if (state is LoggedOutState) {
                Go.offALL(context, const LoginPage(isAnother: false));
              } else if (state is SuccessMsgState) {
                SnackBarMessage().showSuccessSnackBar(
                    message: state.message, context: context);
                List<String> accessTokens = [];
                for (var school in widget.user.schools!) {
                  accessTokens.add(school.accessToken!);
                }
                BlocProvider.of<AccountBloc>(context)
                    .add(RefreshEvent(accessTokens));
              } else if (state is LoggedInState) {
                setState(() {
                  widget.user = state.user;
                  print('=============sucess============');
                });
              }
            },
          )
        ],
        child: RefreshIndicator(
          onRefresh: () {
            List<String> accessTokens = [];
            for (var school in widget.user.schools!) {
              accessTokens.add(school.accessToken!);
            }
            setState(() {});
            BlocProvider.of<AccountBloc>(context)
                .add(RefreshEvent(accessTokens));

            return Future.value();
          },
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.user.childern!.length,
              itemBuilder: (_, index) {
                final name = TextEditingController();
                final schoolName = TextEditingController();

                schoolName.text = widget.user.childern![index].school!.name!;
                name.text = widget.user.childern![index].name!;

                final balance = TextEditingController();
                balance.text = toCurrencyString(
                    widget.user.childern![index].balance.toString(),
                    trailingSymbol:
                        widget.user.childern![index].school!.currencyName!,
                    useSymbolPadding: true);

                return SizedBox(
                    height: 22.h + 26.w,
                    child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: pc2.withOpacity(0.1),
                            blurRadius: 20.0,
                          )
                        ]),
                        child: ClipRect(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Banner(
                              message:
                                  widget.user.childern![index].isActive == 1
                                      ? "CHILD_ACTIVE".tr(context)
                                      : "CHILD_NOT_ACTIVE".tr(context),
                              location: BannerLocation.topStart,
                              color: widget.user.childern![index].isActive == 1
                                  ? Colors.green
                                  : Colors.redAccent,
                              child: Card(
                                color: HexColor('#23284E').withOpacity(.45),
                                // elevation: 10,
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 5,
                                      color: oldPrimaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Card(
                                  // color: Colors.white.withOpacity(0.5),
                                  color: HexColor('#23284E').withOpacity(.45),
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 3, color: secondaryColor2),
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  elevation: 0,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 6.w,
                                          right: 6.w,
                                          top: 2.h,
                                          bottom: 1.h,
                                        ),
                                        // color: Colors.red,
                                        // height: 7.h,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              name.text,
                                              style: FontManager.dubaiBold
                                                  .copyWith(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              toCurrencyString(balance.text,
                                                  useSymbolPadding: true,
                                                  trailingSymbol: widget
                                                      .user
                                                      .childern![index]
                                                      .school!
                                                      .currencyName!),
                                              style: FontManager.dubaiRegular
                                                  .copyWith(
                                                color: Colors.white,
                                                fontSize: 13.sp,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.w),
                                        child: const DottedLine(
                                          lineThickness: 3,
                                          dashColor: secondaryColor2,
                                        ),
                                      ),
                                      Container(
                                        // color: Colors.red,
                                        width: 100.w,
                                        height: 24.h,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(
                                                  AppLocalizations.of(context)!
                                                              .locale!
                                                              .languageCode !=
                                                          'ar'
                                                      ? 2.w
                                                      : 1.w), //!
                                              width: 32.w,
                                              height: 20.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: Border.all(
                                                  color: HexColor('#8E579C'),
                                                  width: 3,
                                                ),
                                              ),
                                              child: CachedNetworkImage(
                                                // cacheManager: Base,
                                                fit: BoxFit.cover,
                                                imageUrl: 'http://medrese.uk' +
                                                    widget.user.childern![index]
                                                        .image,
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              26),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(7),
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Image.asset(
                                                            'assets/launcher/logo.png'),
                                                        CircularProgressIndicator(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.all(5.w),
                                                    child: Opacity(
                                                      opacity: .6,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Lottie.asset(
                                                              'assets/images/Desktop HD.json'),
                                                          Text(
                                                            'undefined image',
                                                            style: FontManager
                                                                .dubaiRegular
                                                                .copyWith(
                                                              fontSize: 8.5.sp,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                                Container(
                                                    // color: Colors.red,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0),
                                                    width: 48.w,
                                                    height: 3.h,
                                                    child: TextField(
                                                      style: FontManager
                                                          .dubaiBold
                                                          .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 13.sp,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      readOnly: true,
                                                      controller:
                                                          TextEditingController(
                                                              text: schoolName
                                                                  .text
                                                                  .toUpperCase()),
                                                    )),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 5,
                                                        right: 5,
                                                      ),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          padding:
                                                              EdgeInsets.all(0),
                                                          backgroundColor:
                                                              HexColor(
                                                                      '#662483')
                                                                  .withOpacity(
                                                                      .68),
                                                          fixedSize:
                                                              Size(27.w, 6.h),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                        ),
                                                        onPressed: widget
                                                                    .user
                                                                    .childern![
                                                                        index]
                                                                    .isActive ==
                                                                "0"
                                                            ? null
                                                            : () {
                                                                selectStudentSpendingType(
                                                                    context,
                                                                    widget
                                                                        .user
                                                                        .childern![
                                                                            index]
                                                                        .name!,
                                                                    widget
                                                                        .user
                                                                        .childern![
                                                                            index]
                                                                        .id!,
                                                                    widget
                                                                        .user
                                                                        .childern![
                                                                            index]
                                                                        .accessTokenParent!,
                                                                    widget
                                                                        .user
                                                                        .childern![
                                                                            index]
                                                                        .school!
                                                                        .currencyName!);
                                                              },
                                                        child: Text(
                                                          "HOME_PAGE_BUTTON1"
                                                              .tr(context),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FontManager
                                                              .dubaiBold
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 10.sp,
                                                          ),
                                                        ),
                                                      ), // <-- Text
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 5,
                                                        right: 5,
                                                      ),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              HexColor(
                                                                      '#662483')
                                                                  .withOpacity(
                                                                      .68),
                                                          fixedSize:
                                                              Size(27.w, 6.h),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0)),
                                                        ),
                                                        onPressed: widget
                                                                    .user
                                                                    .childern![
                                                                        index]
                                                                    .isActive ==
                                                                "0"
                                                            ? null
                                                            : () {
                                                                BlocProvider.of<
                                                                            pb.ProductsBloc>(
                                                                        context)
                                                                    .add(pb.GetAllBannedProductsEvent(
                                                                        widget
                                                                            .user
                                                                            .childern![
                                                                                index]
                                                                            .id!,
                                                                        widget
                                                                            .user
                                                                            .childern![index]
                                                                            .accessTokenParent!));
                                                                Go.to(
                                                                    context,
                                                                    BannedProducts(
                                                                        accessToken: widget
                                                                            .user
                                                                            .childern![
                                                                                index]
                                                                            .accessTokenParent!,
                                                                        childId: widget
                                                                            .user
                                                                            .childern![
                                                                                index]
                                                                            .id!,
                                                                        currency: widget
                                                                            .user
                                                                            .childern![index]
                                                                            .school!
                                                                            .currencyName!));
                                                              },
                                                        child: Text(
                                                          "HOME_PAGE_BUTTON2"
                                                              .tr(context),
                                                          style: FontManager
                                                              .dubaiBold
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 10.sp,
                                                          ),
                                                        ), // <-- Text
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 5,
                                                        right: 5,
                                                      ),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              HexColor(
                                                                      '#662483')
                                                                  .withOpacity(
                                                                      .68),
                                                          fixedSize:
                                                              Size(27.w, 6.h),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0)),
                                                        ),
                                                        onPressed: widget
                                                                    .user
                                                                    .childern![
                                                                        index]
                                                                    .isActive ==
                                                                "0"
                                                            ? null
                                                            : () {
                                                                BlocProvider.of<
                                                                            pb.ProductsBloc>(
                                                                        context)
                                                                    .add(pb.GetInvoicesEvent(
                                                                        widget
                                                                            .user
                                                                            .childern![
                                                                                index]
                                                                            .id!,
                                                                        widget
                                                                            .user
                                                                            .childern![index]
                                                                            .accessTokenParent!,
                                                                        null,
                                                                        null));
                                                                Go.to(
                                                                    context,
                                                                    InvoicesPage(
                                                                      childId: widget
                                                                          .user
                                                                          .childern![
                                                                              index]
                                                                          .id!,
                                                                      childImage: widget
                                                                          .user
                                                                          .childern![
                                                                              index]
                                                                          .image!,
                                                                      accessToken: widget
                                                                          .user
                                                                          .childern![
                                                                              index]
                                                                          .accessTokenParent!,
                                                                      currencyName: widget
                                                                          .user
                                                                          .childern![
                                                                              index]
                                                                          .school!
                                                                          .currencyName!,
                                                                    ));
                                                              },

                                                        child: Text(
                                                          "HOME_PAGE_BUTTON3"
                                                              .tr(context),
                                                          style: FontManager
                                                              .dubaiBold
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 10.sp,
                                                          ),
                                                        ), // <-- Text
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 5,
                                                        right: 5,
                                                      ),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              HexColor(
                                                                      '#662483')
                                                                  .withOpacity(
                                                                      .68),
                                                          fixedSize:
                                                              Size(27.w, 6.h),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0)),
                                                        ),
                                                        onPressed: widget
                                                                    .user
                                                                    .childern![
                                                                        index]
                                                                    .isActive ==
                                                                "0"
                                                            ? null
                                                            : () {
                                                                selectPaymentMethod(
                                                                    context,
                                                                    widget
                                                                        .user
                                                                        .childern![
                                                                            index]
                                                                        .name!,
                                                                    widget
                                                                        .user
                                                                        .childern![
                                                                            index]
                                                                        .id!,
                                                                    widget
                                                                        .user
                                                                        .childern![
                                                                            index]
                                                                        .accessTokenParent!);
                                                              },

                                                        child: Text(
                                                          "HOME_PAGE_BUTTON4"
                                                              .tr(context),
                                                          style: FontManager
                                                              .dubaiBold
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 10.sp,
                                                          ),
                                                        ), // <-- Text
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  //
                                ),
                              ),
                            ))));
              }),
        ));
  }

  void selectPaymentMethod(
      BuildContext context, String childName, int childId, String accessToken) {
    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: HexColor('#8D6996'),
              titlePadding: EdgeInsets.zero,
              title: SizedBox(
                height: 8.h,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.zero,
                  color: primaryColor,
                  elevation: 5,
                  child: Center(
                    child: Text(
                      "HOME_PAGE_PAYMENT_METHOD".tr(context),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fixedSize: Size(60.w, 6.7.h),
                          elevation: 5,
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: primaryColor)),
                      onPressed: () {
                        Go.back(context);
                        enterCashPayment(
                            context, childName, childId, accessToken);
                      },
                      child: Text("PAYMENT_METHOD_1".tr(context),
                          style: FontManager.kumbhSansBold.copyWith(
                              fontSize: 17.sp, color: HexColor('#777575')))),
                  SizedBox(
                    height: 4.h,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        fixedSize: Size(60.w, 6.7.h),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: primaryColor)),
                    onPressed: () {},
                    child: Text(
                      "PAYMENT_METHOD_2".tr(context),
                      style: TextStyle(
                          fontSize: 17.sp, color: HexColor('#777575')),
                    ),
                  ),
                ],
              ));
        });
  }

  void enterCashPayment(
      BuildContext context, String childName, int childId, String accessToken) {
    showDialog<bool>(
        context: context,
        builder: (_) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: HexColor('#8D6996'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding: EdgeInsets.all(4.h),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.grey,
                        backgroundColor: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text("HOME_PAGE_SET_PAYMENT".tr(context),
                          style: FontManager.kumbhSansBold
                              .copyWith(fontSize: 14.sp, color: Colors.green)),
                      onPressed: () async {
                        if (widget.formKey.currentState!.validate()) {
                          confirmationDialog(context, () {
                            Go.back(context);
                            BlocProvider.of<bb.BalanceBloc>(context).add(
                              bb.AddBalanceEvent(
                                double.parse(widget.balance.text),
                                childId,
                                accessToken,
                              ),
                            );
                          },
                              "ADD_CREDIT_CONFIRMATION"
                                      .tr(context)
                                      .toUpperCase() +
                                  widget.balance.text);
                        }
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.grey,
                        backgroundColor: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                          "DIALOG_BUTTON_CANCEL".tr(context).toUpperCase(),
                          style: FontManager.kumbhSansBold
                              .copyWith(fontSize: 14.sp, color: Colors.red)))
                ],
                titlePadding: EdgeInsets.zero,
                title: SizedBox(
                    height: 8.h,
                    child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: primaryColor,
                        elevation: 10,
                        child: Center(
                            child: Text(
                          "SET_PAYMENTS_TITLE".tr(context),
                          style: FontManager.kumbhSansBold.copyWith(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )))),
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      Text(
                        "SET_PAYMENT_BODY".tr(context) + childName,
                        style: FontManager.kumbhSansBold.copyWith(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Form(
                        key: widget.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 40.w,
                              child: Card(
                                color: HexColor('#F7F4F4'),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 2.h, right: 2.h, left: 2.h),
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'(^-?\d*\.?\d*)'))
                                    ],
                                    validator: (mobile) => mobile!.isEmpty
                                        ? "REQUIRED_FIELD".tr(context)
                                        : null,
                                    controller: widget.balance,
                                    decoration: InputDecoration(
                                      // filled: true,
                                      // fillColor: HexColor('#F7F4F4'),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: HexColor('#8D6996')),
                                      ),
                                      border: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor),
                                      ),
                                      hintStyle: FontManager.kumbhSansBold
                                          .copyWith(color: textColor),
                                      hintText: 'DIALOG_SEARCH_PRICE_TEXT_HINT'
                                          .tr(context),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  void enterWeeklyBalance(BuildContext context, String childName, int childId,
      String accessToken, String currency) {
    showDialog<bool>(
        context: context,
        builder: (_) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  ElevatedButton(
                      child: Text("DIALOG_CONFIRMATION_BUTTON1".tr(context),
                          style: TextStyle(fontSize: 14.sp)),
                      onPressed: () async {
                        if (widget.formKey1.currentState!.validate()) {
                          BlocProvider.of<bb.BalanceBloc>(context).add(
                              bb.StoreWeeklyBalanceEvent(
                                  double.parse(widget.weeklyBalance.text),
                                  childId,
                                  accessToken));
                          await Future.delayed(
                              const Duration(milliseconds: 1500));
                          if (mounted) {
                            BlocProvider.of<pb.ProductsBloc>(context).add(
                                pb.GetSchoolProductsByPriceEvent(
                                    childId, accessToken, null));
                            Go.off(
                                context,
                                ProductSearch(
                                  accessToken: accessToken,
                                  childId: childId,
                                  currency: currency,
                                  maxPrice: null,
                                  dayId: null,
                                  dayName: null,
                                  isWeekly: true,
                                  daysCount: 5,
                                  weeklyBalance: widget.weeklyBalance.text,
                                  childName: childName,
                                ));
                          }
                        }
                      }),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("DIALOG_BUTTON_CANCEL".tr(context),
                          style: TextStyle(fontSize: 14.sp)))
                ],
                title: Text(
                  "SET_WEEKLY_BALANCE".tr(context) + childName,
                  style: TextStyle(fontSize: 11.sp),
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: widget.formKey1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 40.w,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'(^-?\d*\.?\d*)'))
                            ],
                            validator: (mobile) => mobile!.isEmpty
                                ? "REQUIRED_FIELD".tr(context)
                                : null,
                            controller: widget.weeklyBalance,
                            decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              hintText:
                                  'DIALOG_SEARCH_PRICE_TEXT_HINT'.tr(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  void selectStudentSpendingType(BuildContext context, String childName,
      int childId, String accessToken, String currency) {
    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: HexColor('#8D6996'),
              titlePadding: EdgeInsets.zero,
              title: SizedBox(
                height: 8.h,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: HexColor('#8D6996'),
                  margin: EdgeInsets.zero,
                  elevation: 20,
                  child: Center(
                    child: Text(
                      "SET_SPENDING_TYPE".tr(context),
                      style: FontManager.kumbhSansBold.copyWith(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      fixedSize: Size(60.w, 6.5.h),
                      side: const BorderSide(
                        color: textColor,
                      ),
                    ),
                    onPressed: () {
                      Go.back(context);
                      BlocProvider.of<pb.ProductsBloc>(context)
                          .add(pb.GetSchoolDaysEvent(childId, accessToken));
                      Go.to(
                          context,
                          SchoolDays2(
                            accessToken: accessToken,
                            childId: childId,
                            currency: currency,
                            childName: childName,
                          ));
                    },
                    child: Text(
                      "SPENDING_TYPE1".tr(context),
                      style: FontManager.kumbhSansBold.copyWith(
                        fontSize: 17.sp,
                        color: HexColor('#777575'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          fixedSize: Size(60.w, 6.5.h),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: textColor)),
                      onPressed: () {
                        BlocProvider.of<pb.ProductsBloc>(context).add(
                            pb.GetSchoolProductsByPriceEvent(
                                childId, accessToken, null));
                        Go.off(
                            context,
                            ProductSearch(
                              accessToken: accessToken,
                              childId: childId,
                              currency: currency,
                              maxPrice: null,
                              dayId: null,
                              dayName: null,
                              isWeekly: true,
                              daysCount: 5,
                              weeklyBalance: widget.weeklyBalance.text,
                              childName: childName,
                            ));
                      },
                      child: Text(
                        "SPENDING_TYPE2".tr(context),
                        style: FontManager.kumbhSansBold.copyWith(
                          fontSize: 17.sp,
                          color: HexColor('#777575'),
                        ),
                      )),
                ],
              ));
        });
  }
}
