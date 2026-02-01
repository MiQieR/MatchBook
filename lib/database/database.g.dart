// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recommenderMeta = const VerificationMeta(
    'recommender',
  );
  @override
  late final GeneratedColumn<String> recommender = GeneratedColumn<String>(
    'recommender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Gender, int> gender =
      GeneratedColumn<int>(
        'gender',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Gender>($ClientsTable.$convertergender);
  static const VerificationMeta _birthYearMeta = const VerificationMeta(
    'birthYear',
  );
  @override
  late final GeneratedColumn<int> birthYear = GeneratedColumn<int>(
    'birth_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthPlaceMeta = const VerificationMeta(
    'birthPlace',
  );
  @override
  late final GeneratedColumn<String> birthPlace = GeneratedColumn<String>(
    'birth_place',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _residenceMeta = const VerificationMeta(
    'residence',
  );
  @override
  late final GeneratedColumn<String> residence = GeneratedColumn<String>(
    'residence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Education, int> education =
      GeneratedColumn<int>(
        'education',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Education>($ClientsTable.$convertereducation);
  static const VerificationMeta _occupationMeta = const VerificationMeta(
    'occupation',
  );
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
    'occupation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyInfoMeta = const VerificationMeta(
    'familyInfo',
  );
  @override
  late final GeneratedColumn<String> familyInfo = GeneratedColumn<String>(
    'family_info',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _annualIncomeMeta = const VerificationMeta(
    'annualIncome',
  );
  @override
  late final GeneratedColumn<String> annualIncome = GeneratedColumn<String>(
    'annual_income',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carMeta = const VerificationMeta('car');
  @override
  late final GeneratedColumn<String> car = GeneratedColumn<String>(
    'car',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _houseMeta = const VerificationMeta('house');
  @override
  late final GeneratedColumn<String> house = GeneratedColumn<String>(
    'house',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MaritalStatus, int>
  maritalStatus = GeneratedColumn<int>(
    'marital_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  ).withConverter<MaritalStatus>($ClientsTable.$convertermaritalStatus);
  static const VerificationMeta _childrenMeta = const VerificationMeta(
    'children',
  );
  @override
  late final GeneratedColumn<String> children = GeneratedColumn<String>(
    'children',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _selfEvaluationMeta = const VerificationMeta(
    'selfEvaluation',
  );
  @override
  late final GeneratedColumn<String> selfEvaluation = GeneratedColumn<String>(
    'self_evaluation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partnerRequirementsMeta =
      const VerificationMeta('partnerRequirements');
  @override
  late final GeneratedColumn<String> partnerRequirements =
      GeneratedColumn<String>(
        'partner_requirements',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    recommender,
    gender,
    birthYear,
    birthPlace,
    residence,
    height,
    weight,
    education,
    occupation,
    familyInfo,
    annualIncome,
    car,
    house,
    maritalStatus,
    children,
    photoPath,
    selfEvaluation,
    partnerRequirements,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Client> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('recommender')) {
      context.handle(
        _recommenderMeta,
        recommender.isAcceptableOrUnknown(
          data['recommender']!,
          _recommenderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recommenderMeta);
    }
    if (data.containsKey('birth_year')) {
      context.handle(
        _birthYearMeta,
        birthYear.isAcceptableOrUnknown(data['birth_year']!, _birthYearMeta),
      );
    } else if (isInserting) {
      context.missing(_birthYearMeta);
    }
    if (data.containsKey('birth_place')) {
      context.handle(
        _birthPlaceMeta,
        birthPlace.isAcceptableOrUnknown(data['birth_place']!, _birthPlaceMeta),
      );
    } else if (isInserting) {
      context.missing(_birthPlaceMeta);
    }
    if (data.containsKey('residence')) {
      context.handle(
        _residenceMeta,
        residence.isAcceptableOrUnknown(data['residence']!, _residenceMeta),
      );
    } else if (isInserting) {
      context.missing(_residenceMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('occupation')) {
      context.handle(
        _occupationMeta,
        occupation.isAcceptableOrUnknown(data['occupation']!, _occupationMeta),
      );
    } else if (isInserting) {
      context.missing(_occupationMeta);
    }
    if (data.containsKey('family_info')) {
      context.handle(
        _familyInfoMeta,
        familyInfo.isAcceptableOrUnknown(data['family_info']!, _familyInfoMeta),
      );
    } else if (isInserting) {
      context.missing(_familyInfoMeta);
    }
    if (data.containsKey('annual_income')) {
      context.handle(
        _annualIncomeMeta,
        annualIncome.isAcceptableOrUnknown(
          data['annual_income']!,
          _annualIncomeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_annualIncomeMeta);
    }
    if (data.containsKey('car')) {
      context.handle(
        _carMeta,
        car.isAcceptableOrUnknown(data['car']!, _carMeta),
      );
    } else if (isInserting) {
      context.missing(_carMeta);
    }
    if (data.containsKey('house')) {
      context.handle(
        _houseMeta,
        house.isAcceptableOrUnknown(data['house']!, _houseMeta),
      );
    } else if (isInserting) {
      context.missing(_houseMeta);
    }
    if (data.containsKey('children')) {
      context.handle(
        _childrenMeta,
        children.isAcceptableOrUnknown(data['children']!, _childrenMeta),
      );
    } else if (isInserting) {
      context.missing(_childrenMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('self_evaluation')) {
      context.handle(
        _selfEvaluationMeta,
        selfEvaluation.isAcceptableOrUnknown(
          data['self_evaluation']!,
          _selfEvaluationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selfEvaluationMeta);
    }
    if (data.containsKey('partner_requirements')) {
      context.handle(
        _partnerRequirementsMeta,
        partnerRequirements.isAcceptableOrUnknown(
          data['partner_requirements']!,
          _partnerRequirementsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_partnerRequirementsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      recommender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recommender'],
      )!,
      gender: $ClientsTable.$convertergender.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}gender'],
        )!,
      ),
      birthYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}birth_year'],
      )!,
      birthPlace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_place'],
      )!,
      residence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}residence'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight'],
      )!,
      education: $ClientsTable.$convertereducation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}education'],
        )!,
      ),
      occupation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occupation'],
      )!,
      familyInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_info'],
      )!,
      annualIncome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}annual_income'],
      )!,
      car: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}car'],
      )!,
      house: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}house'],
      )!,
      maritalStatus: $ClientsTable.$convertermaritalStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}marital_status'],
        )!,
      ),
      children: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}children'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      )!,
      selfEvaluation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}self_evaluation'],
      )!,
      partnerRequirements: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}partner_requirements'],
      )!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Gender, int, int> $convertergender =
      const EnumIndexConverter<Gender>(Gender.values);
  static JsonTypeConverter2<Education, int, int> $convertereducation =
      const EnumIndexConverter<Education>(Education.values);
  static JsonTypeConverter2<MaritalStatus, int, int> $convertermaritalStatus =
      const EnumIndexConverter<MaritalStatus>(MaritalStatus.values);
}

