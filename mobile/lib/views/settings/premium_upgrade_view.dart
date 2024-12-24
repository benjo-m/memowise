import 'package:flutter/material.dart';
import 'package:mobile/services/stripe_service.dart';

class PremiumUpgradeView extends StatefulWidget {
  const PremiumUpgradeView({super.key});

  @override
  State<PremiumUpgradeView> createState() => _PremiumUpgradeViewState();
}

class _PremiumUpgradeViewState extends State<PremiumUpgradeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Upgrade'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'With the premium upgrade, you get:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Unlimited number of decks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 85, 85),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Unlimited number of cards per deck',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 85, 85),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'AI-generated decks with up to 50 cards instead of 20',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 85, 85),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Premium users\' feedback is displayed before free users\' feedback',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 85, 85),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Price: \$4.99',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  StripeService.instance.makePayment();
                },
                child: const Text('Upgrade Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
