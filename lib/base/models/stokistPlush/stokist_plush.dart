import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';

part 'stokist_plush.g.dart';

@JsonSerializable()
class StokistPlush extends ElephantUserCore {
  late int balanceStuffedAnimals;

  StokistPlush({
    required this.balanceStuffedAnimals,
  });

  static String get tableName => "STOKISTPLUSH";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      BalanceStuffedAnimals INTEGER)""";

  factory StokistPlush.fromJson(Map<String, dynamic> json) => _$StokistPlushFromJson(json);

  Map<String, dynamic> toJson() => _$StokistPlushToJson(this);
}