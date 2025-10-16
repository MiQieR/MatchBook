import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'client.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Clients])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'matchmaker_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }

  Future<List<Client>> getAllClients() => select(clients).get();

  Future<int> insertClient(ClientsCompanion client) => into(clients).insert(client);

  Future<bool> updateClient(Client client) => update(clients).replace(client);

  Future<int> deleteClient(String clientId) =>
      (delete(clients)..where((tbl) => tbl.clientId.equals(clientId))).go();

  Future<Client?> getClientById(String clientId) =>
      (select(clients)..where((tbl) => tbl.clientId.equals(clientId))).getSingleOrNull();

  Future<List<Client>> searchClients({
    String? keyword,
    bool useFuzzySearch = false, // 模糊搜索(或逻辑)
    List<Gender>? genders,
    int? minBirthYear,
    int? maxBirthYear,
    int? minHeight,
    int? maxHeight,
    int? minWeight,
    int? maxWeight,
    List<Education>? educations,
    String? occupation,
    String? residence,
    List<MaritalStatus>? maritalStatuses,
    bool? hasCar, // 有车筛选
    bool? hasHouse, // 有房筛选
  }) {
    final query = select(clients);

    // 统一搜索关键词 - 支持多关键词AND逻辑或OR逻辑
    if (keyword != null && keyword.isNotEmpty) {
      // 按空格分割关键词
      final keywords = keyword.trim().split(RegExp(r'\s+'));

      if (useFuzzySearch) {
        // 模糊搜索(或逻辑): 只要匹配任意一个关键词即可
        query.where((tbl) {
          Expression<bool>? condition;
          for (final kw in keywords) {
            if (kw.isEmpty) continue;
            final kwCondition = tbl.clientId.contains(kw) |
              tbl.recommender.contains(kw) |
              tbl.birthPlace.contains(kw) |
              tbl.residence.contains(kw) |
              tbl.occupation.contains(kw) |
              tbl.familyInfo.contains(kw) |
              tbl.annualIncome.contains(kw) |
              tbl.car.contains(kw) |
              tbl.house.contains(kw) |
              tbl.children.contains(kw) |
              tbl.selfEvaluation.contains(kw) |
              tbl.partnerRequirements.contains(kw);

            condition = condition == null ? kwCondition : (condition | kwCondition);
          }
          return condition ?? Constant(false);
        });
      } else {
        // 精确搜索(且逻辑): 所有关键词都必须匹配
        for (final kw in keywords) {
          if (kw.isEmpty) continue;
          query.where((tbl) =>
            tbl.clientId.contains(kw) |
            tbl.recommender.contains(kw) |
            tbl.birthPlace.contains(kw) |
            tbl.residence.contains(kw) |
            tbl.occupation.contains(kw) |
            tbl.familyInfo.contains(kw) |
            tbl.annualIncome.contains(kw) |
            tbl.car.contains(kw) |
            tbl.house.contains(kw) |
            tbl.children.contains(kw) |
            tbl.selfEvaluation.contains(kw) |
            tbl.partnerRequirements.contains(kw)
          );
        }
      }
    }

    if (genders != null && genders.isNotEmpty) {
      query.where((tbl) => tbl.gender.isIn(genders.map((g) => g.index)));
    }

    if (minBirthYear != null) {
      query.where((tbl) => tbl.birthYear.isBiggerOrEqualValue(minBirthYear));
    }

    if (maxBirthYear != null) {
      query.where((tbl) => tbl.birthYear.isSmallerOrEqualValue(maxBirthYear));
    }

    if (minHeight != null) {
      query.where((tbl) => tbl.height.isBiggerOrEqualValue(minHeight));
    }

    if (maxHeight != null) {
      query.where((tbl) => tbl.height.isSmallerOrEqualValue(maxHeight));
    }

    if (minWeight != null) {
      query.where((tbl) => tbl.weight.isBiggerOrEqualValue(minWeight));
    }

    if (maxWeight != null) {
      query.where((tbl) => tbl.weight.isSmallerOrEqualValue(maxWeight));
    }

    if (educations != null && educations.isNotEmpty) {
      query.where((tbl) => tbl.education.isIn(educations.map((e) => e.index)));
    }

    if (occupation != null && occupation.isNotEmpty) {
      query.where((tbl) => tbl.occupation.contains(occupation));
    }

    if (residence != null && residence.isNotEmpty) {
      query.where((tbl) => tbl.residence.contains(residence));
    }

    if (maritalStatuses != null && maritalStatuses.isNotEmpty) {
      query.where((tbl) => tbl.maritalStatus.isIn(maritalStatuses.map((m) => m.index)));
    }

    // 有车筛选: 勾选后,只显示car字段有内容的客户
    if (hasCar == true) {
      query.where((tbl) => tbl.car.isNotValue(''));
    }

    // 有房筛选: 勾选后,只显示house字段有内容的客户
    if (hasHouse == true) {
      query.where((tbl) => tbl.house.isNotValue(''));
    }

    return query.get();
  }
}