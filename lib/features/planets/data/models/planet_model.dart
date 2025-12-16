import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/planet.dart';

part 'planet_model.freezed.dart';
part 'planet_model.g.dart';

@freezed
class PlanetModel with _$PlanetModel {
  const PlanetModel._();

  const factory PlanetModel({
    required String name,
    @JsonKey(name: 'rotation_period') required String rotationPeriod,
    @JsonKey(name: 'orbital_period') required String orbitalPeriod,
    required String diameter,
    required String climate,
    required String gravity,
    required String terrain,
    @JsonKey(name: 'surface_water') required String surfaceWater,
    required String population,
    required String url,
  }) = _PlanetModel;

  factory PlanetModel.fromJson(Map<String, dynamic> json) =>
      _$PlanetModelFromJson(json);

  Planet toEntity() {
    return Planet(
      name: name,
      rotationPeriod: rotationPeriod,
      orbitalPeriod: orbitalPeriod,
      diameter: diameter,
      climate: climate,
      gravity: gravity,
      terrain: terrain,
      surfaceWater: surfaceWater,
      population: population,
      url: url,
    );
  }
}

@freezed
class PlanetsResponse with _$PlanetsResponse {
  const factory PlanetsResponse({
    required int count,
    String? next,
    String? previous,
    required List<PlanetModel> results,
  }) = _PlanetsResponse;

  factory PlanetsResponse.fromJson(Map<String, dynamic> json) =>
      _$PlanetsResponseFromJson(json);
}
