import 'package:equatable/equatable.dart';

/// Person entity from SWAPI
class Person extends Equatable {
  final String name;
  final String height;
  final String mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String birthYear;
  final String gender;
  final String url;

  const Person({
    required this.name,
    required this.height,
    required this.mass,
    required this.hairColor,
    required this.skinColor,
    required this.eyeColor,
    required this.birthYear,
    required this.gender,
    required this.url,
  });

  String get id => url.split('/').where((s) => s.isNotEmpty).last;

  @override
  List<Object?> get props => [
    name,
    height,
    mass,
    hairColor,
    skinColor,
    eyeColor,
    birthYear,
    gender,
    url,
  ];
}