class Client extends DataClass implements Insertable<Client> {
  final String clientId;
  final String recommender;
  final Gender gender;
  final int birthYear;
  final String birthPlace;
  final String residence;
  final int height;
  final int weight;
  final Education education;
  final String occupation;
  final String familyInfo;
  final String annualIncome;
  final String car;
  final String house;
  final MaritalStatus maritalStatus;
  final String children;
  final String photoPath;
  final String selfEvaluation;
  final String partnerRequirements;
  const Client({
    required this.clientId,
    required this.recommender,
    required this.gender,
    required this.birthYear,
    required this.birthPlace,
    required this.residence,
    required this.height,
    required this.weight,
    required this.education,
    required this.occupation,
    required this.familyInfo,
    required this.annualIncome,
    required this.car,
    required this.house,
    required this.maritalStatus,
    required this.children,
    required this.photoPath,
    required this.selfEvaluation,
    required this.partnerRequirements,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    map['recommender'] = Variable<String>(recommender);
    {
      map['gender'] = Variable<int>(
        $ClientsTable.$convertergender.toSql(gender),
      );
    }
    map['birth_year'] = Variable<int>(birthYear);
    map['birth_place'] = Variable<String>(birthPlace);
    map['residence'] = Variable<String>(residence);
    map['height'] = Variable<int>(height);
    map['weight'] = Variable<int>(weight);
    {
      map['education'] = Variable<int>(
        $ClientsTable.$convertereducation.toSql(education),
      );
    }
    map['occupation'] = Variable<String>(occupation);
    map['family_info'] = Variable<String>(familyInfo);
    map['annual_income'] = Variable<String>(annualIncome);
    map['car'] = Variable<String>(car);
    map['house'] = Variable<String>(house);
    {
      map['marital_status'] = Variable<int>(
        $ClientsTable.$convertermaritalStatus.toSql(maritalStatus),
      );
    }
    map['children'] = Variable<String>(children);
    map['photo_path'] = Variable<String>(photoPath);
    map['self_evaluation'] = Variable<String>(selfEvaluation);
    map['partner_requirements'] = Variable<String>(partnerRequirements);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      clientId: Value(clientId),
      recommender: Value(recommender),
      gender: Value(gender),
      birthYear: Value(birthYear),
      birthPlace: Value(birthPlace),
      residence: Value(residence),
      height: Value(height),
      weight: Value(weight),
      education: Value(education),
      occupation: Value(occupation),
      familyInfo: Value(familyInfo),
      annualIncome: Value(annualIncome),
      car: Value(car),
      house: Value(house),
      maritalStatus: Value(maritalStatus),
      children: Value(children),
      photoPath: Value(photoPath),
      selfEvaluation: Value(selfEvaluation),
      partnerRequirements: Value(partnerRequirements),
    );
  }

