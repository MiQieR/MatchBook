import 'package:drift/drift.dart';

enum Gender {
  male('男'),
  female('女');

  const Gender(this.label);
  final String label;
}

enum Education {
  primary('小学'),
  juniorHigh('初中'),
  seniorHigh('高中'),
  vocational('中专'),
  junior('大专'),
  bachelor('本科'),
  master('硕士'),
  doctor('博士'),
  postdoc('博士后');

  const Education(this.label);
  final String label;
}

class Clients extends Table {
  TextColumn get clientId => text().named('client_id')();
  TextColumn get recommender => text()();
  IntColumn get gender => intEnum<Gender>()();
  IntColumn get birthYear => integer()();
  TextColumn get birthPlace => text()();
  TextColumn get residence => text()();
  IntColumn get height => integer()();
  IntColumn get weight => integer()();
  IntColumn get education => intEnum<Education>()();
  TextColumn get occupation => text()();
  TextColumn get familyInfo => text()();
  TextColumn get annualIncome => text()();
  TextColumn get selfEvaluation => text()();
  TextColumn get partnerRequirements => text()();

  @override
  Set<Column> get primaryKey => {clientId};
}