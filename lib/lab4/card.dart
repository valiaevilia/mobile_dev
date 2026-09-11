part of 'home_page.dart';

class _CardData {
  final String text;
  final String descriptionText;
  final String details;
  final String imagePath;

  const _CardData(
      this.text, {
        required this.descriptionText,
        required this.details,
        required this.imagePath,
      });
}

class _MovieCard extends StatefulWidget {
  final String text;
  final String descriptionText;
  final String details;
  final String imagePath;

  const _MovieCard(
      this.text, {
        required this.descriptionText,
        required this.details,
        required this.imagePath,
      });

  factory _MovieCard.fromData(_CardData data) {
    return _MovieCard(
      data.text,
      descriptionText: data.descriptionText,
      details: data.details,
      imagePath: data.imagePath,
    );
  }

  @override
  State<_MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<_MovieCard> {
  bool isLiked = false;

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isLiked
              ? '${widget.text} добавлен в понравившиеся'
              : '${widget.text} удалён из понравившихся',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showDetails() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.text),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.imagePath,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(widget.descriptionText),
              const SizedBox(height: 12),
              Text(widget.details),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDetails,
      child: Container(
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
                height: 140,
                width: 100,
                child: Image.asset(
                  widget.imagePath,
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
                    widget.text,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.descriptionText,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: _toggleLike,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isLiked
                    ? const Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
                  key: ValueKey<int>(0),
                )
                    : const Icon(
                  Icons.favorite_border,
                  key: ValueKey<int>(1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}