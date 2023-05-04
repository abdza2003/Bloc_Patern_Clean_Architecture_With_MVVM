import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/widgets/loading_widget.dart';
import 'package:school_cafteria/features/products/presentation/bloc/products_bloc.dart';
import 'package:school_cafteria/features/products/presentation/pages/ban_products/school_products_page.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/navigation.dart';
import '../../../../../core/network/api.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/confirmation_dialog.dart';
import '../../no_product_found.dart';

class BannedProducts extends StatelessWidget {
  const BannedProducts(
      {Key? key,
      required this.accessToken,
      required this.childId,
      required this.currency})
      : super(key: key);
  final String accessToken;
  final int childId;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
      if (state is ErrorMsgState) {
        SnackBarMessage()
            .showErrorSnackBar(message: state.message, context: context);
      } else if (state is SuccessMsgState) {
        SnackBarMessage()
            .showSuccessSnackBar(message: state.message, context: context);
        BlocProvider.of<ProductsBloc>(context)
            .add(GetAllBannedProductsEvent(childId, accessToken));
      }
    }, buildWhen: (productsBloc, productsState) {
      if (productsState is LoadedBannedState) {
        return true;
      } else {
        return false;
      }
    }, builder: (context, state) {
      if (state is LoadingState) {
        return Scaffold(body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.repeat,
                    image: AssetImage('assets/images/bg.png'))),
            child: LoadingWidget()));
      } else if (state is LoadedBannedState) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(10.h+10.w),
            child: AppBar(
                flexibleSpace:  Padding(
                  padding:  EdgeInsets.only(top:5.h ,right: 38.w),
                  child: Container(
                    height: 8.h+7.w,
                    decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/launcher/logo.png'))),),
                ),
                elevation: 20,
                bottomOpacity: 0,
                backgroundColor: Colors.white.withOpacity(0.7),
                shadowColor: Color(0xffFF5DB9),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.elliptical(1100, 500),
                      bottomLeft: Radius.elliptical(550, 350)
                  ),
                )),
          ),
          floatingActionButtonLocation:
              AppLocalizations.of(context)!.locale!.languageCode != 'ar'
                  ? FloatingActionButtonLocation.endFloat
                  : FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              BlocProvider.of<ProductsBloc>(context)
                  .add(GetAllSchoolProductsEvent(childId, accessToken));
              Go.to(
                  context,
                  AddBannedProducts(
                    accessToken: accessToken,
                    childId: childId,
                    currency: currency,
                  ));
            },
            child: const Icon(Icons.add),
          ),
          body: state.products.isEmpty
              ? const NoPageFound()
              : Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          repeat: ImageRepeat.repeat,
                          image: AssetImage('assets/images/bg.png'))),
                  child: ListView(children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Center(
                      child: Card(
                        color: Colors.white.withOpacity(0.7),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: SizedBox(
                          height: 5.h,
                          width: 66.w,
                          child: Center(
                              child: Text("PRODUCTS_LIST".tr(context),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700))),
                        ),
                      ),
                    ),
                     ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 7.h + 20.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                        padding: EdgeInsets.all(0.4.h),
                                        child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minWidth: 35.w,
                                              maxWidth: 35.w,
                                              maxHeight: 20.h,
                                              minHeight: 20.h,
                                            ),
                                            child: state.products[index]
                                                        .image ==
                                                    null
                                                ? Image.asset(
                                                    'assets/launcher/logo.png',
                                                    scale: 15.0,
                                                  )
                                                : Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white70,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      25.0),
                                                  border: Border.all(
                                                      color:
                                                      primaryColor)),
                                              height: 12.h + 13.w,
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(25.0),
                                                  child: Image(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(Network().baseUrl + state.products[index].image!),
                                                    width: 35.w,
                                                  )),
                                            ))),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.37,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.w, 1.h, 0, 0),
                                          child: AutoSizeText(
                                            state.products[index].name!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.37,
                                        height: 9.h,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.w, 1.h, 0, 0),
                                          child: AutoSizeText(
                                            state.products[index].description ??
                                                state.products[index].name!,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 1.h, 0, 0),
                                        child: Text(
                                          toCurrencyString(
                                              state.products[index].price!,
                                              trailingSymbol: currency,
                                              useSymbolPadding: true),
                                          style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.w, 2.h, 0, 0),
                                          child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20),
                                                )),
                                                onPressed:(){
                                                  confirmationDialog(context,(){BlocProvider.of<ProductsBloc>(
                                                      context)
                                                      .add(
                                                      DeleteBannedProductsEvent(
                                                          state
                                                              .products[index]
                                                              .id!,
                                                          childId,
                                                          accessToken));},"PRODUCT_REMOVE_BAN_CONFIRMATION".tr(context));


                                                },
                                                child: Text("PRODUCTS_LIST_UNBLOCK".tr(context),style: TextStyle(color: Colors.red),),
                                              )),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                  ]),
                ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
