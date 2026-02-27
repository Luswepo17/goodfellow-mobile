import 'package:flutter/material.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(APPTexts.recentTransactions),
            const SizedBox(height: APPSizes.spaceBtwItem),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon to indicate transaction type
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withAlpha(
                      (0.1 * 255).toInt(),
                    ), // Background color for icon
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons
                        .shopping_cart, // Replace with an icon that matches the transaction
                    color: Colors.blueAccent,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),

                // Transaction details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Transaction name
                      const Text(
                        'Purchase at Store',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Transaction date
                      Text(
                        '12 Nov 2024', // Date of the transaction
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                // Transaction amount
                const Text(
                  '- \$50.00', // Negative for expense, positive for income
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        Colors.redAccent, // Green for income, red for expenses
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
