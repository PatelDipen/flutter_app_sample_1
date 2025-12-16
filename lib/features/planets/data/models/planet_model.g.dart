// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlanetModelImpl _$$PlanetModelImplFromJson(Map<String, dynamic> json) =>
    _$PlanetModelImpl(
      name: json['name'] as String,
      rotationPeriod: json['rotation_period'] as String,
      orbitalPeriod: json['orbital_period'] as String,
      diameter: json['diameter'] as String,
      climate: json['climate'] as String,
      gravity: json['gravity'] as String,
      terrain: json['terrain'] as String,
      surfaceWater: json['surface_water'] as String,
      population: json['population'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$$PlanetModelImplToJson(_$PlanetModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rotation_period': instance.rotationPeriod,
      'orbital_period': instance.orbitalPeriod,
      'diameter': instance.diameter,
      'climate': instance.climate,
      'gravity': instance.gravity,
      'terrain': instance.terrain,
      'surface_water': instance.surfaceWater,
      'population': instance.population,
      'url': instance.url,
    };

_$PlanetsResponseImpl _$$PlanetsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PlanetsResponseImpl(
  count: (json['count'] as num).toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>)
      .map((e) => PlanetModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$PlanetsResponseImplToJson(
  _$PlanetsResponseImpl instance,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results,
};
