import 'package:flutter/material.dart';

class Lab3Page extends StatelessWidget {
  const Lab3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Лабораторная работа №3'),
      ),
      body: const CardList(),
    );
  }
}

class CardData {
  final String title;
  final String description;
  final String imagePath;
  final IconData icon;

  const CardData({
    required this.title,
    required this.description,
    required this.imagePath,
    this.icon = Icons.star,
  });
}

class CardList extends StatelessWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context) {
    const data = CardData(
      title: 'Minions',
      description: 'I love ULSTU',
      imagePath: 'image/photo_2026-09-04_23-06-10.jpg',
      icon: Icons.movie,
    );

    return Center(
      child: SingleChildScrollView(
        child: InfoCard.fromData(data),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.icon,
  });

  factory InfoCard.fromData(CardData data) {
    return InfoCard(
      title: data.title,
      description: data.description,
      imagePath: data.imagePath,
      icon: data.icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 4,
            offset: const Offset(0, 5),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: 120,
              height: 160,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),

          Icon(icon),
        ],
      ),
    );
  }
}