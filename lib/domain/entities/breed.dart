import 'package:equatable/equatable.dart';

class Breed extends Equatable {
  final String id;
  final String name;
  final String temperament;
  final String origin;
  final String description;

  const Breed({
    required this.id,
    required this.name,
    required this.temperament,
    required this.origin,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, temperament, origin, description];
}
