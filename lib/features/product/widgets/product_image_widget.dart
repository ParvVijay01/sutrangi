import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hexacom_user/common/models/product_model.dart';
import 'package:hexacom_user/helper/responsive_helper.dart';
import 'package:hexacom_user/features/cart/providers/cart_provider.dart';
import 'package:hexacom_user/features/product/providers/product_provider.dart';
import 'package:hexacom_user/features/splash/providers/splash_provider.dart';
import 'package:hexacom_user/common/widgets/custom_image_widget.dart';
import 'package:hexacom_user/common/widgets/custom_zoom_widget.dart';
import 'package:hexacom_user/common/widgets/wish_button_widget.dart';

class ProductImageWidget extends StatelessWidget {
  final Product? productModel;
  const ProductImageWidget({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, product, child) {
      String imageUrl =
          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.product!.image![Provider.of<CartProvider>(context, listen: false).productSelect]}';

      return Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (!ResponsiveHelper.isDesktop(context)) {
                _showFullScreenImage(context, imageUrl);
              }
            },
            child: SizedBox(
              height: ResponsiveHelper.isDesktop(context)
                  ? MediaQuery.of(context).size.height * 0.5
                  : MediaQuery.of(context).size.height * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CustomZoomWidget(
                  child: CustomImageWidget(
                    image: imageUrl,
                    fit: ResponsiveHelper.isTab(context)
                        ? BoxFit.fitHeight
                        : BoxFit.contain,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 15,
            bottom: 15,
            child: WishButtonWidget(product: productModel, countVisible: true),
          ),
        ],
      );
    });
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                child: CustomImageWidget(
                  image: imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