  factory Client.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      clientId: serializer.fromJson<String>(json['clientId']),
      recommender: serializer.fromJson<String>(json['recommender']),
      gender: $ClientsTable.$convertergender.fromJson(
        serializer.fromJson<int>(json['gender']),
      ),
      birthYear: serializer.fromJson<int>(json['birthYear']),
      birthPlace: serializer.fromJson<String>(json['birthPlace']),
      residence: serializer.fromJson<String>(json['residence']),
      height: serializer.fromJson<int>(json['height']),
      weight: serializer.fromJson<int>(json['weight']),
      education: $ClientsTable.$convertereducation.fromJson(
        serializer.fromJson<int>(json['education']),
      ),
      occupation: serializer.fromJson<String>(json['occupation']),
      familyInfo: serializer.fromJson<String>(json['familyInfo']),
      annualIncome: serializer.fromJson<String>(json['annualIncome']),
      car: serializer.fromJson<String>(json['car']),
      house: serializer.fromJson<String>(json['house']),
      maritalStatus: $ClientsTable.$convertermaritalStatus.fromJson(
        serializer.fromJson<int>(json['maritalStatus']),
      ),
      children: serializer.fromJson<String>(json['children']),
      photoPath: serializer.fromJson<String>(json['photoPath']),
      selfEvaluation: serializer.fromJson<String>(json['selfEvaluation']),
      partnerRequirements: serializer.fromJson<String>(
        json['partnerRequirements'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'recommender': serializer.toJson<String>(recommender),
      'gender': serializer.toJson<int>(
        $ClientsTable.$convertergender.toJson(gender),
      ),
      'birthYear': serializer.toJson<int>(birthYear),
      'birthPlace': serializer.toJson<String>(birthPlace),
      'residence': serializer.toJson<String>(residence),
      'height': serializer.toJson<int>(height),
      'weight': serializer.toJson<int>(weight),
      'education': serializer.toJson<int>(
        $ClientsTable.$convertereducation.toJson(education),
      ),
      'occupation': serializer.toJson<String>(occupation),
      'familyInfo': serializer.toJson<String>(familyInfo),
      'annualIncome': serializer.toJson<String>(annualIncome),
      'car': serializer.toJson<String>(car),
      'house': serializer.toJson<String>(house),
      'maritalStatus': serializer.toJson<int>(
        $ClientsTable.$convertermaritalStatus.toJson(maritalStatus),
      ),
      'children': serializer.toJson<String>(children),
      'photoPath': serializer.toJson<String>(photoPath),
      'selfEvaluation': serializer.toJson<String>(selfEvaluation),
      'partnerRequirements': serializer.toJson<String>(partnerRequirements),
    };
  }

