import 'package:flutter/material.dart';

part 'card.dart';

class Lab4Page extends StatefulWidget {
  const Lab4Page({super.key});

  @override
  State<Lab4Page> createState() => _Lab4PageState();
}

class _Lab4PageState extends State<Lab4Page> {
  final Color _color = Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color,
        title: const Text('Лабораторная работа №4'),
      ),
      body: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    const data = [
      _CardData(
        'Маяк 2019',
        descriptionText: 'The Lighthouse',
        details:
        'Два смотрителя маяка оказываются на удалённом острове, где постепенно начинают происходить странные события.',
        imagePath: 'image/45ea3b3c78d89d0e7b8e6b71284e75c4.jpg',
      ),
      _CardData(
        'Ноябрь 2017',
        descriptionText: 'November',
        details:
        'Мрачная история, действие которой происходит в эстонской деревне, наполненной фольклором, мистикой и необычными существами.',
        imagePath: 'image/nov2.png',
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        children: data.map((movie) => _MovieCard.fromData(movie)).toList(),
      ),
    );
  }
}