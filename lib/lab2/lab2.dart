import 'package:flutter/material.dart';

enum PaymentStatus {
  waiting,
  processing,
  success,
}

class Payment {
  final double amount;
  PaymentStatus status;

  Payment(this.amount, this.status);

  void changeStatus(PaymentStatus newStatus) {
    status = newStatus;
  }
}

extension MoneyExtension on double {
  String get rubles => '${toStringAsFixed(2)} ₽';
}

class Lab2Page extends StatefulWidget {
  const Lab2Page({super.key});

  @override
  State<Lab2Page> createState() => _Lab2PageState();
}

class _Lab2PageState extends State<Lab2Page> {
  final Payment payment = Payment(100, PaymentStatus.waiting);

  final List<Payment> paymentHistory = [];

  Future<void> processPayment() async {
    setState(() {
      payment.changeStatus(PaymentStatus.processing);
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      payment.changeStatus(PaymentStatus.success);
      paymentHistory.add(payment);
    });

    for (Payment item in paymentHistory) {
      print('Оплата: ${item.amount.rubles}, статус: ${item.status.name}');
    }
  }

  String getStatusText() {
    switch (payment.status) {
      case PaymentStatus.waiting:
        return 'Ожидание оплаты';
      case PaymentStatus.processing:
        return 'Обработка платежа...';
      case PaymentStatus.success:
        return 'Оплата подтверждена';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Валяев Илья ПИбд 33'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Сумма: ${payment.amount.rubles}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),

            Text(
              getStatusText(),
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: payment.status == PaymentStatus.processing
                  ? null
                  : () async {
                await processPayment();
              },
              child: const Text('Оплатить'),
            ),
          ],
        ),
      ),
    );
  }
}