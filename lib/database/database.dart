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

    if (useFuzzySearch) {
      // 模糊搜索(或逻辑): 统一搜索框关键词 或 高级筛选条件
      query.where((tbl) {
        Expression<bool>? condition;

        // 处理统一搜索框关键词
        if (keyword != null && keyword.isNotEmpty) {
          final keywords = keyword.trim().split(RegExp(r'\s+'));
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
        }

        // 处理高级筛选条件 - 与关键词使用"或"逻辑
        if (genders != null && genders.isNotEmpty) {
          final genderCondition = tbl.gender.isIn(genders.map((g) => g.index));
          condition = condition == null ? genderCondition : (condition | genderCondition);
        }

        if (minBirthYear != null) {
          final birthYearCondition = tbl.birthYear.isBiggerOrEqualValue(minBirthYear);
          condition = condition == null ? birthYearCondition : (condition | birthYearCondition);
        }

        if (maxBirthYear != null) {
          final birthYearCondition = tbl.birthYear.isSmallerOrEqualValue(maxBirthYear);
          condition = condition == null ? birthYearCondition : (condition | birthYearCondition);
        }

        if (minHeight != null) {
          final heightCondition = tbl.height.isBiggerOrEqualValue(minHeight);
          condition = condition == null ? heightCondition : (condition | heightCondition);
        }

        if (maxHeight != null) {
          final heightCondition = tbl.height.isSmallerOrEqualValue(maxHeight);
          condition = condition == null ? heightCondition : (condition | heightCondition);
        }

        if (minWeight != null) {
          final weightCondition = tbl.weight.isBiggerOrEqualValue(minWeight);
          condition = condition == null ? weightCondition : (condition | weightCondition);
        }

        if (maxWeight != null) {
          final weightCondition = tbl.weight.isSmallerOrEqualValue(maxWeight);
          condition = condition == null ? weightCondition : (condition | weightCondition);
        }

        if (educations != null && educations.isNotEmpty) {
          final educationCondition = tbl.education.isIn(educations.map((e) => e.index));
          condition = condition == null ? educationCondition : (condition | educationCondition);
        }

        if (occupation != null && occupation.isNotEmpty) {
          final occupationCondition = tbl.occupation.contains(occupation);
          condition = condition == null ? occupationCondition : (condition | occupationCondition);
        }

        if (residence != null && residence.isNotEmpty) {
          final residenceCondition = tbl.residence.contains(residence);
          condition = condition == null ? residenceCondition : (condition | residenceCondition);
        }

        if (maritalStatuses != null && maritalStatuses.isNotEmpty) {
          final maritalCondition = tbl.maritalStatus.isIn(maritalStatuses.map((m) => m.index));
          condition = condition == null ? maritalCondition : (condition | maritalCondition);
        }

        if (hasCar == true) {
          final carCondition = tbl.car.isNotValue('');
          condition = condition == null ? carCondition : (condition | carCondition);
        }

        if (hasHouse == true) {
          final houseCondition = tbl.house.isNotValue('');
          condition = condition == null ? houseCondition : (condition | houseCondition);
        }

        return condition ?? Constant(true);
      });
    } else {
      // 精确搜索(且逻辑): 统一搜索框关键词 且 高级筛选条件

      // 处理统一搜索框关键词 - 所有关键词都必须匹配
      if (keyword != null && keyword.isNotEmpty) {
        final keywords = keyword.trim().split(RegExp(r'\s+'));
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

      // 处理高级筛选条件 - 与关键词使用"且"逻辑
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
    }

    return query.get();
  }
}