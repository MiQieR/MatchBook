import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'client.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Clients])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

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
  }) {
    final query = select(clients);
    
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
    
    return query.get();
  }
}