  Client copyWith({
    String? clientId,
    String? recommender,
    Gender? gender,
    int? birthYear,
    String? birthPlace,
    String? residence,
    int? height,
    int? weight,
    Education? education,
    String? occupation,
    String? familyInfo,
    String? annualIncome,
    String? car,
    String? house,
    MaritalStatus? maritalStatus,
    String? children,
    String? photoPath,
    String? selfEvaluation,
    String? partnerRequirements,
  }) => Client(
    clientId: clientId ?? this.clientId,
    recommender: recommender ?? this.recommender,
    gender: gender ?? this.gender,
    birthYear: birthYear ?? this.birthYear,
    birthPlace: birthPlace ?? this.birthPlace,
    residence: residence ?? this.residence,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    education: education ?? this.education,
    occupation: occupation ?? this.occupation,
    familyInfo: familyInfo ?? this.familyInfo,
    annualIncome: annualIncome ?? this.annualIncome,
    car: car ?? this.car,
    house: house ?? this.house,
    maritalStatus: maritalStatus ?? this.maritalStatus,
    children: children ?? this.children,
    photoPath: photoPath ?? this.photoPath,
    selfEvaluation: selfEvaluation ?? this.selfEvaluation,
    partnerRequirements: partnerRequirements ?? this.partnerRequirements,
  );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      recommender: data.recommender.present
          ? data.recommender.value
          : this.recommender,
      gender: data.gender.present ? data.gender.value : this.gender,
      birthYear: data.birthYear.present ? data.birthYear.value : this.birthYear,
      birthPlace: data.birthPlace.present
          ? data.birthPlace.value
          : this.birthPlace,
      residence: data.residence.present ? data.residence.value : this.residence,
      height: data.height.present ? data.height.value : this.height,
      weight: data.weight.present ? data.weight.value : this.weight,
      education: data.education.present ? data.education.value : this.education,
      occupation: data.occupation.present
          ? data.occupation.value
          : this.occupation,
      familyInfo: data.familyInfo.present
          ? data.familyInfo.value
          : this.familyInfo,
      annualIncome: data.annualIncome.present
          ? data.annualIncome.value
          : this.annualIncome,
      car: data.car.present ? data.car.value : this.car,
      house: data.house.present ? data.house.value : this.house,
      maritalStatus: data.maritalStatus.present
          ? data.maritalStatus.value
          : this.maritalStatus,
      children: data.children.present ? data.children.value : this.children,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      selfEvaluation: data.selfEvaluation.present
          ? data.selfEvaluation.value
          : this.selfEvaluation,
      partnerRequirements: data.partnerRequirements.present
          ? data.partnerRequirements.value
          : this.partnerRequirements,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('clientId: $clientId, ')
          ..write('recommender: $recommender, ')
          ..write('gender: $gender, ')
          ..write('birthYear: $birthYear, ')
          ..write('birthPlace: $birthPlace, ')
          ..write('residence: $residence, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('education: $education, ')
          ..write('occupation: $occupation, ')
          ..write('familyInfo: $familyInfo, ')
          ..write('annualIncome: $annualIncome, ')
          ..write('car: $car, ')
          ..write('house: $house, ')
          ..write('maritalStatus: $maritalStatus, ')
          ..write('children: $children, ')
          ..write('photoPath: $photoPath, ')
          ..write('selfEvaluation: $selfEvaluation, ')
          ..write('partnerRequirements: $partnerRequirements')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientId,
    recommender,
    gender,
    birthYear,
    birthPlace,
    residence,
    height,
    weight,
    education,
    occupation,
    familyInfo,
    annualIncome,
    car,
    house,
    maritalStatus,
    children,
    photoPath,
    selfEvaluation,
    partnerRequirements,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.clientId == this.clientId &&
          other.recommender == this.recommender &&
          other.gender == this.gender &&
          other.birthYear == this.birthYear &&
          other.birthPlace == this.birthPlace &&
          other.residence == this.residence &&
          other.height == this.height &&
          other.weight == this.weight &&
          other.education == this.education &&
          other.occupation == this.occupation &&
          other.familyInfo == this.familyInfo &&
          other.annualIncome == this.annualIncome &&
          other.car == this.car &&
          other.house == this.house &&
          other.maritalStatus == this.maritalStatus &&
          other.children == this.children &&
          other.photoPath == this.photoPath &&
          other.selfEvaluation == this.selfEvaluation &&
          other.partnerRequirements == this.partnerRequirements);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<String> clientId;
  final Value<String> recommender;
  final Value<Gender> gender;
  final Value<int> birthYear;
  final Value<String> birthPlace;
  final Value<String> residence;
  final Value<int> height;
  final Value<int> weight;
  final Value<Education> education;
  final Value<String> occupation;
  final Value<String> familyInfo;
  final Value<String> annualIncome;
  final Value<String> car;
  final Value<String> house;
  final Value<MaritalStatus> maritalStatus;
  final Value<String> children;
  final Value<String> photoPath;
  final Value<String> selfEvaluation;
  final Value<String> partnerRequirements;
  final Value<int> rowid;
  const ClientsCompanion({
    this.clientId = const Value.absent(),
    this.recommender = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.birthPlace = const Value.absent(),
    this.residence = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
    this.education = const Value.absent(),
    this.occupation = const Value.absent(),
    this.familyInfo = const Value.absent(),
    this.annualIncome = const Value.absent(),
    this.car = const Value.absent(),
    this.house = const Value.absent(),
    this.maritalStatus = const Value.absent(),
    this.children = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.selfEvaluation = const Value.absent(),
    this.partnerRequirements = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientsCompanion.insert({
    required String clientId,
    required String recommender,
    required Gender gender,
    required int birthYear,
    required String birthPlace,
    required String residence,
    required int height,
    required int weight,
    required Education education,
    required String occupation,
    required String familyInfo,
    required String annualIncome,
    required String car,
    required String house,
    required MaritalStatus maritalStatus,
    required String children,
    this.photoPath = const Value.absent(),
    required String selfEvaluation,
    required String partnerRequirements,
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       recommender = Value(recommender),
       gender = Value(gender),
       birthYear = Value(birthYear),
       birthPlace = Value(birthPlace),
       residence = Value(residence),
       height = Value(height),
       weight = Value(weight),
       education = Value(education),
       occupation = Value(occupation),
       familyInfo = Value(familyInfo),
       annualIncome = Value(annualIncome),
       car = Value(car),
       house = Value(house),
       maritalStatus = Value(maritalStatus),
       children = Value(children),
       selfEvaluation = Value(selfEvaluation),
       partnerRequirements = Value(partnerRequirements);
  static Insertable<Client> custom({
    Expression<String>? clientId,
    Expression<String>? recommender,
    Expression<int>? gender,
    Expression<int>? birthYear,
    Expression<String>? birthPlace,
    Expression<String>? residence,
    Expression<int>? height,
    Expression<int>? weight,
    Expression<int>? education,
    Expression<String>? occupation,
    Expression<String>? familyInfo,
    Expression<String>? annualIncome,
    Expression<String>? car,
    Expression<String>? house,
    Expression<int>? maritalStatus,
    Expression<String>? children,
    Expression<String>? photoPath,
    Expression<String>? selfEvaluation,
    Expression<String>? partnerRequirements,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (recommender != null) 'recommender': recommender,
      if (gender != null) 'gender': gender,
      if (birthYear != null) 'birth_year': birthYear,
      if (birthPlace != null) 'birth_place': birthPlace,
      if (residence != null) 'residence': residence,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (education != null) 'education': education,
      if (occupation != null) 'occupation': occupation,
      if (familyInfo != null) 'family_info': familyInfo,
      if (annualIncome != null) 'annual_income': annualIncome,
      if (car != null) 'car': car,
      if (house != null) 'house': house,
      if (maritalStatus != null) 'marital_status': maritalStatus,
      if (children != null) 'children': children,
      if (photoPath != null) 'photo_path': photoPath,
      if (selfEvaluation != null) 'self_evaluation': selfEvaluation,
      if (partnerRequirements != null)
        'partner_requirements': partnerRequirements,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientsCompanion copyWith({
    Value<String>? clientId,
    Value<String>? recommender,
    Value<Gender>? gender,
    Value<int>? birthYear,
    Value<String>? birthPlace,
    Value<String>? residence,
    Value<int>? height,
    Value<int>? weight,
    Value<Education>? education,
    Value<String>? occupation,
    Value<String>? familyInfo,
    Value<String>? annualIncome,
    Value<String>? car,
    Value<String>? house,
    Value<MaritalStatus>? maritalStatus,
    Value<String>? children,
    Value<String>? photoPath,
    Value<String>? selfEvaluation,
    Value<String>? partnerRequirements,
    Value<int>? rowid,
  }) {
    return ClientsCompanion(
      clientId: clientId ?? this.clientId,
      recommender: recommender ?? this.recommender,
      gender: gender ?? this.gender,
      birthYear: birthYear ?? this.birthYear,
      birthPlace: birthPlace ?? this.birthPlace,
      residence: residence ?? this.residence,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      education: education ?? this.education,
      occupation: occupation ?? this.occupation,
      familyInfo: familyInfo ?? this.familyInfo,
      annualIncome: annualIncome ?? this.annualIncome,
      car: car ?? this.car,
      house: house ?? this.house,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      children: children ?? this.children,
      photoPath: photoPath ?? this.photoPath,
      selfEvaluation: selfEvaluation ?? this.selfEvaluation,
      partnerRequirements: partnerRequirements ?? this.partnerRequirements,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (recommender.present) {
      map['recommender'] = Variable<String>(recommender.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(
        $ClientsTable.$convertergender.toSql(gender.value),
      );
    }
    if (birthYear.present) {
      map['birth_year'] = Variable<int>(birthYear.value);
    }
    if (birthPlace.present) {
      map['birth_place'] = Variable<String>(birthPlace.value);
    }
    if (residence.present) {
      map['residence'] = Variable<String>(residence.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    if (education.present) {
      map['education'] = Variable<int>(
        $ClientsTable.$convertereducation.toSql(education.value),
      );
    }
    if (occupation.present) {
      map['occupation'] = Variable<String>(occupation.value);
    }
    if (familyInfo.present) {
      map['family_info'] = Variable<String>(familyInfo.value);
    }
    if (annualIncome.present) {
      map['annual_income'] = Variable<String>(annualIncome.value);
    }
    if (car.present) {
      map['car'] = Variable<String>(car.value);
    }
    if (house.present) {
      map['house'] = Variable<String>(house.value);
    }
    if (maritalStatus.present) {
      map['marital_status'] = Variable<int>(
        $ClientsTable.$convertermaritalStatus.toSql(maritalStatus.value),
      );
    }
    if (children.present) {
      map['children'] = Variable<String>(children.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (selfEvaluation.present) {
      map['self_evaluation'] = Variable<String>(selfEvaluation.value);
    }
    if (partnerRequirements.present) {
      map['partner_requirements'] = Variable<String>(partnerRequirements.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('clientId: $clientId, ')
          ..write('recommender: $recommender, ')
          ..write('gender: $gender, ')
          ..write('birthYear: $birthYear, ')
          ..write('birthPlace: $birthPlace, ')
          ..write('residence: $residence, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('education: $education, ')
          ..write('occupation: $occupation, ')
          ..write('familyInfo: $familyInfo, ')
          ..write('annualIncome: $annualIncome, ')
          ..write('car: $car, ')
          ..write('house: $house, ')
          ..write('maritalStatus: $maritalStatus, ')
          ..write('children: $children, ')
          ..write('photoPath: $photoPath, ')
          ..write('selfEvaluation: $selfEvaluation, ')
          ..write('partnerRequirements: $partnerRequirements, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientsTable clients = $ClientsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [clients];
}

typedef $$ClientsTableCreateCompanionBuilder =
    ClientsCompanion Function({
      required String clientId,
      required String recommender,
      required Gender gender,
      required int birthYear,
      required String birthPlace,
      required String residence,
      required int height,
      required int weight,
      required Education education,
      required String occupation,
      required String familyInfo,
      required String annualIncome,
      required String car,
      required String house,
      required MaritalStatus maritalStatus,
      required String children,
      Value<String> photoPath,
      required String selfEvaluation,
      required String partnerRequirements,
      Value<int> rowid,
    });
typedef $$ClientsTableUpdateCompanionBuilder =
    ClientsCompanion Function({
      Value<String> clientId,
      Value<String> recommender,
      Value<Gender> gender,
      Value<int> birthYear,
      Value<String> birthPlace,
      Value<String> residence,
      Value<int> height,
      Value<int> weight,
      Value<Education> education,
      Value<String> occupation,
      Value<String> familyInfo,
      Value<String> annualIncome,
      Value<String> car,
      Value<String> house,
      Value<MaritalStatus> maritalStatus,
      Value<String> children,
      Value<String> photoPath,
      Value<String> selfEvaluation,
      Value<String> partnerRequirements,
      Value<int> rowid,
    });

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recommender => $composableBuilder(
    column: $table.recommender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Gender, Gender, int> get gender =>
      $composableBuilder(
        column: $table.gender,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthPlace => $composableBuilder(
    column: $table.birthPlace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get residence => $composableBuilder(
    column: $table.residence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Education, Education, int> get education =>
      $composableBuilder(
        column: $table.education,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyInfo => $composableBuilder(
    column: $table.familyInfo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get annualIncome => $composableBuilder(
    column: $table.annualIncome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get car => $composableBuilder(
    column: $table.car,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get house => $composableBuilder(
    column: $table.house,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MaritalStatus, MaritalStatus, int>
  get maritalStatus => $composableBuilder(
    column: $table.maritalStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get children => $composableBuilder(
    column: $table.children,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selfEvaluation => $composableBuilder(
    column: $table.selfEvaluation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partnerRequirements => $composableBuilder(
    column: $table.partnerRequirements,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recommender => $composableBuilder(
    column: $table.recommender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthPlace => $composableBuilder(
    column: $table.birthPlace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get residence => $composableBuilder(
    column: $table.residence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get education => $composableBuilder(
    column: $table.education,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyInfo => $composableBuilder(
    column: $table.familyInfo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get annualIncome => $composableBuilder(
    column: $table.annualIncome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get car => $composableBuilder(
    column: $table.car,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get house => $composableBuilder(
    column: $table.house,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maritalStatus => $composableBuilder(
    column: $table.maritalStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get children => $composableBuilder(
    column: $table.children,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selfEvaluation => $composableBuilder(
    column: $table.selfEvaluation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partnerRequirements => $composableBuilder(
    column: $table.partnerRequirements,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get recommender => $composableBuilder(
    column: $table.recommender,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Gender, int> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get birthYear =>
      $composableBuilder(column: $table.birthYear, builder: (column) => column);

  GeneratedColumn<String> get birthPlace => $composableBuilder(
    column: $table.birthPlace,
    builder: (column) => column,
  );

  GeneratedColumn<String> get residence =>
      $composableBuilder(column: $table.residence, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Education, int> get education =>
      $composableBuilder(column: $table.education, builder: (column) => column);

  GeneratedColumn<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get familyInfo => $composableBuilder(
    column: $table.familyInfo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get annualIncome => $composableBuilder(
    column: $table.annualIncome,
    builder: (column) => column,
  );

  GeneratedColumn<String> get car =>
      $composableBuilder(column: $table.car, builder: (column) => column);

  GeneratedColumn<String> get house =>
      $composableBuilder(column: $table.house, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MaritalStatus, int> get maritalStatus =>
      $composableBuilder(
        column: $table.maritalStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get children =>
      $composableBuilder(column: $table.children, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get selfEvaluation => $composableBuilder(
    column: $table.selfEvaluation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get partnerRequirements => $composableBuilder(
    column: $table.partnerRequirements,
    builder: (column) => column,
  );
}

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          Client,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
          Client,
          PrefetchHooks Function()
        > {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<String> recommender = const Value.absent(),
                Value<Gender> gender = const Value.absent(),
                Value<int> birthYear = const Value.absent(),
                Value<String> birthPlace = const Value.absent(),
                Value<String> residence = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> weight = const Value.absent(),
                Value<Education> education = const Value.absent(),
                Value<String> occupation = const Value.absent(),
                Value<String> familyInfo = const Value.absent(),
                Value<String> annualIncome = const Value.absent(),
                Value<String> car = const Value.absent(),
                Value<String> house = const Value.absent(),
                Value<MaritalStatus> maritalStatus = const Value.absent(),
                Value<String> children = const Value.absent(),
                Value<String> photoPath = const Value.absent(),
                Value<String> selfEvaluation = const Value.absent(),
                Value<String> partnerRequirements = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientsCompanion(
                clientId: clientId,
                recommender: recommender,
                gender: gender,
                birthYear: birthYear,
                birthPlace: birthPlace,
                residence: residence,
                height: height,
                weight: weight,
                education: education,
                occupation: occupation,
                familyInfo: familyInfo,
                annualIncome: annualIncome,
                car: car,
                house: house,
                maritalStatus: maritalStatus,
                children: children,
                photoPath: photoPath,
                selfEvaluation: selfEvaluation,
                partnerRequirements: partnerRequirements,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                required String recommender,
                required Gender gender,
                required int birthYear,
                required String birthPlace,
                required String residence,
                required int height,
                required int weight,
                required Education education,
                required String occupation,
                required String familyInfo,
                required String annualIncome,
                required String car,
                required String house,
                required MaritalStatus maritalStatus,
                required String children,
                Value<String> photoPath = const Value.absent(),
                required String selfEvaluation,
                required String partnerRequirements,
                Value<int> rowid = const Value.absent(),
              }) => ClientsCompanion.insert(
                clientId: clientId,
                recommender: recommender,
                gender: gender,
                birthYear: birthYear,
                birthPlace: birthPlace,
                residence: residence,
                height: height,
                weight: weight,
                education: education,
                occupation: occupation,
                familyInfo: familyInfo,
                annualIncome: annualIncome,
                car: car,
                house: house,
                maritalStatus: maritalStatus,
                children: children,
                photoPath: photoPath,
                selfEvaluation: selfEvaluation,
                partnerRequirements: partnerRequirements,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      Client,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
      Client,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
}
