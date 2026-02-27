import 'package:flutter/material.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/widgets/detail_text.dart';
import 'package:goodfellow/utils/constants/sizes.dart';

class ZescoDetails extends StatelessWidget {
  final String zescoToken;
  final String units;
  final String customerName;
  final String customerAddress;
  final String kwhAmount;
  final String totalVat;
  final String voucherSerial;

  const ZescoDetails({
    super.key,
    required this.zescoToken,
    required this.units,
    required this.customerName,
    required this.customerAddress,
    required this.kwhAmount,
    required this.totalVat,
    required this.voucherSerial,
  });

  @override
  Widget build(BuildContext context) {
    if (zescoToken.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DetailText(text: "Token"),
            DetailText(text: zescoToken),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItem / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DetailText(text: "Units"),
            DetailText(text: units),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItem / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DetailText(text: "Customer Name"),
            DetailText(text: customerName),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItem / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DetailText(text: "Address"),
            DetailText(text: customerAddress),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItem / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DetailText(text: "Kwh Amount"),
            DetailText(text: kwhAmount),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItem / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DetailText(text: "Total VAT"),
            DetailText(text: totalVat),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItem / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DetailText(text: "Voucher Serial"),
            DetailText(text: voucherSerial),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItem / 2),
      ],
    );
  }
}
