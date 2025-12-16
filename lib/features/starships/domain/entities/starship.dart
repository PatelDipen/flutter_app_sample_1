import 'package:equatable/equatable.dart';

/// Starship entity from SWAPI
class Starship extends Equatable {
  final String name;
  final String model;
  final String manufacturer;
  final String costInCredits;
  final String length;
  final String maxAtmospheringSpeed;
  final String crew;
  final String passengers;
  final String cargoCapacity;
  final String starshipClass;
  final String url;

  const Starship({
    required this.name,
    required this.model,
    required this.manufacturer,
    required this.costInCredits,
    required this.length,
    required this.maxAtmospheringSpeed,
    required this.crew,
    required this.passengers,
    required this.cargoCapacity,
    required this.starshipClass,
    required this.url,
  });

  String get id => url.split('/').where((s) => s.isNotEmpty).last;

  @override
  List<Object?> get props => [
    name,
    model,
    manufacturer,
    costInCredits,
    length,
    maxAtmospheringSpeed,
    crew,
    passengers,
    cargoCapacity,
    starshipClass,
    url,
  ];
}
