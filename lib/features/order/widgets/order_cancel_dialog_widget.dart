
import 'package:flutter/material.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/features/order/providers/order_provider.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:provider/provider.dart';

class OrderCancelDialogWidget extends StatelessWidget {
  final String orderID;
  final Function callback;
  const OrderCancelDialogWidget({super.key, required this.orderID, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, order, child) {
      return Column(mainAxisSize: MainAxisSize.min, children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 50),
          child: Text(getTranslated('are_you_sure_to_cancel', context), style: rubikBold, textAlign: TextAlign.center),
        ),

        Divider(height: 0, color: Theme.of(context).hintColor),

        !order.isLoading ? Row(children: [

          Expanded(child: InkWell(
            onTap: () {
              Provider.of<OrderProvider>(context, listen: false).cancelOrder(orderID, (String message, bool isSuccess, String orderID) {
                Navigator.pop(context);
                callback(message, isSuccess, orderID);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              alignment: Alignment.center,
              decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text(getTranslated('yes', context), style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
            ),
          )),

          Expanded(child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text(getTranslated('no', context), style: rubikBold.copyWith(color: Colors.white)),
            ),
          )),

        ]) : Center(child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
        )),

      ]);
    });
  }
}
