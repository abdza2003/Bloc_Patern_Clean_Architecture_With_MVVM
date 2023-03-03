import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/app_theme.dart';
import 'package:school_cafteria/features/account/data/models/child_model.dart';
import 'package:school_cafteria/features/account/presentation/pages/Account/loginpage.dart';
import 'package:school_cafteria/features/account/presentation/pages/add_child_page.dart';
import 'package:school_cafteria/features/products/presentation/bloc/products_bloc.dart'
    as pb;
import 'package:school_cafteria/features/balance/presentation/bloc/balance_bloc.dart'
    as bb;
import 'package:school_cafteria/features/products/presentation/pages/day_products/school_days.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/navigation.dart';
import '../../../../core/network/api.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../../main.dart';
import '../../../products/presentation/pages/ban_products/banned_products_page.dart';
import '../../domain/entities/user.dart';
import '../bloc/account/account_bloc.dart';

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
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<bb.BalanceBloc, bb.BalanceState>(
            listener: (context, state) {
              if (state is bb.SuccessMsgState) {
                Fluttertoast.showToast(msg: state.message,toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.green,textColor: Colors.white);
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
                });
              }
            },
          )
        ],
        child: Scaffold(
            floatingActionButtonLocation:
                AppLocalizations.of(context)!.locale!.languageCode != 'ar'
                    ? FloatingActionButtonLocation.endFloat
                    : FloatingActionButtonLocation.startFloat,
            floatingActionButton: _getFAB(true, context),
            appBar: AppBar(
              leadingWidth: 30.w,
              leading:
              Row(
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.logout),
                  //   onPressed: () {
                  //     BlocProvider.of<AccountBloc>(context).add(LogoutEvent());
                  //     Go.offALL(context, const LoginPage(isAnother: false));
                  //   },),
                  SizedBox(width: 3.w,),
                   SizedBox(
                     width: 27.w,
                     height: 10.h,
                     child: DropdownButtonHideUnderline(
                       child: DropdownButton(
                           dropdownColor:Colors.white,
                           hint:Text("Language",style: TextStyle(color: Colors.white),) ,
                           items: [DropdownMenuItem(
                          value: "en",
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 20.w,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "English",
                                    style: TextStyle(fontSize: 14.sp),
                                  )),
                            ],
                          ),
                  ),DropdownMenuItem(
                          value: "ar",
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 20.w,
                                  child: Text(
                                    "Arabic",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14.sp),
                                  )),
                            ],
                          ),
                  ),
                             DropdownMenuItem(
                          value: "tr",
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 20.w,
                                  child: Text(
                                    "Turkey",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14.sp),
                                  )),
                            ],
                          ),
                  ),
                  ], onChanged: (String? lang) async {
                             SharedPreferences local= await SharedPreferences.getInstance();
                             local.setString("lang", lang!);
                             if(mounted) {
                               MyApp.of(context)?.setLocale(Locale.fromSubtags(languageCode: lang));
                             }
                       }),
                     ),
                   ),
                  // ), IconButton(
                  //   icon: const Icon(Icons.logout),
                  // //  onPressed: () => MyApp.of(context)?.setLocale(Locale.fromSubtags(languageCode: 'ar')),
                  //
                  // ),
                ],
              ),
              actions: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.history),
                  label: Text("HOME_PAGE_BUTTON5".tr(context)),
                ),
              ],
              title: Text(
                "APP_NAME".tr(context),
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () {
                List<String> accessTokens = [];
                for (var school in widget.user.schools!) {
                  accessTokens.add(school.accessToken!);
                }
                BlocProvider.of<AccountBloc>(context)
                    .add(RefreshEvent(accessTokens));

                return Future.value();
              },
              child: GroupedListView<ChildModel, String>(
                  elements: widget.user.childern!,
                  // itemCount: user.childern?.length,
                  groupBy: (child) => child.school!.name!,
                  useStickyGroupSeparators: true,
                  // optional
                  groupSeparatorBuilder: (String groupByValue) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Icon(
                              Icons.school,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              groupByValue,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                  itemBuilder: (context, ChildModel childModel) {
                    final name = TextEditingController();
                    name.text = childModel.name!;
                    final balance = TextEditingController();
                    balance.text = toCurrencyString(
                        childModel.balance.toString(),
                        trailingSymbol: childModel.school!.currencyName!,
                        useSymbolPadding: true);
                    return SizedBox(
                        height: 30.h,
                        child: Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: pc2.withOpacity(0.1),
                                blurRadius: 20.0,
                              )
                            ]),
                            child: ClipRect(
                                child: Banner(
                              message: childModel.isActive == "1"
                                  ? "CHILD_ACTIVE".tr(context)
                                  : "CHILD_NOT_ACTIVE".tr(context),
                              location: BannerLocation.topStart,
                              color: childModel.isActive == "1"
                                  ? Colors.green
                                  : Colors.redAccent,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                                elevation: 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: pc2.withOpacity(0.2),
                                      width: 37.w,
                                      height: 100.h,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          childModel.image == null
                                              ? Image.asset(
                                                  'assets/launcher/logo.png',
                                                  scale: 25.0,
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Image(
                                                    image: NetworkImage(
                                                        Network().baseUrl +
                                                            childModel.image!),
                                                    width: 30.w,
                                                  )),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 60.w,
                                          height: 12.h,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  height: 7.h,
                                                  width: 60.w,
                                                  child: TextField(
                                                    style: TextStyle(
                                                        fontSize: 13.sp),
                                                    decoration: InputDecoration(
                                                      //contentPadding: EdgeInsets.symmetric(vertical: 6),
                                                      border: InputBorder.none,
                                                      prefixIcon: Icon(
                                                        Icons.person,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                    readOnly: true,
                                                    controller: name,
                                                  )),
                                              SizedBox(
                                                  height: 5.h,
                                                  width: 60.w,
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 1),
                                                      border: InputBorder.none,
                                                      prefixIcon: Icon(
                                                        Icons
                                                            .account_balance_wallet,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                    readOnly: true,
                                                    controller: balance,
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(28.w, 7.h),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0)),
                                                ),
                                                onPressed: childModel
                                                            .isActive ==
                                                        "0"
                                                    ? null
                                                    : () {
                                                        if (childModel.weeklyBalance != null && childModel.weeklyBalance!="0.00") {
                                                          BlocProvider.of<
                                                                      pb.ProductsBloc>(
                                                                  context)
                                                              .add(pb.GetSchoolDaysEvent(
                                                                  childModel
                                                                      .id!,
                                                                  childModel
                                                                      .accessTokenParent!));
                                                          Go.to(
                                                              context,
                                                              SchoolDays(
                                                                  accessToken:
                                                                      childModel
                                                                          .accessTokenParent!,
                                                                  childId:
                                                                      childModel
                                                                          .id!,
                                                                  currency: childModel
                                                                      .school!
                                                                      .currencyName!,childName: childModel.name!,));
                                                        } else {
                                                          enterWeeklyBalance(
                                                              context,
                                                              childModel.name!,
                                                              childModel.id!,
                                                              childModel
                                                                  .accessTokenParent!,
                                                              childModel.school!
                                                                  .currencyName!);
                                                        }
                                                      },
                                                icon: Icon(
                                                  // <-- Icon
                                                  Icons.calendar_month,
                                                  size: 16.sp,
                                                ),
                                                label: Text(
                                                  "HOME_PAGE_BUTTON1"
                                                      .tr(context),
                                                  style: TextStyle(
                                                      fontSize: 8.5.sp),
                                                ),
                                              ), // <-- Text
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(28.w, 7.h),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0)),
                                                ),
                                                onPressed:
                                                    childModel.isActive == "0"
                                                        ? null
                                                        : () {
                                                            BlocProvider.of<
                                                                        pb.ProductsBloc>(
                                                                    context)
                                                                .add(pb.GetAllBannedProductsEvent(
                                                                    childModel
                                                                        .id!,
                                                                    childModel
                                                                        .accessTokenParent!));
                                                            Go.to(
                                                                context,
                                                                BannedProducts(
                                                                    accessToken:
                                                                        childModel
                                                                            .accessTokenParent!,
                                                                    childId:
                                                                        childModel
                                                                            .id!,
                                                                    currency: childModel
                                                                        .school!
                                                                        .currencyName!));
                                                          },
                                                icon: Icon(
                                                  // <-- Icon
                                                  Icons.not_interested,
                                                  size: 16.sp,
                                                ),
                                                label: Text(
                                                  "HOME_PAGE_BUTTON2"
                                                      .tr(context),
                                                  style: TextStyle(
                                                      fontSize: 8.5.sp),
                                                ), // <-- Text
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(28.w, 7.h),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0)),
                                                ),
                                                onPressed:
                                                    childModel.isActive == "0"
                                                        ? null
                                                        : () {},
                                                icon: Icon(
                                                  // <-- Icon
                                                  Icons.receipt,
                                                  size: 16.sp,
                                                ),
                                                label: Text(
                                                  "HOME_PAGE_BUTTON3"
                                                      .tr(context),
                                                  style: TextStyle(
                                                      fontSize: 8.5.sp),
                                                ), // <-- Text
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(28.w, 7.h),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0)),
                                                ),
                                                onPressed:
                                                    childModel.isActive == "0"
                                                        ? null
                                                        : () {
                                                            selectPaymentMethod(
                                                                context,
                                                                childModel
                                                                    .name!,
                                                                childModel.id!,
                                                                childModel
                                                                    .accessTokenParent!);
                                                          },
                                                icon: Icon(
                                                  // <-- Icon
                                                  Icons
                                                      .monetization_on_outlined,
                                                  size: 16.sp,
                                                ),
                                                label: Text(
                                                  "HOME_PAGE_BUTTON4"
                                                      .tr(context),
                                                  style: TextStyle(
                                                      fontSize: 8.5.sp),
                                                ), // <-- Text
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //
                              ),
                            ))));
                  }),
            )));
  }

  Widget _getFAB(bool canAdd, BuildContext context) {
    return SpeedDial(
      childMargin: EdgeInsets.zero,
      animatedIcon: AnimatedIcons.add_event,
      //animatedIconTheme: IconThemeData(size: 22),
      //backgroundColor: Color(0xFF801E48),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: const Icon(Icons.home_work),
            //backgroundColor: Color(0xFF801E48),
            onTap: () {
              Go.to(context, const LoginPage(isAnother: true));
            },
            label: "HOME_PAGE_FLOAT_BUTTON".tr(context),
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 10.sp),
            labelBackgroundColor: primaryColor),
        // FAB 2
        SpeedDialChild(
            visible: canAdd,
            child: const Icon(Icons.child_care),
            //backgroundColor: Color(0xFF801E48),
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text(
                        "CHOOSE_SCHOOL".tr(context),
                        style: TextStyle(color: primaryColor),
                      ),
                      content: SizedBox(
                          height: 30.h, // Change as per your requirement
                          width: 30.w,
                          child: ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const Divider(thickness: 1),
                              itemCount: widget.user.schools!.length,
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: BorderSide(color: primaryColor)),
                                    onPressed: () => Go.off(
                                        context,
                                        AddChild(
                                            accessToken: widget.user
                                                .schools![index].accessToken!)),
                                    child: Text(
                                        widget.user.schools![index].name!,
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            color: primaryColor)));
                              })));
                }),
            //Go.to(context, const AddChild());
            label: "HOME_PAGE_FLOAT_BUTTON2".tr(context),
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 10.sp),
            labelBackgroundColor: primaryColor)
      ],
    );
  }

  void selectPaymentMethod(
      BuildContext context, String childName, int childId, String accessToken) {
    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "Choose Payment Method",
                style: TextStyle(color: primaryColor),
              ),
              content: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(26.w, 10.h),
                                backgroundColor: Colors.white,
                                side: BorderSide(color: primaryColor)),
                            onPressed: () {
                              Go.back(context);
                              enterCashPayment(
                                  context, childName, childId, accessToken);
                            },
                            child: Text("Cash",
                                style: TextStyle(
                                    fontSize: 17.sp, color: primaryColor))),
                       ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(26.w, 10.h),
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: primaryColor)),
                              onPressed: null,
                              child: Text("Online",
                                  style: TextStyle(
                                      fontSize: 17.sp, color: primaryColor))),
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
                contentPadding: EdgeInsets.zero,
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  ElevatedButton(
                      child: Text("Confirm", style: TextStyle(fontSize: 14.sp)),
                      onPressed: () async {
                        if (widget.formKey.currentState!.validate()) {
                          Go.back(context);
                          BlocProvider.of<bb.BalanceBloc>(context).add(
                              bb.AddBalanceEvent(
                                  double.parse(widget.balance.text),
                                  childId,
                                  accessToken));
                        }
                      }),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("DIALOG_BUTTON_CANCEL".tr(context),
                          style: TextStyle(fontSize: 14.sp)))
                ],
                title: Text(
                  "Add Balance to $childName",
                  style: TextStyle(fontSize: 11.sp),
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: widget.formKey,
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
                            controller: widget.balance,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              border: UnderlineInputBorder(
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
                      child: Text("Confirm", style: TextStyle(fontSize: 14.sp)),
                      onPressed: ()  async {
                        if (widget.formKey1.currentState!.validate()) {
                          BlocProvider.of<bb.BalanceBloc>(context).add(
                              bb.StoreWeeklyBalanceEvent(
                                  double.parse(widget.weeklyBalance.text),
                                  childId,
                                  accessToken));
                          await Future.delayed(const Duration(milliseconds:1500 ));
                          if (mounted) {
                            BlocProvider.of<
                                pb.ProductsBloc>(
                                context)
                                .add(pb.GetSchoolDaysEvent(
                                childId,
                                accessToken));


                            Go.off(
                                context,
                                SchoolDays(
                                    accessToken: accessToken,
                                    childId: childId,
                                    currency: currency,childName: childName,));
                          }

                        }
                      }),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("DIALOG_BUTTON_CANCEL".tr(context),
                          style: TextStyle(fontSize: 14.sp)))
                ],
                title: Text(
                  "Set Weekly Balance to $childName",
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
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              border: UnderlineInputBorder(
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
}
