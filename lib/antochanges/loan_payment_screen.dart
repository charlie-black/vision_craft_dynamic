import 'package:flutter/material.dart';

class LoanPaymentScreen extends StatefulWidget {
  final String loanAccount;
  final String loanOutstandingBalance;

  const LoanPaymentScreen({
    super.key,
    required this.loanAccount,
    required this.loanOutstandingBalance,
  });

  @override
  State<LoanPaymentScreen> createState() => _LoanPaymentScreenState();
}

class _LoanPaymentScreenState extends State<LoanPaymentScreen> {
  bool _isFullPayment = true;
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.loanOutstandingBalance;
  }

  void _handlePaymentTypeChange(bool? value) {
    setState(() {
      _isFullPayment = value!;
      if (_isFullPayment) {
        _amountController.text = widget.loanOutstandingBalance;
      } else {
        _amountController.clear();
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Repayment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Type:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Full Payment'),
                    leading: Radio<bool>(
                      value: true,
                      groupValue: _isFullPayment,
                      onChanged: _handlePaymentTypeChange,
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Partial Payment'),
                    leading: Radio<bool>(
                      value: false,
                      groupValue: _isFullPayment,
                      onChanged: _handlePaymentTypeChange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              enabled: !_isFullPayment,
              decoration: const InputDecoration(
                labelText: 'Enter Amount To Pay',
                border: OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.error,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Proceed to Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
