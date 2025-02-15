import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hexacom_user/common/models/notification_body.dart';
import 'package:hexacom_user/helper/notification_helper.dart';
import 'package:hexacom_user/helper/responsive_helper.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/features/auth/providers/auth_provider.dart';
import 'package:hexacom_user/features/cart/providers/cart_provider.dart';
import 'package:hexacom_user/provider/language_provider.dart';
import 'package:hexacom_user/features/splash/providers/splash_provider.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import 'package:hexacom_user/utill/images.dart';
import 'package:hexacom_user/utill/routes.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<List<ConnectivityResult>> _onConnectivityChanged;
  NotificationBody? notificationBody;

  @override
  void initState() {
    super.initState();
    triggerFirebaseNotification();

    bool firstTime = true;
    _onConnectivityChanged =
        Connectivity().onConnectivityChanged.listen((result) {
      if (!firstTime) {
        bool isNotConnected = result.contains(ConnectivityResult.mobile) ||
            result.contains(ConnectivityResult.wifi);
        isNotConnected
            ? const SizedBox()
            : _globalKey.currentState!.hideCurrentSnackBar();
        _globalKey.currentState!.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', _globalKey.currentContext!)
                : getTranslated('connected', _globalKey.currentContext!),
            textAlign: TextAlign.center,
          ),
        ));

        if (!isNotConnected) {
          _routeToPage();
        }
      }

      firstTime = false;
    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();

    Provider.of<CartProvider>(context, listen: false).getCartData();
    _routeToPage();
    Provider.of<LanguageProvider>(context, listen: false)
        .initializeAllLanguages(context);
  }

  triggerFirebaseNotification() async {
    try {
      final RemoteMessage? remoteMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        notificationBody =
            NotificationHelper.convertNotification(remoteMessage.data);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Images.logo,
              width: 170,
            ),
            // Text(AppConstants.appName, style: rubikBold.copyWith(fontSize: 30, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _routeToPage() {
    final SplashProvider splashProvider = context.read<SplashProvider>();

    splashProvider.initConfig().then((bool isSuccess) async {
      if (isSuccess) {
        try {
          await splashProvider.getDeliveryInfo();

          Timer(const Duration(seconds: 1), () async {
            double minimumVersion = 0.0;
            if (Platform.isAndroid) {
              if (Provider.of<SplashProvider>(context, listen: false)
                      .configModel!
                      .playStoreConfig!
                      .minVersion !=
                  null) {
                minimumVersion =
                    Provider.of<SplashProvider>(context, listen: false)
                            .configModel!
                            .playStoreConfig!
                            .minVersion ??
                        6.0;
              }
            } else if (Platform.isIOS) {
              if (Provider.of<SplashProvider>(context, listen: false)
                      .configModel!
                      .appStoreConfig!
                      .minVersion !=
                  null) {
                minimumVersion =
                    Provider.of<SplashProvider>(context, listen: false)
                            .configModel!
                            .appStoreConfig!
                            .minVersion ??
                        6.0;
              }
            }

            if (AppConstants.appVersion < minimumVersion &&
                !ResponsiveHelper.isWeb()) {
              if (mounted) {
                RouteHelper.getUpdateRoute(context,
                    action: RouteAction.pushNamedAndRemoveUntil);
              }
            } else if (notificationBody != null) {
              notificationRoute();
            } else {
              if (Provider.of<AuthProvider>(context, listen: false)
                  .isLoggedIn()) {
                Provider.of<AuthProvider>(context, listen: false).updateToken();
                if (mounted) {
                  RouteHelper.getMainRoute(context,
                      action: RouteAction.pushNamedAndRemoveUntil);
                }
              } else {
                if (Provider.of<SplashProvider>(context, listen: false)
                    .showLang()) {
                  if (ResponsiveHelper.isMobile(context)) {
                    if (mounted) {
                      RouteHelper.getLanguageRoute(context, 'splash',
                          action: RouteAction.pushNamedAndRemoveUntil);
                    }
                  } else {
                    if (mounted) {
                      RouteHelper.getMainRoute(context,
                          action: RouteAction.pushNamedAndRemoveUntil);
                    }
                  }
                } else {
                  if (mounted) {
                    RouteHelper.getMainRoute(context,
                        action: RouteAction.pushNamedAndRemoveUntil);
                  }
                }
              }
            }
          });
        } catch (e) {
          // Handle errors during async operations
          print('Error during _routeToPage: $e');
          // You can show an error message or handle the failure gracefully here
        }
      }
    }).catchError((e) {
      // Handle errors from initConfig itself
      print('Error in initConfig: $e');
    });
  }

  notificationRoute() {
    if (notificationBody?.type == "message") {
      RouteHelper.getChatRoute(context,
          orderId: notificationBody?.orderId,
          userName: notificationBody?.userName,
          profileImage: notificationBody?.userImage,
          action: RouteAction.pushNamedAndRemoveUntil);
    } else if (notificationBody?.type == "order") {
      RouteHelper.getOrderDetailsRoute(context, notificationBody?.orderId, null,
          action: RouteAction.pushNamedAndRemoveUntil);
    } else if (notificationBody?.type == "general") {
      RouteHelper.getNotificationRoute(context,
          action: RouteAction.pushNamedAndRemoveUntil);
    } else {
      RouteHelper.getMainRoute(context,
          action: RouteAction.pushNamedAndRemoveUntil);
    }
  }
}
