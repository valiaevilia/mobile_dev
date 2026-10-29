import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/movie_card.dart';

part 'state.g.dart';

@CopyWith()
class MovieState extends Equatable {
  final List<MovieCardData>? data;
  final bool isLoading;
  final String? error;

  const MovieState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [
    data,
    isLoading,
    error,
  ];
}