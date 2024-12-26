import 'package:flutter/material.dart';
import 'package:mobile/services/stripe_service.dart';
import 'package:mobile/views/main_view.dart';

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
            const SizedBox(height: 20),
            const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    'Unlimited number of decks',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 85, 85),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    'Unlimited number of cards per deck',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 85, 85),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    'AI generated decks with up to 30 cards',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 85, 85),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    'Premium users\' feedback is prioritized',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 85, 85),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            Column(
              children: [
                const Center(
                  child: Text(
                    '\$4.99',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'One-time purchase',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () => upgradeToPremium(),
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(
                      Color.fromARGB(255, 241, 183, 7),
                    ),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.014),
                    ),
                    fixedSize: WidgetStatePropertyAll(
                      Size.fromWidth(
                        MediaQuery.sizeOf(context).width * 0.4,
                      ),
                    ),
                    side: const WidgetStatePropertyAll(
                      BorderSide(
                        width: 2,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  child: const Text("Upgrade Now"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  upgradeToPremium() async {
    try {
      await StripeService.instance.makePayment();
      showDialog(
          context: context,
          builder: (context) => SimpleDialog(
                title: const Text(
                  "Upgraded to premium",
                  textAlign: TextAlign.center,
                ),
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Upgrade to premium verison successful. Enjoy!",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainView())),
                          child: const Text("Close")),
                    ],
                  )
                ],
              ));
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => SimpleDialog(
                title: const Text(
                  "Transaction Cancelled",
                  textAlign: TextAlign.center,
                ),
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "The premium upgrade transaction has been cancelled",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Close")),
                    ],
                  )
                ],
              ));
    }
  }
}
