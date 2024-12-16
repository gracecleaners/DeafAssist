import 'package:deafassist/services/payment.dart';
import 'package:deafassist/services/subscription.dart';
import 'package:deafassist/views/screens/interpreter/bttom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deafassist/views/screens/deaf/bottomNavDeaf.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final DarazaPaymentService _paymentService = DarazaPaymentService();
  final SubscriptionService _subscriptionService = SubscriptionService();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionAmount();
  }

  double _subscriptionAmount = 0.0;

  Future<void> _loadSubscriptionAmount() async {
    double amount = await _subscriptionService.getSubscriptionAmount();
    setState(() {
      _subscriptionAmount = amount;
    });
  }

  Future<void> _processPayment() async {
    // Validate phone number
    if (_phoneController.text.isEmpty) {
      _showErrorSnackBar('Please enter phone number');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Initiate payment
      var paymentResult = await _paymentService.initiatePayment(
        phone: _phoneController.text,
        amount: _subscriptionAmount,
        note: 'App Subscription',
      );

      if (paymentResult['success']) {
        // Payment successful, create subscription
        await _subscriptionService.createSubscription();

        // Determine navigation based on user role
        String userRole = await _subscriptionService.getUserRole();
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => userRole == 'deaf' 
              ? const BottomNavDeaf() 
              : const BottomNavInterpreter()
          ),
        );
      } else {
        _showErrorSnackBar(paymentResult['error']);
      }
    } catch (e) {
      _showErrorSnackBar('Payment failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'One-Time Subscription',
              // style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Subscription Amount: ${_subscriptionAmount.toStringAsFixed(0)} UGX',
              // style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter +256XXXXXXXXX',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone),
                errorText: _isValidPhoneNumber(_phoneController.text) 
                  ? null 
                  : 'Invalid phone number format',
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                setState(() {}); // Trigger validation
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _phoneController.text.isNotEmpty 
                      ? _processPayment 
                      : null,
                    child: const Text('Complete Subscription'),
                  ),
          ],
        ),
      ),
    );
  }

  bool _isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\+256\d{9}$');
    return phoneRegex.hasMatch(phone);
  }
}