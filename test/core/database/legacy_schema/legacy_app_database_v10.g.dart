// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legacy_app_database_v10.dart';

// ignore_for_file: type=lint
class $LegacyClientsTable extends LegacyClients
    with TableInfo<$LegacyClientsTable, LegacyClientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tradeNameMeta = const VerificationMeta(
    'tradeName',
  );
  @override
  late final GeneratedColumn<String> tradeName = GeneratedColumn<String>(
    'trade_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneDigitsMeta = const VerificationMeta(
    'phoneDigits',
  );
  @override
  late final GeneratedColumn<String> phoneDigits = GeneratedColumn<String>(
    'phone_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _whatsappDigitsMeta = const VerificationMeta(
    'whatsappDigits',
  );
  @override
  late final GeneratedColumn<String> whatsappDigits = GeneratedColumn<String>(
    'whatsapp_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _documentDigitsMeta = const VerificationMeta(
    'documentDigits',
  );
  @override
  late final GeneratedColumn<String> documentDigits = GeneratedColumn<String>(
    'document_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _instagramMeta = const VerificationMeta(
    'instagram',
  );
  @override
  late final GeneratedColumn<String> instagram = GeneratedColumn<String>(
    'instagram',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthdayMeta = const VerificationMeta(
    'birthday',
  );
  @override
  late final GeneratedColumn<String> birthday = GeneratedColumn<String>(
    'birthday',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _internalNotesMeta = const VerificationMeta(
    'internalNotes',
  );
  @override
  late final GeneratedColumn<String> internalNotes = GeneratedColumn<String>(
    'internal_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postalCodeMeta = const VerificationMeta(
    'postalCode',
  );
  @override
  late final GeneratedColumn<String> postalCode = GeneratedColumn<String>(
    'postal_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _streetMeta = const VerificationMeta('street');
  @override
  late final GeneratedColumn<String> street = GeneratedColumn<String>(
    'street',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _complementMeta = const VerificationMeta(
    'complement',
  );
  @override
  late final GeneratedColumn<String> complement = GeneratedColumn<String>(
    'complement',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _neighborhoodMeta = const VerificationMeta(
    'neighborhood',
  );
  @override
  late final GeneratedColumn<String> neighborhood = GeneratedColumn<String>(
    'neighborhood',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    type,
    name,
    tradeName,
    phoneDigits,
    whatsappDigits,
    email,
    documentDigits,
    instagram,
    birthday,
    internalNotes,
    postalCode,
    street,
    number,
    complement,
    neighborhood,
    city,
    state,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyClientRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('trade_name')) {
      context.handle(
        _tradeNameMeta,
        tradeName.isAcceptableOrUnknown(data['trade_name']!, _tradeNameMeta),
      );
    }
    if (data.containsKey('phone_digits')) {
      context.handle(
        _phoneDigitsMeta,
        phoneDigits.isAcceptableOrUnknown(
          data['phone_digits']!,
          _phoneDigitsMeta,
        ),
      );
    }
    if (data.containsKey('whatsapp_digits')) {
      context.handle(
        _whatsappDigitsMeta,
        whatsappDigits.isAcceptableOrUnknown(
          data['whatsapp_digits']!,
          _whatsappDigitsMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('document_digits')) {
      context.handle(
        _documentDigitsMeta,
        documentDigits.isAcceptableOrUnknown(
          data['document_digits']!,
          _documentDigitsMeta,
        ),
      );
    }
    if (data.containsKey('instagram')) {
      context.handle(
        _instagramMeta,
        instagram.isAcceptableOrUnknown(data['instagram']!, _instagramMeta),
      );
    }
    if (data.containsKey('birthday')) {
      context.handle(
        _birthdayMeta,
        birthday.isAcceptableOrUnknown(data['birthday']!, _birthdayMeta),
      );
    }
    if (data.containsKey('internal_notes')) {
      context.handle(
        _internalNotesMeta,
        internalNotes.isAcceptableOrUnknown(
          data['internal_notes']!,
          _internalNotesMeta,
        ),
      );
    }
    if (data.containsKey('postal_code')) {
      context.handle(
        _postalCodeMeta,
        postalCode.isAcceptableOrUnknown(data['postal_code']!, _postalCodeMeta),
      );
    }
    if (data.containsKey('street')) {
      context.handle(
        _streetMeta,
        street.isAcceptableOrUnknown(data['street']!, _streetMeta),
      );
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    }
    if (data.containsKey('complement')) {
      context.handle(
        _complementMeta,
        complement.isAcceptableOrUnknown(data['complement']!, _complementMeta),
      );
    }
    if (data.containsKey('neighborhood')) {
      context.handle(
        _neighborhoodMeta,
        neighborhood.isAcceptableOrUnknown(
          data['neighborhood']!,
          _neighborhoodMeta,
        ),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyClientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyClientRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      tradeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trade_name'],
      ),
      phoneDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_digits'],
      ),
      whatsappDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}whatsapp_digits'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      documentDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_digits'],
      ),
      instagram: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instagram'],
      ),
      birthday: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birthday'],
      ),
      internalNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}internal_notes'],
      ),
      postalCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}postal_code'],
      ),
      street: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}street'],
      ),
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      ),
      complement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}complement'],
      ),
      neighborhood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}neighborhood'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
    );
  }

  @override
  $LegacyClientsTable createAlias(String alias) {
    return $LegacyClientsTable(attachedDatabase, alias);
  }
}

class LegacyClientRow extends DataClass implements Insertable<LegacyClientRow> {
  final String id;
  final int createdAt;
  final String type;
  final String name;
  final String? tradeName;
  final String? phoneDigits;
  final String? whatsappDigits;
  final String? email;
  final String? documentDigits;
  final String? instagram;
  final String? birthday;
  final String? internalNotes;
  final String? postalCode;
  final String? street;
  final String? number;
  final String? complement;
  final String? neighborhood;
  final String? city;
  final String? state;
  const LegacyClientRow({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.name,
    this.tradeName,
    this.phoneDigits,
    this.whatsappDigits,
    this.email,
    this.documentDigits,
    this.instagram,
    this.birthday,
    this.internalNotes,
    this.postalCode,
    this.street,
    this.number,
    this.complement,
    this.neighborhood,
    this.city,
    this.state,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || tradeName != null) {
      map['trade_name'] = Variable<String>(tradeName);
    }
    if (!nullToAbsent || phoneDigits != null) {
      map['phone_digits'] = Variable<String>(phoneDigits);
    }
    if (!nullToAbsent || whatsappDigits != null) {
      map['whatsapp_digits'] = Variable<String>(whatsappDigits);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || documentDigits != null) {
      map['document_digits'] = Variable<String>(documentDigits);
    }
    if (!nullToAbsent || instagram != null) {
      map['instagram'] = Variable<String>(instagram);
    }
    if (!nullToAbsent || birthday != null) {
      map['birthday'] = Variable<String>(birthday);
    }
    if (!nullToAbsent || internalNotes != null) {
      map['internal_notes'] = Variable<String>(internalNotes);
    }
    if (!nullToAbsent || postalCode != null) {
      map['postal_code'] = Variable<String>(postalCode);
    }
    if (!nullToAbsent || street != null) {
      map['street'] = Variable<String>(street);
    }
    if (!nullToAbsent || number != null) {
      map['number'] = Variable<String>(number);
    }
    if (!nullToAbsent || complement != null) {
      map['complement'] = Variable<String>(complement);
    }
    if (!nullToAbsent || neighborhood != null) {
      map['neighborhood'] = Variable<String>(neighborhood);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    return map;
  }

  LegacyClientsCompanion toCompanion(bool nullToAbsent) {
    return LegacyClientsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      type: Value(type),
      name: Value(name),
      tradeName: tradeName == null && nullToAbsent
          ? const Value.absent()
          : Value(tradeName),
      phoneDigits: phoneDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneDigits),
      whatsappDigits: whatsappDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsappDigits),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      documentDigits: documentDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(documentDigits),
      instagram: instagram == null && nullToAbsent
          ? const Value.absent()
          : Value(instagram),
      birthday: birthday == null && nullToAbsent
          ? const Value.absent()
          : Value(birthday),
      internalNotes: internalNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(internalNotes),
      postalCode: postalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(postalCode),
      street: street == null && nullToAbsent
          ? const Value.absent()
          : Value(street),
      number: number == null && nullToAbsent
          ? const Value.absent()
          : Value(number),
      complement: complement == null && nullToAbsent
          ? const Value.absent()
          : Value(complement),
      neighborhood: neighborhood == null && nullToAbsent
          ? const Value.absent()
          : Value(neighborhood),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
    );
  }

  factory LegacyClientRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyClientRow(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      tradeName: serializer.fromJson<String?>(json['tradeName']),
      phoneDigits: serializer.fromJson<String?>(json['phoneDigits']),
      whatsappDigits: serializer.fromJson<String?>(json['whatsappDigits']),
      email: serializer.fromJson<String?>(json['email']),
      documentDigits: serializer.fromJson<String?>(json['documentDigits']),
      instagram: serializer.fromJson<String?>(json['instagram']),
      birthday: serializer.fromJson<String?>(json['birthday']),
      internalNotes: serializer.fromJson<String?>(json['internalNotes']),
      postalCode: serializer.fromJson<String?>(json['postalCode']),
      street: serializer.fromJson<String?>(json['street']),
      number: serializer.fromJson<String?>(json['number']),
      complement: serializer.fromJson<String?>(json['complement']),
      neighborhood: serializer.fromJson<String?>(json['neighborhood']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'tradeName': serializer.toJson<String?>(tradeName),
      'phoneDigits': serializer.toJson<String?>(phoneDigits),
      'whatsappDigits': serializer.toJson<String?>(whatsappDigits),
      'email': serializer.toJson<String?>(email),
      'documentDigits': serializer.toJson<String?>(documentDigits),
      'instagram': serializer.toJson<String?>(instagram),
      'birthday': serializer.toJson<String?>(birthday),
      'internalNotes': serializer.toJson<String?>(internalNotes),
      'postalCode': serializer.toJson<String?>(postalCode),
      'street': serializer.toJson<String?>(street),
      'number': serializer.toJson<String?>(number),
      'complement': serializer.toJson<String?>(complement),
      'neighborhood': serializer.toJson<String?>(neighborhood),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
    };
  }

  LegacyClientRow copyWith({
    String? id,
    int? createdAt,
    String? type,
    String? name,
    Value<String?> tradeName = const Value.absent(),
    Value<String?> phoneDigits = const Value.absent(),
    Value<String?> whatsappDigits = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> documentDigits = const Value.absent(),
    Value<String?> instagram = const Value.absent(),
    Value<String?> birthday = const Value.absent(),
    Value<String?> internalNotes = const Value.absent(),
    Value<String?> postalCode = const Value.absent(),
    Value<String?> street = const Value.absent(),
    Value<String?> number = const Value.absent(),
    Value<String?> complement = const Value.absent(),
    Value<String?> neighborhood = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> state = const Value.absent(),
  }) => LegacyClientRow(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    type: type ?? this.type,
    name: name ?? this.name,
    tradeName: tradeName.present ? tradeName.value : this.tradeName,
    phoneDigits: phoneDigits.present ? phoneDigits.value : this.phoneDigits,
    whatsappDigits: whatsappDigits.present
        ? whatsappDigits.value
        : this.whatsappDigits,
    email: email.present ? email.value : this.email,
    documentDigits: documentDigits.present
        ? documentDigits.value
        : this.documentDigits,
    instagram: instagram.present ? instagram.value : this.instagram,
    birthday: birthday.present ? birthday.value : this.birthday,
    internalNotes: internalNotes.present
        ? internalNotes.value
        : this.internalNotes,
    postalCode: postalCode.present ? postalCode.value : this.postalCode,
    street: street.present ? street.value : this.street,
    number: number.present ? number.value : this.number,
    complement: complement.present ? complement.value : this.complement,
    neighborhood: neighborhood.present ? neighborhood.value : this.neighborhood,
    city: city.present ? city.value : this.city,
    state: state.present ? state.value : this.state,
  );
  LegacyClientRow copyWithCompanion(LegacyClientsCompanion data) {
    return LegacyClientRow(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      tradeName: data.tradeName.present ? data.tradeName.value : this.tradeName,
      phoneDigits: data.phoneDigits.present
          ? data.phoneDigits.value
          : this.phoneDigits,
      whatsappDigits: data.whatsappDigits.present
          ? data.whatsappDigits.value
          : this.whatsappDigits,
      email: data.email.present ? data.email.value : this.email,
      documentDigits: data.documentDigits.present
          ? data.documentDigits.value
          : this.documentDigits,
      instagram: data.instagram.present ? data.instagram.value : this.instagram,
      birthday: data.birthday.present ? data.birthday.value : this.birthday,
      internalNotes: data.internalNotes.present
          ? data.internalNotes.value
          : this.internalNotes,
      postalCode: data.postalCode.present
          ? data.postalCode.value
          : this.postalCode,
      street: data.street.present ? data.street.value : this.street,
      number: data.number.present ? data.number.value : this.number,
      complement: data.complement.present
          ? data.complement.value
          : this.complement,
      neighborhood: data.neighborhood.present
          ? data.neighborhood.value
          : this.neighborhood,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyClientRow(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('tradeName: $tradeName, ')
          ..write('phoneDigits: $phoneDigits, ')
          ..write('whatsappDigits: $whatsappDigits, ')
          ..write('email: $email, ')
          ..write('documentDigits: $documentDigits, ')
          ..write('instagram: $instagram, ')
          ..write('birthday: $birthday, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('postalCode: $postalCode, ')
          ..write('street: $street, ')
          ..write('number: $number, ')
          ..write('complement: $complement, ')
          ..write('neighborhood: $neighborhood, ')
          ..write('city: $city, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    type,
    name,
    tradeName,
    phoneDigits,
    whatsappDigits,
    email,
    documentDigits,
    instagram,
    birthday,
    internalNotes,
    postalCode,
    street,
    number,
    complement,
    neighborhood,
    city,
    state,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyClientRow &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.type == this.type &&
          other.name == this.name &&
          other.tradeName == this.tradeName &&
          other.phoneDigits == this.phoneDigits &&
          other.whatsappDigits == this.whatsappDigits &&
          other.email == this.email &&
          other.documentDigits == this.documentDigits &&
          other.instagram == this.instagram &&
          other.birthday == this.birthday &&
          other.internalNotes == this.internalNotes &&
          other.postalCode == this.postalCode &&
          other.street == this.street &&
          other.number == this.number &&
          other.complement == this.complement &&
          other.neighborhood == this.neighborhood &&
          other.city == this.city &&
          other.state == this.state);
}

class LegacyClientsCompanion extends UpdateCompanion<LegacyClientRow> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<String> type;
  final Value<String> name;
  final Value<String?> tradeName;
  final Value<String?> phoneDigits;
  final Value<String?> whatsappDigits;
  final Value<String?> email;
  final Value<String?> documentDigits;
  final Value<String?> instagram;
  final Value<String?> birthday;
  final Value<String?> internalNotes;
  final Value<String?> postalCode;
  final Value<String?> street;
  final Value<String?> number;
  final Value<String?> complement;
  final Value<String?> neighborhood;
  final Value<String?> city;
  final Value<String?> state;
  final Value<int> rowid;
  const LegacyClientsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.tradeName = const Value.absent(),
    this.phoneDigits = const Value.absent(),
    this.whatsappDigits = const Value.absent(),
    this.email = const Value.absent(),
    this.documentDigits = const Value.absent(),
    this.instagram = const Value.absent(),
    this.birthday = const Value.absent(),
    this.internalNotes = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.street = const Value.absent(),
    this.number = const Value.absent(),
    this.complement = const Value.absent(),
    this.neighborhood = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyClientsCompanion.insert({
    required String id,
    required int createdAt,
    required String type,
    required String name,
    this.tradeName = const Value.absent(),
    this.phoneDigits = const Value.absent(),
    this.whatsappDigits = const Value.absent(),
    this.email = const Value.absent(),
    this.documentDigits = const Value.absent(),
    this.instagram = const Value.absent(),
    this.birthday = const Value.absent(),
    this.internalNotes = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.street = const Value.absent(),
    this.number = const Value.absent(),
    this.complement = const Value.absent(),
    this.neighborhood = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       type = Value(type),
       name = Value(name);
  static Insertable<LegacyClientRow> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? tradeName,
    Expression<String>? phoneDigits,
    Expression<String>? whatsappDigits,
    Expression<String>? email,
    Expression<String>? documentDigits,
    Expression<String>? instagram,
    Expression<String>? birthday,
    Expression<String>? internalNotes,
    Expression<String>? postalCode,
    Expression<String>? street,
    Expression<String>? number,
    Expression<String>? complement,
    Expression<String>? neighborhood,
    Expression<String>? city,
    Expression<String>? state,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (tradeName != null) 'trade_name': tradeName,
      if (phoneDigits != null) 'phone_digits': phoneDigits,
      if (whatsappDigits != null) 'whatsapp_digits': whatsappDigits,
      if (email != null) 'email': email,
      if (documentDigits != null) 'document_digits': documentDigits,
      if (instagram != null) 'instagram': instagram,
      if (birthday != null) 'birthday': birthday,
      if (internalNotes != null) 'internal_notes': internalNotes,
      if (postalCode != null) 'postal_code': postalCode,
      if (street != null) 'street': street,
      if (number != null) 'number': number,
      if (complement != null) 'complement': complement,
      if (neighborhood != null) 'neighborhood': neighborhood,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyClientsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<String>? type,
    Value<String>? name,
    Value<String?>? tradeName,
    Value<String?>? phoneDigits,
    Value<String?>? whatsappDigits,
    Value<String?>? email,
    Value<String?>? documentDigits,
    Value<String?>? instagram,
    Value<String?>? birthday,
    Value<String?>? internalNotes,
    Value<String?>? postalCode,
    Value<String?>? street,
    Value<String?>? number,
    Value<String?>? complement,
    Value<String?>? neighborhood,
    Value<String?>? city,
    Value<String?>? state,
    Value<int>? rowid,
  }) {
    return LegacyClientsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      name: name ?? this.name,
      tradeName: tradeName ?? this.tradeName,
      phoneDigits: phoneDigits ?? this.phoneDigits,
      whatsappDigits: whatsappDigits ?? this.whatsappDigits,
      email: email ?? this.email,
      documentDigits: documentDigits ?? this.documentDigits,
      instagram: instagram ?? this.instagram,
      birthday: birthday ?? this.birthday,
      internalNotes: internalNotes ?? this.internalNotes,
      postalCode: postalCode ?? this.postalCode,
      street: street ?? this.street,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (tradeName.present) {
      map['trade_name'] = Variable<String>(tradeName.value);
    }
    if (phoneDigits.present) {
      map['phone_digits'] = Variable<String>(phoneDigits.value);
    }
    if (whatsappDigits.present) {
      map['whatsapp_digits'] = Variable<String>(whatsappDigits.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (documentDigits.present) {
      map['document_digits'] = Variable<String>(documentDigits.value);
    }
    if (instagram.present) {
      map['instagram'] = Variable<String>(instagram.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<String>(birthday.value);
    }
    if (internalNotes.present) {
      map['internal_notes'] = Variable<String>(internalNotes.value);
    }
    if (postalCode.present) {
      map['postal_code'] = Variable<String>(postalCode.value);
    }
    if (street.present) {
      map['street'] = Variable<String>(street.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (complement.present) {
      map['complement'] = Variable<String>(complement.value);
    }
    if (neighborhood.present) {
      map['neighborhood'] = Variable<String>(neighborhood.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyClientsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('tradeName: $tradeName, ')
          ..write('phoneDigits: $phoneDigits, ')
          ..write('whatsappDigits: $whatsappDigits, ')
          ..write('email: $email, ')
          ..write('documentDigits: $documentDigits, ')
          ..write('instagram: $instagram, ')
          ..write('birthday: $birthday, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('postalCode: $postalCode, ')
          ..write('street: $street, ')
          ..write('number: $number, ')
          ..write('complement: $complement, ')
          ..write('neighborhood: $neighborhood, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyCatalogItemsTable extends LegacyCatalogItems
    with TableInfo<$LegacyCatalogItemsTable, LegacyCatalogItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyCatalogItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceCentsMeta = const VerificationMeta(
    'priceCents',
  );
  @override
  late final GeneratedColumn<int> priceCents = GeneratedColumn<int>(
    'price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
  );
  static const VerificationMeta _imageReferenceMeta = const VerificationMeta(
    'imageReference',
  );
  @override
  late final GeneratedColumn<String> imageReference = GeneratedColumn<String>(
    'image_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    type,
    name,
    category,
    description,
    unit,
    priceCents,
    active,
    imageReference,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyCatalogItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('price_cents')) {
      context.handle(
        _priceCentsMeta,
        priceCents.isAcceptableOrUnknown(data['price_cents']!, _priceCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_priceCentsMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    if (data.containsKey('image_reference')) {
      context.handle(
        _imageReferenceMeta,
        imageReference.isAcceptableOrUnknown(
          data['image_reference']!,
          _imageReferenceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyCatalogItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyCatalogItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      priceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_cents'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      imageReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_reference'],
      ),
    );
  }

  @override
  $LegacyCatalogItemsTable createAlias(String alias) {
    return $LegacyCatalogItemsTable(attachedDatabase, alias);
  }
}

class LegacyCatalogItemRow extends DataClass
    implements Insertable<LegacyCatalogItemRow> {
  final String id;
  final int createdAt;
  final String type;
  final String name;
  final String category;
  final String? description;
  final String unit;
  final int priceCents;
  final bool active;
  final String? imageReference;
  const LegacyCatalogItemRow({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.name,
    required this.category,
    this.description,
    required this.unit,
    required this.priceCents,
    required this.active,
    this.imageReference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['unit'] = Variable<String>(unit);
    map['price_cents'] = Variable<int>(priceCents);
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || imageReference != null) {
      map['image_reference'] = Variable<String>(imageReference);
    }
    return map;
  }

  LegacyCatalogItemsCompanion toCompanion(bool nullToAbsent) {
    return LegacyCatalogItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      type: Value(type),
      name: Value(name),
      category: Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      unit: Value(unit),
      priceCents: Value(priceCents),
      active: Value(active),
      imageReference: imageReference == null && nullToAbsent
          ? const Value.absent()
          : Value(imageReference),
    );
  }

  factory LegacyCatalogItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyCatalogItemRow(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      unit: serializer.fromJson<String>(json['unit']),
      priceCents: serializer.fromJson<int>(json['priceCents']),
      active: serializer.fromJson<bool>(json['active']),
      imageReference: serializer.fromJson<String?>(json['imageReference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String?>(description),
      'unit': serializer.toJson<String>(unit),
      'priceCents': serializer.toJson<int>(priceCents),
      'active': serializer.toJson<bool>(active),
      'imageReference': serializer.toJson<String?>(imageReference),
    };
  }

  LegacyCatalogItemRow copyWith({
    String? id,
    int? createdAt,
    String? type,
    String? name,
    String? category,
    Value<String?> description = const Value.absent(),
    String? unit,
    int? priceCents,
    bool? active,
    Value<String?> imageReference = const Value.absent(),
  }) => LegacyCatalogItemRow(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    type: type ?? this.type,
    name: name ?? this.name,
    category: category ?? this.category,
    description: description.present ? description.value : this.description,
    unit: unit ?? this.unit,
    priceCents: priceCents ?? this.priceCents,
    active: active ?? this.active,
    imageReference: imageReference.present
        ? imageReference.value
        : this.imageReference,
  );
  LegacyCatalogItemRow copyWithCompanion(LegacyCatalogItemsCompanion data) {
    return LegacyCatalogItemRow(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      unit: data.unit.present ? data.unit.value : this.unit,
      priceCents: data.priceCents.present
          ? data.priceCents.value
          : this.priceCents,
      active: data.active.present ? data.active.value : this.active,
      imageReference: data.imageReference.present
          ? data.imageReference.value
          : this.imageReference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyCatalogItemRow(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('unit: $unit, ')
          ..write('priceCents: $priceCents, ')
          ..write('active: $active, ')
          ..write('imageReference: $imageReference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    type,
    name,
    category,
    description,
    unit,
    priceCents,
    active,
    imageReference,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyCatalogItemRow &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.type == this.type &&
          other.name == this.name &&
          other.category == this.category &&
          other.description == this.description &&
          other.unit == this.unit &&
          other.priceCents == this.priceCents &&
          other.active == this.active &&
          other.imageReference == this.imageReference);
}

class LegacyCatalogItemsCompanion
    extends UpdateCompanion<LegacyCatalogItemRow> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<String> type;
  final Value<String> name;
  final Value<String> category;
  final Value<String?> description;
  final Value<String> unit;
  final Value<int> priceCents;
  final Value<bool> active;
  final Value<String?> imageReference;
  final Value<int> rowid;
  const LegacyCatalogItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.unit = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.active = const Value.absent(),
    this.imageReference = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyCatalogItemsCompanion.insert({
    required String id,
    required int createdAt,
    required String type,
    required String name,
    required String category,
    this.description = const Value.absent(),
    required String unit,
    required int priceCents,
    required bool active,
    this.imageReference = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       type = Value(type),
       name = Value(name),
       category = Value(category),
       unit = Value(unit),
       priceCents = Value(priceCents),
       active = Value(active);
  static Insertable<LegacyCatalogItemRow> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? unit,
    Expression<int>? priceCents,
    Expression<bool>? active,
    Expression<String>? imageReference,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (unit != null) 'unit': unit,
      if (priceCents != null) 'price_cents': priceCents,
      if (active != null) 'active': active,
      if (imageReference != null) 'image_reference': imageReference,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyCatalogItemsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<String>? type,
    Value<String>? name,
    Value<String>? category,
    Value<String?>? description,
    Value<String>? unit,
    Value<int>? priceCents,
    Value<bool>? active,
    Value<String?>? imageReference,
    Value<int>? rowid,
  }) {
    return LegacyCatalogItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      priceCents: priceCents ?? this.priceCents,
      active: active ?? this.active,
      imageReference: imageReference ?? this.imageReference,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (priceCents.present) {
      map['price_cents'] = Variable<int>(priceCents.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (imageReference.present) {
      map['image_reference'] = Variable<String>(imageReference.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyCatalogItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('unit: $unit, ')
          ..write('priceCents: $priceCents, ')
          ..write('active: $active, ')
          ..write('imageReference: $imageReference, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyCatalogPackageComponentsTable
    extends LegacyCatalogPackageComponents
    with
        TableInfo<
          $LegacyCatalogPackageComponentsTable,
          LegacyCatalogPackageComponentRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyCatalogPackageComponentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packageIdMeta = const VerificationMeta(
    'packageId',
  );
  @override
  late final GeneratedColumn<String> packageId = GeneratedColumn<String>(
    'package_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES catalog_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _componentItemIdMeta = const VerificationMeta(
    'componentItemId',
  );
  @override
  late final GeneratedColumn<String> componentItemId = GeneratedColumn<String>(
    'component_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES catalog_items (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _nameSnapshotMeta = const VerificationMeta(
    'nameSnapshot',
  );
  @override
  late final GeneratedColumn<String> nameSnapshot = GeneratedColumn<String>(
    'name_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitSnapshotMeta = const VerificationMeta(
    'unitSnapshot',
  );
  @override
  late final GeneratedColumn<String> unitSnapshot = GeneratedColumn<String>(
    'unit_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeSnapshotMeta = const VerificationMeta(
    'typeSnapshot',
  );
  @override
  late final GeneratedColumn<String> typeSnapshot = GeneratedColumn<String>(
    'type_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categorySnapshotMeta = const VerificationMeta(
    'categorySnapshot',
  );
  @override
  late final GeneratedColumn<String> categorySnapshot = GeneratedColumn<String>(
    'category_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityPerPackageMeta =
      const VerificationMeta('quantityPerPackage');
  @override
  late final GeneratedColumn<double> quantityPerPackage =
      GeneratedColumn<double>(
        'quantity_per_package',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    packageId,
    componentItemId,
    nameSnapshot,
    unitSnapshot,
    typeSnapshot,
    categorySnapshot,
    quantityPerPackage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_package_components';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyCatalogPackageComponentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('package_id')) {
      context.handle(
        _packageIdMeta,
        packageId.isAcceptableOrUnknown(data['package_id']!, _packageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packageIdMeta);
    }
    if (data.containsKey('component_item_id')) {
      context.handle(
        _componentItemIdMeta,
        componentItemId.isAcceptableOrUnknown(
          data['component_item_id']!,
          _componentItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_componentItemIdMeta);
    }
    if (data.containsKey('name_snapshot')) {
      context.handle(
        _nameSnapshotMeta,
        nameSnapshot.isAcceptableOrUnknown(
          data['name_snapshot']!,
          _nameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameSnapshotMeta);
    }
    if (data.containsKey('unit_snapshot')) {
      context.handle(
        _unitSnapshotMeta,
        unitSnapshot.isAcceptableOrUnknown(
          data['unit_snapshot']!,
          _unitSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitSnapshotMeta);
    }
    if (data.containsKey('type_snapshot')) {
      context.handle(
        _typeSnapshotMeta,
        typeSnapshot.isAcceptableOrUnknown(
          data['type_snapshot']!,
          _typeSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_typeSnapshotMeta);
    }
    if (data.containsKey('category_snapshot')) {
      context.handle(
        _categorySnapshotMeta,
        categorySnapshot.isAcceptableOrUnknown(
          data['category_snapshot']!,
          _categorySnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categorySnapshotMeta);
    }
    if (data.containsKey('quantity_per_package')) {
      context.handle(
        _quantityPerPackageMeta,
        quantityPerPackage.isAcceptableOrUnknown(
          data['quantity_per_package']!,
          _quantityPerPackageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityPerPackageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageId, componentItemId};
  @override
  LegacyCatalogPackageComponentRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyCatalogPackageComponentRow(
      packageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_id'],
      )!,
      componentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component_item_id'],
      )!,
      nameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_snapshot'],
      )!,
      unitSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_snapshot'],
      )!,
      typeSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_snapshot'],
      )!,
      categorySnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_snapshot'],
      )!,
      quantityPerPackage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_per_package'],
      )!,
    );
  }

  @override
  $LegacyCatalogPackageComponentsTable createAlias(String alias) {
    return $LegacyCatalogPackageComponentsTable(attachedDatabase, alias);
  }
}

class LegacyCatalogPackageComponentRow extends DataClass
    implements Insertable<LegacyCatalogPackageComponentRow> {
  final String packageId;
  final String componentItemId;
  final String nameSnapshot;
  final String unitSnapshot;
  final String typeSnapshot;
  final String categorySnapshot;
  final double quantityPerPackage;
  const LegacyCatalogPackageComponentRow({
    required this.packageId,
    required this.componentItemId,
    required this.nameSnapshot,
    required this.unitSnapshot,
    required this.typeSnapshot,
    required this.categorySnapshot,
    required this.quantityPerPackage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_id'] = Variable<String>(packageId);
    map['component_item_id'] = Variable<String>(componentItemId);
    map['name_snapshot'] = Variable<String>(nameSnapshot);
    map['unit_snapshot'] = Variable<String>(unitSnapshot);
    map['type_snapshot'] = Variable<String>(typeSnapshot);
    map['category_snapshot'] = Variable<String>(categorySnapshot);
    map['quantity_per_package'] = Variable<double>(quantityPerPackage);
    return map;
  }

  LegacyCatalogPackageComponentsCompanion toCompanion(bool nullToAbsent) {
    return LegacyCatalogPackageComponentsCompanion(
      packageId: Value(packageId),
      componentItemId: Value(componentItemId),
      nameSnapshot: Value(nameSnapshot),
      unitSnapshot: Value(unitSnapshot),
      typeSnapshot: Value(typeSnapshot),
      categorySnapshot: Value(categorySnapshot),
      quantityPerPackage: Value(quantityPerPackage),
    );
  }

  factory LegacyCatalogPackageComponentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyCatalogPackageComponentRow(
      packageId: serializer.fromJson<String>(json['packageId']),
      componentItemId: serializer.fromJson<String>(json['componentItemId']),
      nameSnapshot: serializer.fromJson<String>(json['nameSnapshot']),
      unitSnapshot: serializer.fromJson<String>(json['unitSnapshot']),
      typeSnapshot: serializer.fromJson<String>(json['typeSnapshot']),
      categorySnapshot: serializer.fromJson<String>(json['categorySnapshot']),
      quantityPerPackage: serializer.fromJson<double>(
        json['quantityPerPackage'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageId': serializer.toJson<String>(packageId),
      'componentItemId': serializer.toJson<String>(componentItemId),
      'nameSnapshot': serializer.toJson<String>(nameSnapshot),
      'unitSnapshot': serializer.toJson<String>(unitSnapshot),
      'typeSnapshot': serializer.toJson<String>(typeSnapshot),
      'categorySnapshot': serializer.toJson<String>(categorySnapshot),
      'quantityPerPackage': serializer.toJson<double>(quantityPerPackage),
    };
  }

  LegacyCatalogPackageComponentRow copyWith({
    String? packageId,
    String? componentItemId,
    String? nameSnapshot,
    String? unitSnapshot,
    String? typeSnapshot,
    String? categorySnapshot,
    double? quantityPerPackage,
  }) => LegacyCatalogPackageComponentRow(
    packageId: packageId ?? this.packageId,
    componentItemId: componentItemId ?? this.componentItemId,
    nameSnapshot: nameSnapshot ?? this.nameSnapshot,
    unitSnapshot: unitSnapshot ?? this.unitSnapshot,
    typeSnapshot: typeSnapshot ?? this.typeSnapshot,
    categorySnapshot: categorySnapshot ?? this.categorySnapshot,
    quantityPerPackage: quantityPerPackage ?? this.quantityPerPackage,
  );
  LegacyCatalogPackageComponentRow copyWithCompanion(
    LegacyCatalogPackageComponentsCompanion data,
  ) {
    return LegacyCatalogPackageComponentRow(
      packageId: data.packageId.present ? data.packageId.value : this.packageId,
      componentItemId: data.componentItemId.present
          ? data.componentItemId.value
          : this.componentItemId,
      nameSnapshot: data.nameSnapshot.present
          ? data.nameSnapshot.value
          : this.nameSnapshot,
      unitSnapshot: data.unitSnapshot.present
          ? data.unitSnapshot.value
          : this.unitSnapshot,
      typeSnapshot: data.typeSnapshot.present
          ? data.typeSnapshot.value
          : this.typeSnapshot,
      categorySnapshot: data.categorySnapshot.present
          ? data.categorySnapshot.value
          : this.categorySnapshot,
      quantityPerPackage: data.quantityPerPackage.present
          ? data.quantityPerPackage.value
          : this.quantityPerPackage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyCatalogPackageComponentRow(')
          ..write('packageId: $packageId, ')
          ..write('componentItemId: $componentItemId, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('unitSnapshot: $unitSnapshot, ')
          ..write('typeSnapshot: $typeSnapshot, ')
          ..write('categorySnapshot: $categorySnapshot, ')
          ..write('quantityPerPackage: $quantityPerPackage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    packageId,
    componentItemId,
    nameSnapshot,
    unitSnapshot,
    typeSnapshot,
    categorySnapshot,
    quantityPerPackage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyCatalogPackageComponentRow &&
          other.packageId == this.packageId &&
          other.componentItemId == this.componentItemId &&
          other.nameSnapshot == this.nameSnapshot &&
          other.unitSnapshot == this.unitSnapshot &&
          other.typeSnapshot == this.typeSnapshot &&
          other.categorySnapshot == this.categorySnapshot &&
          other.quantityPerPackage == this.quantityPerPackage);
}

class LegacyCatalogPackageComponentsCompanion
    extends UpdateCompanion<LegacyCatalogPackageComponentRow> {
  final Value<String> packageId;
  final Value<String> componentItemId;
  final Value<String> nameSnapshot;
  final Value<String> unitSnapshot;
  final Value<String> typeSnapshot;
  final Value<String> categorySnapshot;
  final Value<double> quantityPerPackage;
  final Value<int> rowid;
  const LegacyCatalogPackageComponentsCompanion({
    this.packageId = const Value.absent(),
    this.componentItemId = const Value.absent(),
    this.nameSnapshot = const Value.absent(),
    this.unitSnapshot = const Value.absent(),
    this.typeSnapshot = const Value.absent(),
    this.categorySnapshot = const Value.absent(),
    this.quantityPerPackage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyCatalogPackageComponentsCompanion.insert({
    required String packageId,
    required String componentItemId,
    required String nameSnapshot,
    required String unitSnapshot,
    required String typeSnapshot,
    required String categorySnapshot,
    required double quantityPerPackage,
    this.rowid = const Value.absent(),
  }) : packageId = Value(packageId),
       componentItemId = Value(componentItemId),
       nameSnapshot = Value(nameSnapshot),
       unitSnapshot = Value(unitSnapshot),
       typeSnapshot = Value(typeSnapshot),
       categorySnapshot = Value(categorySnapshot),
       quantityPerPackage = Value(quantityPerPackage);
  static Insertable<LegacyCatalogPackageComponentRow> custom({
    Expression<String>? packageId,
    Expression<String>? componentItemId,
    Expression<String>? nameSnapshot,
    Expression<String>? unitSnapshot,
    Expression<String>? typeSnapshot,
    Expression<String>? categorySnapshot,
    Expression<double>? quantityPerPackage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packageId != null) 'package_id': packageId,
      if (componentItemId != null) 'component_item_id': componentItemId,
      if (nameSnapshot != null) 'name_snapshot': nameSnapshot,
      if (unitSnapshot != null) 'unit_snapshot': unitSnapshot,
      if (typeSnapshot != null) 'type_snapshot': typeSnapshot,
      if (categorySnapshot != null) 'category_snapshot': categorySnapshot,
      if (quantityPerPackage != null)
        'quantity_per_package': quantityPerPackage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyCatalogPackageComponentsCompanion copyWith({
    Value<String>? packageId,
    Value<String>? componentItemId,
    Value<String>? nameSnapshot,
    Value<String>? unitSnapshot,
    Value<String>? typeSnapshot,
    Value<String>? categorySnapshot,
    Value<double>? quantityPerPackage,
    Value<int>? rowid,
  }) {
    return LegacyCatalogPackageComponentsCompanion(
      packageId: packageId ?? this.packageId,
      componentItemId: componentItemId ?? this.componentItemId,
      nameSnapshot: nameSnapshot ?? this.nameSnapshot,
      unitSnapshot: unitSnapshot ?? this.unitSnapshot,
      typeSnapshot: typeSnapshot ?? this.typeSnapshot,
      categorySnapshot: categorySnapshot ?? this.categorySnapshot,
      quantityPerPackage: quantityPerPackage ?? this.quantityPerPackage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packageId.present) {
      map['package_id'] = Variable<String>(packageId.value);
    }
    if (componentItemId.present) {
      map['component_item_id'] = Variable<String>(componentItemId.value);
    }
    if (nameSnapshot.present) {
      map['name_snapshot'] = Variable<String>(nameSnapshot.value);
    }
    if (unitSnapshot.present) {
      map['unit_snapshot'] = Variable<String>(unitSnapshot.value);
    }
    if (typeSnapshot.present) {
      map['type_snapshot'] = Variable<String>(typeSnapshot.value);
    }
    if (categorySnapshot.present) {
      map['category_snapshot'] = Variable<String>(categorySnapshot.value);
    }
    if (quantityPerPackage.present) {
      map['quantity_per_package'] = Variable<double>(quantityPerPackage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyCatalogPackageComponentsCompanion(')
          ..write('packageId: $packageId, ')
          ..write('componentItemId: $componentItemId, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('unitSnapshot: $unitSnapshot, ')
          ..write('typeSnapshot: $typeSnapshot, ')
          ..write('categorySnapshot: $categorySnapshot, ')
          ..write('quantityPerPackage: $quantityPerPackage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyCompanyProfilesTable extends LegacyCompanyProfiles
    with TableInfo<$LegacyCompanyProfilesTable, LegacyCompanyProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyCompanyProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tradeNameMeta = const VerificationMeta(
    'tradeName',
  );
  @override
  late final GeneratedColumn<String> tradeName = GeneratedColumn<String>(
    'trade_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _legalNameMeta = const VerificationMeta(
    'legalName',
  );
  @override
  late final GeneratedColumn<String> legalName = GeneratedColumn<String>(
    'legal_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cnpjDigitsMeta = const VerificationMeta(
    'cnpjDigits',
  );
  @override
  late final GeneratedColumn<String> cnpjDigits = GeneratedColumn<String>(
    'cnpj_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateRegistrationMeta = const VerificationMeta(
    'stateRegistration',
  );
  @override
  late final GeneratedColumn<String> stateRegistration =
      GeneratedColumn<String>(
        'state_registration',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _logoReferenceMeta = const VerificationMeta(
    'logoReference',
  );
  @override
  late final GeneratedColumn<String> logoReference = GeneratedColumn<String>(
    'logo_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneDigitsMeta = const VerificationMeta(
    'phoneDigits',
  );
  @override
  late final GeneratedColumn<String> phoneDigits = GeneratedColumn<String>(
    'phone_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _whatsappDigitsMeta = const VerificationMeta(
    'whatsappDigits',
  );
  @override
  late final GeneratedColumn<String> whatsappDigits = GeneratedColumn<String>(
    'whatsapp_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _instagramMeta = const VerificationMeta(
    'instagram',
  );
  @override
  late final GeneratedColumn<String> instagram = GeneratedColumn<String>(
    'instagram',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postalCodeMeta = const VerificationMeta(
    'postalCode',
  );
  @override
  late final GeneratedColumn<String> postalCode = GeneratedColumn<String>(
    'postal_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _streetMeta = const VerificationMeta('street');
  @override
  late final GeneratedColumn<String> street = GeneratedColumn<String>(
    'street',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _complementMeta = const VerificationMeta(
    'complement',
  );
  @override
  late final GeneratedColumn<String> complement = GeneratedColumn<String>(
    'complement',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _neighborhoodMeta = const VerificationMeta(
    'neighborhood',
  );
  @override
  late final GeneratedColumn<String> neighborhood = GeneratedColumn<String>(
    'neighborhood',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repFullNameMeta = const VerificationMeta(
    'repFullName',
  );
  @override
  late final GeneratedColumn<String> repFullName = GeneratedColumn<String>(
    'rep_full_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repCpfDigitsMeta = const VerificationMeta(
    'repCpfDigits',
  );
  @override
  late final GeneratedColumn<String> repCpfDigits = GeneratedColumn<String>(
    'rep_cpf_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repRoleMeta = const VerificationMeta(
    'repRole',
  );
  @override
  late final GeneratedColumn<String> repRole = GeneratedColumn<String>(
    'rep_role',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pixKeyTypeMeta = const VerificationMeta(
    'pixKeyType',
  );
  @override
  late final GeneratedColumn<String> pixKeyType = GeneratedColumn<String>(
    'pix_key_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pixKeyMeta = const VerificationMeta('pixKey');
  @override
  late final GeneratedColumn<String> pixKey = GeneratedColumn<String>(
    'pix_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _beneficiaryNameMeta = const VerificationMeta(
    'beneficiaryName',
  );
  @override
  late final GeneratedColumn<String> beneficiaryName = GeneratedColumn<String>(
    'beneficiary_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentTermsMeta = const VerificationMeta(
    'paymentTerms',
  );
  @override
  late final GeneratedColumn<String> paymentTerms = GeneratedColumn<String>(
    'payment_terms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultValidityDaysMeta =
      const VerificationMeta('defaultValidityDays');
  @override
  late final GeneratedColumn<int> defaultValidityDays = GeneratedColumn<int>(
    'default_validity_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultPublicNotesMeta =
      const VerificationMeta('defaultPublicNotes');
  @override
  late final GeneratedColumn<String> defaultPublicNotes =
      GeneratedColumn<String>(
        'default_public_notes',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tradeName,
    legalName,
    cnpjDigits,
    stateRegistration,
    logoReference,
    phoneDigits,
    whatsappDigits,
    email,
    instagram,
    website,
    postalCode,
    street,
    number,
    complement,
    neighborhood,
    city,
    state,
    repFullName,
    repCpfDigits,
    repRole,
    pixKeyType,
    pixKey,
    beneficiaryName,
    paymentTerms,
    defaultValidityDays,
    defaultPublicNotes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'company_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyCompanyProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trade_name')) {
      context.handle(
        _tradeNameMeta,
        tradeName.isAcceptableOrUnknown(data['trade_name']!, _tradeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_tradeNameMeta);
    }
    if (data.containsKey('legal_name')) {
      context.handle(
        _legalNameMeta,
        legalName.isAcceptableOrUnknown(data['legal_name']!, _legalNameMeta),
      );
    }
    if (data.containsKey('cnpj_digits')) {
      context.handle(
        _cnpjDigitsMeta,
        cnpjDigits.isAcceptableOrUnknown(data['cnpj_digits']!, _cnpjDigitsMeta),
      );
    }
    if (data.containsKey('state_registration')) {
      context.handle(
        _stateRegistrationMeta,
        stateRegistration.isAcceptableOrUnknown(
          data['state_registration']!,
          _stateRegistrationMeta,
        ),
      );
    }
    if (data.containsKey('logo_reference')) {
      context.handle(
        _logoReferenceMeta,
        logoReference.isAcceptableOrUnknown(
          data['logo_reference']!,
          _logoReferenceMeta,
        ),
      );
    }
    if (data.containsKey('phone_digits')) {
      context.handle(
        _phoneDigitsMeta,
        phoneDigits.isAcceptableOrUnknown(
          data['phone_digits']!,
          _phoneDigitsMeta,
        ),
      );
    }
    if (data.containsKey('whatsapp_digits')) {
      context.handle(
        _whatsappDigitsMeta,
        whatsappDigits.isAcceptableOrUnknown(
          data['whatsapp_digits']!,
          _whatsappDigitsMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('instagram')) {
      context.handle(
        _instagramMeta,
        instagram.isAcceptableOrUnknown(data['instagram']!, _instagramMeta),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('postal_code')) {
      context.handle(
        _postalCodeMeta,
        postalCode.isAcceptableOrUnknown(data['postal_code']!, _postalCodeMeta),
      );
    }
    if (data.containsKey('street')) {
      context.handle(
        _streetMeta,
        street.isAcceptableOrUnknown(data['street']!, _streetMeta),
      );
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    }
    if (data.containsKey('complement')) {
      context.handle(
        _complementMeta,
        complement.isAcceptableOrUnknown(data['complement']!, _complementMeta),
      );
    }
    if (data.containsKey('neighborhood')) {
      context.handle(
        _neighborhoodMeta,
        neighborhood.isAcceptableOrUnknown(
          data['neighborhood']!,
          _neighborhoodMeta,
        ),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('rep_full_name')) {
      context.handle(
        _repFullNameMeta,
        repFullName.isAcceptableOrUnknown(
          data['rep_full_name']!,
          _repFullNameMeta,
        ),
      );
    }
    if (data.containsKey('rep_cpf_digits')) {
      context.handle(
        _repCpfDigitsMeta,
        repCpfDigits.isAcceptableOrUnknown(
          data['rep_cpf_digits']!,
          _repCpfDigitsMeta,
        ),
      );
    }
    if (data.containsKey('rep_role')) {
      context.handle(
        _repRoleMeta,
        repRole.isAcceptableOrUnknown(data['rep_role']!, _repRoleMeta),
      );
    }
    if (data.containsKey('pix_key_type')) {
      context.handle(
        _pixKeyTypeMeta,
        pixKeyType.isAcceptableOrUnknown(
          data['pix_key_type']!,
          _pixKeyTypeMeta,
        ),
      );
    }
    if (data.containsKey('pix_key')) {
      context.handle(
        _pixKeyMeta,
        pixKey.isAcceptableOrUnknown(data['pix_key']!, _pixKeyMeta),
      );
    }
    if (data.containsKey('beneficiary_name')) {
      context.handle(
        _beneficiaryNameMeta,
        beneficiaryName.isAcceptableOrUnknown(
          data['beneficiary_name']!,
          _beneficiaryNameMeta,
        ),
      );
    }
    if (data.containsKey('payment_terms')) {
      context.handle(
        _paymentTermsMeta,
        paymentTerms.isAcceptableOrUnknown(
          data['payment_terms']!,
          _paymentTermsMeta,
        ),
      );
    }
    if (data.containsKey('default_validity_days')) {
      context.handle(
        _defaultValidityDaysMeta,
        defaultValidityDays.isAcceptableOrUnknown(
          data['default_validity_days']!,
          _defaultValidityDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultValidityDaysMeta);
    }
    if (data.containsKey('default_public_notes')) {
      context.handle(
        _defaultPublicNotesMeta,
        defaultPublicNotes.isAcceptableOrUnknown(
          data['default_public_notes']!,
          _defaultPublicNotesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyCompanyProfileRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyCompanyProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tradeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trade_name'],
      )!,
      legalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legal_name'],
      ),
      cnpjDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cnpj_digits'],
      ),
      stateRegistration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_registration'],
      ),
      logoReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_reference'],
      ),
      phoneDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_digits'],
      ),
      whatsappDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}whatsapp_digits'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      instagram: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instagram'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      postalCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}postal_code'],
      ),
      street: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}street'],
      ),
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      ),
      complement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}complement'],
      ),
      neighborhood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}neighborhood'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      repFullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rep_full_name'],
      ),
      repCpfDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rep_cpf_digits'],
      ),
      repRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rep_role'],
      ),
      pixKeyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pix_key_type'],
      ),
      pixKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pix_key'],
      ),
      beneficiaryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}beneficiary_name'],
      ),
      paymentTerms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_terms'],
      ),
      defaultValidityDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_validity_days'],
      )!,
      defaultPublicNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_public_notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LegacyCompanyProfilesTable createAlias(String alias) {
    return $LegacyCompanyProfilesTable(attachedDatabase, alias);
  }
}

class LegacyCompanyProfileRow extends DataClass
    implements Insertable<LegacyCompanyProfileRow> {
  final String id;
  final String tradeName;
  final String? legalName;
  final String? cnpjDigits;
  final String? stateRegistration;
  final String? logoReference;
  final String? phoneDigits;
  final String? whatsappDigits;
  final String? email;
  final String? instagram;
  final String? website;
  final String? postalCode;
  final String? street;
  final String? number;
  final String? complement;
  final String? neighborhood;
  final String? city;
  final String? state;
  final String? repFullName;
  final String? repCpfDigits;
  final String? repRole;
  final String? pixKeyType;
  final String? pixKey;
  final String? beneficiaryName;
  final String? paymentTerms;
  final int defaultValidityDays;
  final String? defaultPublicNotes;
  final int createdAt;
  final int updatedAt;
  const LegacyCompanyProfileRow({
    required this.id,
    required this.tradeName,
    this.legalName,
    this.cnpjDigits,
    this.stateRegistration,
    this.logoReference,
    this.phoneDigits,
    this.whatsappDigits,
    this.email,
    this.instagram,
    this.website,
    this.postalCode,
    this.street,
    this.number,
    this.complement,
    this.neighborhood,
    this.city,
    this.state,
    this.repFullName,
    this.repCpfDigits,
    this.repRole,
    this.pixKeyType,
    this.pixKey,
    this.beneficiaryName,
    this.paymentTerms,
    required this.defaultValidityDays,
    this.defaultPublicNotes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trade_name'] = Variable<String>(tradeName);
    if (!nullToAbsent || legalName != null) {
      map['legal_name'] = Variable<String>(legalName);
    }
    if (!nullToAbsent || cnpjDigits != null) {
      map['cnpj_digits'] = Variable<String>(cnpjDigits);
    }
    if (!nullToAbsent || stateRegistration != null) {
      map['state_registration'] = Variable<String>(stateRegistration);
    }
    if (!nullToAbsent || logoReference != null) {
      map['logo_reference'] = Variable<String>(logoReference);
    }
    if (!nullToAbsent || phoneDigits != null) {
      map['phone_digits'] = Variable<String>(phoneDigits);
    }
    if (!nullToAbsent || whatsappDigits != null) {
      map['whatsapp_digits'] = Variable<String>(whatsappDigits);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || instagram != null) {
      map['instagram'] = Variable<String>(instagram);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    if (!nullToAbsent || postalCode != null) {
      map['postal_code'] = Variable<String>(postalCode);
    }
    if (!nullToAbsent || street != null) {
      map['street'] = Variable<String>(street);
    }
    if (!nullToAbsent || number != null) {
      map['number'] = Variable<String>(number);
    }
    if (!nullToAbsent || complement != null) {
      map['complement'] = Variable<String>(complement);
    }
    if (!nullToAbsent || neighborhood != null) {
      map['neighborhood'] = Variable<String>(neighborhood);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || repFullName != null) {
      map['rep_full_name'] = Variable<String>(repFullName);
    }
    if (!nullToAbsent || repCpfDigits != null) {
      map['rep_cpf_digits'] = Variable<String>(repCpfDigits);
    }
    if (!nullToAbsent || repRole != null) {
      map['rep_role'] = Variable<String>(repRole);
    }
    if (!nullToAbsent || pixKeyType != null) {
      map['pix_key_type'] = Variable<String>(pixKeyType);
    }
    if (!nullToAbsent || pixKey != null) {
      map['pix_key'] = Variable<String>(pixKey);
    }
    if (!nullToAbsent || beneficiaryName != null) {
      map['beneficiary_name'] = Variable<String>(beneficiaryName);
    }
    if (!nullToAbsent || paymentTerms != null) {
      map['payment_terms'] = Variable<String>(paymentTerms);
    }
    map['default_validity_days'] = Variable<int>(defaultValidityDays);
    if (!nullToAbsent || defaultPublicNotes != null) {
      map['default_public_notes'] = Variable<String>(defaultPublicNotes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LegacyCompanyProfilesCompanion toCompanion(bool nullToAbsent) {
    return LegacyCompanyProfilesCompanion(
      id: Value(id),
      tradeName: Value(tradeName),
      legalName: legalName == null && nullToAbsent
          ? const Value.absent()
          : Value(legalName),
      cnpjDigits: cnpjDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(cnpjDigits),
      stateRegistration: stateRegistration == null && nullToAbsent
          ? const Value.absent()
          : Value(stateRegistration),
      logoReference: logoReference == null && nullToAbsent
          ? const Value.absent()
          : Value(logoReference),
      phoneDigits: phoneDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneDigits),
      whatsappDigits: whatsappDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsappDigits),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      instagram: instagram == null && nullToAbsent
          ? const Value.absent()
          : Value(instagram),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      postalCode: postalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(postalCode),
      street: street == null && nullToAbsent
          ? const Value.absent()
          : Value(street),
      number: number == null && nullToAbsent
          ? const Value.absent()
          : Value(number),
      complement: complement == null && nullToAbsent
          ? const Value.absent()
          : Value(complement),
      neighborhood: neighborhood == null && nullToAbsent
          ? const Value.absent()
          : Value(neighborhood),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      repFullName: repFullName == null && nullToAbsent
          ? const Value.absent()
          : Value(repFullName),
      repCpfDigits: repCpfDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(repCpfDigits),
      repRole: repRole == null && nullToAbsent
          ? const Value.absent()
          : Value(repRole),
      pixKeyType: pixKeyType == null && nullToAbsent
          ? const Value.absent()
          : Value(pixKeyType),
      pixKey: pixKey == null && nullToAbsent
          ? const Value.absent()
          : Value(pixKey),
      beneficiaryName: beneficiaryName == null && nullToAbsent
          ? const Value.absent()
          : Value(beneficiaryName),
      paymentTerms: paymentTerms == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentTerms),
      defaultValidityDays: Value(defaultValidityDays),
      defaultPublicNotes: defaultPublicNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultPublicNotes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LegacyCompanyProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyCompanyProfileRow(
      id: serializer.fromJson<String>(json['id']),
      tradeName: serializer.fromJson<String>(json['tradeName']),
      legalName: serializer.fromJson<String?>(json['legalName']),
      cnpjDigits: serializer.fromJson<String?>(json['cnpjDigits']),
      stateRegistration: serializer.fromJson<String?>(
        json['stateRegistration'],
      ),
      logoReference: serializer.fromJson<String?>(json['logoReference']),
      phoneDigits: serializer.fromJson<String?>(json['phoneDigits']),
      whatsappDigits: serializer.fromJson<String?>(json['whatsappDigits']),
      email: serializer.fromJson<String?>(json['email']),
      instagram: serializer.fromJson<String?>(json['instagram']),
      website: serializer.fromJson<String?>(json['website']),
      postalCode: serializer.fromJson<String?>(json['postalCode']),
      street: serializer.fromJson<String?>(json['street']),
      number: serializer.fromJson<String?>(json['number']),
      complement: serializer.fromJson<String?>(json['complement']),
      neighborhood: serializer.fromJson<String?>(json['neighborhood']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      repFullName: serializer.fromJson<String?>(json['repFullName']),
      repCpfDigits: serializer.fromJson<String?>(json['repCpfDigits']),
      repRole: serializer.fromJson<String?>(json['repRole']),
      pixKeyType: serializer.fromJson<String?>(json['pixKeyType']),
      pixKey: serializer.fromJson<String?>(json['pixKey']),
      beneficiaryName: serializer.fromJson<String?>(json['beneficiaryName']),
      paymentTerms: serializer.fromJson<String?>(json['paymentTerms']),
      defaultValidityDays: serializer.fromJson<int>(
        json['defaultValidityDays'],
      ),
      defaultPublicNotes: serializer.fromJson<String?>(
        json['defaultPublicNotes'],
      ),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tradeName': serializer.toJson<String>(tradeName),
      'legalName': serializer.toJson<String?>(legalName),
      'cnpjDigits': serializer.toJson<String?>(cnpjDigits),
      'stateRegistration': serializer.toJson<String?>(stateRegistration),
      'logoReference': serializer.toJson<String?>(logoReference),
      'phoneDigits': serializer.toJson<String?>(phoneDigits),
      'whatsappDigits': serializer.toJson<String?>(whatsappDigits),
      'email': serializer.toJson<String?>(email),
      'instagram': serializer.toJson<String?>(instagram),
      'website': serializer.toJson<String?>(website),
      'postalCode': serializer.toJson<String?>(postalCode),
      'street': serializer.toJson<String?>(street),
      'number': serializer.toJson<String?>(number),
      'complement': serializer.toJson<String?>(complement),
      'neighborhood': serializer.toJson<String?>(neighborhood),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'repFullName': serializer.toJson<String?>(repFullName),
      'repCpfDigits': serializer.toJson<String?>(repCpfDigits),
      'repRole': serializer.toJson<String?>(repRole),
      'pixKeyType': serializer.toJson<String?>(pixKeyType),
      'pixKey': serializer.toJson<String?>(pixKey),
      'beneficiaryName': serializer.toJson<String?>(beneficiaryName),
      'paymentTerms': serializer.toJson<String?>(paymentTerms),
      'defaultValidityDays': serializer.toJson<int>(defaultValidityDays),
      'defaultPublicNotes': serializer.toJson<String?>(defaultPublicNotes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LegacyCompanyProfileRow copyWith({
    String? id,
    String? tradeName,
    Value<String?> legalName = const Value.absent(),
    Value<String?> cnpjDigits = const Value.absent(),
    Value<String?> stateRegistration = const Value.absent(),
    Value<String?> logoReference = const Value.absent(),
    Value<String?> phoneDigits = const Value.absent(),
    Value<String?> whatsappDigits = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> instagram = const Value.absent(),
    Value<String?> website = const Value.absent(),
    Value<String?> postalCode = const Value.absent(),
    Value<String?> street = const Value.absent(),
    Value<String?> number = const Value.absent(),
    Value<String?> complement = const Value.absent(),
    Value<String?> neighborhood = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> repFullName = const Value.absent(),
    Value<String?> repCpfDigits = const Value.absent(),
    Value<String?> repRole = const Value.absent(),
    Value<String?> pixKeyType = const Value.absent(),
    Value<String?> pixKey = const Value.absent(),
    Value<String?> beneficiaryName = const Value.absent(),
    Value<String?> paymentTerms = const Value.absent(),
    int? defaultValidityDays,
    Value<String?> defaultPublicNotes = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => LegacyCompanyProfileRow(
    id: id ?? this.id,
    tradeName: tradeName ?? this.tradeName,
    legalName: legalName.present ? legalName.value : this.legalName,
    cnpjDigits: cnpjDigits.present ? cnpjDigits.value : this.cnpjDigits,
    stateRegistration: stateRegistration.present
        ? stateRegistration.value
        : this.stateRegistration,
    logoReference: logoReference.present
        ? logoReference.value
        : this.logoReference,
    phoneDigits: phoneDigits.present ? phoneDigits.value : this.phoneDigits,
    whatsappDigits: whatsappDigits.present
        ? whatsappDigits.value
        : this.whatsappDigits,
    email: email.present ? email.value : this.email,
    instagram: instagram.present ? instagram.value : this.instagram,
    website: website.present ? website.value : this.website,
    postalCode: postalCode.present ? postalCode.value : this.postalCode,
    street: street.present ? street.value : this.street,
    number: number.present ? number.value : this.number,
    complement: complement.present ? complement.value : this.complement,
    neighborhood: neighborhood.present ? neighborhood.value : this.neighborhood,
    city: city.present ? city.value : this.city,
    state: state.present ? state.value : this.state,
    repFullName: repFullName.present ? repFullName.value : this.repFullName,
    repCpfDigits: repCpfDigits.present ? repCpfDigits.value : this.repCpfDigits,
    repRole: repRole.present ? repRole.value : this.repRole,
    pixKeyType: pixKeyType.present ? pixKeyType.value : this.pixKeyType,
    pixKey: pixKey.present ? pixKey.value : this.pixKey,
    beneficiaryName: beneficiaryName.present
        ? beneficiaryName.value
        : this.beneficiaryName,
    paymentTerms: paymentTerms.present ? paymentTerms.value : this.paymentTerms,
    defaultValidityDays: defaultValidityDays ?? this.defaultValidityDays,
    defaultPublicNotes: defaultPublicNotes.present
        ? defaultPublicNotes.value
        : this.defaultPublicNotes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LegacyCompanyProfileRow copyWithCompanion(
    LegacyCompanyProfilesCompanion data,
  ) {
    return LegacyCompanyProfileRow(
      id: data.id.present ? data.id.value : this.id,
      tradeName: data.tradeName.present ? data.tradeName.value : this.tradeName,
      legalName: data.legalName.present ? data.legalName.value : this.legalName,
      cnpjDigits: data.cnpjDigits.present
          ? data.cnpjDigits.value
          : this.cnpjDigits,
      stateRegistration: data.stateRegistration.present
          ? data.stateRegistration.value
          : this.stateRegistration,
      logoReference: data.logoReference.present
          ? data.logoReference.value
          : this.logoReference,
      phoneDigits: data.phoneDigits.present
          ? data.phoneDigits.value
          : this.phoneDigits,
      whatsappDigits: data.whatsappDigits.present
          ? data.whatsappDigits.value
          : this.whatsappDigits,
      email: data.email.present ? data.email.value : this.email,
      instagram: data.instagram.present ? data.instagram.value : this.instagram,
      website: data.website.present ? data.website.value : this.website,
      postalCode: data.postalCode.present
          ? data.postalCode.value
          : this.postalCode,
      street: data.street.present ? data.street.value : this.street,
      number: data.number.present ? data.number.value : this.number,
      complement: data.complement.present
          ? data.complement.value
          : this.complement,
      neighborhood: data.neighborhood.present
          ? data.neighborhood.value
          : this.neighborhood,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      repFullName: data.repFullName.present
          ? data.repFullName.value
          : this.repFullName,
      repCpfDigits: data.repCpfDigits.present
          ? data.repCpfDigits.value
          : this.repCpfDigits,
      repRole: data.repRole.present ? data.repRole.value : this.repRole,
      pixKeyType: data.pixKeyType.present
          ? data.pixKeyType.value
          : this.pixKeyType,
      pixKey: data.pixKey.present ? data.pixKey.value : this.pixKey,
      beneficiaryName: data.beneficiaryName.present
          ? data.beneficiaryName.value
          : this.beneficiaryName,
      paymentTerms: data.paymentTerms.present
          ? data.paymentTerms.value
          : this.paymentTerms,
      defaultValidityDays: data.defaultValidityDays.present
          ? data.defaultValidityDays.value
          : this.defaultValidityDays,
      defaultPublicNotes: data.defaultPublicNotes.present
          ? data.defaultPublicNotes.value
          : this.defaultPublicNotes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyCompanyProfileRow(')
          ..write('id: $id, ')
          ..write('tradeName: $tradeName, ')
          ..write('legalName: $legalName, ')
          ..write('cnpjDigits: $cnpjDigits, ')
          ..write('stateRegistration: $stateRegistration, ')
          ..write('logoReference: $logoReference, ')
          ..write('phoneDigits: $phoneDigits, ')
          ..write('whatsappDigits: $whatsappDigits, ')
          ..write('email: $email, ')
          ..write('instagram: $instagram, ')
          ..write('website: $website, ')
          ..write('postalCode: $postalCode, ')
          ..write('street: $street, ')
          ..write('number: $number, ')
          ..write('complement: $complement, ')
          ..write('neighborhood: $neighborhood, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('repFullName: $repFullName, ')
          ..write('repCpfDigits: $repCpfDigits, ')
          ..write('repRole: $repRole, ')
          ..write('pixKeyType: $pixKeyType, ')
          ..write('pixKey: $pixKey, ')
          ..write('beneficiaryName: $beneficiaryName, ')
          ..write('paymentTerms: $paymentTerms, ')
          ..write('defaultValidityDays: $defaultValidityDays, ')
          ..write('defaultPublicNotes: $defaultPublicNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    tradeName,
    legalName,
    cnpjDigits,
    stateRegistration,
    logoReference,
    phoneDigits,
    whatsappDigits,
    email,
    instagram,
    website,
    postalCode,
    street,
    number,
    complement,
    neighborhood,
    city,
    state,
    repFullName,
    repCpfDigits,
    repRole,
    pixKeyType,
    pixKey,
    beneficiaryName,
    paymentTerms,
    defaultValidityDays,
    defaultPublicNotes,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyCompanyProfileRow &&
          other.id == this.id &&
          other.tradeName == this.tradeName &&
          other.legalName == this.legalName &&
          other.cnpjDigits == this.cnpjDigits &&
          other.stateRegistration == this.stateRegistration &&
          other.logoReference == this.logoReference &&
          other.phoneDigits == this.phoneDigits &&
          other.whatsappDigits == this.whatsappDigits &&
          other.email == this.email &&
          other.instagram == this.instagram &&
          other.website == this.website &&
          other.postalCode == this.postalCode &&
          other.street == this.street &&
          other.number == this.number &&
          other.complement == this.complement &&
          other.neighborhood == this.neighborhood &&
          other.city == this.city &&
          other.state == this.state &&
          other.repFullName == this.repFullName &&
          other.repCpfDigits == this.repCpfDigits &&
          other.repRole == this.repRole &&
          other.pixKeyType == this.pixKeyType &&
          other.pixKey == this.pixKey &&
          other.beneficiaryName == this.beneficiaryName &&
          other.paymentTerms == this.paymentTerms &&
          other.defaultValidityDays == this.defaultValidityDays &&
          other.defaultPublicNotes == this.defaultPublicNotes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LegacyCompanyProfilesCompanion
    extends UpdateCompanion<LegacyCompanyProfileRow> {
  final Value<String> id;
  final Value<String> tradeName;
  final Value<String?> legalName;
  final Value<String?> cnpjDigits;
  final Value<String?> stateRegistration;
  final Value<String?> logoReference;
  final Value<String?> phoneDigits;
  final Value<String?> whatsappDigits;
  final Value<String?> email;
  final Value<String?> instagram;
  final Value<String?> website;
  final Value<String?> postalCode;
  final Value<String?> street;
  final Value<String?> number;
  final Value<String?> complement;
  final Value<String?> neighborhood;
  final Value<String?> city;
  final Value<String?> state;
  final Value<String?> repFullName;
  final Value<String?> repCpfDigits;
  final Value<String?> repRole;
  final Value<String?> pixKeyType;
  final Value<String?> pixKey;
  final Value<String?> beneficiaryName;
  final Value<String?> paymentTerms;
  final Value<int> defaultValidityDays;
  final Value<String?> defaultPublicNotes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LegacyCompanyProfilesCompanion({
    this.id = const Value.absent(),
    this.tradeName = const Value.absent(),
    this.legalName = const Value.absent(),
    this.cnpjDigits = const Value.absent(),
    this.stateRegistration = const Value.absent(),
    this.logoReference = const Value.absent(),
    this.phoneDigits = const Value.absent(),
    this.whatsappDigits = const Value.absent(),
    this.email = const Value.absent(),
    this.instagram = const Value.absent(),
    this.website = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.street = const Value.absent(),
    this.number = const Value.absent(),
    this.complement = const Value.absent(),
    this.neighborhood = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.repFullName = const Value.absent(),
    this.repCpfDigits = const Value.absent(),
    this.repRole = const Value.absent(),
    this.pixKeyType = const Value.absent(),
    this.pixKey = const Value.absent(),
    this.beneficiaryName = const Value.absent(),
    this.paymentTerms = const Value.absent(),
    this.defaultValidityDays = const Value.absent(),
    this.defaultPublicNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyCompanyProfilesCompanion.insert({
    required String id,
    required String tradeName,
    this.legalName = const Value.absent(),
    this.cnpjDigits = const Value.absent(),
    this.stateRegistration = const Value.absent(),
    this.logoReference = const Value.absent(),
    this.phoneDigits = const Value.absent(),
    this.whatsappDigits = const Value.absent(),
    this.email = const Value.absent(),
    this.instagram = const Value.absent(),
    this.website = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.street = const Value.absent(),
    this.number = const Value.absent(),
    this.complement = const Value.absent(),
    this.neighborhood = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.repFullName = const Value.absent(),
    this.repCpfDigits = const Value.absent(),
    this.repRole = const Value.absent(),
    this.pixKeyType = const Value.absent(),
    this.pixKey = const Value.absent(),
    this.beneficiaryName = const Value.absent(),
    this.paymentTerms = const Value.absent(),
    required int defaultValidityDays,
    this.defaultPublicNotes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tradeName = Value(tradeName),
       defaultValidityDays = Value(defaultValidityDays),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LegacyCompanyProfileRow> custom({
    Expression<String>? id,
    Expression<String>? tradeName,
    Expression<String>? legalName,
    Expression<String>? cnpjDigits,
    Expression<String>? stateRegistration,
    Expression<String>? logoReference,
    Expression<String>? phoneDigits,
    Expression<String>? whatsappDigits,
    Expression<String>? email,
    Expression<String>? instagram,
    Expression<String>? website,
    Expression<String>? postalCode,
    Expression<String>? street,
    Expression<String>? number,
    Expression<String>? complement,
    Expression<String>? neighborhood,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? repFullName,
    Expression<String>? repCpfDigits,
    Expression<String>? repRole,
    Expression<String>? pixKeyType,
    Expression<String>? pixKey,
    Expression<String>? beneficiaryName,
    Expression<String>? paymentTerms,
    Expression<int>? defaultValidityDays,
    Expression<String>? defaultPublicNotes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tradeName != null) 'trade_name': tradeName,
      if (legalName != null) 'legal_name': legalName,
      if (cnpjDigits != null) 'cnpj_digits': cnpjDigits,
      if (stateRegistration != null) 'state_registration': stateRegistration,
      if (logoReference != null) 'logo_reference': logoReference,
      if (phoneDigits != null) 'phone_digits': phoneDigits,
      if (whatsappDigits != null) 'whatsapp_digits': whatsappDigits,
      if (email != null) 'email': email,
      if (instagram != null) 'instagram': instagram,
      if (website != null) 'website': website,
      if (postalCode != null) 'postal_code': postalCode,
      if (street != null) 'street': street,
      if (number != null) 'number': number,
      if (complement != null) 'complement': complement,
      if (neighborhood != null) 'neighborhood': neighborhood,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (repFullName != null) 'rep_full_name': repFullName,
      if (repCpfDigits != null) 'rep_cpf_digits': repCpfDigits,
      if (repRole != null) 'rep_role': repRole,
      if (pixKeyType != null) 'pix_key_type': pixKeyType,
      if (pixKey != null) 'pix_key': pixKey,
      if (beneficiaryName != null) 'beneficiary_name': beneficiaryName,
      if (paymentTerms != null) 'payment_terms': paymentTerms,
      if (defaultValidityDays != null)
        'default_validity_days': defaultValidityDays,
      if (defaultPublicNotes != null)
        'default_public_notes': defaultPublicNotes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyCompanyProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? tradeName,
    Value<String?>? legalName,
    Value<String?>? cnpjDigits,
    Value<String?>? stateRegistration,
    Value<String?>? logoReference,
    Value<String?>? phoneDigits,
    Value<String?>? whatsappDigits,
    Value<String?>? email,
    Value<String?>? instagram,
    Value<String?>? website,
    Value<String?>? postalCode,
    Value<String?>? street,
    Value<String?>? number,
    Value<String?>? complement,
    Value<String?>? neighborhood,
    Value<String?>? city,
    Value<String?>? state,
    Value<String?>? repFullName,
    Value<String?>? repCpfDigits,
    Value<String?>? repRole,
    Value<String?>? pixKeyType,
    Value<String?>? pixKey,
    Value<String?>? beneficiaryName,
    Value<String?>? paymentTerms,
    Value<int>? defaultValidityDays,
    Value<String?>? defaultPublicNotes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LegacyCompanyProfilesCompanion(
      id: id ?? this.id,
      tradeName: tradeName ?? this.tradeName,
      legalName: legalName ?? this.legalName,
      cnpjDigits: cnpjDigits ?? this.cnpjDigits,
      stateRegistration: stateRegistration ?? this.stateRegistration,
      logoReference: logoReference ?? this.logoReference,
      phoneDigits: phoneDigits ?? this.phoneDigits,
      whatsappDigits: whatsappDigits ?? this.whatsappDigits,
      email: email ?? this.email,
      instagram: instagram ?? this.instagram,
      website: website ?? this.website,
      postalCode: postalCode ?? this.postalCode,
      street: street ?? this.street,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
      repFullName: repFullName ?? this.repFullName,
      repCpfDigits: repCpfDigits ?? this.repCpfDigits,
      repRole: repRole ?? this.repRole,
      pixKeyType: pixKeyType ?? this.pixKeyType,
      pixKey: pixKey ?? this.pixKey,
      beneficiaryName: beneficiaryName ?? this.beneficiaryName,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      defaultValidityDays: defaultValidityDays ?? this.defaultValidityDays,
      defaultPublicNotes: defaultPublicNotes ?? this.defaultPublicNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tradeName.present) {
      map['trade_name'] = Variable<String>(tradeName.value);
    }
    if (legalName.present) {
      map['legal_name'] = Variable<String>(legalName.value);
    }
    if (cnpjDigits.present) {
      map['cnpj_digits'] = Variable<String>(cnpjDigits.value);
    }
    if (stateRegistration.present) {
      map['state_registration'] = Variable<String>(stateRegistration.value);
    }
    if (logoReference.present) {
      map['logo_reference'] = Variable<String>(logoReference.value);
    }
    if (phoneDigits.present) {
      map['phone_digits'] = Variable<String>(phoneDigits.value);
    }
    if (whatsappDigits.present) {
      map['whatsapp_digits'] = Variable<String>(whatsappDigits.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (instagram.present) {
      map['instagram'] = Variable<String>(instagram.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (postalCode.present) {
      map['postal_code'] = Variable<String>(postalCode.value);
    }
    if (street.present) {
      map['street'] = Variable<String>(street.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (complement.present) {
      map['complement'] = Variable<String>(complement.value);
    }
    if (neighborhood.present) {
      map['neighborhood'] = Variable<String>(neighborhood.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (repFullName.present) {
      map['rep_full_name'] = Variable<String>(repFullName.value);
    }
    if (repCpfDigits.present) {
      map['rep_cpf_digits'] = Variable<String>(repCpfDigits.value);
    }
    if (repRole.present) {
      map['rep_role'] = Variable<String>(repRole.value);
    }
    if (pixKeyType.present) {
      map['pix_key_type'] = Variable<String>(pixKeyType.value);
    }
    if (pixKey.present) {
      map['pix_key'] = Variable<String>(pixKey.value);
    }
    if (beneficiaryName.present) {
      map['beneficiary_name'] = Variable<String>(beneficiaryName.value);
    }
    if (paymentTerms.present) {
      map['payment_terms'] = Variable<String>(paymentTerms.value);
    }
    if (defaultValidityDays.present) {
      map['default_validity_days'] = Variable<int>(defaultValidityDays.value);
    }
    if (defaultPublicNotes.present) {
      map['default_public_notes'] = Variable<String>(defaultPublicNotes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyCompanyProfilesCompanion(')
          ..write('id: $id, ')
          ..write('tradeName: $tradeName, ')
          ..write('legalName: $legalName, ')
          ..write('cnpjDigits: $cnpjDigits, ')
          ..write('stateRegistration: $stateRegistration, ')
          ..write('logoReference: $logoReference, ')
          ..write('phoneDigits: $phoneDigits, ')
          ..write('whatsappDigits: $whatsappDigits, ')
          ..write('email: $email, ')
          ..write('instagram: $instagram, ')
          ..write('website: $website, ')
          ..write('postalCode: $postalCode, ')
          ..write('street: $street, ')
          ..write('number: $number, ')
          ..write('complement: $complement, ')
          ..write('neighborhood: $neighborhood, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('repFullName: $repFullName, ')
          ..write('repCpfDigits: $repCpfDigits, ')
          ..write('repRole: $repRole, ')
          ..write('pixKeyType: $pixKeyType, ')
          ..write('pixKey: $pixKey, ')
          ..write('beneficiaryName: $beneficiaryName, ')
          ..write('paymentTerms: $paymentTerms, ')
          ..write('defaultValidityDays: $defaultValidityDays, ')
          ..write('defaultPublicNotes: $defaultPublicNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyQuotesTable extends LegacyQuotes
    with TableInfo<$LegacyQuotesTable, LegacyQuoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyQuotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalCentsMeta = const VerificationMeta(
    'subtotalCents',
  );
  @override
  late final GeneratedColumn<int> subtotalCents = GeneratedColumn<int>(
    'subtotal_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountCentsMeta = const VerificationMeta(
    'discountCents',
  );
  @override
  late final GeneratedColumn<int> discountCents = GeneratedColumn<int>(
    'discount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _freightCentsMeta = const VerificationMeta(
    'freightCents',
  );
  @override
  late final GeneratedColumn<int> freightCents = GeneratedColumn<int>(
    'freight_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCentsMeta = const VerificationMeta(
    'totalCents',
  );
  @override
  late final GeneratedColumn<int> totalCents = GeneratedColumn<int>(
    'total_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validUntilMeta = const VerificationMeta(
    'validUntil',
  );
  @override
  late final GeneratedColumn<String> validUntil = GeneratedColumn<String>(
    'valid_until',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _internalNotesMeta = const VerificationMeta(
    'internalNotes',
  );
  @override
  late final GeneratedColumn<String> internalNotes = GeneratedColumn<String>(
    'internal_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _approvedAtMeta = const VerificationMeta(
    'approvedAt',
  );
  @override
  late final GeneratedColumn<int> approvedAt = GeneratedColumn<int>(
    'approved_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    number,
    status,
    subtotalCents,
    discountCents,
    freightCents,
    totalCents,
    validUntil,
    notes,
    internalNotes,
    createdAt,
    updatedAt,
    approvedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quotes';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyQuoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('subtotal_cents')) {
      context.handle(
        _subtotalCentsMeta,
        subtotalCents.isAcceptableOrUnknown(
          data['subtotal_cents']!,
          _subtotalCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subtotalCentsMeta);
    }
    if (data.containsKey('discount_cents')) {
      context.handle(
        _discountCentsMeta,
        discountCents.isAcceptableOrUnknown(
          data['discount_cents']!,
          _discountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discountCentsMeta);
    }
    if (data.containsKey('freight_cents')) {
      context.handle(
        _freightCentsMeta,
        freightCents.isAcceptableOrUnknown(
          data['freight_cents']!,
          _freightCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_freightCentsMeta);
    }
    if (data.containsKey('total_cents')) {
      context.handle(
        _totalCentsMeta,
        totalCents.isAcceptableOrUnknown(data['total_cents']!, _totalCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalCentsMeta);
    }
    if (data.containsKey('valid_until')) {
      context.handle(
        _validUntilMeta,
        validUntil.isAcceptableOrUnknown(data['valid_until']!, _validUntilMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('internal_notes')) {
      context.handle(
        _internalNotesMeta,
        internalNotes.isAcceptableOrUnknown(
          data['internal_notes']!,
          _internalNotesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('approved_at')) {
      context.handle(
        _approvedAtMeta,
        approvedAt.isAcceptableOrUnknown(data['approved_at']!, _approvedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyQuoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyQuoteRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      subtotalCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal_cents'],
      )!,
      discountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_cents'],
      )!,
      freightCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}freight_cents'],
      )!,
      totalCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_cents'],
      )!,
      validUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_until'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      internalNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}internal_notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      approvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}approved_at'],
      ),
    );
  }

  @override
  $LegacyQuotesTable createAlias(String alias) {
    return $LegacyQuotesTable(attachedDatabase, alias);
  }
}

class LegacyQuoteRow extends DataClass implements Insertable<LegacyQuoteRow> {
  final String id;
  final String number;
  final String status;
  final int subtotalCents;
  final int discountCents;
  final int freightCents;
  final int totalCents;
  final String? validUntil;
  final String? notes;
  final String? internalNotes;
  final int createdAt;
  final int updatedAt;
  final int? approvedAt;
  const LegacyQuoteRow({
    required this.id,
    required this.number,
    required this.status,
    required this.subtotalCents,
    required this.discountCents,
    required this.freightCents,
    required this.totalCents,
    this.validUntil,
    this.notes,
    this.internalNotes,
    required this.createdAt,
    required this.updatedAt,
    this.approvedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['number'] = Variable<String>(number);
    map['status'] = Variable<String>(status);
    map['subtotal_cents'] = Variable<int>(subtotalCents);
    map['discount_cents'] = Variable<int>(discountCents);
    map['freight_cents'] = Variable<int>(freightCents);
    map['total_cents'] = Variable<int>(totalCents);
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<String>(validUntil);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || internalNotes != null) {
      map['internal_notes'] = Variable<String>(internalNotes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || approvedAt != null) {
      map['approved_at'] = Variable<int>(approvedAt);
    }
    return map;
  }

  LegacyQuotesCompanion toCompanion(bool nullToAbsent) {
    return LegacyQuotesCompanion(
      id: Value(id),
      number: Value(number),
      status: Value(status),
      subtotalCents: Value(subtotalCents),
      discountCents: Value(discountCents),
      freightCents: Value(freightCents),
      totalCents: Value(totalCents),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      internalNotes: internalNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(internalNotes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      approvedAt: approvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedAt),
    );
  }

  factory LegacyQuoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyQuoteRow(
      id: serializer.fromJson<String>(json['id']),
      number: serializer.fromJson<String>(json['number']),
      status: serializer.fromJson<String>(json['status']),
      subtotalCents: serializer.fromJson<int>(json['subtotalCents']),
      discountCents: serializer.fromJson<int>(json['discountCents']),
      freightCents: serializer.fromJson<int>(json['freightCents']),
      totalCents: serializer.fromJson<int>(json['totalCents']),
      validUntil: serializer.fromJson<String?>(json['validUntil']),
      notes: serializer.fromJson<String?>(json['notes']),
      internalNotes: serializer.fromJson<String?>(json['internalNotes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      approvedAt: serializer.fromJson<int?>(json['approvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'number': serializer.toJson<String>(number),
      'status': serializer.toJson<String>(status),
      'subtotalCents': serializer.toJson<int>(subtotalCents),
      'discountCents': serializer.toJson<int>(discountCents),
      'freightCents': serializer.toJson<int>(freightCents),
      'totalCents': serializer.toJson<int>(totalCents),
      'validUntil': serializer.toJson<String?>(validUntil),
      'notes': serializer.toJson<String?>(notes),
      'internalNotes': serializer.toJson<String?>(internalNotes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'approvedAt': serializer.toJson<int?>(approvedAt),
    };
  }

  LegacyQuoteRow copyWith({
    String? id,
    String? number,
    String? status,
    int? subtotalCents,
    int? discountCents,
    int? freightCents,
    int? totalCents,
    Value<String?> validUntil = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> internalNotes = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    Value<int?> approvedAt = const Value.absent(),
  }) => LegacyQuoteRow(
    id: id ?? this.id,
    number: number ?? this.number,
    status: status ?? this.status,
    subtotalCents: subtotalCents ?? this.subtotalCents,
    discountCents: discountCents ?? this.discountCents,
    freightCents: freightCents ?? this.freightCents,
    totalCents: totalCents ?? this.totalCents,
    validUntil: validUntil.present ? validUntil.value : this.validUntil,
    notes: notes.present ? notes.value : this.notes,
    internalNotes: internalNotes.present
        ? internalNotes.value
        : this.internalNotes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    approvedAt: approvedAt.present ? approvedAt.value : this.approvedAt,
  );
  LegacyQuoteRow copyWithCompanion(LegacyQuotesCompanion data) {
    return LegacyQuoteRow(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      status: data.status.present ? data.status.value : this.status,
      subtotalCents: data.subtotalCents.present
          ? data.subtotalCents.value
          : this.subtotalCents,
      discountCents: data.discountCents.present
          ? data.discountCents.value
          : this.discountCents,
      freightCents: data.freightCents.present
          ? data.freightCents.value
          : this.freightCents,
      totalCents: data.totalCents.present
          ? data.totalCents.value
          : this.totalCents,
      validUntil: data.validUntil.present
          ? data.validUntil.value
          : this.validUntil,
      notes: data.notes.present ? data.notes.value : this.notes,
      internalNotes: data.internalNotes.present
          ? data.internalNotes.value
          : this.internalNotes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      approvedAt: data.approvedAt.present
          ? data.approvedAt.value
          : this.approvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteRow(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('status: $status, ')
          ..write('subtotalCents: $subtotalCents, ')
          ..write('discountCents: $discountCents, ')
          ..write('freightCents: $freightCents, ')
          ..write('totalCents: $totalCents, ')
          ..write('validUntil: $validUntil, ')
          ..write('notes: $notes, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('approvedAt: $approvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    number,
    status,
    subtotalCents,
    discountCents,
    freightCents,
    totalCents,
    validUntil,
    notes,
    internalNotes,
    createdAt,
    updatedAt,
    approvedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyQuoteRow &&
          other.id == this.id &&
          other.number == this.number &&
          other.status == this.status &&
          other.subtotalCents == this.subtotalCents &&
          other.discountCents == this.discountCents &&
          other.freightCents == this.freightCents &&
          other.totalCents == this.totalCents &&
          other.validUntil == this.validUntil &&
          other.notes == this.notes &&
          other.internalNotes == this.internalNotes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.approvedAt == this.approvedAt);
}

class LegacyQuotesCompanion extends UpdateCompanion<LegacyQuoteRow> {
  final Value<String> id;
  final Value<String> number;
  final Value<String> status;
  final Value<int> subtotalCents;
  final Value<int> discountCents;
  final Value<int> freightCents;
  final Value<int> totalCents;
  final Value<String?> validUntil;
  final Value<String?> notes;
  final Value<String?> internalNotes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> approvedAt;
  final Value<int> rowid;
  const LegacyQuotesCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotalCents = const Value.absent(),
    this.discountCents = const Value.absent(),
    this.freightCents = const Value.absent(),
    this.totalCents = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.notes = const Value.absent(),
    this.internalNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyQuotesCompanion.insert({
    required String id,
    required String number,
    required String status,
    required int subtotalCents,
    required int discountCents,
    required int freightCents,
    required int totalCents,
    this.validUntil = const Value.absent(),
    this.notes = const Value.absent(),
    this.internalNotes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.approvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       number = Value(number),
       status = Value(status),
       subtotalCents = Value(subtotalCents),
       discountCents = Value(discountCents),
       freightCents = Value(freightCents),
       totalCents = Value(totalCents),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LegacyQuoteRow> custom({
    Expression<String>? id,
    Expression<String>? number,
    Expression<String>? status,
    Expression<int>? subtotalCents,
    Expression<int>? discountCents,
    Expression<int>? freightCents,
    Expression<int>? totalCents,
    Expression<String>? validUntil,
    Expression<String>? notes,
    Expression<String>? internalNotes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? approvedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (status != null) 'status': status,
      if (subtotalCents != null) 'subtotal_cents': subtotalCents,
      if (discountCents != null) 'discount_cents': discountCents,
      if (freightCents != null) 'freight_cents': freightCents,
      if (totalCents != null) 'total_cents': totalCents,
      if (validUntil != null) 'valid_until': validUntil,
      if (notes != null) 'notes': notes,
      if (internalNotes != null) 'internal_notes': internalNotes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (approvedAt != null) 'approved_at': approvedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyQuotesCompanion copyWith({
    Value<String>? id,
    Value<String>? number,
    Value<String>? status,
    Value<int>? subtotalCents,
    Value<int>? discountCents,
    Value<int>? freightCents,
    Value<int>? totalCents,
    Value<String?>? validUntil,
    Value<String?>? notes,
    Value<String?>? internalNotes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? approvedAt,
    Value<int>? rowid,
  }) {
    return LegacyQuotesCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      status: status ?? this.status,
      subtotalCents: subtotalCents ?? this.subtotalCents,
      discountCents: discountCents ?? this.discountCents,
      freightCents: freightCents ?? this.freightCents,
      totalCents: totalCents ?? this.totalCents,
      validUntil: validUntil ?? this.validUntil,
      notes: notes ?? this.notes,
      internalNotes: internalNotes ?? this.internalNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (subtotalCents.present) {
      map['subtotal_cents'] = Variable<int>(subtotalCents.value);
    }
    if (discountCents.present) {
      map['discount_cents'] = Variable<int>(discountCents.value);
    }
    if (freightCents.present) {
      map['freight_cents'] = Variable<int>(freightCents.value);
    }
    if (totalCents.present) {
      map['total_cents'] = Variable<int>(totalCents.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<String>(validUntil.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (internalNotes.present) {
      map['internal_notes'] = Variable<String>(internalNotes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (approvedAt.present) {
      map['approved_at'] = Variable<int>(approvedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuotesCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('status: $status, ')
          ..write('subtotalCents: $subtotalCents, ')
          ..write('discountCents: $discountCents, ')
          ..write('freightCents: $freightCents, ')
          ..write('totalCents: $totalCents, ')
          ..write('validUntil: $validUntil, ')
          ..write('notes: $notes, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyQuoteClientSnapshotsTable extends LegacyQuoteClientSnapshots
    with
        TableInfo<
          $LegacyQuoteClientSnapshotsTable,
          LegacyQuoteClientSnapshotRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyQuoteClientSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quotes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sourceClientIdMeta = const VerificationMeta(
    'sourceClientId',
  );
  @override
  late final GeneratedColumn<String> sourceClientId = GeneratedColumn<String>(
    'source_client_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _legalNameMeta = const VerificationMeta(
    'legalName',
  );
  @override
  late final GeneratedColumn<String> legalName = GeneratedColumn<String>(
    'legal_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _documentDigitsMeta = const VerificationMeta(
    'documentDigits',
  );
  @override
  late final GeneratedColumn<String> documentDigits = GeneratedColumn<String>(
    'document_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneDigitsMeta = const VerificationMeta(
    'phoneDigits',
  );
  @override
  late final GeneratedColumn<String> phoneDigits = GeneratedColumn<String>(
    'phone_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _whatsappDigitsMeta = const VerificationMeta(
    'whatsappDigits',
  );
  @override
  late final GeneratedColumn<String> whatsappDigits = GeneratedColumn<String>(
    'whatsapp_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressSummaryMeta = const VerificationMeta(
    'addressSummary',
  );
  @override
  late final GeneratedColumn<String> addressSummary = GeneratedColumn<String>(
    'address_summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    quoteId,
    sourceClientId,
    type,
    displayName,
    legalName,
    documentDigits,
    phoneDigits,
    whatsappDigits,
    email,
    addressSummary,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote_client_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyQuoteClientSnapshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('source_client_id')) {
      context.handle(
        _sourceClientIdMeta,
        sourceClientId.isAcceptableOrUnknown(
          data['source_client_id']!,
          _sourceClientIdMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('legal_name')) {
      context.handle(
        _legalNameMeta,
        legalName.isAcceptableOrUnknown(data['legal_name']!, _legalNameMeta),
      );
    }
    if (data.containsKey('document_digits')) {
      context.handle(
        _documentDigitsMeta,
        documentDigits.isAcceptableOrUnknown(
          data['document_digits']!,
          _documentDigitsMeta,
        ),
      );
    }
    if (data.containsKey('phone_digits')) {
      context.handle(
        _phoneDigitsMeta,
        phoneDigits.isAcceptableOrUnknown(
          data['phone_digits']!,
          _phoneDigitsMeta,
        ),
      );
    }
    if (data.containsKey('whatsapp_digits')) {
      context.handle(
        _whatsappDigitsMeta,
        whatsappDigits.isAcceptableOrUnknown(
          data['whatsapp_digits']!,
          _whatsappDigitsMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address_summary')) {
      context.handle(
        _addressSummaryMeta,
        addressSummary.isAcceptableOrUnknown(
          data['address_summary']!,
          _addressSummaryMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {quoteId};
  @override
  LegacyQuoteClientSnapshotRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyQuoteClientSnapshotRow(
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      sourceClientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_client_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      legalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legal_name'],
      ),
      documentDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_digits'],
      ),
      phoneDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_digits'],
      ),
      whatsappDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}whatsapp_digits'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      addressSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_summary'],
      ),
    );
  }

  @override
  $LegacyQuoteClientSnapshotsTable createAlias(String alias) {
    return $LegacyQuoteClientSnapshotsTable(attachedDatabase, alias);
  }
}

class LegacyQuoteClientSnapshotRow extends DataClass
    implements Insertable<LegacyQuoteClientSnapshotRow> {
  final String quoteId;
  final String? sourceClientId;
  final String type;
  final String displayName;
  final String? legalName;
  final String? documentDigits;
  final String? phoneDigits;
  final String? whatsappDigits;
  final String? email;
  final String? addressSummary;
  const LegacyQuoteClientSnapshotRow({
    required this.quoteId,
    this.sourceClientId,
    required this.type,
    required this.displayName,
    this.legalName,
    this.documentDigits,
    this.phoneDigits,
    this.whatsappDigits,
    this.email,
    this.addressSummary,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['quote_id'] = Variable<String>(quoteId);
    if (!nullToAbsent || sourceClientId != null) {
      map['source_client_id'] = Variable<String>(sourceClientId);
    }
    map['type'] = Variable<String>(type);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || legalName != null) {
      map['legal_name'] = Variable<String>(legalName);
    }
    if (!nullToAbsent || documentDigits != null) {
      map['document_digits'] = Variable<String>(documentDigits);
    }
    if (!nullToAbsent || phoneDigits != null) {
      map['phone_digits'] = Variable<String>(phoneDigits);
    }
    if (!nullToAbsent || whatsappDigits != null) {
      map['whatsapp_digits'] = Variable<String>(whatsappDigits);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || addressSummary != null) {
      map['address_summary'] = Variable<String>(addressSummary);
    }
    return map;
  }

  LegacyQuoteClientSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return LegacyQuoteClientSnapshotsCompanion(
      quoteId: Value(quoteId),
      sourceClientId: sourceClientId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceClientId),
      type: Value(type),
      displayName: Value(displayName),
      legalName: legalName == null && nullToAbsent
          ? const Value.absent()
          : Value(legalName),
      documentDigits: documentDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(documentDigits),
      phoneDigits: phoneDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneDigits),
      whatsappDigits: whatsappDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsappDigits),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      addressSummary: addressSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(addressSummary),
    );
  }

  factory LegacyQuoteClientSnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyQuoteClientSnapshotRow(
      quoteId: serializer.fromJson<String>(json['quoteId']),
      sourceClientId: serializer.fromJson<String?>(json['sourceClientId']),
      type: serializer.fromJson<String>(json['type']),
      displayName: serializer.fromJson<String>(json['displayName']),
      legalName: serializer.fromJson<String?>(json['legalName']),
      documentDigits: serializer.fromJson<String?>(json['documentDigits']),
      phoneDigits: serializer.fromJson<String?>(json['phoneDigits']),
      whatsappDigits: serializer.fromJson<String?>(json['whatsappDigits']),
      email: serializer.fromJson<String?>(json['email']),
      addressSummary: serializer.fromJson<String?>(json['addressSummary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'quoteId': serializer.toJson<String>(quoteId),
      'sourceClientId': serializer.toJson<String?>(sourceClientId),
      'type': serializer.toJson<String>(type),
      'displayName': serializer.toJson<String>(displayName),
      'legalName': serializer.toJson<String?>(legalName),
      'documentDigits': serializer.toJson<String?>(documentDigits),
      'phoneDigits': serializer.toJson<String?>(phoneDigits),
      'whatsappDigits': serializer.toJson<String?>(whatsappDigits),
      'email': serializer.toJson<String?>(email),
      'addressSummary': serializer.toJson<String?>(addressSummary),
    };
  }

  LegacyQuoteClientSnapshotRow copyWith({
    String? quoteId,
    Value<String?> sourceClientId = const Value.absent(),
    String? type,
    String? displayName,
    Value<String?> legalName = const Value.absent(),
    Value<String?> documentDigits = const Value.absent(),
    Value<String?> phoneDigits = const Value.absent(),
    Value<String?> whatsappDigits = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> addressSummary = const Value.absent(),
  }) => LegacyQuoteClientSnapshotRow(
    quoteId: quoteId ?? this.quoteId,
    sourceClientId: sourceClientId.present
        ? sourceClientId.value
        : this.sourceClientId,
    type: type ?? this.type,
    displayName: displayName ?? this.displayName,
    legalName: legalName.present ? legalName.value : this.legalName,
    documentDigits: documentDigits.present
        ? documentDigits.value
        : this.documentDigits,
    phoneDigits: phoneDigits.present ? phoneDigits.value : this.phoneDigits,
    whatsappDigits: whatsappDigits.present
        ? whatsappDigits.value
        : this.whatsappDigits,
    email: email.present ? email.value : this.email,
    addressSummary: addressSummary.present
        ? addressSummary.value
        : this.addressSummary,
  );
  LegacyQuoteClientSnapshotRow copyWithCompanion(
    LegacyQuoteClientSnapshotsCompanion data,
  ) {
    return LegacyQuoteClientSnapshotRow(
      quoteId: data.quoteId.present ? data.quoteId.value : this.quoteId,
      sourceClientId: data.sourceClientId.present
          ? data.sourceClientId.value
          : this.sourceClientId,
      type: data.type.present ? data.type.value : this.type,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      legalName: data.legalName.present ? data.legalName.value : this.legalName,
      documentDigits: data.documentDigits.present
          ? data.documentDigits.value
          : this.documentDigits,
      phoneDigits: data.phoneDigits.present
          ? data.phoneDigits.value
          : this.phoneDigits,
      whatsappDigits: data.whatsappDigits.present
          ? data.whatsappDigits.value
          : this.whatsappDigits,
      email: data.email.present ? data.email.value : this.email,
      addressSummary: data.addressSummary.present
          ? data.addressSummary.value
          : this.addressSummary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteClientSnapshotRow(')
          ..write('quoteId: $quoteId, ')
          ..write('sourceClientId: $sourceClientId, ')
          ..write('type: $type, ')
          ..write('displayName: $displayName, ')
          ..write('legalName: $legalName, ')
          ..write('documentDigits: $documentDigits, ')
          ..write('phoneDigits: $phoneDigits, ')
          ..write('whatsappDigits: $whatsappDigits, ')
          ..write('email: $email, ')
          ..write('addressSummary: $addressSummary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    quoteId,
    sourceClientId,
    type,
    displayName,
    legalName,
    documentDigits,
    phoneDigits,
    whatsappDigits,
    email,
    addressSummary,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyQuoteClientSnapshotRow &&
          other.quoteId == this.quoteId &&
          other.sourceClientId == this.sourceClientId &&
          other.type == this.type &&
          other.displayName == this.displayName &&
          other.legalName == this.legalName &&
          other.documentDigits == this.documentDigits &&
          other.phoneDigits == this.phoneDigits &&
          other.whatsappDigits == this.whatsappDigits &&
          other.email == this.email &&
          other.addressSummary == this.addressSummary);
}

class LegacyQuoteClientSnapshotsCompanion
    extends UpdateCompanion<LegacyQuoteClientSnapshotRow> {
  final Value<String> quoteId;
  final Value<String?> sourceClientId;
  final Value<String> type;
  final Value<String> displayName;
  final Value<String?> legalName;
  final Value<String?> documentDigits;
  final Value<String?> phoneDigits;
  final Value<String?> whatsappDigits;
  final Value<String?> email;
  final Value<String?> addressSummary;
  final Value<int> rowid;
  const LegacyQuoteClientSnapshotsCompanion({
    this.quoteId = const Value.absent(),
    this.sourceClientId = const Value.absent(),
    this.type = const Value.absent(),
    this.displayName = const Value.absent(),
    this.legalName = const Value.absent(),
    this.documentDigits = const Value.absent(),
    this.phoneDigits = const Value.absent(),
    this.whatsappDigits = const Value.absent(),
    this.email = const Value.absent(),
    this.addressSummary = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyQuoteClientSnapshotsCompanion.insert({
    required String quoteId,
    this.sourceClientId = const Value.absent(),
    required String type,
    required String displayName,
    this.legalName = const Value.absent(),
    this.documentDigits = const Value.absent(),
    this.phoneDigits = const Value.absent(),
    this.whatsappDigits = const Value.absent(),
    this.email = const Value.absent(),
    this.addressSummary = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : quoteId = Value(quoteId),
       type = Value(type),
       displayName = Value(displayName);
  static Insertable<LegacyQuoteClientSnapshotRow> custom({
    Expression<String>? quoteId,
    Expression<String>? sourceClientId,
    Expression<String>? type,
    Expression<String>? displayName,
    Expression<String>? legalName,
    Expression<String>? documentDigits,
    Expression<String>? phoneDigits,
    Expression<String>? whatsappDigits,
    Expression<String>? email,
    Expression<String>? addressSummary,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (quoteId != null) 'quote_id': quoteId,
      if (sourceClientId != null) 'source_client_id': sourceClientId,
      if (type != null) 'type': type,
      if (displayName != null) 'display_name': displayName,
      if (legalName != null) 'legal_name': legalName,
      if (documentDigits != null) 'document_digits': documentDigits,
      if (phoneDigits != null) 'phone_digits': phoneDigits,
      if (whatsappDigits != null) 'whatsapp_digits': whatsappDigits,
      if (email != null) 'email': email,
      if (addressSummary != null) 'address_summary': addressSummary,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyQuoteClientSnapshotsCompanion copyWith({
    Value<String>? quoteId,
    Value<String?>? sourceClientId,
    Value<String>? type,
    Value<String>? displayName,
    Value<String?>? legalName,
    Value<String?>? documentDigits,
    Value<String?>? phoneDigits,
    Value<String?>? whatsappDigits,
    Value<String?>? email,
    Value<String?>? addressSummary,
    Value<int>? rowid,
  }) {
    return LegacyQuoteClientSnapshotsCompanion(
      quoteId: quoteId ?? this.quoteId,
      sourceClientId: sourceClientId ?? this.sourceClientId,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      legalName: legalName ?? this.legalName,
      documentDigits: documentDigits ?? this.documentDigits,
      phoneDigits: phoneDigits ?? this.phoneDigits,
      whatsappDigits: whatsappDigits ?? this.whatsappDigits,
      email: email ?? this.email,
      addressSummary: addressSummary ?? this.addressSummary,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (sourceClientId.present) {
      map['source_client_id'] = Variable<String>(sourceClientId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (legalName.present) {
      map['legal_name'] = Variable<String>(legalName.value);
    }
    if (documentDigits.present) {
      map['document_digits'] = Variable<String>(documentDigits.value);
    }
    if (phoneDigits.present) {
      map['phone_digits'] = Variable<String>(phoneDigits.value);
    }
    if (whatsappDigits.present) {
      map['whatsapp_digits'] = Variable<String>(whatsappDigits.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (addressSummary.present) {
      map['address_summary'] = Variable<String>(addressSummary.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteClientSnapshotsCompanion(')
          ..write('quoteId: $quoteId, ')
          ..write('sourceClientId: $sourceClientId, ')
          ..write('type: $type, ')
          ..write('displayName: $displayName, ')
          ..write('legalName: $legalName, ')
          ..write('documentDigits: $documentDigits, ')
          ..write('phoneDigits: $phoneDigits, ')
          ..write('whatsappDigits: $whatsappDigits, ')
          ..write('email: $email, ')
          ..write('addressSummary: $addressSummary, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyQuoteEventSnapshotsTable extends LegacyQuoteEventSnapshots
    with
        TableInfo<
          $LegacyQuoteEventSnapshotsTable,
          LegacyQuoteEventSnapshotRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyQuoteEventSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quotes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eventDateMeta = const VerificationMeta(
    'eventDate',
  );
  @override
  late final GeneratedColumn<String> eventDate = GeneratedColumn<String>(
    'event_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _venueNameMeta = const VerificationMeta(
    'venueName',
  );
  @override
  late final GeneratedColumn<String> venueName = GeneratedColumn<String>(
    'venue_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressSummaryMeta = const VerificationMeta(
    'addressSummary',
  );
  @override
  late final GeneratedColumn<String> addressSummary = GeneratedColumn<String>(
    'address_summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _guestCountMeta = const VerificationMeta(
    'guestCount',
  );
  @override
  late final GeneratedColumn<int> guestCount = GeneratedColumn<int>(
    'guest_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    quoteId,
    name,
    type,
    eventDate,
    startTime,
    endTime,
    venueName,
    addressSummary,
    guestCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote_event_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyQuoteEventSnapshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('event_date')) {
      context.handle(
        _eventDateMeta,
        eventDate.isAcceptableOrUnknown(data['event_date']!, _eventDateMeta),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('venue_name')) {
      context.handle(
        _venueNameMeta,
        venueName.isAcceptableOrUnknown(data['venue_name']!, _venueNameMeta),
      );
    }
    if (data.containsKey('address_summary')) {
      context.handle(
        _addressSummaryMeta,
        addressSummary.isAcceptableOrUnknown(
          data['address_summary']!,
          _addressSummaryMeta,
        ),
      );
    }
    if (data.containsKey('guest_count')) {
      context.handle(
        _guestCountMeta,
        guestCount.isAcceptableOrUnknown(data['guest_count']!, _guestCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {quoteId};
  @override
  LegacyQuoteEventSnapshotRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyQuoteEventSnapshotRow(
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      ),
      eventDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_date'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      ),
      venueName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}venue_name'],
      ),
      addressSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_summary'],
      ),
      guestCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}guest_count'],
      ),
    );
  }

  @override
  $LegacyQuoteEventSnapshotsTable createAlias(String alias) {
    return $LegacyQuoteEventSnapshotsTable(attachedDatabase, alias);
  }
}

class LegacyQuoteEventSnapshotRow extends DataClass
    implements Insertable<LegacyQuoteEventSnapshotRow> {
  final String quoteId;
  final String? name;
  final String? type;
  final String? eventDate;
  final String? startTime;
  final String? endTime;
  final String? venueName;
  final String? addressSummary;
  final int? guestCount;
  const LegacyQuoteEventSnapshotRow({
    required this.quoteId,
    this.name,
    this.type,
    this.eventDate,
    this.startTime,
    this.endTime,
    this.venueName,
    this.addressSummary,
    this.guestCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['quote_id'] = Variable<String>(quoteId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || eventDate != null) {
      map['event_date'] = Variable<String>(eventDate);
    }
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<String>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    if (!nullToAbsent || venueName != null) {
      map['venue_name'] = Variable<String>(venueName);
    }
    if (!nullToAbsent || addressSummary != null) {
      map['address_summary'] = Variable<String>(addressSummary);
    }
    if (!nullToAbsent || guestCount != null) {
      map['guest_count'] = Variable<int>(guestCount);
    }
    return map;
  }

  LegacyQuoteEventSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return LegacyQuoteEventSnapshotsCompanion(
      quoteId: Value(quoteId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      eventDate: eventDate == null && nullToAbsent
          ? const Value.absent()
          : Value(eventDate),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      venueName: venueName == null && nullToAbsent
          ? const Value.absent()
          : Value(venueName),
      addressSummary: addressSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(addressSummary),
      guestCount: guestCount == null && nullToAbsent
          ? const Value.absent()
          : Value(guestCount),
    );
  }

  factory LegacyQuoteEventSnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyQuoteEventSnapshotRow(
      quoteId: serializer.fromJson<String>(json['quoteId']),
      name: serializer.fromJson<String?>(json['name']),
      type: serializer.fromJson<String?>(json['type']),
      eventDate: serializer.fromJson<String?>(json['eventDate']),
      startTime: serializer.fromJson<String?>(json['startTime']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      venueName: serializer.fromJson<String?>(json['venueName']),
      addressSummary: serializer.fromJson<String?>(json['addressSummary']),
      guestCount: serializer.fromJson<int?>(json['guestCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'quoteId': serializer.toJson<String>(quoteId),
      'name': serializer.toJson<String?>(name),
      'type': serializer.toJson<String?>(type),
      'eventDate': serializer.toJson<String?>(eventDate),
      'startTime': serializer.toJson<String?>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'venueName': serializer.toJson<String?>(venueName),
      'addressSummary': serializer.toJson<String?>(addressSummary),
      'guestCount': serializer.toJson<int?>(guestCount),
    };
  }

  LegacyQuoteEventSnapshotRow copyWith({
    String? quoteId,
    Value<String?> name = const Value.absent(),
    Value<String?> type = const Value.absent(),
    Value<String?> eventDate = const Value.absent(),
    Value<String?> startTime = const Value.absent(),
    Value<String?> endTime = const Value.absent(),
    Value<String?> venueName = const Value.absent(),
    Value<String?> addressSummary = const Value.absent(),
    Value<int?> guestCount = const Value.absent(),
  }) => LegacyQuoteEventSnapshotRow(
    quoteId: quoteId ?? this.quoteId,
    name: name.present ? name.value : this.name,
    type: type.present ? type.value : this.type,
    eventDate: eventDate.present ? eventDate.value : this.eventDate,
    startTime: startTime.present ? startTime.value : this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    venueName: venueName.present ? venueName.value : this.venueName,
    addressSummary: addressSummary.present
        ? addressSummary.value
        : this.addressSummary,
    guestCount: guestCount.present ? guestCount.value : this.guestCount,
  );
  LegacyQuoteEventSnapshotRow copyWithCompanion(
    LegacyQuoteEventSnapshotsCompanion data,
  ) {
    return LegacyQuoteEventSnapshotRow(
      quoteId: data.quoteId.present ? data.quoteId.value : this.quoteId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      eventDate: data.eventDate.present ? data.eventDate.value : this.eventDate,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      venueName: data.venueName.present ? data.venueName.value : this.venueName,
      addressSummary: data.addressSummary.present
          ? data.addressSummary.value
          : this.addressSummary,
      guestCount: data.guestCount.present
          ? data.guestCount.value
          : this.guestCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteEventSnapshotRow(')
          ..write('quoteId: $quoteId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('eventDate: $eventDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('venueName: $venueName, ')
          ..write('addressSummary: $addressSummary, ')
          ..write('guestCount: $guestCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    quoteId,
    name,
    type,
    eventDate,
    startTime,
    endTime,
    venueName,
    addressSummary,
    guestCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyQuoteEventSnapshotRow &&
          other.quoteId == this.quoteId &&
          other.name == this.name &&
          other.type == this.type &&
          other.eventDate == this.eventDate &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.venueName == this.venueName &&
          other.addressSummary == this.addressSummary &&
          other.guestCount == this.guestCount);
}

class LegacyQuoteEventSnapshotsCompanion
    extends UpdateCompanion<LegacyQuoteEventSnapshotRow> {
  final Value<String> quoteId;
  final Value<String?> name;
  final Value<String?> type;
  final Value<String?> eventDate;
  final Value<String?> startTime;
  final Value<String?> endTime;
  final Value<String?> venueName;
  final Value<String?> addressSummary;
  final Value<int?> guestCount;
  final Value<int> rowid;
  const LegacyQuoteEventSnapshotsCompanion({
    this.quoteId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.venueName = const Value.absent(),
    this.addressSummary = const Value.absent(),
    this.guestCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyQuoteEventSnapshotsCompanion.insert({
    required String quoteId,
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.venueName = const Value.absent(),
    this.addressSummary = const Value.absent(),
    this.guestCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : quoteId = Value(quoteId);
  static Insertable<LegacyQuoteEventSnapshotRow> custom({
    Expression<String>? quoteId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? eventDate,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? venueName,
    Expression<String>? addressSummary,
    Expression<int>? guestCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (quoteId != null) 'quote_id': quoteId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (eventDate != null) 'event_date': eventDate,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (venueName != null) 'venue_name': venueName,
      if (addressSummary != null) 'address_summary': addressSummary,
      if (guestCount != null) 'guest_count': guestCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyQuoteEventSnapshotsCompanion copyWith({
    Value<String>? quoteId,
    Value<String?>? name,
    Value<String?>? type,
    Value<String?>? eventDate,
    Value<String?>? startTime,
    Value<String?>? endTime,
    Value<String?>? venueName,
    Value<String?>? addressSummary,
    Value<int?>? guestCount,
    Value<int>? rowid,
  }) {
    return LegacyQuoteEventSnapshotsCompanion(
      quoteId: quoteId ?? this.quoteId,
      name: name ?? this.name,
      type: type ?? this.type,
      eventDate: eventDate ?? this.eventDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      venueName: venueName ?? this.venueName,
      addressSummary: addressSummary ?? this.addressSummary,
      guestCount: guestCount ?? this.guestCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<String>(eventDate.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (venueName.present) {
      map['venue_name'] = Variable<String>(venueName.value);
    }
    if (addressSummary.present) {
      map['address_summary'] = Variable<String>(addressSummary.value);
    }
    if (guestCount.present) {
      map['guest_count'] = Variable<int>(guestCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteEventSnapshotsCompanion(')
          ..write('quoteId: $quoteId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('eventDate: $eventDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('venueName: $venueName, ')
          ..write('addressSummary: $addressSummary, ')
          ..write('guestCount: $guestCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyQuoteCompanySnapshotsTable extends LegacyQuoteCompanySnapshots
    with
        TableInfo<
          $LegacyQuoteCompanySnapshotsTable,
          LegacyQuoteCompanySnapshotRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyQuoteCompanySnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quotes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _captureStatusMeta = const VerificationMeta(
    'captureStatus',
  );
  @override
  late final GeneratedColumn<String> captureStatus = GeneratedColumn<String>(
    'capture_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<int> capturedAt = GeneratedColumn<int>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logoReferenceMeta = const VerificationMeta(
    'logoReference',
  );
  @override
  late final GeneratedColumn<String> logoReference = GeneratedColumn<String>(
    'logo_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _identTradeNameMeta = const VerificationMeta(
    'identTradeName',
  );
  @override
  late final GeneratedColumn<String> identTradeName = GeneratedColumn<String>(
    'ident_trade_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _identLegalNameMeta = const VerificationMeta(
    'identLegalName',
  );
  @override
  late final GeneratedColumn<String> identLegalName = GeneratedColumn<String>(
    'ident_legal_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _identCnpjDigitsMeta = const VerificationMeta(
    'identCnpjDigits',
  );
  @override
  late final GeneratedColumn<String> identCnpjDigits = GeneratedColumn<String>(
    'ident_cnpj_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _identStateRegistrationMeta =
      const VerificationMeta('identStateRegistration');
  @override
  late final GeneratedColumn<String> identStateRegistration =
      GeneratedColumn<String>(
        'ident_state_registration',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _contactPhoneDigitsMeta =
      const VerificationMeta('contactPhoneDigits');
  @override
  late final GeneratedColumn<String> contactPhoneDigits =
      GeneratedColumn<String>(
        'contact_phone_digits',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _contactWhatsappDigitsMeta =
      const VerificationMeta('contactWhatsappDigits');
  @override
  late final GeneratedColumn<String> contactWhatsappDigits =
      GeneratedColumn<String>(
        'contact_whatsapp_digits',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _contactEmailMeta = const VerificationMeta(
    'contactEmail',
  );
  @override
  late final GeneratedColumn<String> contactEmail = GeneratedColumn<String>(
    'contact_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactInstagramMeta = const VerificationMeta(
    'contactInstagram',
  );
  @override
  late final GeneratedColumn<String> contactInstagram = GeneratedColumn<String>(
    'contact_instagram',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactWebsiteMeta = const VerificationMeta(
    'contactWebsite',
  );
  @override
  late final GeneratedColumn<String> contactWebsite = GeneratedColumn<String>(
    'contact_website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addrPostalCodeMeta = const VerificationMeta(
    'addrPostalCode',
  );
  @override
  late final GeneratedColumn<String> addrPostalCode = GeneratedColumn<String>(
    'addr_postal_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addrStreetMeta = const VerificationMeta(
    'addrStreet',
  );
  @override
  late final GeneratedColumn<String> addrStreet = GeneratedColumn<String>(
    'addr_street',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addrNumberMeta = const VerificationMeta(
    'addrNumber',
  );
  @override
  late final GeneratedColumn<String> addrNumber = GeneratedColumn<String>(
    'addr_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addrComplementMeta = const VerificationMeta(
    'addrComplement',
  );
  @override
  late final GeneratedColumn<String> addrComplement = GeneratedColumn<String>(
    'addr_complement',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addrNeighborhoodMeta = const VerificationMeta(
    'addrNeighborhood',
  );
  @override
  late final GeneratedColumn<String> addrNeighborhood = GeneratedColumn<String>(
    'addr_neighborhood',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addrCityMeta = const VerificationMeta(
    'addrCity',
  );
  @override
  late final GeneratedColumn<String> addrCity = GeneratedColumn<String>(
    'addr_city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addrStateMeta = const VerificationMeta(
    'addrState',
  );
  @override
  late final GeneratedColumn<String> addrState = GeneratedColumn<String>(
    'addr_state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repFullNameMeta = const VerificationMeta(
    'repFullName',
  );
  @override
  late final GeneratedColumn<String> repFullName = GeneratedColumn<String>(
    'rep_full_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repCpfDigitsMeta = const VerificationMeta(
    'repCpfDigits',
  );
  @override
  late final GeneratedColumn<String> repCpfDigits = GeneratedColumn<String>(
    'rep_cpf_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repRoleMeta = const VerificationMeta(
    'repRole',
  );
  @override
  late final GeneratedColumn<String> repRole = GeneratedColumn<String>(
    'rep_role',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payPixKeyTypeMeta = const VerificationMeta(
    'payPixKeyType',
  );
  @override
  late final GeneratedColumn<String> payPixKeyType = GeneratedColumn<String>(
    'pay_pix_key_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payPixKeyMeta = const VerificationMeta(
    'payPixKey',
  );
  @override
  late final GeneratedColumn<String> payPixKey = GeneratedColumn<String>(
    'pay_pix_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payBeneficiaryNameMeta =
      const VerificationMeta('payBeneficiaryName');
  @override
  late final GeneratedColumn<String> payBeneficiaryName =
      GeneratedColumn<String>(
        'pay_beneficiary_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _payPaymentTermsMeta = const VerificationMeta(
    'payPaymentTerms',
  );
  @override
  late final GeneratedColumn<String> payPaymentTerms = GeneratedColumn<String>(
    'pay_payment_terms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    quoteId,
    captureStatus,
    capturedAt,
    logoReference,
    identTradeName,
    identLegalName,
    identCnpjDigits,
    identStateRegistration,
    contactPhoneDigits,
    contactWhatsappDigits,
    contactEmail,
    contactInstagram,
    contactWebsite,
    addrPostalCode,
    addrStreet,
    addrNumber,
    addrComplement,
    addrNeighborhood,
    addrCity,
    addrState,
    repFullName,
    repCpfDigits,
    repRole,
    payPixKeyType,
    payPixKey,
    payBeneficiaryName,
    payPaymentTerms,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote_company_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyQuoteCompanySnapshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('capture_status')) {
      context.handle(
        _captureStatusMeta,
        captureStatus.isAcceptableOrUnknown(
          data['capture_status']!,
          _captureStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_captureStatusMeta);
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('logo_reference')) {
      context.handle(
        _logoReferenceMeta,
        logoReference.isAcceptableOrUnknown(
          data['logo_reference']!,
          _logoReferenceMeta,
        ),
      );
    }
    if (data.containsKey('ident_trade_name')) {
      context.handle(
        _identTradeNameMeta,
        identTradeName.isAcceptableOrUnknown(
          data['ident_trade_name']!,
          _identTradeNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_identTradeNameMeta);
    }
    if (data.containsKey('ident_legal_name')) {
      context.handle(
        _identLegalNameMeta,
        identLegalName.isAcceptableOrUnknown(
          data['ident_legal_name']!,
          _identLegalNameMeta,
        ),
      );
    }
    if (data.containsKey('ident_cnpj_digits')) {
      context.handle(
        _identCnpjDigitsMeta,
        identCnpjDigits.isAcceptableOrUnknown(
          data['ident_cnpj_digits']!,
          _identCnpjDigitsMeta,
        ),
      );
    }
    if (data.containsKey('ident_state_registration')) {
      context.handle(
        _identStateRegistrationMeta,
        identStateRegistration.isAcceptableOrUnknown(
          data['ident_state_registration']!,
          _identStateRegistrationMeta,
        ),
      );
    }
    if (data.containsKey('contact_phone_digits')) {
      context.handle(
        _contactPhoneDigitsMeta,
        contactPhoneDigits.isAcceptableOrUnknown(
          data['contact_phone_digits']!,
          _contactPhoneDigitsMeta,
        ),
      );
    }
    if (data.containsKey('contact_whatsapp_digits')) {
      context.handle(
        _contactWhatsappDigitsMeta,
        contactWhatsappDigits.isAcceptableOrUnknown(
          data['contact_whatsapp_digits']!,
          _contactWhatsappDigitsMeta,
        ),
      );
    }
    if (data.containsKey('contact_email')) {
      context.handle(
        _contactEmailMeta,
        contactEmail.isAcceptableOrUnknown(
          data['contact_email']!,
          _contactEmailMeta,
        ),
      );
    }
    if (data.containsKey('contact_instagram')) {
      context.handle(
        _contactInstagramMeta,
        contactInstagram.isAcceptableOrUnknown(
          data['contact_instagram']!,
          _contactInstagramMeta,
        ),
      );
    }
    if (data.containsKey('contact_website')) {
      context.handle(
        _contactWebsiteMeta,
        contactWebsite.isAcceptableOrUnknown(
          data['contact_website']!,
          _contactWebsiteMeta,
        ),
      );
    }
    if (data.containsKey('addr_postal_code')) {
      context.handle(
        _addrPostalCodeMeta,
        addrPostalCode.isAcceptableOrUnknown(
          data['addr_postal_code']!,
          _addrPostalCodeMeta,
        ),
      );
    }
    if (data.containsKey('addr_street')) {
      context.handle(
        _addrStreetMeta,
        addrStreet.isAcceptableOrUnknown(data['addr_street']!, _addrStreetMeta),
      );
    }
    if (data.containsKey('addr_number')) {
      context.handle(
        _addrNumberMeta,
        addrNumber.isAcceptableOrUnknown(data['addr_number']!, _addrNumberMeta),
      );
    }
    if (data.containsKey('addr_complement')) {
      context.handle(
        _addrComplementMeta,
        addrComplement.isAcceptableOrUnknown(
          data['addr_complement']!,
          _addrComplementMeta,
        ),
      );
    }
    if (data.containsKey('addr_neighborhood')) {
      context.handle(
        _addrNeighborhoodMeta,
        addrNeighborhood.isAcceptableOrUnknown(
          data['addr_neighborhood']!,
          _addrNeighborhoodMeta,
        ),
      );
    }
    if (data.containsKey('addr_city')) {
      context.handle(
        _addrCityMeta,
        addrCity.isAcceptableOrUnknown(data['addr_city']!, _addrCityMeta),
      );
    }
    if (data.containsKey('addr_state')) {
      context.handle(
        _addrStateMeta,
        addrState.isAcceptableOrUnknown(data['addr_state']!, _addrStateMeta),
      );
    }
    if (data.containsKey('rep_full_name')) {
      context.handle(
        _repFullNameMeta,
        repFullName.isAcceptableOrUnknown(
          data['rep_full_name']!,
          _repFullNameMeta,
        ),
      );
    }
    if (data.containsKey('rep_cpf_digits')) {
      context.handle(
        _repCpfDigitsMeta,
        repCpfDigits.isAcceptableOrUnknown(
          data['rep_cpf_digits']!,
          _repCpfDigitsMeta,
        ),
      );
    }
    if (data.containsKey('rep_role')) {
      context.handle(
        _repRoleMeta,
        repRole.isAcceptableOrUnknown(data['rep_role']!, _repRoleMeta),
      );
    }
    if (data.containsKey('pay_pix_key_type')) {
      context.handle(
        _payPixKeyTypeMeta,
        payPixKeyType.isAcceptableOrUnknown(
          data['pay_pix_key_type']!,
          _payPixKeyTypeMeta,
        ),
      );
    }
    if (data.containsKey('pay_pix_key')) {
      context.handle(
        _payPixKeyMeta,
        payPixKey.isAcceptableOrUnknown(data['pay_pix_key']!, _payPixKeyMeta),
      );
    }
    if (data.containsKey('pay_beneficiary_name')) {
      context.handle(
        _payBeneficiaryNameMeta,
        payBeneficiaryName.isAcceptableOrUnknown(
          data['pay_beneficiary_name']!,
          _payBeneficiaryNameMeta,
        ),
      );
    }
    if (data.containsKey('pay_payment_terms')) {
      context.handle(
        _payPaymentTermsMeta,
        payPaymentTerms.isAcceptableOrUnknown(
          data['pay_payment_terms']!,
          _payPaymentTermsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {quoteId};
  @override
  LegacyQuoteCompanySnapshotRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyQuoteCompanySnapshotRow(
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      captureStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}capture_status'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}captured_at'],
      )!,
      logoReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_reference'],
      ),
      identTradeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ident_trade_name'],
      )!,
      identLegalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ident_legal_name'],
      ),
      identCnpjDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ident_cnpj_digits'],
      ),
      identStateRegistration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ident_state_registration'],
      ),
      contactPhoneDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_phone_digits'],
      ),
      contactWhatsappDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_whatsapp_digits'],
      ),
      contactEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_email'],
      ),
      contactInstagram: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_instagram'],
      ),
      contactWebsite: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_website'],
      ),
      addrPostalCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}addr_postal_code'],
      ),
      addrStreet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}addr_street'],
      ),
      addrNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}addr_number'],
      ),
      addrComplement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}addr_complement'],
      ),
      addrNeighborhood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}addr_neighborhood'],
      ),
      addrCity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}addr_city'],
      ),
      addrState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}addr_state'],
      ),
      repFullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rep_full_name'],
      ),
      repCpfDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rep_cpf_digits'],
      ),
      repRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rep_role'],
      ),
      payPixKeyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pay_pix_key_type'],
      ),
      payPixKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pay_pix_key'],
      ),
      payBeneficiaryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pay_beneficiary_name'],
      ),
      payPaymentTerms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pay_payment_terms'],
      ),
    );
  }

  @override
  $LegacyQuoteCompanySnapshotsTable createAlias(String alias) {
    return $LegacyQuoteCompanySnapshotsTable(attachedDatabase, alias);
  }
}

class LegacyQuoteCompanySnapshotRow extends DataClass
    implements Insertable<LegacyQuoteCompanySnapshotRow> {
  final String quoteId;
  final String captureStatus;
  final int capturedAt;
  final String? logoReference;
  final String identTradeName;
  final String? identLegalName;
  final String? identCnpjDigits;
  final String? identStateRegistration;
  final String? contactPhoneDigits;
  final String? contactWhatsappDigits;
  final String? contactEmail;
  final String? contactInstagram;
  final String? contactWebsite;
  final String? addrPostalCode;
  final String? addrStreet;
  final String? addrNumber;
  final String? addrComplement;
  final String? addrNeighborhood;
  final String? addrCity;
  final String? addrState;
  final String? repFullName;
  final String? repCpfDigits;
  final String? repRole;
  final String? payPixKeyType;
  final String? payPixKey;
  final String? payBeneficiaryName;
  final String? payPaymentTerms;
  const LegacyQuoteCompanySnapshotRow({
    required this.quoteId,
    required this.captureStatus,
    required this.capturedAt,
    this.logoReference,
    required this.identTradeName,
    this.identLegalName,
    this.identCnpjDigits,
    this.identStateRegistration,
    this.contactPhoneDigits,
    this.contactWhatsappDigits,
    this.contactEmail,
    this.contactInstagram,
    this.contactWebsite,
    this.addrPostalCode,
    this.addrStreet,
    this.addrNumber,
    this.addrComplement,
    this.addrNeighborhood,
    this.addrCity,
    this.addrState,
    this.repFullName,
    this.repCpfDigits,
    this.repRole,
    this.payPixKeyType,
    this.payPixKey,
    this.payBeneficiaryName,
    this.payPaymentTerms,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['quote_id'] = Variable<String>(quoteId);
    map['capture_status'] = Variable<String>(captureStatus);
    map['captured_at'] = Variable<int>(capturedAt);
    if (!nullToAbsent || logoReference != null) {
      map['logo_reference'] = Variable<String>(logoReference);
    }
    map['ident_trade_name'] = Variable<String>(identTradeName);
    if (!nullToAbsent || identLegalName != null) {
      map['ident_legal_name'] = Variable<String>(identLegalName);
    }
    if (!nullToAbsent || identCnpjDigits != null) {
      map['ident_cnpj_digits'] = Variable<String>(identCnpjDigits);
    }
    if (!nullToAbsent || identStateRegistration != null) {
      map['ident_state_registration'] = Variable<String>(
        identStateRegistration,
      );
    }
    if (!nullToAbsent || contactPhoneDigits != null) {
      map['contact_phone_digits'] = Variable<String>(contactPhoneDigits);
    }
    if (!nullToAbsent || contactWhatsappDigits != null) {
      map['contact_whatsapp_digits'] = Variable<String>(contactWhatsappDigits);
    }
    if (!nullToAbsent || contactEmail != null) {
      map['contact_email'] = Variable<String>(contactEmail);
    }
    if (!nullToAbsent || contactInstagram != null) {
      map['contact_instagram'] = Variable<String>(contactInstagram);
    }
    if (!nullToAbsent || contactWebsite != null) {
      map['contact_website'] = Variable<String>(contactWebsite);
    }
    if (!nullToAbsent || addrPostalCode != null) {
      map['addr_postal_code'] = Variable<String>(addrPostalCode);
    }
    if (!nullToAbsent || addrStreet != null) {
      map['addr_street'] = Variable<String>(addrStreet);
    }
    if (!nullToAbsent || addrNumber != null) {
      map['addr_number'] = Variable<String>(addrNumber);
    }
    if (!nullToAbsent || addrComplement != null) {
      map['addr_complement'] = Variable<String>(addrComplement);
    }
    if (!nullToAbsent || addrNeighborhood != null) {
      map['addr_neighborhood'] = Variable<String>(addrNeighborhood);
    }
    if (!nullToAbsent || addrCity != null) {
      map['addr_city'] = Variable<String>(addrCity);
    }
    if (!nullToAbsent || addrState != null) {
      map['addr_state'] = Variable<String>(addrState);
    }
    if (!nullToAbsent || repFullName != null) {
      map['rep_full_name'] = Variable<String>(repFullName);
    }
    if (!nullToAbsent || repCpfDigits != null) {
      map['rep_cpf_digits'] = Variable<String>(repCpfDigits);
    }
    if (!nullToAbsent || repRole != null) {
      map['rep_role'] = Variable<String>(repRole);
    }
    if (!nullToAbsent || payPixKeyType != null) {
      map['pay_pix_key_type'] = Variable<String>(payPixKeyType);
    }
    if (!nullToAbsent || payPixKey != null) {
      map['pay_pix_key'] = Variable<String>(payPixKey);
    }
    if (!nullToAbsent || payBeneficiaryName != null) {
      map['pay_beneficiary_name'] = Variable<String>(payBeneficiaryName);
    }
    if (!nullToAbsent || payPaymentTerms != null) {
      map['pay_payment_terms'] = Variable<String>(payPaymentTerms);
    }
    return map;
  }

  LegacyQuoteCompanySnapshotsCompanion toCompanion(bool nullToAbsent) {
    return LegacyQuoteCompanySnapshotsCompanion(
      quoteId: Value(quoteId),
      captureStatus: Value(captureStatus),
      capturedAt: Value(capturedAt),
      logoReference: logoReference == null && nullToAbsent
          ? const Value.absent()
          : Value(logoReference),
      identTradeName: Value(identTradeName),
      identLegalName: identLegalName == null && nullToAbsent
          ? const Value.absent()
          : Value(identLegalName),
      identCnpjDigits: identCnpjDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(identCnpjDigits),
      identStateRegistration: identStateRegistration == null && nullToAbsent
          ? const Value.absent()
          : Value(identStateRegistration),
      contactPhoneDigits: contactPhoneDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPhoneDigits),
      contactWhatsappDigits: contactWhatsappDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(contactWhatsappDigits),
      contactEmail: contactEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(contactEmail),
      contactInstagram: contactInstagram == null && nullToAbsent
          ? const Value.absent()
          : Value(contactInstagram),
      contactWebsite: contactWebsite == null && nullToAbsent
          ? const Value.absent()
          : Value(contactWebsite),
      addrPostalCode: addrPostalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(addrPostalCode),
      addrStreet: addrStreet == null && nullToAbsent
          ? const Value.absent()
          : Value(addrStreet),
      addrNumber: addrNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(addrNumber),
      addrComplement: addrComplement == null && nullToAbsent
          ? const Value.absent()
          : Value(addrComplement),
      addrNeighborhood: addrNeighborhood == null && nullToAbsent
          ? const Value.absent()
          : Value(addrNeighborhood),
      addrCity: addrCity == null && nullToAbsent
          ? const Value.absent()
          : Value(addrCity),
      addrState: addrState == null && nullToAbsent
          ? const Value.absent()
          : Value(addrState),
      repFullName: repFullName == null && nullToAbsent
          ? const Value.absent()
          : Value(repFullName),
      repCpfDigits: repCpfDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(repCpfDigits),
      repRole: repRole == null && nullToAbsent
          ? const Value.absent()
          : Value(repRole),
      payPixKeyType: payPixKeyType == null && nullToAbsent
          ? const Value.absent()
          : Value(payPixKeyType),
      payPixKey: payPixKey == null && nullToAbsent
          ? const Value.absent()
          : Value(payPixKey),
      payBeneficiaryName: payBeneficiaryName == null && nullToAbsent
          ? const Value.absent()
          : Value(payBeneficiaryName),
      payPaymentTerms: payPaymentTerms == null && nullToAbsent
          ? const Value.absent()
          : Value(payPaymentTerms),
    );
  }

  factory LegacyQuoteCompanySnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyQuoteCompanySnapshotRow(
      quoteId: serializer.fromJson<String>(json['quoteId']),
      captureStatus: serializer.fromJson<String>(json['captureStatus']),
      capturedAt: serializer.fromJson<int>(json['capturedAt']),
      logoReference: serializer.fromJson<String?>(json['logoReference']),
      identTradeName: serializer.fromJson<String>(json['identTradeName']),
      identLegalName: serializer.fromJson<String?>(json['identLegalName']),
      identCnpjDigits: serializer.fromJson<String?>(json['identCnpjDigits']),
      identStateRegistration: serializer.fromJson<String?>(
        json['identStateRegistration'],
      ),
      contactPhoneDigits: serializer.fromJson<String?>(
        json['contactPhoneDigits'],
      ),
      contactWhatsappDigits: serializer.fromJson<String?>(
        json['contactWhatsappDigits'],
      ),
      contactEmail: serializer.fromJson<String?>(json['contactEmail']),
      contactInstagram: serializer.fromJson<String?>(json['contactInstagram']),
      contactWebsite: serializer.fromJson<String?>(json['contactWebsite']),
      addrPostalCode: serializer.fromJson<String?>(json['addrPostalCode']),
      addrStreet: serializer.fromJson<String?>(json['addrStreet']),
      addrNumber: serializer.fromJson<String?>(json['addrNumber']),
      addrComplement: serializer.fromJson<String?>(json['addrComplement']),
      addrNeighborhood: serializer.fromJson<String?>(json['addrNeighborhood']),
      addrCity: serializer.fromJson<String?>(json['addrCity']),
      addrState: serializer.fromJson<String?>(json['addrState']),
      repFullName: serializer.fromJson<String?>(json['repFullName']),
      repCpfDigits: serializer.fromJson<String?>(json['repCpfDigits']),
      repRole: serializer.fromJson<String?>(json['repRole']),
      payPixKeyType: serializer.fromJson<String?>(json['payPixKeyType']),
      payPixKey: serializer.fromJson<String?>(json['payPixKey']),
      payBeneficiaryName: serializer.fromJson<String?>(
        json['payBeneficiaryName'],
      ),
      payPaymentTerms: serializer.fromJson<String?>(json['payPaymentTerms']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'quoteId': serializer.toJson<String>(quoteId),
      'captureStatus': serializer.toJson<String>(captureStatus),
      'capturedAt': serializer.toJson<int>(capturedAt),
      'logoReference': serializer.toJson<String?>(logoReference),
      'identTradeName': serializer.toJson<String>(identTradeName),
      'identLegalName': serializer.toJson<String?>(identLegalName),
      'identCnpjDigits': serializer.toJson<String?>(identCnpjDigits),
      'identStateRegistration': serializer.toJson<String?>(
        identStateRegistration,
      ),
      'contactPhoneDigits': serializer.toJson<String?>(contactPhoneDigits),
      'contactWhatsappDigits': serializer.toJson<String?>(
        contactWhatsappDigits,
      ),
      'contactEmail': serializer.toJson<String?>(contactEmail),
      'contactInstagram': serializer.toJson<String?>(contactInstagram),
      'contactWebsite': serializer.toJson<String?>(contactWebsite),
      'addrPostalCode': serializer.toJson<String?>(addrPostalCode),
      'addrStreet': serializer.toJson<String?>(addrStreet),
      'addrNumber': serializer.toJson<String?>(addrNumber),
      'addrComplement': serializer.toJson<String?>(addrComplement),
      'addrNeighborhood': serializer.toJson<String?>(addrNeighborhood),
      'addrCity': serializer.toJson<String?>(addrCity),
      'addrState': serializer.toJson<String?>(addrState),
      'repFullName': serializer.toJson<String?>(repFullName),
      'repCpfDigits': serializer.toJson<String?>(repCpfDigits),
      'repRole': serializer.toJson<String?>(repRole),
      'payPixKeyType': serializer.toJson<String?>(payPixKeyType),
      'payPixKey': serializer.toJson<String?>(payPixKey),
      'payBeneficiaryName': serializer.toJson<String?>(payBeneficiaryName),
      'payPaymentTerms': serializer.toJson<String?>(payPaymentTerms),
    };
  }

  LegacyQuoteCompanySnapshotRow copyWith({
    String? quoteId,
    String? captureStatus,
    int? capturedAt,
    Value<String?> logoReference = const Value.absent(),
    String? identTradeName,
    Value<String?> identLegalName = const Value.absent(),
    Value<String?> identCnpjDigits = const Value.absent(),
    Value<String?> identStateRegistration = const Value.absent(),
    Value<String?> contactPhoneDigits = const Value.absent(),
    Value<String?> contactWhatsappDigits = const Value.absent(),
    Value<String?> contactEmail = const Value.absent(),
    Value<String?> contactInstagram = const Value.absent(),
    Value<String?> contactWebsite = const Value.absent(),
    Value<String?> addrPostalCode = const Value.absent(),
    Value<String?> addrStreet = const Value.absent(),
    Value<String?> addrNumber = const Value.absent(),
    Value<String?> addrComplement = const Value.absent(),
    Value<String?> addrNeighborhood = const Value.absent(),
    Value<String?> addrCity = const Value.absent(),
    Value<String?> addrState = const Value.absent(),
    Value<String?> repFullName = const Value.absent(),
    Value<String?> repCpfDigits = const Value.absent(),
    Value<String?> repRole = const Value.absent(),
    Value<String?> payPixKeyType = const Value.absent(),
    Value<String?> payPixKey = const Value.absent(),
    Value<String?> payBeneficiaryName = const Value.absent(),
    Value<String?> payPaymentTerms = const Value.absent(),
  }) => LegacyQuoteCompanySnapshotRow(
    quoteId: quoteId ?? this.quoteId,
    captureStatus: captureStatus ?? this.captureStatus,
    capturedAt: capturedAt ?? this.capturedAt,
    logoReference: logoReference.present
        ? logoReference.value
        : this.logoReference,
    identTradeName: identTradeName ?? this.identTradeName,
    identLegalName: identLegalName.present
        ? identLegalName.value
        : this.identLegalName,
    identCnpjDigits: identCnpjDigits.present
        ? identCnpjDigits.value
        : this.identCnpjDigits,
    identStateRegistration: identStateRegistration.present
        ? identStateRegistration.value
        : this.identStateRegistration,
    contactPhoneDigits: contactPhoneDigits.present
        ? contactPhoneDigits.value
        : this.contactPhoneDigits,
    contactWhatsappDigits: contactWhatsappDigits.present
        ? contactWhatsappDigits.value
        : this.contactWhatsappDigits,
    contactEmail: contactEmail.present ? contactEmail.value : this.contactEmail,
    contactInstagram: contactInstagram.present
        ? contactInstagram.value
        : this.contactInstagram,
    contactWebsite: contactWebsite.present
        ? contactWebsite.value
        : this.contactWebsite,
    addrPostalCode: addrPostalCode.present
        ? addrPostalCode.value
        : this.addrPostalCode,
    addrStreet: addrStreet.present ? addrStreet.value : this.addrStreet,
    addrNumber: addrNumber.present ? addrNumber.value : this.addrNumber,
    addrComplement: addrComplement.present
        ? addrComplement.value
        : this.addrComplement,
    addrNeighborhood: addrNeighborhood.present
        ? addrNeighborhood.value
        : this.addrNeighborhood,
    addrCity: addrCity.present ? addrCity.value : this.addrCity,
    addrState: addrState.present ? addrState.value : this.addrState,
    repFullName: repFullName.present ? repFullName.value : this.repFullName,
    repCpfDigits: repCpfDigits.present ? repCpfDigits.value : this.repCpfDigits,
    repRole: repRole.present ? repRole.value : this.repRole,
    payPixKeyType: payPixKeyType.present
        ? payPixKeyType.value
        : this.payPixKeyType,
    payPixKey: payPixKey.present ? payPixKey.value : this.payPixKey,
    payBeneficiaryName: payBeneficiaryName.present
        ? payBeneficiaryName.value
        : this.payBeneficiaryName,
    payPaymentTerms: payPaymentTerms.present
        ? payPaymentTerms.value
        : this.payPaymentTerms,
  );
  LegacyQuoteCompanySnapshotRow copyWithCompanion(
    LegacyQuoteCompanySnapshotsCompanion data,
  ) {
    return LegacyQuoteCompanySnapshotRow(
      quoteId: data.quoteId.present ? data.quoteId.value : this.quoteId,
      captureStatus: data.captureStatus.present
          ? data.captureStatus.value
          : this.captureStatus,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      logoReference: data.logoReference.present
          ? data.logoReference.value
          : this.logoReference,
      identTradeName: data.identTradeName.present
          ? data.identTradeName.value
          : this.identTradeName,
      identLegalName: data.identLegalName.present
          ? data.identLegalName.value
          : this.identLegalName,
      identCnpjDigits: data.identCnpjDigits.present
          ? data.identCnpjDigits.value
          : this.identCnpjDigits,
      identStateRegistration: data.identStateRegistration.present
          ? data.identStateRegistration.value
          : this.identStateRegistration,
      contactPhoneDigits: data.contactPhoneDigits.present
          ? data.contactPhoneDigits.value
          : this.contactPhoneDigits,
      contactWhatsappDigits: data.contactWhatsappDigits.present
          ? data.contactWhatsappDigits.value
          : this.contactWhatsappDigits,
      contactEmail: data.contactEmail.present
          ? data.contactEmail.value
          : this.contactEmail,
      contactInstagram: data.contactInstagram.present
          ? data.contactInstagram.value
          : this.contactInstagram,
      contactWebsite: data.contactWebsite.present
          ? data.contactWebsite.value
          : this.contactWebsite,
      addrPostalCode: data.addrPostalCode.present
          ? data.addrPostalCode.value
          : this.addrPostalCode,
      addrStreet: data.addrStreet.present
          ? data.addrStreet.value
          : this.addrStreet,
      addrNumber: data.addrNumber.present
          ? data.addrNumber.value
          : this.addrNumber,
      addrComplement: data.addrComplement.present
          ? data.addrComplement.value
          : this.addrComplement,
      addrNeighborhood: data.addrNeighborhood.present
          ? data.addrNeighborhood.value
          : this.addrNeighborhood,
      addrCity: data.addrCity.present ? data.addrCity.value : this.addrCity,
      addrState: data.addrState.present ? data.addrState.value : this.addrState,
      repFullName: data.repFullName.present
          ? data.repFullName.value
          : this.repFullName,
      repCpfDigits: data.repCpfDigits.present
          ? data.repCpfDigits.value
          : this.repCpfDigits,
      repRole: data.repRole.present ? data.repRole.value : this.repRole,
      payPixKeyType: data.payPixKeyType.present
          ? data.payPixKeyType.value
          : this.payPixKeyType,
      payPixKey: data.payPixKey.present ? data.payPixKey.value : this.payPixKey,
      payBeneficiaryName: data.payBeneficiaryName.present
          ? data.payBeneficiaryName.value
          : this.payBeneficiaryName,
      payPaymentTerms: data.payPaymentTerms.present
          ? data.payPaymentTerms.value
          : this.payPaymentTerms,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteCompanySnapshotRow(')
          ..write('quoteId: $quoteId, ')
          ..write('captureStatus: $captureStatus, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('logoReference: $logoReference, ')
          ..write('identTradeName: $identTradeName, ')
          ..write('identLegalName: $identLegalName, ')
          ..write('identCnpjDigits: $identCnpjDigits, ')
          ..write('identStateRegistration: $identStateRegistration, ')
          ..write('contactPhoneDigits: $contactPhoneDigits, ')
          ..write('contactWhatsappDigits: $contactWhatsappDigits, ')
          ..write('contactEmail: $contactEmail, ')
          ..write('contactInstagram: $contactInstagram, ')
          ..write('contactWebsite: $contactWebsite, ')
          ..write('addrPostalCode: $addrPostalCode, ')
          ..write('addrStreet: $addrStreet, ')
          ..write('addrNumber: $addrNumber, ')
          ..write('addrComplement: $addrComplement, ')
          ..write('addrNeighborhood: $addrNeighborhood, ')
          ..write('addrCity: $addrCity, ')
          ..write('addrState: $addrState, ')
          ..write('repFullName: $repFullName, ')
          ..write('repCpfDigits: $repCpfDigits, ')
          ..write('repRole: $repRole, ')
          ..write('payPixKeyType: $payPixKeyType, ')
          ..write('payPixKey: $payPixKey, ')
          ..write('payBeneficiaryName: $payBeneficiaryName, ')
          ..write('payPaymentTerms: $payPaymentTerms')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    quoteId,
    captureStatus,
    capturedAt,
    logoReference,
    identTradeName,
    identLegalName,
    identCnpjDigits,
    identStateRegistration,
    contactPhoneDigits,
    contactWhatsappDigits,
    contactEmail,
    contactInstagram,
    contactWebsite,
    addrPostalCode,
    addrStreet,
    addrNumber,
    addrComplement,
    addrNeighborhood,
    addrCity,
    addrState,
    repFullName,
    repCpfDigits,
    repRole,
    payPixKeyType,
    payPixKey,
    payBeneficiaryName,
    payPaymentTerms,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyQuoteCompanySnapshotRow &&
          other.quoteId == this.quoteId &&
          other.captureStatus == this.captureStatus &&
          other.capturedAt == this.capturedAt &&
          other.logoReference == this.logoReference &&
          other.identTradeName == this.identTradeName &&
          other.identLegalName == this.identLegalName &&
          other.identCnpjDigits == this.identCnpjDigits &&
          other.identStateRegistration == this.identStateRegistration &&
          other.contactPhoneDigits == this.contactPhoneDigits &&
          other.contactWhatsappDigits == this.contactWhatsappDigits &&
          other.contactEmail == this.contactEmail &&
          other.contactInstagram == this.contactInstagram &&
          other.contactWebsite == this.contactWebsite &&
          other.addrPostalCode == this.addrPostalCode &&
          other.addrStreet == this.addrStreet &&
          other.addrNumber == this.addrNumber &&
          other.addrComplement == this.addrComplement &&
          other.addrNeighborhood == this.addrNeighborhood &&
          other.addrCity == this.addrCity &&
          other.addrState == this.addrState &&
          other.repFullName == this.repFullName &&
          other.repCpfDigits == this.repCpfDigits &&
          other.repRole == this.repRole &&
          other.payPixKeyType == this.payPixKeyType &&
          other.payPixKey == this.payPixKey &&
          other.payBeneficiaryName == this.payBeneficiaryName &&
          other.payPaymentTerms == this.payPaymentTerms);
}

class LegacyQuoteCompanySnapshotsCompanion
    extends UpdateCompanion<LegacyQuoteCompanySnapshotRow> {
  final Value<String> quoteId;
  final Value<String> captureStatus;
  final Value<int> capturedAt;
  final Value<String?> logoReference;
  final Value<String> identTradeName;
  final Value<String?> identLegalName;
  final Value<String?> identCnpjDigits;
  final Value<String?> identStateRegistration;
  final Value<String?> contactPhoneDigits;
  final Value<String?> contactWhatsappDigits;
  final Value<String?> contactEmail;
  final Value<String?> contactInstagram;
  final Value<String?> contactWebsite;
  final Value<String?> addrPostalCode;
  final Value<String?> addrStreet;
  final Value<String?> addrNumber;
  final Value<String?> addrComplement;
  final Value<String?> addrNeighborhood;
  final Value<String?> addrCity;
  final Value<String?> addrState;
  final Value<String?> repFullName;
  final Value<String?> repCpfDigits;
  final Value<String?> repRole;
  final Value<String?> payPixKeyType;
  final Value<String?> payPixKey;
  final Value<String?> payBeneficiaryName;
  final Value<String?> payPaymentTerms;
  final Value<int> rowid;
  const LegacyQuoteCompanySnapshotsCompanion({
    this.quoteId = const Value.absent(),
    this.captureStatus = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.logoReference = const Value.absent(),
    this.identTradeName = const Value.absent(),
    this.identLegalName = const Value.absent(),
    this.identCnpjDigits = const Value.absent(),
    this.identStateRegistration = const Value.absent(),
    this.contactPhoneDigits = const Value.absent(),
    this.contactWhatsappDigits = const Value.absent(),
    this.contactEmail = const Value.absent(),
    this.contactInstagram = const Value.absent(),
    this.contactWebsite = const Value.absent(),
    this.addrPostalCode = const Value.absent(),
    this.addrStreet = const Value.absent(),
    this.addrNumber = const Value.absent(),
    this.addrComplement = const Value.absent(),
    this.addrNeighborhood = const Value.absent(),
    this.addrCity = const Value.absent(),
    this.addrState = const Value.absent(),
    this.repFullName = const Value.absent(),
    this.repCpfDigits = const Value.absent(),
    this.repRole = const Value.absent(),
    this.payPixKeyType = const Value.absent(),
    this.payPixKey = const Value.absent(),
    this.payBeneficiaryName = const Value.absent(),
    this.payPaymentTerms = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyQuoteCompanySnapshotsCompanion.insert({
    required String quoteId,
    required String captureStatus,
    required int capturedAt,
    this.logoReference = const Value.absent(),
    required String identTradeName,
    this.identLegalName = const Value.absent(),
    this.identCnpjDigits = const Value.absent(),
    this.identStateRegistration = const Value.absent(),
    this.contactPhoneDigits = const Value.absent(),
    this.contactWhatsappDigits = const Value.absent(),
    this.contactEmail = const Value.absent(),
    this.contactInstagram = const Value.absent(),
    this.contactWebsite = const Value.absent(),
    this.addrPostalCode = const Value.absent(),
    this.addrStreet = const Value.absent(),
    this.addrNumber = const Value.absent(),
    this.addrComplement = const Value.absent(),
    this.addrNeighborhood = const Value.absent(),
    this.addrCity = const Value.absent(),
    this.addrState = const Value.absent(),
    this.repFullName = const Value.absent(),
    this.repCpfDigits = const Value.absent(),
    this.repRole = const Value.absent(),
    this.payPixKeyType = const Value.absent(),
    this.payPixKey = const Value.absent(),
    this.payBeneficiaryName = const Value.absent(),
    this.payPaymentTerms = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : quoteId = Value(quoteId),
       captureStatus = Value(captureStatus),
       capturedAt = Value(capturedAt),
       identTradeName = Value(identTradeName);
  static Insertable<LegacyQuoteCompanySnapshotRow> custom({
    Expression<String>? quoteId,
    Expression<String>? captureStatus,
    Expression<int>? capturedAt,
    Expression<String>? logoReference,
    Expression<String>? identTradeName,
    Expression<String>? identLegalName,
    Expression<String>? identCnpjDigits,
    Expression<String>? identStateRegistration,
    Expression<String>? contactPhoneDigits,
    Expression<String>? contactWhatsappDigits,
    Expression<String>? contactEmail,
    Expression<String>? contactInstagram,
    Expression<String>? contactWebsite,
    Expression<String>? addrPostalCode,
    Expression<String>? addrStreet,
    Expression<String>? addrNumber,
    Expression<String>? addrComplement,
    Expression<String>? addrNeighborhood,
    Expression<String>? addrCity,
    Expression<String>? addrState,
    Expression<String>? repFullName,
    Expression<String>? repCpfDigits,
    Expression<String>? repRole,
    Expression<String>? payPixKeyType,
    Expression<String>? payPixKey,
    Expression<String>? payBeneficiaryName,
    Expression<String>? payPaymentTerms,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (quoteId != null) 'quote_id': quoteId,
      if (captureStatus != null) 'capture_status': captureStatus,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (logoReference != null) 'logo_reference': logoReference,
      if (identTradeName != null) 'ident_trade_name': identTradeName,
      if (identLegalName != null) 'ident_legal_name': identLegalName,
      if (identCnpjDigits != null) 'ident_cnpj_digits': identCnpjDigits,
      if (identStateRegistration != null)
        'ident_state_registration': identStateRegistration,
      if (contactPhoneDigits != null)
        'contact_phone_digits': contactPhoneDigits,
      if (contactWhatsappDigits != null)
        'contact_whatsapp_digits': contactWhatsappDigits,
      if (contactEmail != null) 'contact_email': contactEmail,
      if (contactInstagram != null) 'contact_instagram': contactInstagram,
      if (contactWebsite != null) 'contact_website': contactWebsite,
      if (addrPostalCode != null) 'addr_postal_code': addrPostalCode,
      if (addrStreet != null) 'addr_street': addrStreet,
      if (addrNumber != null) 'addr_number': addrNumber,
      if (addrComplement != null) 'addr_complement': addrComplement,
      if (addrNeighborhood != null) 'addr_neighborhood': addrNeighborhood,
      if (addrCity != null) 'addr_city': addrCity,
      if (addrState != null) 'addr_state': addrState,
      if (repFullName != null) 'rep_full_name': repFullName,
      if (repCpfDigits != null) 'rep_cpf_digits': repCpfDigits,
      if (repRole != null) 'rep_role': repRole,
      if (payPixKeyType != null) 'pay_pix_key_type': payPixKeyType,
      if (payPixKey != null) 'pay_pix_key': payPixKey,
      if (payBeneficiaryName != null)
        'pay_beneficiary_name': payBeneficiaryName,
      if (payPaymentTerms != null) 'pay_payment_terms': payPaymentTerms,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyQuoteCompanySnapshotsCompanion copyWith({
    Value<String>? quoteId,
    Value<String>? captureStatus,
    Value<int>? capturedAt,
    Value<String?>? logoReference,
    Value<String>? identTradeName,
    Value<String?>? identLegalName,
    Value<String?>? identCnpjDigits,
    Value<String?>? identStateRegistration,
    Value<String?>? contactPhoneDigits,
    Value<String?>? contactWhatsappDigits,
    Value<String?>? contactEmail,
    Value<String?>? contactInstagram,
    Value<String?>? contactWebsite,
    Value<String?>? addrPostalCode,
    Value<String?>? addrStreet,
    Value<String?>? addrNumber,
    Value<String?>? addrComplement,
    Value<String?>? addrNeighborhood,
    Value<String?>? addrCity,
    Value<String?>? addrState,
    Value<String?>? repFullName,
    Value<String?>? repCpfDigits,
    Value<String?>? repRole,
    Value<String?>? payPixKeyType,
    Value<String?>? payPixKey,
    Value<String?>? payBeneficiaryName,
    Value<String?>? payPaymentTerms,
    Value<int>? rowid,
  }) {
    return LegacyQuoteCompanySnapshotsCompanion(
      quoteId: quoteId ?? this.quoteId,
      captureStatus: captureStatus ?? this.captureStatus,
      capturedAt: capturedAt ?? this.capturedAt,
      logoReference: logoReference ?? this.logoReference,
      identTradeName: identTradeName ?? this.identTradeName,
      identLegalName: identLegalName ?? this.identLegalName,
      identCnpjDigits: identCnpjDigits ?? this.identCnpjDigits,
      identStateRegistration:
          identStateRegistration ?? this.identStateRegistration,
      contactPhoneDigits: contactPhoneDigits ?? this.contactPhoneDigits,
      contactWhatsappDigits:
          contactWhatsappDigits ?? this.contactWhatsappDigits,
      contactEmail: contactEmail ?? this.contactEmail,
      contactInstagram: contactInstagram ?? this.contactInstagram,
      contactWebsite: contactWebsite ?? this.contactWebsite,
      addrPostalCode: addrPostalCode ?? this.addrPostalCode,
      addrStreet: addrStreet ?? this.addrStreet,
      addrNumber: addrNumber ?? this.addrNumber,
      addrComplement: addrComplement ?? this.addrComplement,
      addrNeighborhood: addrNeighborhood ?? this.addrNeighborhood,
      addrCity: addrCity ?? this.addrCity,
      addrState: addrState ?? this.addrState,
      repFullName: repFullName ?? this.repFullName,
      repCpfDigits: repCpfDigits ?? this.repCpfDigits,
      repRole: repRole ?? this.repRole,
      payPixKeyType: payPixKeyType ?? this.payPixKeyType,
      payPixKey: payPixKey ?? this.payPixKey,
      payBeneficiaryName: payBeneficiaryName ?? this.payBeneficiaryName,
      payPaymentTerms: payPaymentTerms ?? this.payPaymentTerms,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (captureStatus.present) {
      map['capture_status'] = Variable<String>(captureStatus.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<int>(capturedAt.value);
    }
    if (logoReference.present) {
      map['logo_reference'] = Variable<String>(logoReference.value);
    }
    if (identTradeName.present) {
      map['ident_trade_name'] = Variable<String>(identTradeName.value);
    }
    if (identLegalName.present) {
      map['ident_legal_name'] = Variable<String>(identLegalName.value);
    }
    if (identCnpjDigits.present) {
      map['ident_cnpj_digits'] = Variable<String>(identCnpjDigits.value);
    }
    if (identStateRegistration.present) {
      map['ident_state_registration'] = Variable<String>(
        identStateRegistration.value,
      );
    }
    if (contactPhoneDigits.present) {
      map['contact_phone_digits'] = Variable<String>(contactPhoneDigits.value);
    }
    if (contactWhatsappDigits.present) {
      map['contact_whatsapp_digits'] = Variable<String>(
        contactWhatsappDigits.value,
      );
    }
    if (contactEmail.present) {
      map['contact_email'] = Variable<String>(contactEmail.value);
    }
    if (contactInstagram.present) {
      map['contact_instagram'] = Variable<String>(contactInstagram.value);
    }
    if (contactWebsite.present) {
      map['contact_website'] = Variable<String>(contactWebsite.value);
    }
    if (addrPostalCode.present) {
      map['addr_postal_code'] = Variable<String>(addrPostalCode.value);
    }
    if (addrStreet.present) {
      map['addr_street'] = Variable<String>(addrStreet.value);
    }
    if (addrNumber.present) {
      map['addr_number'] = Variable<String>(addrNumber.value);
    }
    if (addrComplement.present) {
      map['addr_complement'] = Variable<String>(addrComplement.value);
    }
    if (addrNeighborhood.present) {
      map['addr_neighborhood'] = Variable<String>(addrNeighborhood.value);
    }
    if (addrCity.present) {
      map['addr_city'] = Variable<String>(addrCity.value);
    }
    if (addrState.present) {
      map['addr_state'] = Variable<String>(addrState.value);
    }
    if (repFullName.present) {
      map['rep_full_name'] = Variable<String>(repFullName.value);
    }
    if (repCpfDigits.present) {
      map['rep_cpf_digits'] = Variable<String>(repCpfDigits.value);
    }
    if (repRole.present) {
      map['rep_role'] = Variable<String>(repRole.value);
    }
    if (payPixKeyType.present) {
      map['pay_pix_key_type'] = Variable<String>(payPixKeyType.value);
    }
    if (payPixKey.present) {
      map['pay_pix_key'] = Variable<String>(payPixKey.value);
    }
    if (payBeneficiaryName.present) {
      map['pay_beneficiary_name'] = Variable<String>(payBeneficiaryName.value);
    }
    if (payPaymentTerms.present) {
      map['pay_payment_terms'] = Variable<String>(payPaymentTerms.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteCompanySnapshotsCompanion(')
          ..write('quoteId: $quoteId, ')
          ..write('captureStatus: $captureStatus, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('logoReference: $logoReference, ')
          ..write('identTradeName: $identTradeName, ')
          ..write('identLegalName: $identLegalName, ')
          ..write('identCnpjDigits: $identCnpjDigits, ')
          ..write('identStateRegistration: $identStateRegistration, ')
          ..write('contactPhoneDigits: $contactPhoneDigits, ')
          ..write('contactWhatsappDigits: $contactWhatsappDigits, ')
          ..write('contactEmail: $contactEmail, ')
          ..write('contactInstagram: $contactInstagram, ')
          ..write('contactWebsite: $contactWebsite, ')
          ..write('addrPostalCode: $addrPostalCode, ')
          ..write('addrStreet: $addrStreet, ')
          ..write('addrNumber: $addrNumber, ')
          ..write('addrComplement: $addrComplement, ')
          ..write('addrNeighborhood: $addrNeighborhood, ')
          ..write('addrCity: $addrCity, ')
          ..write('addrState: $addrState, ')
          ..write('repFullName: $repFullName, ')
          ..write('repCpfDigits: $repCpfDigits, ')
          ..write('repRole: $repRole, ')
          ..write('payPixKeyType: $payPixKeyType, ')
          ..write('payPixKey: $payPixKey, ')
          ..write('payBeneficiaryName: $payBeneficiaryName, ')
          ..write('payPaymentTerms: $payPaymentTerms, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyQuoteLineItemsTable extends LegacyQuoteLineItems
    with TableInfo<$LegacyQuoteLineItemsTable, LegacyQuoteLineItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyQuoteLineItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quotes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catalogItemIdMeta = const VerificationMeta(
    'catalogItemId',
  );
  @override
  late final GeneratedColumn<String> catalogItemId = GeneratedColumn<String>(
    'catalog_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceCentsMeta = const VerificationMeta(
    'unitPriceCents',
  );
  @override
  late final GeneratedColumn<int> unitPriceCents = GeneratedColumn<int>(
    'unit_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineTotalCentsMeta = const VerificationMeta(
    'lineTotalCents',
  );
  @override
  late final GeneratedColumn<int> lineTotalCents = GeneratedColumn<int>(
    'line_total_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    quoteId,
    sortOrder,
    catalogItemId,
    name,
    description,
    unit,
    quantity,
    unitPriceCents,
    lineTotalCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote_line_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyQuoteLineItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('catalog_item_id')) {
      context.handle(
        _catalogItemIdMeta,
        catalogItemId.isAcceptableOrUnknown(
          data['catalog_item_id']!,
          _catalogItemIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price_cents')) {
      context.handle(
        _unitPriceCentsMeta,
        unitPriceCents.isAcceptableOrUnknown(
          data['unit_price_cents']!,
          _unitPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceCentsMeta);
    }
    if (data.containsKey('line_total_cents')) {
      context.handle(
        _lineTotalCentsMeta,
        lineTotalCents.isAcceptableOrUnknown(
          data['line_total_cents']!,
          _lineTotalCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lineTotalCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyQuoteLineItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyQuoteLineItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      catalogItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_item_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_cents'],
      )!,
      lineTotalCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_total_cents'],
      )!,
    );
  }

  @override
  $LegacyQuoteLineItemsTable createAlias(String alias) {
    return $LegacyQuoteLineItemsTable(attachedDatabase, alias);
  }
}

class LegacyQuoteLineItemRow extends DataClass
    implements Insertable<LegacyQuoteLineItemRow> {
  final String id;
  final String quoteId;
  final int sortOrder;
  final String? catalogItemId;
  final String name;
  final String? description;
  final String unit;
  final double quantity;
  final int unitPriceCents;
  final int lineTotalCents;
  const LegacyQuoteLineItemRow({
    required this.id,
    required this.quoteId,
    required this.sortOrder,
    this.catalogItemId,
    required this.name,
    this.description,
    required this.unit,
    required this.quantity,
    required this.unitPriceCents,
    required this.lineTotalCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quote_id'] = Variable<String>(quoteId);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || catalogItemId != null) {
      map['catalog_item_id'] = Variable<String>(catalogItemId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['unit'] = Variable<String>(unit);
    map['quantity'] = Variable<double>(quantity);
    map['unit_price_cents'] = Variable<int>(unitPriceCents);
    map['line_total_cents'] = Variable<int>(lineTotalCents);
    return map;
  }

  LegacyQuoteLineItemsCompanion toCompanion(bool nullToAbsent) {
    return LegacyQuoteLineItemsCompanion(
      id: Value(id),
      quoteId: Value(quoteId),
      sortOrder: Value(sortOrder),
      catalogItemId: catalogItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogItemId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      unit: Value(unit),
      quantity: Value(quantity),
      unitPriceCents: Value(unitPriceCents),
      lineTotalCents: Value(lineTotalCents),
    );
  }

  factory LegacyQuoteLineItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyQuoteLineItemRow(
      id: serializer.fromJson<String>(json['id']),
      quoteId: serializer.fromJson<String>(json['quoteId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      catalogItemId: serializer.fromJson<String?>(json['catalogItemId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      unit: serializer.fromJson<String>(json['unit']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPriceCents: serializer.fromJson<int>(json['unitPriceCents']),
      lineTotalCents: serializer.fromJson<int>(json['lineTotalCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'quoteId': serializer.toJson<String>(quoteId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'catalogItemId': serializer.toJson<String?>(catalogItemId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'unit': serializer.toJson<String>(unit),
      'quantity': serializer.toJson<double>(quantity),
      'unitPriceCents': serializer.toJson<int>(unitPriceCents),
      'lineTotalCents': serializer.toJson<int>(lineTotalCents),
    };
  }

  LegacyQuoteLineItemRow copyWith({
    String? id,
    String? quoteId,
    int? sortOrder,
    Value<String?> catalogItemId = const Value.absent(),
    String? name,
    Value<String?> description = const Value.absent(),
    String? unit,
    double? quantity,
    int? unitPriceCents,
    int? lineTotalCents,
  }) => LegacyQuoteLineItemRow(
    id: id ?? this.id,
    quoteId: quoteId ?? this.quoteId,
    sortOrder: sortOrder ?? this.sortOrder,
    catalogItemId: catalogItemId.present
        ? catalogItemId.value
        : this.catalogItemId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    unit: unit ?? this.unit,
    quantity: quantity ?? this.quantity,
    unitPriceCents: unitPriceCents ?? this.unitPriceCents,
    lineTotalCents: lineTotalCents ?? this.lineTotalCents,
  );
  LegacyQuoteLineItemRow copyWithCompanion(LegacyQuoteLineItemsCompanion data) {
    return LegacyQuoteLineItemRow(
      id: data.id.present ? data.id.value : this.id,
      quoteId: data.quoteId.present ? data.quoteId.value : this.quoteId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      catalogItemId: data.catalogItemId.present
          ? data.catalogItemId.value
          : this.catalogItemId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      unit: data.unit.present ? data.unit.value : this.unit,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPriceCents: data.unitPriceCents.present
          ? data.unitPriceCents.value
          : this.unitPriceCents,
      lineTotalCents: data.lineTotalCents.present
          ? data.lineTotalCents.value
          : this.lineTotalCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteLineItemRow(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('catalogItemId: $catalogItemId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceCents: $unitPriceCents, ')
          ..write('lineTotalCents: $lineTotalCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    quoteId,
    sortOrder,
    catalogItemId,
    name,
    description,
    unit,
    quantity,
    unitPriceCents,
    lineTotalCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyQuoteLineItemRow &&
          other.id == this.id &&
          other.quoteId == this.quoteId &&
          other.sortOrder == this.sortOrder &&
          other.catalogItemId == this.catalogItemId &&
          other.name == this.name &&
          other.description == this.description &&
          other.unit == this.unit &&
          other.quantity == this.quantity &&
          other.unitPriceCents == this.unitPriceCents &&
          other.lineTotalCents == this.lineTotalCents);
}

class LegacyQuoteLineItemsCompanion
    extends UpdateCompanion<LegacyQuoteLineItemRow> {
  final Value<String> id;
  final Value<String> quoteId;
  final Value<int> sortOrder;
  final Value<String?> catalogItemId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> unit;
  final Value<double> quantity;
  final Value<int> unitPriceCents;
  final Value<int> lineTotalCents;
  final Value<int> rowid;
  const LegacyQuoteLineItemsCompanion({
    this.id = const Value.absent(),
    this.quoteId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.catalogItemId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPriceCents = const Value.absent(),
    this.lineTotalCents = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyQuoteLineItemsCompanion.insert({
    required String id,
    required String quoteId,
    required int sortOrder,
    this.catalogItemId = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required String unit,
    required double quantity,
    required int unitPriceCents,
    required int lineTotalCents,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       quoteId = Value(quoteId),
       sortOrder = Value(sortOrder),
       name = Value(name),
       unit = Value(unit),
       quantity = Value(quantity),
       unitPriceCents = Value(unitPriceCents),
       lineTotalCents = Value(lineTotalCents);
  static Insertable<LegacyQuoteLineItemRow> custom({
    Expression<String>? id,
    Expression<String>? quoteId,
    Expression<int>? sortOrder,
    Expression<String>? catalogItemId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? unit,
    Expression<double>? quantity,
    Expression<int>? unitPriceCents,
    Expression<int>? lineTotalCents,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quoteId != null) 'quote_id': quoteId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (catalogItemId != null) 'catalog_item_id': catalogItemId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (unit != null) 'unit': unit,
      if (quantity != null) 'quantity': quantity,
      if (unitPriceCents != null) 'unit_price_cents': unitPriceCents,
      if (lineTotalCents != null) 'line_total_cents': lineTotalCents,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyQuoteLineItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? quoteId,
    Value<int>? sortOrder,
    Value<String?>? catalogItemId,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? unit,
    Value<double>? quantity,
    Value<int>? unitPriceCents,
    Value<int>? lineTotalCents,
    Value<int>? rowid,
  }) {
    return LegacyQuoteLineItemsCompanion(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      sortOrder: sortOrder ?? this.sortOrder,
      catalogItemId: catalogItemId ?? this.catalogItemId,
      name: name ?? this.name,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      unitPriceCents: unitPriceCents ?? this.unitPriceCents,
      lineTotalCents: lineTotalCents ?? this.lineTotalCents,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (catalogItemId.present) {
      map['catalog_item_id'] = Variable<String>(catalogItemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPriceCents.present) {
      map['unit_price_cents'] = Variable<int>(unitPriceCents.value);
    }
    if (lineTotalCents.present) {
      map['line_total_cents'] = Variable<int>(lineTotalCents.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteLineItemsCompanion(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('catalogItemId: $catalogItemId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceCents: $unitPriceCents, ')
          ..write('lineTotalCents: $lineTotalCents, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyQuoteLinePackageComponentsTable
    extends LegacyQuoteLinePackageComponents
    with
        TableInfo<
          $LegacyQuoteLinePackageComponentsTable,
          LegacyQuoteLinePackageComponentRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyQuoteLinePackageComponentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineItemIdMeta = const VerificationMeta(
    'lineItemId',
  );
  @override
  late final GeneratedColumn<String> lineItemId = GeneratedColumn<String>(
    'line_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quote_line_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catalogItemIdMeta = const VerificationMeta(
    'catalogItemId',
  );
  @override
  late final GeneratedColumn<String> catalogItemId = GeneratedColumn<String>(
    'catalog_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeLabelMeta = const VerificationMeta(
    'typeLabel',
  );
  @override
  late final GeneratedColumn<String> typeLabel = GeneratedColumn<String>(
    'type_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryLabelMeta = const VerificationMeta(
    'categoryLabel',
  );
  @override
  late final GeneratedColumn<String> categoryLabel = GeneratedColumn<String>(
    'category_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityPerPackageMeta =
      const VerificationMeta('quantityPerPackage');
  @override
  late final GeneratedColumn<double> quantityPerPackage =
      GeneratedColumn<double>(
        'quantity_per_package',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lineItemId,
    sortOrder,
    catalogItemId,
    name,
    unit,
    typeLabel,
    categoryLabel,
    quantityPerPackage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote_line_package_components';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyQuoteLinePackageComponentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('line_item_id')) {
      context.handle(
        _lineItemIdMeta,
        lineItemId.isAcceptableOrUnknown(
          data['line_item_id']!,
          _lineItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lineItemIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('catalog_item_id')) {
      context.handle(
        _catalogItemIdMeta,
        catalogItemId.isAcceptableOrUnknown(
          data['catalog_item_id']!,
          _catalogItemIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('type_label')) {
      context.handle(
        _typeLabelMeta,
        typeLabel.isAcceptableOrUnknown(data['type_label']!, _typeLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_typeLabelMeta);
    }
    if (data.containsKey('category_label')) {
      context.handle(
        _categoryLabelMeta,
        categoryLabel.isAcceptableOrUnknown(
          data['category_label']!,
          _categoryLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryLabelMeta);
    }
    if (data.containsKey('quantity_per_package')) {
      context.handle(
        _quantityPerPackageMeta,
        quantityPerPackage.isAcceptableOrUnknown(
          data['quantity_per_package']!,
          _quantityPerPackageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityPerPackageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyQuoteLinePackageComponentRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyQuoteLinePackageComponentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lineItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}line_item_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      catalogItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_item_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      typeLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_label'],
      )!,
      categoryLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_label'],
      )!,
      quantityPerPackage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_per_package'],
      )!,
    );
  }

  @override
  $LegacyQuoteLinePackageComponentsTable createAlias(String alias) {
    return $LegacyQuoteLinePackageComponentsTable(attachedDatabase, alias);
  }
}

class LegacyQuoteLinePackageComponentRow extends DataClass
    implements Insertable<LegacyQuoteLinePackageComponentRow> {
  final String id;
  final String lineItemId;
  final int sortOrder;
  final String? catalogItemId;
  final String name;
  final String unit;
  final String typeLabel;
  final String categoryLabel;
  final double quantityPerPackage;
  const LegacyQuoteLinePackageComponentRow({
    required this.id,
    required this.lineItemId,
    required this.sortOrder,
    this.catalogItemId,
    required this.name,
    required this.unit,
    required this.typeLabel,
    required this.categoryLabel,
    required this.quantityPerPackage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['line_item_id'] = Variable<String>(lineItemId);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || catalogItemId != null) {
      map['catalog_item_id'] = Variable<String>(catalogItemId);
    }
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<String>(unit);
    map['type_label'] = Variable<String>(typeLabel);
    map['category_label'] = Variable<String>(categoryLabel);
    map['quantity_per_package'] = Variable<double>(quantityPerPackage);
    return map;
  }

  LegacyQuoteLinePackageComponentsCompanion toCompanion(bool nullToAbsent) {
    return LegacyQuoteLinePackageComponentsCompanion(
      id: Value(id),
      lineItemId: Value(lineItemId),
      sortOrder: Value(sortOrder),
      catalogItemId: catalogItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogItemId),
      name: Value(name),
      unit: Value(unit),
      typeLabel: Value(typeLabel),
      categoryLabel: Value(categoryLabel),
      quantityPerPackage: Value(quantityPerPackage),
    );
  }

  factory LegacyQuoteLinePackageComponentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyQuoteLinePackageComponentRow(
      id: serializer.fromJson<String>(json['id']),
      lineItemId: serializer.fromJson<String>(json['lineItemId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      catalogItemId: serializer.fromJson<String?>(json['catalogItemId']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      typeLabel: serializer.fromJson<String>(json['typeLabel']),
      categoryLabel: serializer.fromJson<String>(json['categoryLabel']),
      quantityPerPackage: serializer.fromJson<double>(
        json['quantityPerPackage'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lineItemId': serializer.toJson<String>(lineItemId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'catalogItemId': serializer.toJson<String?>(catalogItemId),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'typeLabel': serializer.toJson<String>(typeLabel),
      'categoryLabel': serializer.toJson<String>(categoryLabel),
      'quantityPerPackage': serializer.toJson<double>(quantityPerPackage),
    };
  }

  LegacyQuoteLinePackageComponentRow copyWith({
    String? id,
    String? lineItemId,
    int? sortOrder,
    Value<String?> catalogItemId = const Value.absent(),
    String? name,
    String? unit,
    String? typeLabel,
    String? categoryLabel,
    double? quantityPerPackage,
  }) => LegacyQuoteLinePackageComponentRow(
    id: id ?? this.id,
    lineItemId: lineItemId ?? this.lineItemId,
    sortOrder: sortOrder ?? this.sortOrder,
    catalogItemId: catalogItemId.present
        ? catalogItemId.value
        : this.catalogItemId,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    typeLabel: typeLabel ?? this.typeLabel,
    categoryLabel: categoryLabel ?? this.categoryLabel,
    quantityPerPackage: quantityPerPackage ?? this.quantityPerPackage,
  );
  LegacyQuoteLinePackageComponentRow copyWithCompanion(
    LegacyQuoteLinePackageComponentsCompanion data,
  ) {
    return LegacyQuoteLinePackageComponentRow(
      id: data.id.present ? data.id.value : this.id,
      lineItemId: data.lineItemId.present
          ? data.lineItemId.value
          : this.lineItemId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      catalogItemId: data.catalogItemId.present
          ? data.catalogItemId.value
          : this.catalogItemId,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      typeLabel: data.typeLabel.present ? data.typeLabel.value : this.typeLabel,
      categoryLabel: data.categoryLabel.present
          ? data.categoryLabel.value
          : this.categoryLabel,
      quantityPerPackage: data.quantityPerPackage.present
          ? data.quantityPerPackage.value
          : this.quantityPerPackage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteLinePackageComponentRow(')
          ..write('id: $id, ')
          ..write('lineItemId: $lineItemId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('catalogItemId: $catalogItemId, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('typeLabel: $typeLabel, ')
          ..write('categoryLabel: $categoryLabel, ')
          ..write('quantityPerPackage: $quantityPerPackage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lineItemId,
    sortOrder,
    catalogItemId,
    name,
    unit,
    typeLabel,
    categoryLabel,
    quantityPerPackage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyQuoteLinePackageComponentRow &&
          other.id == this.id &&
          other.lineItemId == this.lineItemId &&
          other.sortOrder == this.sortOrder &&
          other.catalogItemId == this.catalogItemId &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.typeLabel == this.typeLabel &&
          other.categoryLabel == this.categoryLabel &&
          other.quantityPerPackage == this.quantityPerPackage);
}

class LegacyQuoteLinePackageComponentsCompanion
    extends UpdateCompanion<LegacyQuoteLinePackageComponentRow> {
  final Value<String> id;
  final Value<String> lineItemId;
  final Value<int> sortOrder;
  final Value<String?> catalogItemId;
  final Value<String> name;
  final Value<String> unit;
  final Value<String> typeLabel;
  final Value<String> categoryLabel;
  final Value<double> quantityPerPackage;
  final Value<int> rowid;
  const LegacyQuoteLinePackageComponentsCompanion({
    this.id = const Value.absent(),
    this.lineItemId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.catalogItemId = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.typeLabel = const Value.absent(),
    this.categoryLabel = const Value.absent(),
    this.quantityPerPackage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyQuoteLinePackageComponentsCompanion.insert({
    required String id,
    required String lineItemId,
    required int sortOrder,
    this.catalogItemId = const Value.absent(),
    required String name,
    required String unit,
    required String typeLabel,
    required String categoryLabel,
    required double quantityPerPackage,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lineItemId = Value(lineItemId),
       sortOrder = Value(sortOrder),
       name = Value(name),
       unit = Value(unit),
       typeLabel = Value(typeLabel),
       categoryLabel = Value(categoryLabel),
       quantityPerPackage = Value(quantityPerPackage);
  static Insertable<LegacyQuoteLinePackageComponentRow> custom({
    Expression<String>? id,
    Expression<String>? lineItemId,
    Expression<int>? sortOrder,
    Expression<String>? catalogItemId,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<String>? typeLabel,
    Expression<String>? categoryLabel,
    Expression<double>? quantityPerPackage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lineItemId != null) 'line_item_id': lineItemId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (catalogItemId != null) 'catalog_item_id': catalogItemId,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (typeLabel != null) 'type_label': typeLabel,
      if (categoryLabel != null) 'category_label': categoryLabel,
      if (quantityPerPackage != null)
        'quantity_per_package': quantityPerPackage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyQuoteLinePackageComponentsCompanion copyWith({
    Value<String>? id,
    Value<String>? lineItemId,
    Value<int>? sortOrder,
    Value<String?>? catalogItemId,
    Value<String>? name,
    Value<String>? unit,
    Value<String>? typeLabel,
    Value<String>? categoryLabel,
    Value<double>? quantityPerPackage,
    Value<int>? rowid,
  }) {
    return LegacyQuoteLinePackageComponentsCompanion(
      id: id ?? this.id,
      lineItemId: lineItemId ?? this.lineItemId,
      sortOrder: sortOrder ?? this.sortOrder,
      catalogItemId: catalogItemId ?? this.catalogItemId,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      typeLabel: typeLabel ?? this.typeLabel,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      quantityPerPackage: quantityPerPackage ?? this.quantityPerPackage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lineItemId.present) {
      map['line_item_id'] = Variable<String>(lineItemId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (catalogItemId.present) {
      map['catalog_item_id'] = Variable<String>(catalogItemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (typeLabel.present) {
      map['type_label'] = Variable<String>(typeLabel.value);
    }
    if (categoryLabel.present) {
      map['category_label'] = Variable<String>(categoryLabel.value);
    }
    if (quantityPerPackage.present) {
      map['quantity_per_package'] = Variable<double>(quantityPerPackage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteLinePackageComponentsCompanion(')
          ..write('id: $id, ')
          ..write('lineItemId: $lineItemId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('catalogItemId: $catalogItemId, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('typeLabel: $typeLabel, ')
          ..write('categoryLabel: $categoryLabel, ')
          ..write('quantityPerPackage: $quantityPerPackage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyQuoteStatusHistoryTable extends LegacyQuoteStatusHistory
    with
        TableInfo<$LegacyQuoteStatusHistoryTable, LegacyQuoteStatusHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyQuoteStatusHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quotes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousStatusMeta = const VerificationMeta(
    'previousStatus',
  );
  @override
  late final GeneratedColumn<String> previousStatus = GeneratedColumn<String>(
    'previous_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _newStatusMeta = const VerificationMeta(
    'newStatus',
  );
  @override
  late final GeneratedColumn<String> newStatus = GeneratedColumn<String>(
    'new_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<int> changedAt = GeneratedColumn<int>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    quoteId,
    sortOrder,
    previousStatus,
    newStatus,
    changedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote_status_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyQuoteStatusHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('previous_status')) {
      context.handle(
        _previousStatusMeta,
        previousStatus.isAcceptableOrUnknown(
          data['previous_status']!,
          _previousStatusMeta,
        ),
      );
    }
    if (data.containsKey('new_status')) {
      context.handle(
        _newStatusMeta,
        newStatus.isAcceptableOrUnknown(data['new_status']!, _newStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_newStatusMeta);
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyQuoteStatusHistoryRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyQuoteStatusHistoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      previousStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_status'],
      ),
      newStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_status'],
      )!,
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}changed_at'],
      )!,
    );
  }

  @override
  $LegacyQuoteStatusHistoryTable createAlias(String alias) {
    return $LegacyQuoteStatusHistoryTable(attachedDatabase, alias);
  }
}

class LegacyQuoteStatusHistoryRow extends DataClass
    implements Insertable<LegacyQuoteStatusHistoryRow> {
  final String id;
  final String quoteId;
  final int sortOrder;
  final String? previousStatus;
  final String newStatus;
  final int changedAt;
  const LegacyQuoteStatusHistoryRow({
    required this.id,
    required this.quoteId,
    required this.sortOrder,
    this.previousStatus,
    required this.newStatus,
    required this.changedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quote_id'] = Variable<String>(quoteId);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || previousStatus != null) {
      map['previous_status'] = Variable<String>(previousStatus);
    }
    map['new_status'] = Variable<String>(newStatus);
    map['changed_at'] = Variable<int>(changedAt);
    return map;
  }

  LegacyQuoteStatusHistoryCompanion toCompanion(bool nullToAbsent) {
    return LegacyQuoteStatusHistoryCompanion(
      id: Value(id),
      quoteId: Value(quoteId),
      sortOrder: Value(sortOrder),
      previousStatus: previousStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(previousStatus),
      newStatus: Value(newStatus),
      changedAt: Value(changedAt),
    );
  }

  factory LegacyQuoteStatusHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyQuoteStatusHistoryRow(
      id: serializer.fromJson<String>(json['id']),
      quoteId: serializer.fromJson<String>(json['quoteId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      previousStatus: serializer.fromJson<String?>(json['previousStatus']),
      newStatus: serializer.fromJson<String>(json['newStatus']),
      changedAt: serializer.fromJson<int>(json['changedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'quoteId': serializer.toJson<String>(quoteId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'previousStatus': serializer.toJson<String?>(previousStatus),
      'newStatus': serializer.toJson<String>(newStatus),
      'changedAt': serializer.toJson<int>(changedAt),
    };
  }

  LegacyQuoteStatusHistoryRow copyWith({
    String? id,
    String? quoteId,
    int? sortOrder,
    Value<String?> previousStatus = const Value.absent(),
    String? newStatus,
    int? changedAt,
  }) => LegacyQuoteStatusHistoryRow(
    id: id ?? this.id,
    quoteId: quoteId ?? this.quoteId,
    sortOrder: sortOrder ?? this.sortOrder,
    previousStatus: previousStatus.present
        ? previousStatus.value
        : this.previousStatus,
    newStatus: newStatus ?? this.newStatus,
    changedAt: changedAt ?? this.changedAt,
  );
  LegacyQuoteStatusHistoryRow copyWithCompanion(
    LegacyQuoteStatusHistoryCompanion data,
  ) {
    return LegacyQuoteStatusHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      quoteId: data.quoteId.present ? data.quoteId.value : this.quoteId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      previousStatus: data.previousStatus.present
          ? data.previousStatus.value
          : this.previousStatus,
      newStatus: data.newStatus.present ? data.newStatus.value : this.newStatus,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteStatusHistoryRow(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('previousStatus: $previousStatus, ')
          ..write('newStatus: $newStatus, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, quoteId, sortOrder, previousStatus, newStatus, changedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyQuoteStatusHistoryRow &&
          other.id == this.id &&
          other.quoteId == this.quoteId &&
          other.sortOrder == this.sortOrder &&
          other.previousStatus == this.previousStatus &&
          other.newStatus == this.newStatus &&
          other.changedAt == this.changedAt);
}

class LegacyQuoteStatusHistoryCompanion
    extends UpdateCompanion<LegacyQuoteStatusHistoryRow> {
  final Value<String> id;
  final Value<String> quoteId;
  final Value<int> sortOrder;
  final Value<String?> previousStatus;
  final Value<String> newStatus;
  final Value<int> changedAt;
  final Value<int> rowid;
  const LegacyQuoteStatusHistoryCompanion({
    this.id = const Value.absent(),
    this.quoteId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.previousStatus = const Value.absent(),
    this.newStatus = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyQuoteStatusHistoryCompanion.insert({
    required String id,
    required String quoteId,
    required int sortOrder,
    this.previousStatus = const Value.absent(),
    required String newStatus,
    required int changedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       quoteId = Value(quoteId),
       sortOrder = Value(sortOrder),
       newStatus = Value(newStatus),
       changedAt = Value(changedAt);
  static Insertable<LegacyQuoteStatusHistoryRow> custom({
    Expression<String>? id,
    Expression<String>? quoteId,
    Expression<int>? sortOrder,
    Expression<String>? previousStatus,
    Expression<String>? newStatus,
    Expression<int>? changedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quoteId != null) 'quote_id': quoteId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (previousStatus != null) 'previous_status': previousStatus,
      if (newStatus != null) 'new_status': newStatus,
      if (changedAt != null) 'changed_at': changedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyQuoteStatusHistoryCompanion copyWith({
    Value<String>? id,
    Value<String>? quoteId,
    Value<int>? sortOrder,
    Value<String?>? previousStatus,
    Value<String>? newStatus,
    Value<int>? changedAt,
    Value<int>? rowid,
  }) {
    return LegacyQuoteStatusHistoryCompanion(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      sortOrder: sortOrder ?? this.sortOrder,
      previousStatus: previousStatus ?? this.previousStatus,
      newStatus: newStatus ?? this.newStatus,
      changedAt: changedAt ?? this.changedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (previousStatus.present) {
      map['previous_status'] = Variable<String>(previousStatus.value);
    }
    if (newStatus.present) {
      map['new_status'] = Variable<String>(newStatus.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<int>(changedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteStatusHistoryCompanion(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('previousStatus: $previousStatus, ')
          ..write('newStatus: $newStatus, ')
          ..write('changedAt: $changedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyQuoteNumberSequencesTable extends LegacyQuoteNumberSequences
    with
        TableInfo<
          $LegacyQuoteNumberSequencesTable,
          LegacyQuoteNumberSequenceRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyQuoteNumberSequencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSequenceMeta = const VerificationMeta(
    'lastSequence',
  );
  @override
  late final GeneratedColumn<int> lastSequence = GeneratedColumn<int>(
    'last_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [year, lastSequence];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote_number_sequences';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyQuoteNumberSequenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('last_sequence')) {
      context.handle(
        _lastSequenceMeta,
        lastSequence.isAcceptableOrUnknown(
          data['last_sequence']!,
          _lastSequenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSequenceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {year};
  @override
  LegacyQuoteNumberSequenceRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyQuoteNumberSequenceRow(
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      lastSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sequence'],
      )!,
    );
  }

  @override
  $LegacyQuoteNumberSequencesTable createAlias(String alias) {
    return $LegacyQuoteNumberSequencesTable(attachedDatabase, alias);
  }
}

class LegacyQuoteNumberSequenceRow extends DataClass
    implements Insertable<LegacyQuoteNumberSequenceRow> {
  final int year;
  final int lastSequence;
  const LegacyQuoteNumberSequenceRow({
    required this.year,
    required this.lastSequence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['year'] = Variable<int>(year);
    map['last_sequence'] = Variable<int>(lastSequence);
    return map;
  }

  LegacyQuoteNumberSequencesCompanion toCompanion(bool nullToAbsent) {
    return LegacyQuoteNumberSequencesCompanion(
      year: Value(year),
      lastSequence: Value(lastSequence),
    );
  }

  factory LegacyQuoteNumberSequenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyQuoteNumberSequenceRow(
      year: serializer.fromJson<int>(json['year']),
      lastSequence: serializer.fromJson<int>(json['lastSequence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'year': serializer.toJson<int>(year),
      'lastSequence': serializer.toJson<int>(lastSequence),
    };
  }

  LegacyQuoteNumberSequenceRow copyWith({int? year, int? lastSequence}) =>
      LegacyQuoteNumberSequenceRow(
        year: year ?? this.year,
        lastSequence: lastSequence ?? this.lastSequence,
      );
  LegacyQuoteNumberSequenceRow copyWithCompanion(
    LegacyQuoteNumberSequencesCompanion data,
  ) {
    return LegacyQuoteNumberSequenceRow(
      year: data.year.present ? data.year.value : this.year,
      lastSequence: data.lastSequence.present
          ? data.lastSequence.value
          : this.lastSequence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteNumberSequenceRow(')
          ..write('year: $year, ')
          ..write('lastSequence: $lastSequence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(year, lastSequence);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyQuoteNumberSequenceRow &&
          other.year == this.year &&
          other.lastSequence == this.lastSequence);
}

class LegacyQuoteNumberSequencesCompanion
    extends UpdateCompanion<LegacyQuoteNumberSequenceRow> {
  final Value<int> year;
  final Value<int> lastSequence;
  const LegacyQuoteNumberSequencesCompanion({
    this.year = const Value.absent(),
    this.lastSequence = const Value.absent(),
  });
  LegacyQuoteNumberSequencesCompanion.insert({
    this.year = const Value.absent(),
    required int lastSequence,
  }) : lastSequence = Value(lastSequence);
  static Insertable<LegacyQuoteNumberSequenceRow> custom({
    Expression<int>? year,
    Expression<int>? lastSequence,
  }) {
    return RawValuesInsertable({
      if (year != null) 'year': year,
      if (lastSequence != null) 'last_sequence': lastSequence,
    });
  }

  LegacyQuoteNumberSequencesCompanion copyWith({
    Value<int>? year,
    Value<int>? lastSequence,
  }) {
    return LegacyQuoteNumberSequencesCompanion(
      year: year ?? this.year,
      lastSequence: lastSequence ?? this.lastSequence,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (lastSequence.present) {
      map['last_sequence'] = Variable<int>(lastSequence.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteNumberSequencesCompanion(')
          ..write('year: $year, ')
          ..write('lastSequence: $lastSequence')
          ..write(')'))
        .toString();
  }
}

class $LegacyAgendaBlocksTable extends LegacyAgendaBlocks
    with TableInfo<$LegacyAgendaBlocksTable, LegacyAgendaBlockRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyAgendaBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<int> start = GeneratedColumn<int>(
    'start',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<int> end = GeneratedColumn<int>(
    'end',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    notes,
    start,
    end,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agenda_blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyAgendaBlockRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
        _endMeta,
        end.isAcceptableOrUnknown(data['end']!, _endMeta),
      );
    } else if (isInserting) {
      context.missing(_endMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyAgendaBlockRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyAgendaBlockRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start'],
      )!,
      end: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LegacyAgendaBlocksTable createAlias(String alias) {
    return $LegacyAgendaBlocksTable(attachedDatabase, alias);
  }
}

class LegacyAgendaBlockRow extends DataClass
    implements Insertable<LegacyAgendaBlockRow> {
  final String id;
  final String title;
  final String? notes;
  final int start;
  final int end;
  final int createdAt;
  final int updatedAt;
  const LegacyAgendaBlockRow({
    required this.id,
    required this.title,
    this.notes,
    required this.start,
    required this.end,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['start'] = Variable<int>(start);
    map['end'] = Variable<int>(end);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LegacyAgendaBlocksCompanion toCompanion(bool nullToAbsent) {
    return LegacyAgendaBlocksCompanion(
      id: Value(id),
      title: Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      start: Value(start),
      end: Value(end),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LegacyAgendaBlockRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyAgendaBlockRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      start: serializer.fromJson<int>(json['start']),
      end: serializer.fromJson<int>(json['end']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'start': serializer.toJson<int>(start),
      'end': serializer.toJson<int>(end),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LegacyAgendaBlockRow copyWith({
    String? id,
    String? title,
    Value<String?> notes = const Value.absent(),
    int? start,
    int? end,
    int? createdAt,
    int? updatedAt,
  }) => LegacyAgendaBlockRow(
    id: id ?? this.id,
    title: title ?? this.title,
    notes: notes.present ? notes.value : this.notes,
    start: start ?? this.start,
    end: end ?? this.end,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LegacyAgendaBlockRow copyWithCompanion(LegacyAgendaBlocksCompanion data) {
    return LegacyAgendaBlockRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      start: data.start.present ? data.start.value : this.start,
      end: data.end.present ? data.end.value : this.end,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyAgendaBlockRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, notes, start, end, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyAgendaBlockRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.start == this.start &&
          other.end == this.end &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LegacyAgendaBlocksCompanion
    extends UpdateCompanion<LegacyAgendaBlockRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> notes;
  final Value<int> start;
  final Value<int> end;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LegacyAgendaBlocksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyAgendaBlocksCompanion.insert({
    required String id,
    required String title,
    this.notes = const Value.absent(),
    required int start,
    required int end,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       start = Value(start),
       end = Value(end),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LegacyAgendaBlockRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<int>? start,
    Expression<int>? end,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyAgendaBlocksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? notes,
    Value<int>? start,
    Value<int>? end,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LegacyAgendaBlocksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      start: start ?? this.start,
      end: end ?? this.end,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (start.present) {
      map['start'] = Variable<int>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<int>(end.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyAgendaBlocksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyFinancialCategoriesTable extends LegacyFinancialCategories
    with
        TableInfo<$LegacyFinancialCategoriesTable, LegacyFinancialCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyFinancialCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, kind, active, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyFinancialCategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyFinancialCategoryRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyFinancialCategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LegacyFinancialCategoriesTable createAlias(String alias) {
    return $LegacyFinancialCategoriesTable(attachedDatabase, alias);
  }
}

class LegacyFinancialCategoryRow extends DataClass
    implements Insertable<LegacyFinancialCategoryRow> {
  final String id;
  final String name;
  final String kind;
  final bool active;
  final int createdAt;
  const LegacyFinancialCategoryRow({
    required this.id,
    required this.name,
    required this.kind,
    required this.active,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['kind'] = Variable<String>(kind);
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  LegacyFinancialCategoriesCompanion toCompanion(bool nullToAbsent) {
    return LegacyFinancialCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      active: Value(active),
      createdAt: Value(createdAt),
    );
  }

  factory LegacyFinancialCategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyFinancialCategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(kind),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  LegacyFinancialCategoryRow copyWith({
    String? id,
    String? name,
    String? kind,
    bool? active,
    int? createdAt,
  }) => LegacyFinancialCategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
  );
  LegacyFinancialCategoryRow copyWithCompanion(
    LegacyFinancialCategoriesCompanion data,
  ) {
    return LegacyFinancialCategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyFinancialCategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, kind, active, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyFinancialCategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.active == this.active &&
          other.createdAt == this.createdAt);
}

class LegacyFinancialCategoriesCompanion
    extends UpdateCompanion<LegacyFinancialCategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> kind;
  final Value<bool> active;
  final Value<int> createdAt;
  final Value<int> rowid;
  const LegacyFinancialCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyFinancialCategoriesCompanion.insert({
    required String id,
    required String name,
    required String kind,
    required bool active,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       kind = Value(kind),
       active = Value(active),
       createdAt = Value(createdAt);
  static Insertable<LegacyFinancialCategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<bool>? active,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyFinancialCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? kind,
    Value<bool>? active,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return LegacyFinancialCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyFinancialCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyFinancialEntriesTable extends LegacyFinancialEntries
    with TableInfo<$LegacyFinancialEntriesTable, LegacyFinancialEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyFinancialEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES financial_categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<int> paidAt = GeneratedColumn<int>(
    'paid_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quotes (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    description,
    amountCents,
    date,
    categoryId,
    status,
    paidAt,
    notes,
    quoteId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyFinancialEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyFinancialEntryRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyFinancialEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LegacyFinancialEntriesTable createAlias(String alias) {
    return $LegacyFinancialEntriesTable(attachedDatabase, alias);
  }
}

class LegacyFinancialEntryRow extends DataClass
    implements Insertable<LegacyFinancialEntryRow> {
  final String id;
  final String kind;
  final String description;
  final int amountCents;

  /// Civil date (competência), stored as an ISO `YYYY-MM-DD` string via
  /// `CivilDateConverter` — this field has no time-of-day meaning.
  final String date;
  final String categoryId;
  final String status;
  final int? paidAt;
  final String? notes;

  /// Optional link to the event/quote this entry belongs to (TASK-027
  /// CP-D). Nullable — most entries (general company overhead, etc.) have
  /// no associated event. Uses `LegacyQuotes.id` as the single source of truth
  /// for events; no event data is duplicated here.
  final String? quoteId;
  final int createdAt;
  final int updatedAt;
  const LegacyFinancialEntryRow({
    required this.id,
    required this.kind,
    required this.description,
    required this.amountCents,
    required this.date,
    required this.categoryId,
    required this.status,
    this.paidAt,
    this.notes,
    this.quoteId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['description'] = Variable<String>(description);
    map['amount_cents'] = Variable<int>(amountCents);
    map['date'] = Variable<String>(date);
    map['category_id'] = Variable<String>(categoryId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<int>(paidAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || quoteId != null) {
      map['quote_id'] = Variable<String>(quoteId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LegacyFinancialEntriesCompanion toCompanion(bool nullToAbsent) {
    return LegacyFinancialEntriesCompanion(
      id: Value(id),
      kind: Value(kind),
      description: Value(description),
      amountCents: Value(amountCents),
      date: Value(date),
      categoryId: Value(categoryId),
      status: Value(status),
      paidAt: paidAt == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      quoteId: quoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(quoteId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LegacyFinancialEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyFinancialEntryRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      description: serializer.fromJson<String>(json['description']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      date: serializer.fromJson<String>(json['date']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      status: serializer.fromJson<String>(json['status']),
      paidAt: serializer.fromJson<int?>(json['paidAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      quoteId: serializer.fromJson<String?>(json['quoteId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'description': serializer.toJson<String>(description),
      'amountCents': serializer.toJson<int>(amountCents),
      'date': serializer.toJson<String>(date),
      'categoryId': serializer.toJson<String>(categoryId),
      'status': serializer.toJson<String>(status),
      'paidAt': serializer.toJson<int?>(paidAt),
      'notes': serializer.toJson<String?>(notes),
      'quoteId': serializer.toJson<String?>(quoteId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LegacyFinancialEntryRow copyWith({
    String? id,
    String? kind,
    String? description,
    int? amountCents,
    String? date,
    String? categoryId,
    String? status,
    Value<int?> paidAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> quoteId = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => LegacyFinancialEntryRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    description: description ?? this.description,
    amountCents: amountCents ?? this.amountCents,
    date: date ?? this.date,
    categoryId: categoryId ?? this.categoryId,
    status: status ?? this.status,
    paidAt: paidAt.present ? paidAt.value : this.paidAt,
    notes: notes.present ? notes.value : this.notes,
    quoteId: quoteId.present ? quoteId.value : this.quoteId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LegacyFinancialEntryRow copyWithCompanion(
    LegacyFinancialEntriesCompanion data,
  ) {
    return LegacyFinancialEntryRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      description: data.description.present
          ? data.description.value
          : this.description,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      date: data.date.present ? data.date.value : this.date,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      status: data.status.present ? data.status.value : this.status,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      quoteId: data.quoteId.present ? data.quoteId.value : this.quoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyFinancialEntryRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date, ')
          ..write('categoryId: $categoryId, ')
          ..write('status: $status, ')
          ..write('paidAt: $paidAt, ')
          ..write('notes: $notes, ')
          ..write('quoteId: $quoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    description,
    amountCents,
    date,
    categoryId,
    status,
    paidAt,
    notes,
    quoteId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyFinancialEntryRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.description == this.description &&
          other.amountCents == this.amountCents &&
          other.date == this.date &&
          other.categoryId == this.categoryId &&
          other.status == this.status &&
          other.paidAt == this.paidAt &&
          other.notes == this.notes &&
          other.quoteId == this.quoteId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LegacyFinancialEntriesCompanion
    extends UpdateCompanion<LegacyFinancialEntryRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> description;
  final Value<int> amountCents;
  final Value<String> date;
  final Value<String> categoryId;
  final Value<String> status;
  final Value<int?> paidAt;
  final Value<String?> notes;
  final Value<String?> quoteId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LegacyFinancialEntriesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.description = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.date = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.status = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.quoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyFinancialEntriesCompanion.insert({
    required String id,
    required String kind,
    required String description,
    required int amountCents,
    required String date,
    required String categoryId,
    required String status,
    this.paidAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.quoteId = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       description = Value(description),
       amountCents = Value(amountCents),
       date = Value(date),
       categoryId = Value(categoryId),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LegacyFinancialEntryRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? description,
    Expression<int>? amountCents,
    Expression<String>? date,
    Expression<String>? categoryId,
    Expression<String>? status,
    Expression<int>? paidAt,
    Expression<String>? notes,
    Expression<String>? quoteId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (description != null) 'description': description,
      if (amountCents != null) 'amount_cents': amountCents,
      if (date != null) 'date': date,
      if (categoryId != null) 'category_id': categoryId,
      if (status != null) 'status': status,
      if (paidAt != null) 'paid_at': paidAt,
      if (notes != null) 'notes': notes,
      if (quoteId != null) 'quote_id': quoteId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyFinancialEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String>? description,
    Value<int>? amountCents,
    Value<String>? date,
    Value<String>? categoryId,
    Value<String>? status,
    Value<int?>? paidAt,
    Value<String?>? notes,
    Value<String?>? quoteId,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LegacyFinancialEntriesCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      description: description ?? this.description,
      amountCents: amountCents ?? this.amountCents,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      paidAt: paidAt ?? this.paidAt,
      notes: notes ?? this.notes,
      quoteId: quoteId ?? this.quoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<int>(paidAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyFinancialEntriesCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date, ')
          ..write('categoryId: $categoryId, ')
          ..write('status: $status, ')
          ..write('paidAt: $paidAt, ')
          ..write('notes: $notes, ')
          ..write('quoteId: $quoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyEquipmentCategoriesTable extends LegacyEquipmentCategories
    with
        TableInfo<$LegacyEquipmentCategoriesTable, LegacyEquipmentCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyEquipmentCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    active,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyEquipmentCategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyEquipmentCategoryRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyEquipmentCategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LegacyEquipmentCategoriesTable createAlias(String alias) {
    return $LegacyEquipmentCategoriesTable(attachedDatabase, alias);
  }
}

class LegacyEquipmentCategoryRow extends DataClass
    implements Insertable<LegacyEquipmentCategoryRow> {
  final String id;
  final String name;
  final String? description;
  final bool active;
  final int createdAt;
  final int updatedAt;
  const LegacyEquipmentCategoryRow({
    required this.id,
    required this.name,
    this.description,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LegacyEquipmentCategoriesCompanion toCompanion(bool nullToAbsent) {
    return LegacyEquipmentCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LegacyEquipmentCategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyEquipmentCategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LegacyEquipmentCategoryRow copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? active,
    int? createdAt,
    int? updatedAt,
  }) => LegacyEquipmentCategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LegacyEquipmentCategoryRow copyWithCompanion(
    LegacyEquipmentCategoriesCompanion data,
  ) {
    return LegacyEquipmentCategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyEquipmentCategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, active, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyEquipmentCategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LegacyEquipmentCategoriesCompanion
    extends UpdateCompanion<LegacyEquipmentCategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> active;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LegacyEquipmentCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyEquipmentCategoriesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required bool active,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       active = Value(active),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LegacyEquipmentCategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? active,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyEquipmentCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? active,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LegacyEquipmentCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyEquipmentCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyEquipmentsTable extends LegacyEquipments
    with TableInfo<$LegacyEquipmentsTable, LegacyEquipmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyEquipmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipment_categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _serialNumberMeta = const VerificationMeta(
    'serialNumber',
  );
  @override
  late final GeneratedColumn<String> serialNumber = GeneratedColumn<String>(
    'serial_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalQuantityMeta = const VerificationMeta(
    'totalQuantity',
  );
  @override
  late final GeneratedColumn<int> totalQuantity = GeneratedColumn<int>(
    'total_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    categoryId,
    serialNumber,
    totalQuantity,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyEquipmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('serial_number')) {
      context.handle(
        _serialNumberMeta,
        serialNumber.isAcceptableOrUnknown(
          data['serial_number']!,
          _serialNumberMeta,
        ),
      );
    }
    if (data.containsKey('total_quantity')) {
      context.handle(
        _totalQuantityMeta,
        totalQuantity.isAcceptableOrUnknown(
          data['total_quantity']!,
          _totalQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalQuantityMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyEquipmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyEquipmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      serialNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_number'],
      ),
      totalQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_quantity'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LegacyEquipmentsTable createAlias(String alias) {
    return $LegacyEquipmentsTable(attachedDatabase, alias);
  }
}

class LegacyEquipmentRow extends DataClass
    implements Insertable<LegacyEquipmentRow> {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String? serialNumber;
  final int totalQuantity;

  /// Serialized [EquipmentStatus] name (`available`, `reserved`, …).
  final String status;
  final int createdAt;
  final int updatedAt;
  const LegacyEquipmentRow({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    this.serialNumber,
    required this.totalQuantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || serialNumber != null) {
      map['serial_number'] = Variable<String>(serialNumber);
    }
    map['total_quantity'] = Variable<int>(totalQuantity);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LegacyEquipmentsCompanion toCompanion(bool nullToAbsent) {
    return LegacyEquipmentsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      categoryId: Value(categoryId),
      serialNumber: serialNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(serialNumber),
      totalQuantity: Value(totalQuantity),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LegacyEquipmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyEquipmentRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      serialNumber: serializer.fromJson<String?>(json['serialNumber']),
      totalQuantity: serializer.fromJson<int>(json['totalQuantity']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'categoryId': serializer.toJson<String>(categoryId),
      'serialNumber': serializer.toJson<String?>(serialNumber),
      'totalQuantity': serializer.toJson<int>(totalQuantity),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LegacyEquipmentRow copyWith({
    String? id,
    String? name,
    String? description,
    String? categoryId,
    Value<String?> serialNumber = const Value.absent(),
    int? totalQuantity,
    String? status,
    int? createdAt,
    int? updatedAt,
  }) => LegacyEquipmentRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    categoryId: categoryId ?? this.categoryId,
    serialNumber: serialNumber.present ? serialNumber.value : this.serialNumber,
    totalQuantity: totalQuantity ?? this.totalQuantity,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LegacyEquipmentRow copyWithCompanion(LegacyEquipmentsCompanion data) {
    return LegacyEquipmentRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      totalQuantity: data.totalQuantity.present
          ? data.totalQuantity.value
          : this.totalQuantity,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyEquipmentRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('totalQuantity: $totalQuantity, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    categoryId,
    serialNumber,
    totalQuantity,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyEquipmentRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.categoryId == this.categoryId &&
          other.serialNumber == this.serialNumber &&
          other.totalQuantity == this.totalQuantity &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LegacyEquipmentsCompanion extends UpdateCompanion<LegacyEquipmentRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> categoryId;
  final Value<String?> serialNumber;
  final Value<int> totalQuantity;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LegacyEquipmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.totalQuantity = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyEquipmentsCompanion.insert({
    required String id,
    required String name,
    required String description,
    required String categoryId,
    this.serialNumber = const Value.absent(),
    required int totalQuantity,
    required String status,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       description = Value(description),
       categoryId = Value(categoryId),
       totalQuantity = Value(totalQuantity),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LegacyEquipmentRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? categoryId,
    Expression<String>? serialNumber,
    Expression<int>? totalQuantity,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (categoryId != null) 'category_id': categoryId,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (totalQuantity != null) 'total_quantity': totalQuantity,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyEquipmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? categoryId,
    Value<String?>? serialNumber,
    Value<int>? totalQuantity,
    Value<String>? status,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LegacyEquipmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      serialNumber: serialNumber ?? this.serialNumber,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<String>(serialNumber.value);
    }
    if (totalQuantity.present) {
      map['total_quantity'] = Variable<int>(totalQuantity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyEquipmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('totalQuantity: $totalQuantity, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyQuoteEquipmentItemsTable extends LegacyQuoteEquipmentItems
    with TableInfo<$LegacyQuoteEquipmentItemsTable, LegacyQuoteEquipmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyQuoteEquipmentItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quotes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _equipmentIdMeta = const VerificationMeta(
    'equipmentId',
  );
  @override
  late final GeneratedColumn<String> equipmentId = GeneratedColumn<String>(
    'equipment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipment (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    quoteId,
    equipmentId,
    quantity,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote_equipment';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyQuoteEquipmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('equipment_id')) {
      context.handle(
        _equipmentIdMeta,
        equipmentId.isAcceptableOrUnknown(
          data['equipment_id']!,
          _equipmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyQuoteEquipmentRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyQuoteEquipmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      equipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LegacyQuoteEquipmentItemsTable createAlias(String alias) {
    return $LegacyQuoteEquipmentItemsTable(attachedDatabase, alias);
  }
}

class LegacyQuoteEquipmentRow extends DataClass
    implements Insertable<LegacyQuoteEquipmentRow> {
  final String id;
  final String quoteId;
  final String equipmentId;
  final int quantity;
  final int createdAt;
  final int updatedAt;
  const LegacyQuoteEquipmentRow({
    required this.id,
    required this.quoteId,
    required this.equipmentId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quote_id'] = Variable<String>(quoteId);
    map['equipment_id'] = Variable<String>(equipmentId);
    map['quantity'] = Variable<int>(quantity);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LegacyQuoteEquipmentItemsCompanion toCompanion(bool nullToAbsent) {
    return LegacyQuoteEquipmentItemsCompanion(
      id: Value(id),
      quoteId: Value(quoteId),
      equipmentId: Value(equipmentId),
      quantity: Value(quantity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LegacyQuoteEquipmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyQuoteEquipmentRow(
      id: serializer.fromJson<String>(json['id']),
      quoteId: serializer.fromJson<String>(json['quoteId']),
      equipmentId: serializer.fromJson<String>(json['equipmentId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'quoteId': serializer.toJson<String>(quoteId),
      'equipmentId': serializer.toJson<String>(equipmentId),
      'quantity': serializer.toJson<int>(quantity),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LegacyQuoteEquipmentRow copyWith({
    String? id,
    String? quoteId,
    String? equipmentId,
    int? quantity,
    int? createdAt,
    int? updatedAt,
  }) => LegacyQuoteEquipmentRow(
    id: id ?? this.id,
    quoteId: quoteId ?? this.quoteId,
    equipmentId: equipmentId ?? this.equipmentId,
    quantity: quantity ?? this.quantity,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LegacyQuoteEquipmentRow copyWithCompanion(
    LegacyQuoteEquipmentItemsCompanion data,
  ) {
    return LegacyQuoteEquipmentRow(
      id: data.id.present ? data.id.value : this.id,
      quoteId: data.quoteId.present ? data.quoteId.value : this.quoteId,
      equipmentId: data.equipmentId.present
          ? data.equipmentId.value
          : this.equipmentId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteEquipmentRow(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('quantity: $quantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, quoteId, equipmentId, quantity, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyQuoteEquipmentRow &&
          other.id == this.id &&
          other.quoteId == this.quoteId &&
          other.equipmentId == this.equipmentId &&
          other.quantity == this.quantity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LegacyQuoteEquipmentItemsCompanion
    extends UpdateCompanion<LegacyQuoteEquipmentRow> {
  final Value<String> id;
  final Value<String> quoteId;
  final Value<String> equipmentId;
  final Value<int> quantity;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LegacyQuoteEquipmentItemsCompanion({
    this.id = const Value.absent(),
    this.quoteId = const Value.absent(),
    this.equipmentId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyQuoteEquipmentItemsCompanion.insert({
    required String id,
    required String quoteId,
    required String equipmentId,
    required int quantity,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       quoteId = Value(quoteId),
       equipmentId = Value(equipmentId),
       quantity = Value(quantity),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LegacyQuoteEquipmentRow> custom({
    Expression<String>? id,
    Expression<String>? quoteId,
    Expression<String>? equipmentId,
    Expression<int>? quantity,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quoteId != null) 'quote_id': quoteId,
      if (equipmentId != null) 'equipment_id': equipmentId,
      if (quantity != null) 'quantity': quantity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyQuoteEquipmentItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? quoteId,
    Value<String>? equipmentId,
    Value<int>? quantity,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LegacyQuoteEquipmentItemsCompanion(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      equipmentId: equipmentId ?? this.equipmentId,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (equipmentId.present) {
      map['equipment_id'] = Variable<String>(equipmentId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteEquipmentItemsCompanion(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('quantity: $quantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyTeamRolesTable extends LegacyTeamRoles
    with TableInfo<$LegacyTeamRolesTable, LegacyTeamRoleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyTeamRolesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    active,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'team_roles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyTeamRoleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyTeamRoleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyTeamRoleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LegacyTeamRolesTable createAlias(String alias) {
    return $LegacyTeamRolesTable(attachedDatabase, alias);
  }
}

class LegacyTeamRoleRow extends DataClass
    implements Insertable<LegacyTeamRoleRow> {
  final String id;
  final String name;
  final String? description;
  final bool active;
  final int createdAt;
  final int updatedAt;
  const LegacyTeamRoleRow({
    required this.id,
    required this.name,
    this.description,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LegacyTeamRolesCompanion toCompanion(bool nullToAbsent) {
    return LegacyTeamRolesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LegacyTeamRoleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyTeamRoleRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LegacyTeamRoleRow copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? active,
    int? createdAt,
    int? updatedAt,
  }) => LegacyTeamRoleRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LegacyTeamRoleRow copyWithCompanion(LegacyTeamRolesCompanion data) {
    return LegacyTeamRoleRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyTeamRoleRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, active, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyTeamRoleRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LegacyTeamRolesCompanion extends UpdateCompanion<LegacyTeamRoleRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> active;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LegacyTeamRolesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyTeamRolesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required bool active,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       active = Value(active),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LegacyTeamRoleRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? active,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyTeamRolesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? active,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LegacyTeamRolesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyTeamRolesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyTeamMembersTable extends LegacyTeamMembers
    with TableInfo<$LegacyTeamMembersTable, LegacyTeamMemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyTeamMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleIdMeta = const VerificationMeta('roleId');
  @override
  late final GeneratedColumn<String> roleId = GeneratedColumn<String>(
    'role_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES team_roles (id) ON UPDATE CASCADE ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _observationsMeta = const VerificationMeta(
    'observations',
  );
  @override
  late final GeneratedColumn<String> observations = GeneratedColumn<String>(
    'observations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dailyRateMeta = const VerificationMeta(
    'dailyRate',
  );
  @override
  late final GeneratedColumn<int> dailyRate = GeneratedColumn<int>(
    'daily_rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    email,
    roleId,
    observations,
    dailyRate,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'team_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyTeamMemberRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('role_id')) {
      context.handle(
        _roleIdMeta,
        roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roleIdMeta);
    }
    if (data.containsKey('observations')) {
      context.handle(
        _observationsMeta,
        observations.isAcceptableOrUnknown(
          data['observations']!,
          _observationsMeta,
        ),
      );
    }
    if (data.containsKey('daily_rate')) {
      context.handle(
        _dailyRateMeta,
        dailyRate.isAcceptableOrUnknown(data['daily_rate']!, _dailyRateMeta),
      );
    } else if (isInserting) {
      context.missing(_dailyRateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyTeamMemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyTeamMemberRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      roleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_id'],
      )!,
      observations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observations'],
      ),
      dailyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_rate'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LegacyTeamMembersTable createAlias(String alias) {
    return $LegacyTeamMembersTable(attachedDatabase, alias);
  }
}

class LegacyTeamMemberRow extends DataClass
    implements Insertable<LegacyTeamMemberRow> {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String roleId;
  final String? observations;
  final int dailyRate;

  /// Serialized TeamMemberStatus name (`active`, `unavailable`, `inactive`).
  final String status;
  final int createdAt;
  final int updatedAt;
  const LegacyTeamMemberRow({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.roleId,
    this.observations,
    required this.dailyRate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['role_id'] = Variable<String>(roleId);
    if (!nullToAbsent || observations != null) {
      map['observations'] = Variable<String>(observations);
    }
    map['daily_rate'] = Variable<int>(dailyRate);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LegacyTeamMembersCompanion toCompanion(bool nullToAbsent) {
    return LegacyTeamMembersCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      roleId: Value(roleId),
      observations: observations == null && nullToAbsent
          ? const Value.absent()
          : Value(observations),
      dailyRate: Value(dailyRate),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LegacyTeamMemberRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyTeamMemberRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      roleId: serializer.fromJson<String>(json['roleId']),
      observations: serializer.fromJson<String?>(json['observations']),
      dailyRate: serializer.fromJson<int>(json['dailyRate']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String?>(email),
      'roleId': serializer.toJson<String>(roleId),
      'observations': serializer.toJson<String?>(observations),
      'dailyRate': serializer.toJson<int>(dailyRate),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LegacyTeamMemberRow copyWith({
    String? id,
    String? name,
    String? phone,
    Value<String?> email = const Value.absent(),
    String? roleId,
    Value<String?> observations = const Value.absent(),
    int? dailyRate,
    String? status,
    int? createdAt,
    int? updatedAt,
  }) => LegacyTeamMemberRow(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    email: email.present ? email.value : this.email,
    roleId: roleId ?? this.roleId,
    observations: observations.present ? observations.value : this.observations,
    dailyRate: dailyRate ?? this.dailyRate,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LegacyTeamMemberRow copyWithCompanion(LegacyTeamMembersCompanion data) {
    return LegacyTeamMemberRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
      observations: data.observations.present
          ? data.observations.value
          : this.observations,
      dailyRate: data.dailyRate.present ? data.dailyRate.value : this.dailyRate,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyTeamMemberRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('roleId: $roleId, ')
          ..write('observations: $observations, ')
          ..write('dailyRate: $dailyRate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    email,
    roleId,
    observations,
    dailyRate,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyTeamMemberRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.roleId == this.roleId &&
          other.observations == this.observations &&
          other.dailyRate == this.dailyRate &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LegacyTeamMembersCompanion extends UpdateCompanion<LegacyTeamMemberRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String?> email;
  final Value<String> roleId;
  final Value<String?> observations;
  final Value<int> dailyRate;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LegacyTeamMembersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.roleId = const Value.absent(),
    this.observations = const Value.absent(),
    this.dailyRate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyTeamMembersCompanion.insert({
    required String id,
    required String name,
    required String phone,
    this.email = const Value.absent(),
    required String roleId,
    this.observations = const Value.absent(),
    required int dailyRate,
    required String status,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       phone = Value(phone),
       roleId = Value(roleId),
       dailyRate = Value(dailyRate),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LegacyTeamMemberRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? roleId,
    Expression<String>? observations,
    Expression<int>? dailyRate,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (roleId != null) 'role_id': roleId,
      if (observations != null) 'observations': observations,
      if (dailyRate != null) 'daily_rate': dailyRate,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyTeamMembersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<String?>? email,
    Value<String>? roleId,
    Value<String?>? observations,
    Value<int>? dailyRate,
    Value<String>? status,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LegacyTeamMembersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      roleId: roleId ?? this.roleId,
      observations: observations ?? this.observations,
      dailyRate: dailyRate ?? this.dailyRate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<String>(roleId.value);
    }
    if (observations.present) {
      map['observations'] = Variable<String>(observations.value);
    }
    if (dailyRate.present) {
      map['daily_rate'] = Variable<int>(dailyRate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyTeamMembersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('roleId: $roleId, ')
          ..write('observations: $observations, ')
          ..write('dailyRate: $dailyRate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyQuoteTeamMembersTable extends LegacyQuoteTeamMembers
    with TableInfo<$LegacyQuoteTeamMembersTable, LegacyQuoteTeamMemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyQuoteTeamMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quotes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _teamMemberIdMeta = const VerificationMeta(
    'teamMemberId',
  );
  @override
  late final GeneratedColumn<String> teamMemberId = GeneratedColumn<String>(
    'team_member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES team_members (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _roleIdMeta = const VerificationMeta('roleId');
  @override
  late final GeneratedColumn<String> roleId = GeneratedColumn<String>(
    'role_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES team_roles (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _dailyRateMeta = const VerificationMeta(
    'dailyRate',
  );
  @override
  late final GeneratedColumn<int> dailyRate = GeneratedColumn<int>(
    'daily_rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    quoteId,
    teamMemberId,
    roleId,
    dailyRate,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote_team_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyQuoteTeamMemberRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('team_member_id')) {
      context.handle(
        _teamMemberIdMeta,
        teamMemberId.isAcceptableOrUnknown(
          data['team_member_id']!,
          _teamMemberIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_teamMemberIdMeta);
    }
    if (data.containsKey('role_id')) {
      context.handle(
        _roleIdMeta,
        roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roleIdMeta);
    }
    if (data.containsKey('daily_rate')) {
      context.handle(
        _dailyRateMeta,
        dailyRate.isAcceptableOrUnknown(data['daily_rate']!, _dailyRateMeta),
      );
    } else if (isInserting) {
      context.missing(_dailyRateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyQuoteTeamMemberRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyQuoteTeamMemberRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      teamMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_member_id'],
      )!,
      roleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_id'],
      )!,
      dailyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_rate'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LegacyQuoteTeamMembersTable createAlias(String alias) {
    return $LegacyQuoteTeamMembersTable(attachedDatabase, alias);
  }
}

class LegacyQuoteTeamMemberRow extends DataClass
    implements Insertable<LegacyQuoteTeamMemberRow> {
  final String id;
  final String quoteId;
  final String teamMemberId;
  final String roleId;
  final int dailyRate;
  final String? notes;
  final int createdAt;
  final int updatedAt;
  const LegacyQuoteTeamMemberRow({
    required this.id,
    required this.quoteId,
    required this.teamMemberId,
    required this.roleId,
    required this.dailyRate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quote_id'] = Variable<String>(quoteId);
    map['team_member_id'] = Variable<String>(teamMemberId);
    map['role_id'] = Variable<String>(roleId);
    map['daily_rate'] = Variable<int>(dailyRate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LegacyQuoteTeamMembersCompanion toCompanion(bool nullToAbsent) {
    return LegacyQuoteTeamMembersCompanion(
      id: Value(id),
      quoteId: Value(quoteId),
      teamMemberId: Value(teamMemberId),
      roleId: Value(roleId),
      dailyRate: Value(dailyRate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LegacyQuoteTeamMemberRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyQuoteTeamMemberRow(
      id: serializer.fromJson<String>(json['id']),
      quoteId: serializer.fromJson<String>(json['quoteId']),
      teamMemberId: serializer.fromJson<String>(json['teamMemberId']),
      roleId: serializer.fromJson<String>(json['roleId']),
      dailyRate: serializer.fromJson<int>(json['dailyRate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'quoteId': serializer.toJson<String>(quoteId),
      'teamMemberId': serializer.toJson<String>(teamMemberId),
      'roleId': serializer.toJson<String>(roleId),
      'dailyRate': serializer.toJson<int>(dailyRate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LegacyQuoteTeamMemberRow copyWith({
    String? id,
    String? quoteId,
    String? teamMemberId,
    String? roleId,
    int? dailyRate,
    Value<String?> notes = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => LegacyQuoteTeamMemberRow(
    id: id ?? this.id,
    quoteId: quoteId ?? this.quoteId,
    teamMemberId: teamMemberId ?? this.teamMemberId,
    roleId: roleId ?? this.roleId,
    dailyRate: dailyRate ?? this.dailyRate,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LegacyQuoteTeamMemberRow copyWithCompanion(
    LegacyQuoteTeamMembersCompanion data,
  ) {
    return LegacyQuoteTeamMemberRow(
      id: data.id.present ? data.id.value : this.id,
      quoteId: data.quoteId.present ? data.quoteId.value : this.quoteId,
      teamMemberId: data.teamMemberId.present
          ? data.teamMemberId.value
          : this.teamMemberId,
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
      dailyRate: data.dailyRate.present ? data.dailyRate.value : this.dailyRate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteTeamMemberRow(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('teamMemberId: $teamMemberId, ')
          ..write('roleId: $roleId, ')
          ..write('dailyRate: $dailyRate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    quoteId,
    teamMemberId,
    roleId,
    dailyRate,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyQuoteTeamMemberRow &&
          other.id == this.id &&
          other.quoteId == this.quoteId &&
          other.teamMemberId == this.teamMemberId &&
          other.roleId == this.roleId &&
          other.dailyRate == this.dailyRate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LegacyQuoteTeamMembersCompanion
    extends UpdateCompanion<LegacyQuoteTeamMemberRow> {
  final Value<String> id;
  final Value<String> quoteId;
  final Value<String> teamMemberId;
  final Value<String> roleId;
  final Value<int> dailyRate;
  final Value<String?> notes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LegacyQuoteTeamMembersCompanion({
    this.id = const Value.absent(),
    this.quoteId = const Value.absent(),
    this.teamMemberId = const Value.absent(),
    this.roleId = const Value.absent(),
    this.dailyRate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyQuoteTeamMembersCompanion.insert({
    required String id,
    required String quoteId,
    required String teamMemberId,
    required String roleId,
    required int dailyRate,
    this.notes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       quoteId = Value(quoteId),
       teamMemberId = Value(teamMemberId),
       roleId = Value(roleId),
       dailyRate = Value(dailyRate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LegacyQuoteTeamMemberRow> custom({
    Expression<String>? id,
    Expression<String>? quoteId,
    Expression<String>? teamMemberId,
    Expression<String>? roleId,
    Expression<int>? dailyRate,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quoteId != null) 'quote_id': quoteId,
      if (teamMemberId != null) 'team_member_id': teamMemberId,
      if (roleId != null) 'role_id': roleId,
      if (dailyRate != null) 'daily_rate': dailyRate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyQuoteTeamMembersCompanion copyWith({
    Value<String>? id,
    Value<String>? quoteId,
    Value<String>? teamMemberId,
    Value<String>? roleId,
    Value<int>? dailyRate,
    Value<String?>? notes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LegacyQuoteTeamMembersCompanion(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      teamMemberId: teamMemberId ?? this.teamMemberId,
      roleId: roleId ?? this.roleId,
      dailyRate: dailyRate ?? this.dailyRate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (teamMemberId.present) {
      map['team_member_id'] = Variable<String>(teamMemberId.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<String>(roleId.value);
    }
    if (dailyRate.present) {
      map['daily_rate'] = Variable<int>(dailyRate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteTeamMembersCompanion(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('teamMemberId: $teamMemberId, ')
          ..write('roleId: $roleId, ')
          ..write('dailyRate: $dailyRate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyVehicleTypesTable extends LegacyVehicleTypes
    with TableInfo<$LegacyVehicleTypesTable, LegacyVehicleTypeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyVehicleTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    active,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicle_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyVehicleTypeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyVehicleTypeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyVehicleTypeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LegacyVehicleTypesTable createAlias(String alias) {
    return $LegacyVehicleTypesTable(attachedDatabase, alias);
  }
}

class LegacyVehicleTypeRow extends DataClass
    implements Insertable<LegacyVehicleTypeRow> {
  final String id;
  final String name;
  final String? description;
  final bool active;
  final int createdAt;
  final int updatedAt;
  const LegacyVehicleTypeRow({
    required this.id,
    required this.name,
    this.description,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LegacyVehicleTypesCompanion toCompanion(bool nullToAbsent) {
    return LegacyVehicleTypesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LegacyVehicleTypeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyVehicleTypeRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LegacyVehicleTypeRow copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? active,
    int? createdAt,
    int? updatedAt,
  }) => LegacyVehicleTypeRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LegacyVehicleTypeRow copyWithCompanion(LegacyVehicleTypesCompanion data) {
    return LegacyVehicleTypeRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyVehicleTypeRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, active, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyVehicleTypeRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LegacyVehicleTypesCompanion
    extends UpdateCompanion<LegacyVehicleTypeRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> active;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LegacyVehicleTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyVehicleTypesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required bool active,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       active = Value(active),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LegacyVehicleTypeRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? active,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyVehicleTypesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? active,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LegacyVehicleTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyVehicleTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyVehiclesTable extends LegacyVehicles
    with TableInfo<$LegacyVehiclesTable, LegacyVehicleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyVehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plateMeta = const VerificationMeta('plate');
  @override
  late final GeneratedColumn<String> plate = GeneratedColumn<String>(
    'plate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleTypeIdMeta = const VerificationMeta(
    'vehicleTypeId',
  );
  @override
  late final GeneratedColumn<String> vehicleTypeId = GeneratedColumn<String>(
    'vehicle_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicle_types (id) ON UPDATE CASCADE ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _payloadCapacityKgMeta = const VerificationMeta(
    'payloadCapacityKg',
  );
  @override
  late final GeneratedColumn<double> payloadCapacityKg =
      GeneratedColumn<double>(
        'payload_capacity_kg',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _volumeCapacityM3Meta = const VerificationMeta(
    'volumeCapacityM3',
  );
  @override
  late final GeneratedColumn<double> volumeCapacityM3 = GeneratedColumn<double>(
    'volume_capacity_m3',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _observationsMeta = const VerificationMeta(
    'observations',
  );
  @override
  late final GeneratedColumn<String> observations = GeneratedColumn<String>(
    'observations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    plate,
    description,
    vehicleTypeId,
    payloadCapacityKg,
    volumeCapacityM3,
    observations,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyVehicleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plate')) {
      context.handle(
        _plateMeta,
        plate.isAcceptableOrUnknown(data['plate']!, _plateMeta),
      );
    } else if (isInserting) {
      context.missing(_plateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('vehicle_type_id')) {
      context.handle(
        _vehicleTypeIdMeta,
        vehicleTypeId.isAcceptableOrUnknown(
          data['vehicle_type_id']!,
          _vehicleTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vehicleTypeIdMeta);
    }
    if (data.containsKey('payload_capacity_kg')) {
      context.handle(
        _payloadCapacityKgMeta,
        payloadCapacityKg.isAcceptableOrUnknown(
          data['payload_capacity_kg']!,
          _payloadCapacityKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadCapacityKgMeta);
    }
    if (data.containsKey('volume_capacity_m3')) {
      context.handle(
        _volumeCapacityM3Meta,
        volumeCapacityM3.isAcceptableOrUnknown(
          data['volume_capacity_m3']!,
          _volumeCapacityM3Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_volumeCapacityM3Meta);
    }
    if (data.containsKey('observations')) {
      context.handle(
        _observationsMeta,
        observations.isAcceptableOrUnknown(
          data['observations']!,
          _observationsMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyVehicleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyVehicleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      plate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      vehicleTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_type_id'],
      )!,
      payloadCapacityKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}payload_capacity_kg'],
      )!,
      volumeCapacityM3: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volume_capacity_m3'],
      )!,
      observations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observations'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LegacyVehiclesTable createAlias(String alias) {
    return $LegacyVehiclesTable(attachedDatabase, alias);
  }
}

class LegacyVehicleRow extends DataClass
    implements Insertable<LegacyVehicleRow> {
  final String id;
  final String plate;
  final String description;
  final String vehicleTypeId;
  final double payloadCapacityKg;
  final double volumeCapacityM3;
  final String? observations;
  final String status;
  final int createdAt;
  final int updatedAt;
  const LegacyVehicleRow({
    required this.id,
    required this.plate,
    required this.description,
    required this.vehicleTypeId,
    required this.payloadCapacityKg,
    required this.volumeCapacityM3,
    this.observations,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plate'] = Variable<String>(plate);
    map['description'] = Variable<String>(description);
    map['vehicle_type_id'] = Variable<String>(vehicleTypeId);
    map['payload_capacity_kg'] = Variable<double>(payloadCapacityKg);
    map['volume_capacity_m3'] = Variable<double>(volumeCapacityM3);
    if (!nullToAbsent || observations != null) {
      map['observations'] = Variable<String>(observations);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LegacyVehiclesCompanion toCompanion(bool nullToAbsent) {
    return LegacyVehiclesCompanion(
      id: Value(id),
      plate: Value(plate),
      description: Value(description),
      vehicleTypeId: Value(vehicleTypeId),
      payloadCapacityKg: Value(payloadCapacityKg),
      volumeCapacityM3: Value(volumeCapacityM3),
      observations: observations == null && nullToAbsent
          ? const Value.absent()
          : Value(observations),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LegacyVehicleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyVehicleRow(
      id: serializer.fromJson<String>(json['id']),
      plate: serializer.fromJson<String>(json['plate']),
      description: serializer.fromJson<String>(json['description']),
      vehicleTypeId: serializer.fromJson<String>(json['vehicleTypeId']),
      payloadCapacityKg: serializer.fromJson<double>(json['payloadCapacityKg']),
      volumeCapacityM3: serializer.fromJson<double>(json['volumeCapacityM3']),
      observations: serializer.fromJson<String?>(json['observations']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'plate': serializer.toJson<String>(plate),
      'description': serializer.toJson<String>(description),
      'vehicleTypeId': serializer.toJson<String>(vehicleTypeId),
      'payloadCapacityKg': serializer.toJson<double>(payloadCapacityKg),
      'volumeCapacityM3': serializer.toJson<double>(volumeCapacityM3),
      'observations': serializer.toJson<String?>(observations),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LegacyVehicleRow copyWith({
    String? id,
    String? plate,
    String? description,
    String? vehicleTypeId,
    double? payloadCapacityKg,
    double? volumeCapacityM3,
    Value<String?> observations = const Value.absent(),
    String? status,
    int? createdAt,
    int? updatedAt,
  }) => LegacyVehicleRow(
    id: id ?? this.id,
    plate: plate ?? this.plate,
    description: description ?? this.description,
    vehicleTypeId: vehicleTypeId ?? this.vehicleTypeId,
    payloadCapacityKg: payloadCapacityKg ?? this.payloadCapacityKg,
    volumeCapacityM3: volumeCapacityM3 ?? this.volumeCapacityM3,
    observations: observations.present ? observations.value : this.observations,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LegacyVehicleRow copyWithCompanion(LegacyVehiclesCompanion data) {
    return LegacyVehicleRow(
      id: data.id.present ? data.id.value : this.id,
      plate: data.plate.present ? data.plate.value : this.plate,
      description: data.description.present
          ? data.description.value
          : this.description,
      vehicleTypeId: data.vehicleTypeId.present
          ? data.vehicleTypeId.value
          : this.vehicleTypeId,
      payloadCapacityKg: data.payloadCapacityKg.present
          ? data.payloadCapacityKg.value
          : this.payloadCapacityKg,
      volumeCapacityM3: data.volumeCapacityM3.present
          ? data.volumeCapacityM3.value
          : this.volumeCapacityM3,
      observations: data.observations.present
          ? data.observations.value
          : this.observations,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyVehicleRow(')
          ..write('id: $id, ')
          ..write('plate: $plate, ')
          ..write('description: $description, ')
          ..write('vehicleTypeId: $vehicleTypeId, ')
          ..write('payloadCapacityKg: $payloadCapacityKg, ')
          ..write('volumeCapacityM3: $volumeCapacityM3, ')
          ..write('observations: $observations, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    plate,
    description,
    vehicleTypeId,
    payloadCapacityKg,
    volumeCapacityM3,
    observations,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyVehicleRow &&
          other.id == this.id &&
          other.plate == this.plate &&
          other.description == this.description &&
          other.vehicleTypeId == this.vehicleTypeId &&
          other.payloadCapacityKg == this.payloadCapacityKg &&
          other.volumeCapacityM3 == this.volumeCapacityM3 &&
          other.observations == this.observations &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LegacyVehiclesCompanion extends UpdateCompanion<LegacyVehicleRow> {
  final Value<String> id;
  final Value<String> plate;
  final Value<String> description;
  final Value<String> vehicleTypeId;
  final Value<double> payloadCapacityKg;
  final Value<double> volumeCapacityM3;
  final Value<String?> observations;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LegacyVehiclesCompanion({
    this.id = const Value.absent(),
    this.plate = const Value.absent(),
    this.description = const Value.absent(),
    this.vehicleTypeId = const Value.absent(),
    this.payloadCapacityKg = const Value.absent(),
    this.volumeCapacityM3 = const Value.absent(),
    this.observations = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyVehiclesCompanion.insert({
    required String id,
    required String plate,
    required String description,
    required String vehicleTypeId,
    required double payloadCapacityKg,
    required double volumeCapacityM3,
    this.observations = const Value.absent(),
    required String status,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       plate = Value(plate),
       description = Value(description),
       vehicleTypeId = Value(vehicleTypeId),
       payloadCapacityKg = Value(payloadCapacityKg),
       volumeCapacityM3 = Value(volumeCapacityM3),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LegacyVehicleRow> custom({
    Expression<String>? id,
    Expression<String>? plate,
    Expression<String>? description,
    Expression<String>? vehicleTypeId,
    Expression<double>? payloadCapacityKg,
    Expression<double>? volumeCapacityM3,
    Expression<String>? observations,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plate != null) 'plate': plate,
      if (description != null) 'description': description,
      if (vehicleTypeId != null) 'vehicle_type_id': vehicleTypeId,
      if (payloadCapacityKg != null) 'payload_capacity_kg': payloadCapacityKg,
      if (volumeCapacityM3 != null) 'volume_capacity_m3': volumeCapacityM3,
      if (observations != null) 'observations': observations,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyVehiclesCompanion copyWith({
    Value<String>? id,
    Value<String>? plate,
    Value<String>? description,
    Value<String>? vehicleTypeId,
    Value<double>? payloadCapacityKg,
    Value<double>? volumeCapacityM3,
    Value<String?>? observations,
    Value<String>? status,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LegacyVehiclesCompanion(
      id: id ?? this.id,
      plate: plate ?? this.plate,
      description: description ?? this.description,
      vehicleTypeId: vehicleTypeId ?? this.vehicleTypeId,
      payloadCapacityKg: payloadCapacityKg ?? this.payloadCapacityKg,
      volumeCapacityM3: volumeCapacityM3 ?? this.volumeCapacityM3,
      observations: observations ?? this.observations,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (plate.present) {
      map['plate'] = Variable<String>(plate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (vehicleTypeId.present) {
      map['vehicle_type_id'] = Variable<String>(vehicleTypeId.value);
    }
    if (payloadCapacityKg.present) {
      map['payload_capacity_kg'] = Variable<double>(payloadCapacityKg.value);
    }
    if (volumeCapacityM3.present) {
      map['volume_capacity_m3'] = Variable<double>(volumeCapacityM3.value);
    }
    if (observations.present) {
      map['observations'] = Variable<String>(observations.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyVehiclesCompanion(')
          ..write('id: $id, ')
          ..write('plate: $plate, ')
          ..write('description: $description, ')
          ..write('vehicleTypeId: $vehicleTypeId, ')
          ..write('payloadCapacityKg: $payloadCapacityKg, ')
          ..write('volumeCapacityM3: $volumeCapacityM3, ')
          ..write('observations: $observations, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyQuoteVehiclesTable extends LegacyQuoteVehicles
    with TableInfo<$LegacyQuoteVehiclesTable, LegacyQuoteVehicleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyQuoteVehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quotes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _driverTeamMemberIdMeta =
      const VerificationMeta('driverTeamMemberId');
  @override
  late final GeneratedColumn<String> driverTeamMemberId =
      GeneratedColumn<String>(
        'driver_team_member_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES team_members (id) ON DELETE RESTRICT',
        ),
      );
  static const VerificationMeta _plannedDepartureAtMeta =
      const VerificationMeta('plannedDepartureAt');
  @override
  late final GeneratedColumn<int> plannedDepartureAt = GeneratedColumn<int>(
    'planned_departure_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedReturnAtMeta = const VerificationMeta(
    'plannedReturnAt',
  );
  @override
  late final GeneratedColumn<int> plannedReturnAt = GeneratedColumn<int>(
    'planned_return_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _freightCostCentsMeta = const VerificationMeta(
    'freightCostCents',
  );
  @override
  late final GeneratedColumn<int> freightCostCents = GeneratedColumn<int>(
    'freight_cost_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    quoteId,
    vehicleId,
    driverTeamMemberId,
    plannedDepartureAt,
    plannedReturnAt,
    freightCostCents,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote_vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyQuoteVehicleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('driver_team_member_id')) {
      context.handle(
        _driverTeamMemberIdMeta,
        driverTeamMemberId.isAcceptableOrUnknown(
          data['driver_team_member_id']!,
          _driverTeamMemberIdMeta,
        ),
      );
    }
    if (data.containsKey('planned_departure_at')) {
      context.handle(
        _plannedDepartureAtMeta,
        plannedDepartureAt.isAcceptableOrUnknown(
          data['planned_departure_at']!,
          _plannedDepartureAtMeta,
        ),
      );
    }
    if (data.containsKey('planned_return_at')) {
      context.handle(
        _plannedReturnAtMeta,
        plannedReturnAt.isAcceptableOrUnknown(
          data['planned_return_at']!,
          _plannedReturnAtMeta,
        ),
      );
    }
    if (data.containsKey('freight_cost_cents')) {
      context.handle(
        _freightCostCentsMeta,
        freightCostCents.isAcceptableOrUnknown(
          data['freight_cost_cents']!,
          _freightCostCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_freightCostCentsMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegacyQuoteVehicleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyQuoteVehicleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      driverTeamMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}driver_team_member_id'],
      ),
      plannedDepartureAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_departure_at'],
      ),
      plannedReturnAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_return_at'],
      ),
      freightCostCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}freight_cost_cents'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LegacyQuoteVehiclesTable createAlias(String alias) {
    return $LegacyQuoteVehiclesTable(attachedDatabase, alias);
  }
}

class LegacyQuoteVehicleRow extends DataClass
    implements Insertable<LegacyQuoteVehicleRow> {
  final String id;
  final String quoteId;
  final String vehicleId;
  final String? driverTeamMemberId;
  final int? plannedDepartureAt;
  final int? plannedReturnAt;
  final int freightCostCents;
  final String? notes;
  final int createdAt;
  final int updatedAt;
  const LegacyQuoteVehicleRow({
    required this.id,
    required this.quoteId,
    required this.vehicleId,
    this.driverTeamMemberId,
    this.plannedDepartureAt,
    this.plannedReturnAt,
    required this.freightCostCents,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quote_id'] = Variable<String>(quoteId);
    map['vehicle_id'] = Variable<String>(vehicleId);
    if (!nullToAbsent || driverTeamMemberId != null) {
      map['driver_team_member_id'] = Variable<String>(driverTeamMemberId);
    }
    if (!nullToAbsent || plannedDepartureAt != null) {
      map['planned_departure_at'] = Variable<int>(plannedDepartureAt);
    }
    if (!nullToAbsent || plannedReturnAt != null) {
      map['planned_return_at'] = Variable<int>(plannedReturnAt);
    }
    map['freight_cost_cents'] = Variable<int>(freightCostCents);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LegacyQuoteVehiclesCompanion toCompanion(bool nullToAbsent) {
    return LegacyQuoteVehiclesCompanion(
      id: Value(id),
      quoteId: Value(quoteId),
      vehicleId: Value(vehicleId),
      driverTeamMemberId: driverTeamMemberId == null && nullToAbsent
          ? const Value.absent()
          : Value(driverTeamMemberId),
      plannedDepartureAt: plannedDepartureAt == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedDepartureAt),
      plannedReturnAt: plannedReturnAt == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedReturnAt),
      freightCostCents: Value(freightCostCents),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LegacyQuoteVehicleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyQuoteVehicleRow(
      id: serializer.fromJson<String>(json['id']),
      quoteId: serializer.fromJson<String>(json['quoteId']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      driverTeamMemberId: serializer.fromJson<String?>(
        json['driverTeamMemberId'],
      ),
      plannedDepartureAt: serializer.fromJson<int?>(json['plannedDepartureAt']),
      plannedReturnAt: serializer.fromJson<int?>(json['plannedReturnAt']),
      freightCostCents: serializer.fromJson<int>(json['freightCostCents']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'quoteId': serializer.toJson<String>(quoteId),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'driverTeamMemberId': serializer.toJson<String?>(driverTeamMemberId),
      'plannedDepartureAt': serializer.toJson<int?>(plannedDepartureAt),
      'plannedReturnAt': serializer.toJson<int?>(plannedReturnAt),
      'freightCostCents': serializer.toJson<int>(freightCostCents),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LegacyQuoteVehicleRow copyWith({
    String? id,
    String? quoteId,
    String? vehicleId,
    Value<String?> driverTeamMemberId = const Value.absent(),
    Value<int?> plannedDepartureAt = const Value.absent(),
    Value<int?> plannedReturnAt = const Value.absent(),
    int? freightCostCents,
    Value<String?> notes = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => LegacyQuoteVehicleRow(
    id: id ?? this.id,
    quoteId: quoteId ?? this.quoteId,
    vehicleId: vehicleId ?? this.vehicleId,
    driverTeamMemberId: driverTeamMemberId.present
        ? driverTeamMemberId.value
        : this.driverTeamMemberId,
    plannedDepartureAt: plannedDepartureAt.present
        ? plannedDepartureAt.value
        : this.plannedDepartureAt,
    plannedReturnAt: plannedReturnAt.present
        ? plannedReturnAt.value
        : this.plannedReturnAt,
    freightCostCents: freightCostCents ?? this.freightCostCents,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LegacyQuoteVehicleRow copyWithCompanion(LegacyQuoteVehiclesCompanion data) {
    return LegacyQuoteVehicleRow(
      id: data.id.present ? data.id.value : this.id,
      quoteId: data.quoteId.present ? data.quoteId.value : this.quoteId,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      driverTeamMemberId: data.driverTeamMemberId.present
          ? data.driverTeamMemberId.value
          : this.driverTeamMemberId,
      plannedDepartureAt: data.plannedDepartureAt.present
          ? data.plannedDepartureAt.value
          : this.plannedDepartureAt,
      plannedReturnAt: data.plannedReturnAt.present
          ? data.plannedReturnAt.value
          : this.plannedReturnAt,
      freightCostCents: data.freightCostCents.present
          ? data.freightCostCents.value
          : this.freightCostCents,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteVehicleRow(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('driverTeamMemberId: $driverTeamMemberId, ')
          ..write('plannedDepartureAt: $plannedDepartureAt, ')
          ..write('plannedReturnAt: $plannedReturnAt, ')
          ..write('freightCostCents: $freightCostCents, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    quoteId,
    vehicleId,
    driverTeamMemberId,
    plannedDepartureAt,
    plannedReturnAt,
    freightCostCents,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyQuoteVehicleRow &&
          other.id == this.id &&
          other.quoteId == this.quoteId &&
          other.vehicleId == this.vehicleId &&
          other.driverTeamMemberId == this.driverTeamMemberId &&
          other.plannedDepartureAt == this.plannedDepartureAt &&
          other.plannedReturnAt == this.plannedReturnAt &&
          other.freightCostCents == this.freightCostCents &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LegacyQuoteVehiclesCompanion
    extends UpdateCompanion<LegacyQuoteVehicleRow> {
  final Value<String> id;
  final Value<String> quoteId;
  final Value<String> vehicleId;
  final Value<String?> driverTeamMemberId;
  final Value<int?> plannedDepartureAt;
  final Value<int?> plannedReturnAt;
  final Value<int> freightCostCents;
  final Value<String?> notes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LegacyQuoteVehiclesCompanion({
    this.id = const Value.absent(),
    this.quoteId = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.driverTeamMemberId = const Value.absent(),
    this.plannedDepartureAt = const Value.absent(),
    this.plannedReturnAt = const Value.absent(),
    this.freightCostCents = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyQuoteVehiclesCompanion.insert({
    required String id,
    required String quoteId,
    required String vehicleId,
    this.driverTeamMemberId = const Value.absent(),
    this.plannedDepartureAt = const Value.absent(),
    this.plannedReturnAt = const Value.absent(),
    required int freightCostCents,
    this.notes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       quoteId = Value(quoteId),
       vehicleId = Value(vehicleId),
       freightCostCents = Value(freightCostCents),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LegacyQuoteVehicleRow> custom({
    Expression<String>? id,
    Expression<String>? quoteId,
    Expression<String>? vehicleId,
    Expression<String>? driverTeamMemberId,
    Expression<int>? plannedDepartureAt,
    Expression<int>? plannedReturnAt,
    Expression<int>? freightCostCents,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quoteId != null) 'quote_id': quoteId,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (driverTeamMemberId != null)
        'driver_team_member_id': driverTeamMemberId,
      if (plannedDepartureAt != null)
        'planned_departure_at': plannedDepartureAt,
      if (plannedReturnAt != null) 'planned_return_at': plannedReturnAt,
      if (freightCostCents != null) 'freight_cost_cents': freightCostCents,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyQuoteVehiclesCompanion copyWith({
    Value<String>? id,
    Value<String>? quoteId,
    Value<String>? vehicleId,
    Value<String?>? driverTeamMemberId,
    Value<int?>? plannedDepartureAt,
    Value<int?>? plannedReturnAt,
    Value<int>? freightCostCents,
    Value<String?>? notes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LegacyQuoteVehiclesCompanion(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      vehicleId: vehicleId ?? this.vehicleId,
      driverTeamMemberId: driverTeamMemberId ?? this.driverTeamMemberId,
      plannedDepartureAt: plannedDepartureAt ?? this.plannedDepartureAt,
      plannedReturnAt: plannedReturnAt ?? this.plannedReturnAt,
      freightCostCents: freightCostCents ?? this.freightCostCents,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (driverTeamMemberId.present) {
      map['driver_team_member_id'] = Variable<String>(driverTeamMemberId.value);
    }
    if (plannedDepartureAt.present) {
      map['planned_departure_at'] = Variable<int>(plannedDepartureAt.value);
    }
    if (plannedReturnAt.present) {
      map['planned_return_at'] = Variable<int>(plannedReturnAt.value);
    }
    if (freightCostCents.present) {
      map['freight_cost_cents'] = Variable<int>(freightCostCents.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyQuoteVehiclesCompanion(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('driverTeamMemberId: $driverTeamMemberId, ')
          ..write('plannedDepartureAt: $plannedDepartureAt, ')
          ..write('plannedReturnAt: $plannedReturnAt, ')
          ..write('freightCostCents: $freightCostCents, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LegacyAppDatabaseV10 extends GeneratedDatabase {
  _$LegacyAppDatabaseV10(QueryExecutor e) : super(e);
  $LegacyAppDatabaseV10Manager get managers =>
      $LegacyAppDatabaseV10Manager(this);
  late final $LegacyClientsTable legacyClients = $LegacyClientsTable(this);
  late final $LegacyCatalogItemsTable legacyCatalogItems =
      $LegacyCatalogItemsTable(this);
  late final $LegacyCatalogPackageComponentsTable
  legacyCatalogPackageComponents = $LegacyCatalogPackageComponentsTable(this);
  late final $LegacyCompanyProfilesTable legacyCompanyProfiles =
      $LegacyCompanyProfilesTable(this);
  late final $LegacyQuotesTable legacyQuotes = $LegacyQuotesTable(this);
  late final $LegacyQuoteClientSnapshotsTable legacyQuoteClientSnapshots =
      $LegacyQuoteClientSnapshotsTable(this);
  late final $LegacyQuoteEventSnapshotsTable legacyQuoteEventSnapshots =
      $LegacyQuoteEventSnapshotsTable(this);
  late final $LegacyQuoteCompanySnapshotsTable legacyQuoteCompanySnapshots =
      $LegacyQuoteCompanySnapshotsTable(this);
  late final $LegacyQuoteLineItemsTable legacyQuoteLineItems =
      $LegacyQuoteLineItemsTable(this);
  late final $LegacyQuoteLinePackageComponentsTable
  legacyQuoteLinePackageComponents = $LegacyQuoteLinePackageComponentsTable(
    this,
  );
  late final $LegacyQuoteStatusHistoryTable legacyQuoteStatusHistory =
      $LegacyQuoteStatusHistoryTable(this);
  late final $LegacyQuoteNumberSequencesTable legacyQuoteNumberSequences =
      $LegacyQuoteNumberSequencesTable(this);
  late final $LegacyAgendaBlocksTable legacyAgendaBlocks =
      $LegacyAgendaBlocksTable(this);
  late final $LegacyFinancialCategoriesTable legacyFinancialCategories =
      $LegacyFinancialCategoriesTable(this);
  late final $LegacyFinancialEntriesTable legacyFinancialEntries =
      $LegacyFinancialEntriesTable(this);
  late final $LegacyEquipmentCategoriesTable legacyEquipmentCategories =
      $LegacyEquipmentCategoriesTable(this);
  late final $LegacyEquipmentsTable legacyEquipments = $LegacyEquipmentsTable(
    this,
  );
  late final $LegacyQuoteEquipmentItemsTable legacyQuoteEquipmentItems =
      $LegacyQuoteEquipmentItemsTable(this);
  late final $LegacyTeamRolesTable legacyTeamRoles = $LegacyTeamRolesTable(
    this,
  );
  late final $LegacyTeamMembersTable legacyTeamMembers =
      $LegacyTeamMembersTable(this);
  late final $LegacyQuoteTeamMembersTable legacyQuoteTeamMembers =
      $LegacyQuoteTeamMembersTable(this);
  late final $LegacyVehicleTypesTable legacyVehicleTypes =
      $LegacyVehicleTypesTable(this);
  late final $LegacyVehiclesTable legacyVehicles = $LegacyVehiclesTable(this);
  late final $LegacyQuoteVehiclesTable legacyQuoteVehicles =
      $LegacyQuoteVehiclesTable(this);
  late final Index idxClientsCreatedAt = Index(
    'idx_clients_created_at',
    'CREATE INDEX idx_clients_created_at ON clients (created_at)',
  );
  late final Index idxCatalogItemsActive = Index(
    'idx_catalog_items_active',
    'CREATE INDEX idx_catalog_items_active ON catalog_items (active)',
  );
  late final Index idxCatalogItemsType = Index(
    'idx_catalog_items_type',
    'CREATE INDEX idx_catalog_items_type ON catalog_items (type)',
  );
  late final Index idxPkgComponentsComponent = Index(
    'idx_pkg_components_component',
    'CREATE INDEX idx_pkg_components_component ON catalog_package_components (component_item_id)',
  );
  late final Index idxQuotesNumber = Index(
    'idx_quotes_number',
    'CREATE UNIQUE INDEX idx_quotes_number ON quotes (number)',
  );
  late final Index idxQuotesStatus = Index(
    'idx_quotes_status',
    'CREATE INDEX idx_quotes_status ON quotes (status)',
  );
  late final Index idxQuotesCreatedAt = Index(
    'idx_quotes_created_at',
    'CREATE INDEX idx_quotes_created_at ON quotes (created_at)',
  );
  late final Index idxQuotesUpdatedAt = Index(
    'idx_quotes_updated_at',
    'CREATE INDEX idx_quotes_updated_at ON quotes (updated_at)',
  );
  late final Index idxQuoteLinesQuoteOrder = Index(
    'idx_quote_lines_quote_order',
    'CREATE INDEX idx_quote_lines_quote_order ON quote_line_items (quote_id, sort_order)',
  );
  late final Index idxQuotePkgLine = Index(
    'idx_quote_pkg_line',
    'CREATE INDEX idx_quote_pkg_line ON quote_line_package_components (line_item_id, sort_order)',
  );
  late final Index idxQuoteHistoryQuoteOrder = Index(
    'idx_quote_history_quote_order',
    'CREATE INDEX idx_quote_history_quote_order ON quote_status_history (quote_id, sort_order)',
  );
  late final Index idxAgendaBlocksStart = Index(
    'idx_agenda_blocks_start',
    'CREATE INDEX idx_agenda_blocks_start ON agenda_blocks (start)',
  );
  late final Index idxAgendaBlocksEnd = Index(
    'idx_agenda_blocks_end',
    'CREATE INDEX idx_agenda_blocks_end ON agenda_blocks ("end")',
  );
  late final Index idxFinancialCategoriesKind = Index(
    'idx_financial_categories_kind',
    'CREATE INDEX idx_financial_categories_kind ON financial_categories (kind)',
  );
  late final Index idxFinancialEntriesDate = Index(
    'idx_financial_entries_date',
    'CREATE INDEX idx_financial_entries_date ON financial_entries (date)',
  );
  late final Index idxFinancialEntriesKind = Index(
    'idx_financial_entries_kind',
    'CREATE INDEX idx_financial_entries_kind ON financial_entries (kind)',
  );
  late final Index idxFinancialEntriesQuoteId = Index(
    'idx_financial_entries_quote_id',
    'CREATE INDEX idx_financial_entries_quote_id ON financial_entries (quote_id)',
  );
  late final Index idxEquipmentCategoriesName = Index(
    'idx_equipment_categories_name',
    'CREATE INDEX idx_equipment_categories_name ON equipment_categories (name)',
  );
  late final Index idxEquipmentCategoryId = Index(
    'idx_equipment_category_id',
    'CREATE INDEX idx_equipment_category_id ON equipment (category_id)',
  );
  late final Index idxEquipmentStatus = Index(
    'idx_equipment_status',
    'CREATE INDEX idx_equipment_status ON equipment (status)',
  );
  late final Index idxQuoteEquipmentQuoteId = Index(
    'idx_quote_equipment_quote_id',
    'CREATE INDEX idx_quote_equipment_quote_id ON quote_equipment (quote_id)',
  );
  late final Index idxQuoteEquipmentEquipmentId = Index(
    'idx_quote_equipment_equipment_id',
    'CREATE INDEX idx_quote_equipment_equipment_id ON quote_equipment (equipment_id)',
  );
  late final Index idxTeamRolesName = Index(
    'idx_team_roles_name',
    'CREATE INDEX idx_team_roles_name ON team_roles (name)',
  );
  late final Index idxTeamMembersRoleId = Index(
    'idx_team_members_role_id',
    'CREATE INDEX idx_team_members_role_id ON team_members (role_id)',
  );
  late final Index idxTeamMembersStatus = Index(
    'idx_team_members_status',
    'CREATE INDEX idx_team_members_status ON team_members (status)',
  );
  late final Index idxQuoteTeamMembersQuoteId = Index(
    'idx_quote_team_members_quote_id',
    'CREATE INDEX idx_quote_team_members_quote_id ON quote_team_members (quote_id)',
  );
  late final Index idxQuoteTeamMembersTeamMemberId = Index(
    'idx_quote_team_members_team_member_id',
    'CREATE INDEX idx_quote_team_members_team_member_id ON quote_team_members (team_member_id)',
  );
  late final Index idxQuoteTeamMembersRoleId = Index(
    'idx_quote_team_members_role_id',
    'CREATE INDEX idx_quote_team_members_role_id ON quote_team_members (role_id)',
  );
  late final Index idxVehicleTypesName = Index(
    'idx_vehicle_types_name',
    'CREATE INDEX idx_vehicle_types_name ON vehicle_types (name)',
  );
  late final Index idxVehiclesTypeId = Index(
    'idx_vehicles_type_id',
    'CREATE INDEX idx_vehicles_type_id ON vehicles (vehicle_type_id)',
  );
  late final Index idxVehiclesStatus = Index(
    'idx_vehicles_status',
    'CREATE INDEX idx_vehicles_status ON vehicles (status)',
  );
  late final Index idxVehiclesPlate = Index(
    'idx_vehicles_plate',
    'CREATE INDEX idx_vehicles_plate ON vehicles (plate)',
  );
  late final Index idxQuoteVehiclesQuoteId = Index(
    'idx_quote_vehicles_quote_id',
    'CREATE INDEX idx_quote_vehicles_quote_id ON quote_vehicles (quote_id)',
  );
  late final Index idxQuoteVehiclesVehicleId = Index(
    'idx_quote_vehicles_vehicle_id',
    'CREATE INDEX idx_quote_vehicles_vehicle_id ON quote_vehicles (vehicle_id)',
  );
  late final Index idxQuoteVehiclesDriverId = Index(
    'idx_quote_vehicles_driver_id',
    'CREATE INDEX idx_quote_vehicles_driver_id ON quote_vehicles (driver_team_member_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    legacyClients,
    legacyCatalogItems,
    legacyCatalogPackageComponents,
    legacyCompanyProfiles,
    legacyQuotes,
    legacyQuoteClientSnapshots,
    legacyQuoteEventSnapshots,
    legacyQuoteCompanySnapshots,
    legacyQuoteLineItems,
    legacyQuoteLinePackageComponents,
    legacyQuoteStatusHistory,
    legacyQuoteNumberSequences,
    legacyAgendaBlocks,
    legacyFinancialCategories,
    legacyFinancialEntries,
    legacyEquipmentCategories,
    legacyEquipments,
    legacyQuoteEquipmentItems,
    legacyTeamRoles,
    legacyTeamMembers,
    legacyQuoteTeamMembers,
    legacyVehicleTypes,
    legacyVehicles,
    legacyQuoteVehicles,
    idxClientsCreatedAt,
    idxCatalogItemsActive,
    idxCatalogItemsType,
    idxPkgComponentsComponent,
    idxQuotesNumber,
    idxQuotesStatus,
    idxQuotesCreatedAt,
    idxQuotesUpdatedAt,
    idxQuoteLinesQuoteOrder,
    idxQuotePkgLine,
    idxQuoteHistoryQuoteOrder,
    idxAgendaBlocksStart,
    idxAgendaBlocksEnd,
    idxFinancialCategoriesKind,
    idxFinancialEntriesDate,
    idxFinancialEntriesKind,
    idxFinancialEntriesQuoteId,
    idxEquipmentCategoriesName,
    idxEquipmentCategoryId,
    idxEquipmentStatus,
    idxQuoteEquipmentQuoteId,
    idxQuoteEquipmentEquipmentId,
    idxTeamRolesName,
    idxTeamMembersRoleId,
    idxTeamMembersStatus,
    idxQuoteTeamMembersQuoteId,
    idxQuoteTeamMembersTeamMemberId,
    idxQuoteTeamMembersRoleId,
    idxVehicleTypesName,
    idxVehiclesTypeId,
    idxVehiclesStatus,
    idxVehiclesPlate,
    idxQuoteVehiclesQuoteId,
    idxQuoteVehiclesVehicleId,
    idxQuoteVehiclesDriverId,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'catalog_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('catalog_package_components', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quotes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quote_client_snapshots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quotes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quote_event_snapshots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quotes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quote_company_snapshots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quotes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quote_line_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quote_line_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('quote_line_package_components', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quotes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quote_status_history', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quotes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('financial_entries', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quotes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quote_equipment', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'team_roles',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('team_members', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quotes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quote_team_members', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicle_types',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('vehicles', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quotes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quote_vehicles', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$LegacyClientsTableCreateCompanionBuilder =
    LegacyClientsCompanion Function({
      required String id,
      required int createdAt,
      required String type,
      required String name,
      Value<String?> tradeName,
      Value<String?> phoneDigits,
      Value<String?> whatsappDigits,
      Value<String?> email,
      Value<String?> documentDigits,
      Value<String?> instagram,
      Value<String?> birthday,
      Value<String?> internalNotes,
      Value<String?> postalCode,
      Value<String?> street,
      Value<String?> number,
      Value<String?> complement,
      Value<String?> neighborhood,
      Value<String?> city,
      Value<String?> state,
      Value<int> rowid,
    });
typedef $$LegacyClientsTableUpdateCompanionBuilder =
    LegacyClientsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<String> type,
      Value<String> name,
      Value<String?> tradeName,
      Value<String?> phoneDigits,
      Value<String?> whatsappDigits,
      Value<String?> email,
      Value<String?> documentDigits,
      Value<String?> instagram,
      Value<String?> birthday,
      Value<String?> internalNotes,
      Value<String?> postalCode,
      Value<String?> street,
      Value<String?> number,
      Value<String?> complement,
      Value<String?> neighborhood,
      Value<String?> city,
      Value<String?> state,
      Value<int> rowid,
    });

class $$LegacyClientsTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyClientsTable> {
  $$LegacyClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tradeName => $composableBuilder(
    column: $table.tradeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneDigits => $composableBuilder(
    column: $table.phoneDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatsappDigits => $composableBuilder(
    column: $table.whatsappDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentDigits => $composableBuilder(
    column: $table.documentDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instagram => $composableBuilder(
    column: $table.instagram,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get complement => $composableBuilder(
    column: $table.complement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get neighborhood => $composableBuilder(
    column: $table.neighborhood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegacyClientsTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyClientsTable> {
  $$LegacyClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tradeName => $composableBuilder(
    column: $table.tradeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneDigits => $composableBuilder(
    column: $table.phoneDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatsappDigits => $composableBuilder(
    column: $table.whatsappDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentDigits => $composableBuilder(
    column: $table.documentDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instagram => $composableBuilder(
    column: $table.instagram,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get complement => $composableBuilder(
    column: $table.complement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get neighborhood => $composableBuilder(
    column: $table.neighborhood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegacyClientsTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyClientsTable> {
  $$LegacyClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get tradeName =>
      $composableBuilder(column: $table.tradeName, builder: (column) => column);

  GeneratedColumn<String> get phoneDigits => $composableBuilder(
    column: $table.phoneDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get whatsappDigits => $composableBuilder(
    column: $table.whatsappDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get documentDigits => $composableBuilder(
    column: $table.documentDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instagram =>
      $composableBuilder(column: $table.instagram, builder: (column) => column);

  GeneratedColumn<String> get birthday =>
      $composableBuilder(column: $table.birthday, builder: (column) => column);

  GeneratedColumn<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get street =>
      $composableBuilder(column: $table.street, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get complement => $composableBuilder(
    column: $table.complement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get neighborhood => $composableBuilder(
    column: $table.neighborhood,
    builder: (column) => column,
  );

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);
}

class $$LegacyClientsTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyClientsTable,
          LegacyClientRow,
          $$LegacyClientsTableFilterComposer,
          $$LegacyClientsTableOrderingComposer,
          $$LegacyClientsTableAnnotationComposer,
          $$LegacyClientsTableCreateCompanionBuilder,
          $$LegacyClientsTableUpdateCompanionBuilder,
          (
            LegacyClientRow,
            BaseReferences<
              _$LegacyAppDatabaseV10,
              $LegacyClientsTable,
              LegacyClientRow
            >,
          ),
          LegacyClientRow,
          PrefetchHooks Function()
        > {
  $$LegacyClientsTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyClientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegacyClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegacyClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> tradeName = const Value.absent(),
                Value<String?> phoneDigits = const Value.absent(),
                Value<String?> whatsappDigits = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> documentDigits = const Value.absent(),
                Value<String?> instagram = const Value.absent(),
                Value<String?> birthday = const Value.absent(),
                Value<String?> internalNotes = const Value.absent(),
                Value<String?> postalCode = const Value.absent(),
                Value<String?> street = const Value.absent(),
                Value<String?> number = const Value.absent(),
                Value<String?> complement = const Value.absent(),
                Value<String?> neighborhood = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyClientsCompanion(
                id: id,
                createdAt: createdAt,
                type: type,
                name: name,
                tradeName: tradeName,
                phoneDigits: phoneDigits,
                whatsappDigits: whatsappDigits,
                email: email,
                documentDigits: documentDigits,
                instagram: instagram,
                birthday: birthday,
                internalNotes: internalNotes,
                postalCode: postalCode,
                street: street,
                number: number,
                complement: complement,
                neighborhood: neighborhood,
                city: city,
                state: state,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required String type,
                required String name,
                Value<String?> tradeName = const Value.absent(),
                Value<String?> phoneDigits = const Value.absent(),
                Value<String?> whatsappDigits = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> documentDigits = const Value.absent(),
                Value<String?> instagram = const Value.absent(),
                Value<String?> birthday = const Value.absent(),
                Value<String?> internalNotes = const Value.absent(),
                Value<String?> postalCode = const Value.absent(),
                Value<String?> street = const Value.absent(),
                Value<String?> number = const Value.absent(),
                Value<String?> complement = const Value.absent(),
                Value<String?> neighborhood = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyClientsCompanion.insert(
                id: id,
                createdAt: createdAt,
                type: type,
                name: name,
                tradeName: tradeName,
                phoneDigits: phoneDigits,
                whatsappDigits: whatsappDigits,
                email: email,
                documentDigits: documentDigits,
                instagram: instagram,
                birthday: birthday,
                internalNotes: internalNotes,
                postalCode: postalCode,
                street: street,
                number: number,
                complement: complement,
                neighborhood: neighborhood,
                city: city,
                state: state,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegacyClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyClientsTable,
      LegacyClientRow,
      $$LegacyClientsTableFilterComposer,
      $$LegacyClientsTableOrderingComposer,
      $$LegacyClientsTableAnnotationComposer,
      $$LegacyClientsTableCreateCompanionBuilder,
      $$LegacyClientsTableUpdateCompanionBuilder,
      (
        LegacyClientRow,
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyClientsTable,
          LegacyClientRow
        >,
      ),
      LegacyClientRow,
      PrefetchHooks Function()
    >;
typedef $$LegacyCatalogItemsTableCreateCompanionBuilder =
    LegacyCatalogItemsCompanion Function({
      required String id,
      required int createdAt,
      required String type,
      required String name,
      required String category,
      Value<String?> description,
      required String unit,
      required int priceCents,
      required bool active,
      Value<String?> imageReference,
      Value<int> rowid,
    });
typedef $$LegacyCatalogItemsTableUpdateCompanionBuilder =
    LegacyCatalogItemsCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<String> type,
      Value<String> name,
      Value<String> category,
      Value<String?> description,
      Value<String> unit,
      Value<int> priceCents,
      Value<bool> active,
      Value<String?> imageReference,
      Value<int> rowid,
    });

final class $$LegacyCatalogItemsTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyCatalogItemsTable,
          LegacyCatalogItemRow
        > {
  $$LegacyCatalogItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $LegacyCatalogPackageComponentsTable,
    List<LegacyCatalogPackageComponentRow>
  >
  _package_componentsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyCatalogPackageComponents,
        aliasName: 'catalog_items__id__catalog_package_components__package_id',
      );

  $$LegacyCatalogPackageComponentsTableProcessedTableManager
  get package_components {
    final manager = $$LegacyCatalogPackageComponentsTableTableManager(
      $_db,
      $_db.legacyCatalogPackageComponents,
    ).filter((f) => f.packageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_package_componentsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LegacyCatalogPackageComponentsTable,
    List<LegacyCatalogPackageComponentRow>
  >
  _component_usagesTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyCatalogPackageComponents,
        aliasName:
            'catalog_items__id__catalog_package_components__component_item_id',
      );

  $$LegacyCatalogPackageComponentsTableProcessedTableManager
  get component_usages {
    final manager =
        $$LegacyCatalogPackageComponentsTableTableManager(
          $_db,
          $_db.legacyCatalogPackageComponents,
        ).filter(
          (f) => f.componentItemId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_component_usagesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LegacyCatalogItemsTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyCatalogItemsTable> {
  $$LegacyCatalogItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageReference => $composableBuilder(
    column: $table.imageReference,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> package_components(
    Expression<bool> Function(
      $$LegacyCatalogPackageComponentsTableFilterComposer f,
    )
    f,
  ) {
    final $$LegacyCatalogPackageComponentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyCatalogPackageComponents,
          getReferencedColumn: (t) => t.packageId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyCatalogPackageComponentsTableFilterComposer(
                $db: $db,
                $table: $db.legacyCatalogPackageComponents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> component_usages(
    Expression<bool> Function(
      $$LegacyCatalogPackageComponentsTableFilterComposer f,
    )
    f,
  ) {
    final $$LegacyCatalogPackageComponentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyCatalogPackageComponents,
          getReferencedColumn: (t) => t.componentItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyCatalogPackageComponentsTableFilterComposer(
                $db: $db,
                $table: $db.legacyCatalogPackageComponents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LegacyCatalogItemsTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyCatalogItemsTable> {
  $$LegacyCatalogItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageReference => $composableBuilder(
    column: $table.imageReference,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegacyCatalogItemsTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyCatalogItemsTable> {
  $$LegacyCatalogItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<String> get imageReference => $composableBuilder(
    column: $table.imageReference,
    builder: (column) => column,
  );

  Expression<T> package_components<T extends Object>(
    Expression<T> Function(
      $$LegacyCatalogPackageComponentsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$LegacyCatalogPackageComponentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyCatalogPackageComponents,
          getReferencedColumn: (t) => t.packageId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyCatalogPackageComponentsTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyCatalogPackageComponents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> component_usages<T extends Object>(
    Expression<T> Function(
      $$LegacyCatalogPackageComponentsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$LegacyCatalogPackageComponentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyCatalogPackageComponents,
          getReferencedColumn: (t) => t.componentItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyCatalogPackageComponentsTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyCatalogPackageComponents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LegacyCatalogItemsTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyCatalogItemsTable,
          LegacyCatalogItemRow,
          $$LegacyCatalogItemsTableFilterComposer,
          $$LegacyCatalogItemsTableOrderingComposer,
          $$LegacyCatalogItemsTableAnnotationComposer,
          $$LegacyCatalogItemsTableCreateCompanionBuilder,
          $$LegacyCatalogItemsTableUpdateCompanionBuilder,
          (LegacyCatalogItemRow, $$LegacyCatalogItemsTableReferences),
          LegacyCatalogItemRow,
          PrefetchHooks Function({
            bool package_components,
            bool component_usages,
          })
        > {
  $$LegacyCatalogItemsTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyCatalogItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyCatalogItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegacyCatalogItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegacyCatalogItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> priceCents = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String?> imageReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyCatalogItemsCompanion(
                id: id,
                createdAt: createdAt,
                type: type,
                name: name,
                category: category,
                description: description,
                unit: unit,
                priceCents: priceCents,
                active: active,
                imageReference: imageReference,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required String type,
                required String name,
                required String category,
                Value<String?> description = const Value.absent(),
                required String unit,
                required int priceCents,
                required bool active,
                Value<String?> imageReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyCatalogItemsCompanion.insert(
                id: id,
                createdAt: createdAt,
                type: type,
                name: name,
                category: category,
                description: description,
                unit: unit,
                priceCents: priceCents,
                active: active,
                imageReference: imageReference,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyCatalogItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({package_components = false, component_usages = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (package_components) db.legacyCatalogPackageComponents,
                    if (component_usages) db.legacyCatalogPackageComponents,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (package_components)
                        await $_getPrefetchedData<
                          LegacyCatalogItemRow,
                          $LegacyCatalogItemsTable,
                          LegacyCatalogPackageComponentRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyCatalogItemsTableReferences
                              ._package_componentsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyCatalogItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).package_components,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packageId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (component_usages)
                        await $_getPrefetchedData<
                          LegacyCatalogItemRow,
                          $LegacyCatalogItemsTable,
                          LegacyCatalogPackageComponentRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyCatalogItemsTableReferences
                              ._component_usagesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyCatalogItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).component_usages,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.componentItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LegacyCatalogItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyCatalogItemsTable,
      LegacyCatalogItemRow,
      $$LegacyCatalogItemsTableFilterComposer,
      $$LegacyCatalogItemsTableOrderingComposer,
      $$LegacyCatalogItemsTableAnnotationComposer,
      $$LegacyCatalogItemsTableCreateCompanionBuilder,
      $$LegacyCatalogItemsTableUpdateCompanionBuilder,
      (LegacyCatalogItemRow, $$LegacyCatalogItemsTableReferences),
      LegacyCatalogItemRow,
      PrefetchHooks Function({bool package_components, bool component_usages})
    >;
typedef $$LegacyCatalogPackageComponentsTableCreateCompanionBuilder =
    LegacyCatalogPackageComponentsCompanion Function({
      required String packageId,
      required String componentItemId,
      required String nameSnapshot,
      required String unitSnapshot,
      required String typeSnapshot,
      required String categorySnapshot,
      required double quantityPerPackage,
      Value<int> rowid,
    });
typedef $$LegacyCatalogPackageComponentsTableUpdateCompanionBuilder =
    LegacyCatalogPackageComponentsCompanion Function({
      Value<String> packageId,
      Value<String> componentItemId,
      Value<String> nameSnapshot,
      Value<String> unitSnapshot,
      Value<String> typeSnapshot,
      Value<String> categorySnapshot,
      Value<double> quantityPerPackage,
      Value<int> rowid,
    });

final class $$LegacyCatalogPackageComponentsTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyCatalogPackageComponentsTable,
          LegacyCatalogPackageComponentRow
        > {
  $$LegacyCatalogPackageComponentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyCatalogItemsTable _packageIdTable(_$LegacyAppDatabaseV10 db) =>
      db.legacyCatalogItems.createAlias(
        'catalog_package_components__package_id__catalog_items__id',
      );

  $$LegacyCatalogItemsTableProcessedTableManager get packageId {
    final $_column = $_itemColumn<String>('package_id')!;

    final manager = $$LegacyCatalogItemsTableTableManager(
      $_db,
      $_db.legacyCatalogItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LegacyCatalogItemsTable _componentItemIdTable(
    _$LegacyAppDatabaseV10 db,
  ) => db.legacyCatalogItems.createAlias(
    'catalog_package_components__component_item_id__catalog_items__id',
  );

  $$LegacyCatalogItemsTableProcessedTableManager get componentItemId {
    final $_column = $_itemColumn<String>('component_item_id')!;

    final manager = $$LegacyCatalogItemsTableTableManager(
      $_db,
      $_db.legacyCatalogItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_componentItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LegacyCatalogPackageComponentsTableFilterComposer
    extends
        Composer<_$LegacyAppDatabaseV10, $LegacyCatalogPackageComponentsTable> {
  $$LegacyCatalogPackageComponentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitSnapshot => $composableBuilder(
    column: $table.unitSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeSnapshot => $composableBuilder(
    column: $table.typeSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categorySnapshot => $composableBuilder(
    column: $table.categorySnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityPerPackage => $composableBuilder(
    column: $table.quantityPerPackage,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyCatalogItemsTableFilterComposer get packageId {
    final $$LegacyCatalogItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.legacyCatalogItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyCatalogItemsTableFilterComposer(
            $db: $db,
            $table: $db.legacyCatalogItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyCatalogItemsTableFilterComposer get componentItemId {
    final $$LegacyCatalogItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentItemId,
      referencedTable: $db.legacyCatalogItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyCatalogItemsTableFilterComposer(
            $db: $db,
            $table: $db.legacyCatalogItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyCatalogPackageComponentsTableOrderingComposer
    extends
        Composer<_$LegacyAppDatabaseV10, $LegacyCatalogPackageComponentsTable> {
  $$LegacyCatalogPackageComponentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitSnapshot => $composableBuilder(
    column: $table.unitSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeSnapshot => $composableBuilder(
    column: $table.typeSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categorySnapshot => $composableBuilder(
    column: $table.categorySnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityPerPackage => $composableBuilder(
    column: $table.quantityPerPackage,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyCatalogItemsTableOrderingComposer get packageId {
    final $$LegacyCatalogItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.legacyCatalogItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyCatalogItemsTableOrderingComposer(
            $db: $db,
            $table: $db.legacyCatalogItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyCatalogItemsTableOrderingComposer get componentItemId {
    final $$LegacyCatalogItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentItemId,
      referencedTable: $db.legacyCatalogItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyCatalogItemsTableOrderingComposer(
            $db: $db,
            $table: $db.legacyCatalogItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyCatalogPackageComponentsTableAnnotationComposer
    extends
        Composer<_$LegacyAppDatabaseV10, $LegacyCatalogPackageComponentsTable> {
  $$LegacyCatalogPackageComponentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitSnapshot => $composableBuilder(
    column: $table.unitSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get typeSnapshot => $composableBuilder(
    column: $table.typeSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categorySnapshot => $composableBuilder(
    column: $table.categorySnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantityPerPackage => $composableBuilder(
    column: $table.quantityPerPackage,
    builder: (column) => column,
  );

  $$LegacyCatalogItemsTableAnnotationComposer get packageId {
    final $$LegacyCatalogItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.packageId,
          referencedTable: $db.legacyCatalogItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyCatalogItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyCatalogItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$LegacyCatalogItemsTableAnnotationComposer get componentItemId {
    final $$LegacyCatalogItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.componentItemId,
          referencedTable: $db.legacyCatalogItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyCatalogItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyCatalogItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$LegacyCatalogPackageComponentsTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyCatalogPackageComponentsTable,
          LegacyCatalogPackageComponentRow,
          $$LegacyCatalogPackageComponentsTableFilterComposer,
          $$LegacyCatalogPackageComponentsTableOrderingComposer,
          $$LegacyCatalogPackageComponentsTableAnnotationComposer,
          $$LegacyCatalogPackageComponentsTableCreateCompanionBuilder,
          $$LegacyCatalogPackageComponentsTableUpdateCompanionBuilder,
          (
            LegacyCatalogPackageComponentRow,
            $$LegacyCatalogPackageComponentsTableReferences,
          ),
          LegacyCatalogPackageComponentRow,
          PrefetchHooks Function({bool packageId, bool componentItemId})
        > {
  $$LegacyCatalogPackageComponentsTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyCatalogPackageComponentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyCatalogPackageComponentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyCatalogPackageComponentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyCatalogPackageComponentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> packageId = const Value.absent(),
                Value<String> componentItemId = const Value.absent(),
                Value<String> nameSnapshot = const Value.absent(),
                Value<String> unitSnapshot = const Value.absent(),
                Value<String> typeSnapshot = const Value.absent(),
                Value<String> categorySnapshot = const Value.absent(),
                Value<double> quantityPerPackage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyCatalogPackageComponentsCompanion(
                packageId: packageId,
                componentItemId: componentItemId,
                nameSnapshot: nameSnapshot,
                unitSnapshot: unitSnapshot,
                typeSnapshot: typeSnapshot,
                categorySnapshot: categorySnapshot,
                quantityPerPackage: quantityPerPackage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packageId,
                required String componentItemId,
                required String nameSnapshot,
                required String unitSnapshot,
                required String typeSnapshot,
                required String categorySnapshot,
                required double quantityPerPackage,
                Value<int> rowid = const Value.absent(),
              }) => LegacyCatalogPackageComponentsCompanion.insert(
                packageId: packageId,
                componentItemId: componentItemId,
                nameSnapshot: nameSnapshot,
                unitSnapshot: unitSnapshot,
                typeSnapshot: typeSnapshot,
                categorySnapshot: categorySnapshot,
                quantityPerPackage: quantityPerPackage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyCatalogPackageComponentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packageId = false, componentItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packageId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.packageId,
                                referencedTable:
                                    $$LegacyCatalogPackageComponentsTableReferences
                                        ._packageIdTable(db),
                                referencedColumn:
                                    $$LegacyCatalogPackageComponentsTableReferences
                                        ._packageIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (componentItemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.componentItemId,
                                referencedTable:
                                    $$LegacyCatalogPackageComponentsTableReferences
                                        ._componentItemIdTable(db),
                                referencedColumn:
                                    $$LegacyCatalogPackageComponentsTableReferences
                                        ._componentItemIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LegacyCatalogPackageComponentsTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyCatalogPackageComponentsTable,
      LegacyCatalogPackageComponentRow,
      $$LegacyCatalogPackageComponentsTableFilterComposer,
      $$LegacyCatalogPackageComponentsTableOrderingComposer,
      $$LegacyCatalogPackageComponentsTableAnnotationComposer,
      $$LegacyCatalogPackageComponentsTableCreateCompanionBuilder,
      $$LegacyCatalogPackageComponentsTableUpdateCompanionBuilder,
      (
        LegacyCatalogPackageComponentRow,
        $$LegacyCatalogPackageComponentsTableReferences,
      ),
      LegacyCatalogPackageComponentRow,
      PrefetchHooks Function({bool packageId, bool componentItemId})
    >;
typedef $$LegacyCompanyProfilesTableCreateCompanionBuilder =
    LegacyCompanyProfilesCompanion Function({
      required String id,
      required String tradeName,
      Value<String?> legalName,
      Value<String?> cnpjDigits,
      Value<String?> stateRegistration,
      Value<String?> logoReference,
      Value<String?> phoneDigits,
      Value<String?> whatsappDigits,
      Value<String?> email,
      Value<String?> instagram,
      Value<String?> website,
      Value<String?> postalCode,
      Value<String?> street,
      Value<String?> number,
      Value<String?> complement,
      Value<String?> neighborhood,
      Value<String?> city,
      Value<String?> state,
      Value<String?> repFullName,
      Value<String?> repCpfDigits,
      Value<String?> repRole,
      Value<String?> pixKeyType,
      Value<String?> pixKey,
      Value<String?> beneficiaryName,
      Value<String?> paymentTerms,
      required int defaultValidityDays,
      Value<String?> defaultPublicNotes,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LegacyCompanyProfilesTableUpdateCompanionBuilder =
    LegacyCompanyProfilesCompanion Function({
      Value<String> id,
      Value<String> tradeName,
      Value<String?> legalName,
      Value<String?> cnpjDigits,
      Value<String?> stateRegistration,
      Value<String?> logoReference,
      Value<String?> phoneDigits,
      Value<String?> whatsappDigits,
      Value<String?> email,
      Value<String?> instagram,
      Value<String?> website,
      Value<String?> postalCode,
      Value<String?> street,
      Value<String?> number,
      Value<String?> complement,
      Value<String?> neighborhood,
      Value<String?> city,
      Value<String?> state,
      Value<String?> repFullName,
      Value<String?> repCpfDigits,
      Value<String?> repRole,
      Value<String?> pixKeyType,
      Value<String?> pixKey,
      Value<String?> beneficiaryName,
      Value<String?> paymentTerms,
      Value<int> defaultValidityDays,
      Value<String?> defaultPublicNotes,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$LegacyCompanyProfilesTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyCompanyProfilesTable> {
  $$LegacyCompanyProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tradeName => $composableBuilder(
    column: $table.tradeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cnpjDigits => $composableBuilder(
    column: $table.cnpjDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateRegistration => $composableBuilder(
    column: $table.stateRegistration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoReference => $composableBuilder(
    column: $table.logoReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneDigits => $composableBuilder(
    column: $table.phoneDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatsappDigits => $composableBuilder(
    column: $table.whatsappDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instagram => $composableBuilder(
    column: $table.instagram,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get complement => $composableBuilder(
    column: $table.complement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get neighborhood => $composableBuilder(
    column: $table.neighborhood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repFullName => $composableBuilder(
    column: $table.repFullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repCpfDigits => $composableBuilder(
    column: $table.repCpfDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repRole => $composableBuilder(
    column: $table.repRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pixKeyType => $composableBuilder(
    column: $table.pixKeyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pixKey => $composableBuilder(
    column: $table.pixKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beneficiaryName => $composableBuilder(
    column: $table.beneficiaryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentTerms => $composableBuilder(
    column: $table.paymentTerms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultValidityDays => $composableBuilder(
    column: $table.defaultValidityDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultPublicNotes => $composableBuilder(
    column: $table.defaultPublicNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegacyCompanyProfilesTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyCompanyProfilesTable> {
  $$LegacyCompanyProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tradeName => $composableBuilder(
    column: $table.tradeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cnpjDigits => $composableBuilder(
    column: $table.cnpjDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateRegistration => $composableBuilder(
    column: $table.stateRegistration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoReference => $composableBuilder(
    column: $table.logoReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneDigits => $composableBuilder(
    column: $table.phoneDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatsappDigits => $composableBuilder(
    column: $table.whatsappDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instagram => $composableBuilder(
    column: $table.instagram,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get complement => $composableBuilder(
    column: $table.complement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get neighborhood => $composableBuilder(
    column: $table.neighborhood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repFullName => $composableBuilder(
    column: $table.repFullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repCpfDigits => $composableBuilder(
    column: $table.repCpfDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repRole => $composableBuilder(
    column: $table.repRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pixKeyType => $composableBuilder(
    column: $table.pixKeyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pixKey => $composableBuilder(
    column: $table.pixKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beneficiaryName => $composableBuilder(
    column: $table.beneficiaryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentTerms => $composableBuilder(
    column: $table.paymentTerms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultValidityDays => $composableBuilder(
    column: $table.defaultValidityDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultPublicNotes => $composableBuilder(
    column: $table.defaultPublicNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegacyCompanyProfilesTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyCompanyProfilesTable> {
  $$LegacyCompanyProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tradeName =>
      $composableBuilder(column: $table.tradeName, builder: (column) => column);

  GeneratedColumn<String> get legalName =>
      $composableBuilder(column: $table.legalName, builder: (column) => column);

  GeneratedColumn<String> get cnpjDigits => $composableBuilder(
    column: $table.cnpjDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stateRegistration => $composableBuilder(
    column: $table.stateRegistration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoReference => $composableBuilder(
    column: $table.logoReference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneDigits => $composableBuilder(
    column: $table.phoneDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get whatsappDigits => $composableBuilder(
    column: $table.whatsappDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get instagram =>
      $composableBuilder(column: $table.instagram, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get street =>
      $composableBuilder(column: $table.street, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get complement => $composableBuilder(
    column: $table.complement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get neighborhood => $composableBuilder(
    column: $table.neighborhood,
    builder: (column) => column,
  );

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get repFullName => $composableBuilder(
    column: $table.repFullName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repCpfDigits => $composableBuilder(
    column: $table.repCpfDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repRole =>
      $composableBuilder(column: $table.repRole, builder: (column) => column);

  GeneratedColumn<String> get pixKeyType => $composableBuilder(
    column: $table.pixKeyType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pixKey =>
      $composableBuilder(column: $table.pixKey, builder: (column) => column);

  GeneratedColumn<String> get beneficiaryName => $composableBuilder(
    column: $table.beneficiaryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentTerms => $composableBuilder(
    column: $table.paymentTerms,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultValidityDays => $composableBuilder(
    column: $table.defaultValidityDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultPublicNotes => $composableBuilder(
    column: $table.defaultPublicNotes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LegacyCompanyProfilesTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyCompanyProfilesTable,
          LegacyCompanyProfileRow,
          $$LegacyCompanyProfilesTableFilterComposer,
          $$LegacyCompanyProfilesTableOrderingComposer,
          $$LegacyCompanyProfilesTableAnnotationComposer,
          $$LegacyCompanyProfilesTableCreateCompanionBuilder,
          $$LegacyCompanyProfilesTableUpdateCompanionBuilder,
          (
            LegacyCompanyProfileRow,
            BaseReferences<
              _$LegacyAppDatabaseV10,
              $LegacyCompanyProfilesTable,
              LegacyCompanyProfileRow
            >,
          ),
          LegacyCompanyProfileRow,
          PrefetchHooks Function()
        > {
  $$LegacyCompanyProfilesTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyCompanyProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyCompanyProfilesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyCompanyProfilesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyCompanyProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tradeName = const Value.absent(),
                Value<String?> legalName = const Value.absent(),
                Value<String?> cnpjDigits = const Value.absent(),
                Value<String?> stateRegistration = const Value.absent(),
                Value<String?> logoReference = const Value.absent(),
                Value<String?> phoneDigits = const Value.absent(),
                Value<String?> whatsappDigits = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> instagram = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> postalCode = const Value.absent(),
                Value<String?> street = const Value.absent(),
                Value<String?> number = const Value.absent(),
                Value<String?> complement = const Value.absent(),
                Value<String?> neighborhood = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> repFullName = const Value.absent(),
                Value<String?> repCpfDigits = const Value.absent(),
                Value<String?> repRole = const Value.absent(),
                Value<String?> pixKeyType = const Value.absent(),
                Value<String?> pixKey = const Value.absent(),
                Value<String?> beneficiaryName = const Value.absent(),
                Value<String?> paymentTerms = const Value.absent(),
                Value<int> defaultValidityDays = const Value.absent(),
                Value<String?> defaultPublicNotes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyCompanyProfilesCompanion(
                id: id,
                tradeName: tradeName,
                legalName: legalName,
                cnpjDigits: cnpjDigits,
                stateRegistration: stateRegistration,
                logoReference: logoReference,
                phoneDigits: phoneDigits,
                whatsappDigits: whatsappDigits,
                email: email,
                instagram: instagram,
                website: website,
                postalCode: postalCode,
                street: street,
                number: number,
                complement: complement,
                neighborhood: neighborhood,
                city: city,
                state: state,
                repFullName: repFullName,
                repCpfDigits: repCpfDigits,
                repRole: repRole,
                pixKeyType: pixKeyType,
                pixKey: pixKey,
                beneficiaryName: beneficiaryName,
                paymentTerms: paymentTerms,
                defaultValidityDays: defaultValidityDays,
                defaultPublicNotes: defaultPublicNotes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tradeName,
                Value<String?> legalName = const Value.absent(),
                Value<String?> cnpjDigits = const Value.absent(),
                Value<String?> stateRegistration = const Value.absent(),
                Value<String?> logoReference = const Value.absent(),
                Value<String?> phoneDigits = const Value.absent(),
                Value<String?> whatsappDigits = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> instagram = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> postalCode = const Value.absent(),
                Value<String?> street = const Value.absent(),
                Value<String?> number = const Value.absent(),
                Value<String?> complement = const Value.absent(),
                Value<String?> neighborhood = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> repFullName = const Value.absent(),
                Value<String?> repCpfDigits = const Value.absent(),
                Value<String?> repRole = const Value.absent(),
                Value<String?> pixKeyType = const Value.absent(),
                Value<String?> pixKey = const Value.absent(),
                Value<String?> beneficiaryName = const Value.absent(),
                Value<String?> paymentTerms = const Value.absent(),
                required int defaultValidityDays,
                Value<String?> defaultPublicNotes = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyCompanyProfilesCompanion.insert(
                id: id,
                tradeName: tradeName,
                legalName: legalName,
                cnpjDigits: cnpjDigits,
                stateRegistration: stateRegistration,
                logoReference: logoReference,
                phoneDigits: phoneDigits,
                whatsappDigits: whatsappDigits,
                email: email,
                instagram: instagram,
                website: website,
                postalCode: postalCode,
                street: street,
                number: number,
                complement: complement,
                neighborhood: neighborhood,
                city: city,
                state: state,
                repFullName: repFullName,
                repCpfDigits: repCpfDigits,
                repRole: repRole,
                pixKeyType: pixKeyType,
                pixKey: pixKey,
                beneficiaryName: beneficiaryName,
                paymentTerms: paymentTerms,
                defaultValidityDays: defaultValidityDays,
                defaultPublicNotes: defaultPublicNotes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegacyCompanyProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyCompanyProfilesTable,
      LegacyCompanyProfileRow,
      $$LegacyCompanyProfilesTableFilterComposer,
      $$LegacyCompanyProfilesTableOrderingComposer,
      $$LegacyCompanyProfilesTableAnnotationComposer,
      $$LegacyCompanyProfilesTableCreateCompanionBuilder,
      $$LegacyCompanyProfilesTableUpdateCompanionBuilder,
      (
        LegacyCompanyProfileRow,
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyCompanyProfilesTable,
          LegacyCompanyProfileRow
        >,
      ),
      LegacyCompanyProfileRow,
      PrefetchHooks Function()
    >;
typedef $$LegacyQuotesTableCreateCompanionBuilder =
    LegacyQuotesCompanion Function({
      required String id,
      required String number,
      required String status,
      required int subtotalCents,
      required int discountCents,
      required int freightCents,
      required int totalCents,
      Value<String?> validUntil,
      Value<String?> notes,
      Value<String?> internalNotes,
      required int createdAt,
      required int updatedAt,
      Value<int?> approvedAt,
      Value<int> rowid,
    });
typedef $$LegacyQuotesTableUpdateCompanionBuilder =
    LegacyQuotesCompanion Function({
      Value<String> id,
      Value<String> number,
      Value<String> status,
      Value<int> subtotalCents,
      Value<int> discountCents,
      Value<int> freightCents,
      Value<int> totalCents,
      Value<String?> validUntil,
      Value<String?> notes,
      Value<String?> internalNotes,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> approvedAt,
      Value<int> rowid,
    });

final class $$LegacyQuotesTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyQuotesTable,
          LegacyQuoteRow
        > {
  $$LegacyQuotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $LegacyQuoteClientSnapshotsTable,
    List<LegacyQuoteClientSnapshotRow>
  >
  _legacyQuoteClientSnapshotsRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteClientSnapshots,
        aliasName: 'quotes__id__quote_client_snapshots__quote_id',
      );

  $$LegacyQuoteClientSnapshotsTableProcessedTableManager
  get legacyQuoteClientSnapshotsRefs {
    final manager = $$LegacyQuoteClientSnapshotsTableTableManager(
      $_db,
      $_db.legacyQuoteClientSnapshots,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteClientSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LegacyQuoteEventSnapshotsTable,
    List<LegacyQuoteEventSnapshotRow>
  >
  _legacyQuoteEventSnapshotsRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteEventSnapshots,
        aliasName: 'quotes__id__quote_event_snapshots__quote_id',
      );

  $$LegacyQuoteEventSnapshotsTableProcessedTableManager
  get legacyQuoteEventSnapshotsRefs {
    final manager = $$LegacyQuoteEventSnapshotsTableTableManager(
      $_db,
      $_db.legacyQuoteEventSnapshots,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteEventSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LegacyQuoteCompanySnapshotsTable,
    List<LegacyQuoteCompanySnapshotRow>
  >
  _legacyQuoteCompanySnapshotsRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteCompanySnapshots,
        aliasName: 'quotes__id__quote_company_snapshots__quote_id',
      );

  $$LegacyQuoteCompanySnapshotsTableProcessedTableManager
  get legacyQuoteCompanySnapshotsRefs {
    final manager = $$LegacyQuoteCompanySnapshotsTableTableManager(
      $_db,
      $_db.legacyQuoteCompanySnapshots,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteCompanySnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LegacyQuoteLineItemsTable,
    List<LegacyQuoteLineItemRow>
  >
  _legacyQuoteLineItemsRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteLineItems,
        aliasName: 'quotes__id__quote_line_items__quote_id',
      );

  $$LegacyQuoteLineItemsTableProcessedTableManager
  get legacyQuoteLineItemsRefs {
    final manager = $$LegacyQuoteLineItemsTableTableManager(
      $_db,
      $_db.legacyQuoteLineItems,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteLineItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LegacyQuoteStatusHistoryTable,
    List<LegacyQuoteStatusHistoryRow>
  >
  _legacyQuoteStatusHistoryRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteStatusHistory,
        aliasName: 'quotes__id__quote_status_history__quote_id',
      );

  $$LegacyQuoteStatusHistoryTableProcessedTableManager
  get legacyQuoteStatusHistoryRefs {
    final manager = $$LegacyQuoteStatusHistoryTableTableManager(
      $_db,
      $_db.legacyQuoteStatusHistory,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteStatusHistoryRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LegacyFinancialEntriesTable,
    List<LegacyFinancialEntryRow>
  >
  _legacyFinancialEntriesRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyFinancialEntries,
        aliasName: 'quotes__id__financial_entries__quote_id',
      );

  $$LegacyFinancialEntriesTableProcessedTableManager
  get legacyFinancialEntriesRefs {
    final manager = $$LegacyFinancialEntriesTableTableManager(
      $_db,
      $_db.legacyFinancialEntries,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyFinancialEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LegacyQuoteEquipmentItemsTable,
    List<LegacyQuoteEquipmentRow>
  >
  _legacyQuoteEquipmentItemsRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteEquipmentItems,
        aliasName: 'quotes__id__quote_equipment__quote_id',
      );

  $$LegacyQuoteEquipmentItemsTableProcessedTableManager
  get legacyQuoteEquipmentItemsRefs {
    final manager = $$LegacyQuoteEquipmentItemsTableTableManager(
      $_db,
      $_db.legacyQuoteEquipmentItems,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteEquipmentItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LegacyQuoteTeamMembersTable,
    List<LegacyQuoteTeamMemberRow>
  >
  _legacyQuoteTeamMembersRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteTeamMembers,
        aliasName: 'quotes__id__quote_team_members__quote_id',
      );

  $$LegacyQuoteTeamMembersTableProcessedTableManager
  get legacyQuoteTeamMembersRefs {
    final manager = $$LegacyQuoteTeamMembersTableTableManager(
      $_db,
      $_db.legacyQuoteTeamMembers,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteTeamMembersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LegacyQuoteVehiclesTable,
    List<LegacyQuoteVehicleRow>
  >
  _legacyQuoteVehiclesRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteVehicles,
        aliasName: 'quotes__id__quote_vehicles__quote_id',
      );

  $$LegacyQuoteVehiclesTableProcessedTableManager get legacyQuoteVehiclesRefs {
    final manager = $$LegacyQuoteVehiclesTableTableManager(
      $_db,
      $_db.legacyQuoteVehicles,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteVehiclesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LegacyQuotesTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuotesTable> {
  $$LegacyQuotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotalCents => $composableBuilder(
    column: $table.subtotalCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountCents => $composableBuilder(
    column: $table.discountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get freightCents => $composableBuilder(
    column: $table.freightCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCents => $composableBuilder(
    column: $table.totalCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> legacyQuoteClientSnapshotsRefs(
    Expression<bool> Function($$LegacyQuoteClientSnapshotsTableFilterComposer f)
    f,
  ) {
    final $$LegacyQuoteClientSnapshotsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteClientSnapshots,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteClientSnapshotsTableFilterComposer(
                $db: $db,
                $table: $db.legacyQuoteClientSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> legacyQuoteEventSnapshotsRefs(
    Expression<bool> Function($$LegacyQuoteEventSnapshotsTableFilterComposer f)
    f,
  ) {
    final $$LegacyQuoteEventSnapshotsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteEventSnapshots,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteEventSnapshotsTableFilterComposer(
                $db: $db,
                $table: $db.legacyQuoteEventSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> legacyQuoteCompanySnapshotsRefs(
    Expression<bool> Function(
      $$LegacyQuoteCompanySnapshotsTableFilterComposer f,
    )
    f,
  ) {
    final $$LegacyQuoteCompanySnapshotsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteCompanySnapshots,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteCompanySnapshotsTableFilterComposer(
                $db: $db,
                $table: $db.legacyQuoteCompanySnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> legacyQuoteLineItemsRefs(
    Expression<bool> Function($$LegacyQuoteLineItemsTableFilterComposer f) f,
  ) {
    final $$LegacyQuoteLineItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.legacyQuoteLineItems,
      getReferencedColumn: (t) => t.quoteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuoteLineItemsTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuoteLineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> legacyQuoteStatusHistoryRefs(
    Expression<bool> Function($$LegacyQuoteStatusHistoryTableFilterComposer f)
    f,
  ) {
    final $$LegacyQuoteStatusHistoryTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteStatusHistory,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteStatusHistoryTableFilterComposer(
                $db: $db,
                $table: $db.legacyQuoteStatusHistory,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> legacyFinancialEntriesRefs(
    Expression<bool> Function($$LegacyFinancialEntriesTableFilterComposer f) f,
  ) {
    final $$LegacyFinancialEntriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyFinancialEntries,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyFinancialEntriesTableFilterComposer(
                $db: $db,
                $table: $db.legacyFinancialEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> legacyQuoteEquipmentItemsRefs(
    Expression<bool> Function($$LegacyQuoteEquipmentItemsTableFilterComposer f)
    f,
  ) {
    final $$LegacyQuoteEquipmentItemsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteEquipmentItems,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteEquipmentItemsTableFilterComposer(
                $db: $db,
                $table: $db.legacyQuoteEquipmentItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> legacyQuoteTeamMembersRefs(
    Expression<bool> Function($$LegacyQuoteTeamMembersTableFilterComposer f) f,
  ) {
    final $$LegacyQuoteTeamMembersTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteTeamMembers,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteTeamMembersTableFilterComposer(
                $db: $db,
                $table: $db.legacyQuoteTeamMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> legacyQuoteVehiclesRefs(
    Expression<bool> Function($$LegacyQuoteVehiclesTableFilterComposer f) f,
  ) {
    final $$LegacyQuoteVehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.legacyQuoteVehicles,
      getReferencedColumn: (t) => t.quoteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuoteVehiclesTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuoteVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LegacyQuotesTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuotesTable> {
  $$LegacyQuotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotalCents => $composableBuilder(
    column: $table.subtotalCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountCents => $composableBuilder(
    column: $table.discountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get freightCents => $composableBuilder(
    column: $table.freightCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCents => $composableBuilder(
    column: $table.totalCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegacyQuotesTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuotesTable> {
  $$LegacyQuotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get subtotalCents => $composableBuilder(
    column: $table.subtotalCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountCents => $composableBuilder(
    column: $table.discountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get freightCents => $composableBuilder(
    column: $table.freightCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCents => $composableBuilder(
    column: $table.totalCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => column,
  );

  Expression<T> legacyQuoteClientSnapshotsRefs<T extends Object>(
    Expression<T> Function(
      $$LegacyQuoteClientSnapshotsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$LegacyQuoteClientSnapshotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteClientSnapshots,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteClientSnapshotsTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteClientSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> legacyQuoteEventSnapshotsRefs<T extends Object>(
    Expression<T> Function($$LegacyQuoteEventSnapshotsTableAnnotationComposer a)
    f,
  ) {
    final $$LegacyQuoteEventSnapshotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteEventSnapshots,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteEventSnapshotsTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteEventSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> legacyQuoteCompanySnapshotsRefs<T extends Object>(
    Expression<T> Function(
      $$LegacyQuoteCompanySnapshotsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$LegacyQuoteCompanySnapshotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteCompanySnapshots,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteCompanySnapshotsTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteCompanySnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> legacyQuoteLineItemsRefs<T extends Object>(
    Expression<T> Function($$LegacyQuoteLineItemsTableAnnotationComposer a) f,
  ) {
    final $$LegacyQuoteLineItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteLineItems,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteLineItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteLineItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> legacyQuoteStatusHistoryRefs<T extends Object>(
    Expression<T> Function($$LegacyQuoteStatusHistoryTableAnnotationComposer a)
    f,
  ) {
    final $$LegacyQuoteStatusHistoryTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteStatusHistory,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteStatusHistoryTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteStatusHistory,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> legacyFinancialEntriesRefs<T extends Object>(
    Expression<T> Function($$LegacyFinancialEntriesTableAnnotationComposer a) f,
  ) {
    final $$LegacyFinancialEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyFinancialEntries,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyFinancialEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyFinancialEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> legacyQuoteEquipmentItemsRefs<T extends Object>(
    Expression<T> Function($$LegacyQuoteEquipmentItemsTableAnnotationComposer a)
    f,
  ) {
    final $$LegacyQuoteEquipmentItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteEquipmentItems,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteEquipmentItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteEquipmentItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> legacyQuoteTeamMembersRefs<T extends Object>(
    Expression<T> Function($$LegacyQuoteTeamMembersTableAnnotationComposer a) f,
  ) {
    final $$LegacyQuoteTeamMembersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteTeamMembers,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteTeamMembersTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteTeamMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> legacyQuoteVehiclesRefs<T extends Object>(
    Expression<T> Function($$LegacyQuoteVehiclesTableAnnotationComposer a) f,
  ) {
    final $$LegacyQuoteVehiclesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteVehicles,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteVehiclesTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteVehicles,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LegacyQuotesTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyQuotesTable,
          LegacyQuoteRow,
          $$LegacyQuotesTableFilterComposer,
          $$LegacyQuotesTableOrderingComposer,
          $$LegacyQuotesTableAnnotationComposer,
          $$LegacyQuotesTableCreateCompanionBuilder,
          $$LegacyQuotesTableUpdateCompanionBuilder,
          (LegacyQuoteRow, $$LegacyQuotesTableReferences),
          LegacyQuoteRow,
          PrefetchHooks Function({
            bool legacyQuoteClientSnapshotsRefs,
            bool legacyQuoteEventSnapshotsRefs,
            bool legacyQuoteCompanySnapshotsRefs,
            bool legacyQuoteLineItemsRefs,
            bool legacyQuoteStatusHistoryRefs,
            bool legacyFinancialEntriesRefs,
            bool legacyQuoteEquipmentItemsRefs,
            bool legacyQuoteTeamMembersRefs,
            bool legacyQuoteVehiclesRefs,
          })
        > {
  $$LegacyQuotesTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyQuotesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyQuotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegacyQuotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegacyQuotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> number = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> subtotalCents = const Value.absent(),
                Value<int> discountCents = const Value.absent(),
                Value<int> freightCents = const Value.absent(),
                Value<int> totalCents = const Value.absent(),
                Value<String?> validUntil = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> internalNotes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> approvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuotesCompanion(
                id: id,
                number: number,
                status: status,
                subtotalCents: subtotalCents,
                discountCents: discountCents,
                freightCents: freightCents,
                totalCents: totalCents,
                validUntil: validUntil,
                notes: notes,
                internalNotes: internalNotes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                approvedAt: approvedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String number,
                required String status,
                required int subtotalCents,
                required int discountCents,
                required int freightCents,
                required int totalCents,
                Value<String?> validUntil = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> internalNotes = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> approvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuotesCompanion.insert(
                id: id,
                number: number,
                status: status,
                subtotalCents: subtotalCents,
                discountCents: discountCents,
                freightCents: freightCents,
                totalCents: totalCents,
                validUntil: validUntil,
                notes: notes,
                internalNotes: internalNotes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                approvedAt: approvedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyQuotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                legacyQuoteClientSnapshotsRefs = false,
                legacyQuoteEventSnapshotsRefs = false,
                legacyQuoteCompanySnapshotsRefs = false,
                legacyQuoteLineItemsRefs = false,
                legacyQuoteStatusHistoryRefs = false,
                legacyFinancialEntriesRefs = false,
                legacyQuoteEquipmentItemsRefs = false,
                legacyQuoteTeamMembersRefs = false,
                legacyQuoteVehiclesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (legacyQuoteClientSnapshotsRefs)
                      db.legacyQuoteClientSnapshots,
                    if (legacyQuoteEventSnapshotsRefs)
                      db.legacyQuoteEventSnapshots,
                    if (legacyQuoteCompanySnapshotsRefs)
                      db.legacyQuoteCompanySnapshots,
                    if (legacyQuoteLineItemsRefs) db.legacyQuoteLineItems,
                    if (legacyQuoteStatusHistoryRefs)
                      db.legacyQuoteStatusHistory,
                    if (legacyFinancialEntriesRefs) db.legacyFinancialEntries,
                    if (legacyQuoteEquipmentItemsRefs)
                      db.legacyQuoteEquipmentItems,
                    if (legacyQuoteTeamMembersRefs) db.legacyQuoteTeamMembers,
                    if (legacyQuoteVehiclesRefs) db.legacyQuoteVehicles,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (legacyQuoteClientSnapshotsRefs)
                        await $_getPrefetchedData<
                          LegacyQuoteRow,
                          $LegacyQuotesTable,
                          LegacyQuoteClientSnapshotRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyQuotesTableReferences
                              ._legacyQuoteClientSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyQuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteClientSnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quoteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (legacyQuoteEventSnapshotsRefs)
                        await $_getPrefetchedData<
                          LegacyQuoteRow,
                          $LegacyQuotesTable,
                          LegacyQuoteEventSnapshotRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyQuotesTableReferences
                              ._legacyQuoteEventSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyQuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteEventSnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quoteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (legacyQuoteCompanySnapshotsRefs)
                        await $_getPrefetchedData<
                          LegacyQuoteRow,
                          $LegacyQuotesTable,
                          LegacyQuoteCompanySnapshotRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyQuotesTableReferences
                              ._legacyQuoteCompanySnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyQuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteCompanySnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quoteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (legacyQuoteLineItemsRefs)
                        await $_getPrefetchedData<
                          LegacyQuoteRow,
                          $LegacyQuotesTable,
                          LegacyQuoteLineItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyQuotesTableReferences
                              ._legacyQuoteLineItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyQuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteLineItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quoteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (legacyQuoteStatusHistoryRefs)
                        await $_getPrefetchedData<
                          LegacyQuoteRow,
                          $LegacyQuotesTable,
                          LegacyQuoteStatusHistoryRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyQuotesTableReferences
                              ._legacyQuoteStatusHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyQuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteStatusHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quoteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (legacyFinancialEntriesRefs)
                        await $_getPrefetchedData<
                          LegacyQuoteRow,
                          $LegacyQuotesTable,
                          LegacyFinancialEntryRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyQuotesTableReferences
                              ._legacyFinancialEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyQuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyFinancialEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quoteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (legacyQuoteEquipmentItemsRefs)
                        await $_getPrefetchedData<
                          LegacyQuoteRow,
                          $LegacyQuotesTable,
                          LegacyQuoteEquipmentRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyQuotesTableReferences
                              ._legacyQuoteEquipmentItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyQuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteEquipmentItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quoteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (legacyQuoteTeamMembersRefs)
                        await $_getPrefetchedData<
                          LegacyQuoteRow,
                          $LegacyQuotesTable,
                          LegacyQuoteTeamMemberRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyQuotesTableReferences
                              ._legacyQuoteTeamMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyQuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteTeamMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quoteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (legacyQuoteVehiclesRefs)
                        await $_getPrefetchedData<
                          LegacyQuoteRow,
                          $LegacyQuotesTable,
                          LegacyQuoteVehicleRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyQuotesTableReferences
                              ._legacyQuoteVehiclesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyQuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteVehiclesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quoteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LegacyQuotesTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyQuotesTable,
      LegacyQuoteRow,
      $$LegacyQuotesTableFilterComposer,
      $$LegacyQuotesTableOrderingComposer,
      $$LegacyQuotesTableAnnotationComposer,
      $$LegacyQuotesTableCreateCompanionBuilder,
      $$LegacyQuotesTableUpdateCompanionBuilder,
      (LegacyQuoteRow, $$LegacyQuotesTableReferences),
      LegacyQuoteRow,
      PrefetchHooks Function({
        bool legacyQuoteClientSnapshotsRefs,
        bool legacyQuoteEventSnapshotsRefs,
        bool legacyQuoteCompanySnapshotsRefs,
        bool legacyQuoteLineItemsRefs,
        bool legacyQuoteStatusHistoryRefs,
        bool legacyFinancialEntriesRefs,
        bool legacyQuoteEquipmentItemsRefs,
        bool legacyQuoteTeamMembersRefs,
        bool legacyQuoteVehiclesRefs,
      })
    >;
typedef $$LegacyQuoteClientSnapshotsTableCreateCompanionBuilder =
    LegacyQuoteClientSnapshotsCompanion Function({
      required String quoteId,
      Value<String?> sourceClientId,
      required String type,
      required String displayName,
      Value<String?> legalName,
      Value<String?> documentDigits,
      Value<String?> phoneDigits,
      Value<String?> whatsappDigits,
      Value<String?> email,
      Value<String?> addressSummary,
      Value<int> rowid,
    });
typedef $$LegacyQuoteClientSnapshotsTableUpdateCompanionBuilder =
    LegacyQuoteClientSnapshotsCompanion Function({
      Value<String> quoteId,
      Value<String?> sourceClientId,
      Value<String> type,
      Value<String> displayName,
      Value<String?> legalName,
      Value<String?> documentDigits,
      Value<String?> phoneDigits,
      Value<String?> whatsappDigits,
      Value<String?> email,
      Value<String?> addressSummary,
      Value<int> rowid,
    });

final class $$LegacyQuoteClientSnapshotsTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteClientSnapshotsTable,
          LegacyQuoteClientSnapshotRow
        > {
  $$LegacyQuoteClientSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyQuotesTable _quoteIdTable(_$LegacyAppDatabaseV10 db) => db
      .legacyQuotes
      .createAlias('quote_client_snapshots__quote_id__quotes__id');

  $$LegacyQuotesTableProcessedTableManager get quoteId {
    final $_column = $_itemColumn<String>('quote_id')!;

    final manager = $$LegacyQuotesTableTableManager(
      $_db,
      $_db.legacyQuotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LegacyQuoteClientSnapshotsTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteClientSnapshotsTable> {
  $$LegacyQuoteClientSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sourceClientId => $composableBuilder(
    column: $table.sourceClientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentDigits => $composableBuilder(
    column: $table.documentDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneDigits => $composableBuilder(
    column: $table.phoneDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatsappDigits => $composableBuilder(
    column: $table.whatsappDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressSummary => $composableBuilder(
    column: $table.addressSummary,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyQuotesTableFilterComposer get quoteId {
    final $$LegacyQuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteClientSnapshotsTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteClientSnapshotsTable> {
  $$LegacyQuoteClientSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sourceClientId => $composableBuilder(
    column: $table.sourceClientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentDigits => $composableBuilder(
    column: $table.documentDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneDigits => $composableBuilder(
    column: $table.phoneDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatsappDigits => $composableBuilder(
    column: $table.whatsappDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressSummary => $composableBuilder(
    column: $table.addressSummary,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyQuotesTableOrderingComposer get quoteId {
    final $$LegacyQuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableOrderingComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteClientSnapshotsTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteClientSnapshotsTable> {
  $$LegacyQuoteClientSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sourceClientId => $composableBuilder(
    column: $table.sourceClientId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get legalName =>
      $composableBuilder(column: $table.legalName, builder: (column) => column);

  GeneratedColumn<String> get documentDigits => $composableBuilder(
    column: $table.documentDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneDigits => $composableBuilder(
    column: $table.phoneDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get whatsappDigits => $composableBuilder(
    column: $table.whatsappDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get addressSummary => $composableBuilder(
    column: $table.addressSummary,
    builder: (column) => column,
  );

  $$LegacyQuotesTableAnnotationComposer get quoteId {
    final $$LegacyQuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteClientSnapshotsTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteClientSnapshotsTable,
          LegacyQuoteClientSnapshotRow,
          $$LegacyQuoteClientSnapshotsTableFilterComposer,
          $$LegacyQuoteClientSnapshotsTableOrderingComposer,
          $$LegacyQuoteClientSnapshotsTableAnnotationComposer,
          $$LegacyQuoteClientSnapshotsTableCreateCompanionBuilder,
          $$LegacyQuoteClientSnapshotsTableUpdateCompanionBuilder,
          (
            LegacyQuoteClientSnapshotRow,
            $$LegacyQuoteClientSnapshotsTableReferences,
          ),
          LegacyQuoteClientSnapshotRow,
          PrefetchHooks Function({bool quoteId})
        > {
  $$LegacyQuoteClientSnapshotsTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyQuoteClientSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyQuoteClientSnapshotsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyQuoteClientSnapshotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyQuoteClientSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> quoteId = const Value.absent(),
                Value<String?> sourceClientId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> legalName = const Value.absent(),
                Value<String?> documentDigits = const Value.absent(),
                Value<String?> phoneDigits = const Value.absent(),
                Value<String?> whatsappDigits = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> addressSummary = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteClientSnapshotsCompanion(
                quoteId: quoteId,
                sourceClientId: sourceClientId,
                type: type,
                displayName: displayName,
                legalName: legalName,
                documentDigits: documentDigits,
                phoneDigits: phoneDigits,
                whatsappDigits: whatsappDigits,
                email: email,
                addressSummary: addressSummary,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String quoteId,
                Value<String?> sourceClientId = const Value.absent(),
                required String type,
                required String displayName,
                Value<String?> legalName = const Value.absent(),
                Value<String?> documentDigits = const Value.absent(),
                Value<String?> phoneDigits = const Value.absent(),
                Value<String?> whatsappDigits = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> addressSummary = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteClientSnapshotsCompanion.insert(
                quoteId: quoteId,
                sourceClientId: sourceClientId,
                type: type,
                displayName: displayName,
                legalName: legalName,
                documentDigits: documentDigits,
                phoneDigits: phoneDigits,
                whatsappDigits: whatsappDigits,
                email: email,
                addressSummary: addressSummary,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyQuoteClientSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quoteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (quoteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.quoteId,
                                referencedTable:
                                    $$LegacyQuoteClientSnapshotsTableReferences
                                        ._quoteIdTable(db),
                                referencedColumn:
                                    $$LegacyQuoteClientSnapshotsTableReferences
                                        ._quoteIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LegacyQuoteClientSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyQuoteClientSnapshotsTable,
      LegacyQuoteClientSnapshotRow,
      $$LegacyQuoteClientSnapshotsTableFilterComposer,
      $$LegacyQuoteClientSnapshotsTableOrderingComposer,
      $$LegacyQuoteClientSnapshotsTableAnnotationComposer,
      $$LegacyQuoteClientSnapshotsTableCreateCompanionBuilder,
      $$LegacyQuoteClientSnapshotsTableUpdateCompanionBuilder,
      (
        LegacyQuoteClientSnapshotRow,
        $$LegacyQuoteClientSnapshotsTableReferences,
      ),
      LegacyQuoteClientSnapshotRow,
      PrefetchHooks Function({bool quoteId})
    >;
typedef $$LegacyQuoteEventSnapshotsTableCreateCompanionBuilder =
    LegacyQuoteEventSnapshotsCompanion Function({
      required String quoteId,
      Value<String?> name,
      Value<String?> type,
      Value<String?> eventDate,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<String?> venueName,
      Value<String?> addressSummary,
      Value<int?> guestCount,
      Value<int> rowid,
    });
typedef $$LegacyQuoteEventSnapshotsTableUpdateCompanionBuilder =
    LegacyQuoteEventSnapshotsCompanion Function({
      Value<String> quoteId,
      Value<String?> name,
      Value<String?> type,
      Value<String?> eventDate,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<String?> venueName,
      Value<String?> addressSummary,
      Value<int?> guestCount,
      Value<int> rowid,
    });

final class $$LegacyQuoteEventSnapshotsTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteEventSnapshotsTable,
          LegacyQuoteEventSnapshotRow
        > {
  $$LegacyQuoteEventSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyQuotesTable _quoteIdTable(_$LegacyAppDatabaseV10 db) => db
      .legacyQuotes
      .createAlias('quote_event_snapshots__quote_id__quotes__id');

  $$LegacyQuotesTableProcessedTableManager get quoteId {
    final $_column = $_itemColumn<String>('quote_id')!;

    final manager = $$LegacyQuotesTableTableManager(
      $_db,
      $_db.legacyQuotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LegacyQuoteEventSnapshotsTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteEventSnapshotsTable> {
  $$LegacyQuoteEventSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get venueName => $composableBuilder(
    column: $table.venueName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressSummary => $composableBuilder(
    column: $table.addressSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get guestCount => $composableBuilder(
    column: $table.guestCount,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyQuotesTableFilterComposer get quoteId {
    final $$LegacyQuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteEventSnapshotsTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteEventSnapshotsTable> {
  $$LegacyQuoteEventSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get venueName => $composableBuilder(
    column: $table.venueName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressSummary => $composableBuilder(
    column: $table.addressSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get guestCount => $composableBuilder(
    column: $table.guestCount,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyQuotesTableOrderingComposer get quoteId {
    final $$LegacyQuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableOrderingComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteEventSnapshotsTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteEventSnapshotsTable> {
  $$LegacyQuoteEventSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get eventDate =>
      $composableBuilder(column: $table.eventDate, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get venueName =>
      $composableBuilder(column: $table.venueName, builder: (column) => column);

  GeneratedColumn<String> get addressSummary => $composableBuilder(
    column: $table.addressSummary,
    builder: (column) => column,
  );

  GeneratedColumn<int> get guestCount => $composableBuilder(
    column: $table.guestCount,
    builder: (column) => column,
  );

  $$LegacyQuotesTableAnnotationComposer get quoteId {
    final $$LegacyQuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteEventSnapshotsTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteEventSnapshotsTable,
          LegacyQuoteEventSnapshotRow,
          $$LegacyQuoteEventSnapshotsTableFilterComposer,
          $$LegacyQuoteEventSnapshotsTableOrderingComposer,
          $$LegacyQuoteEventSnapshotsTableAnnotationComposer,
          $$LegacyQuoteEventSnapshotsTableCreateCompanionBuilder,
          $$LegacyQuoteEventSnapshotsTableUpdateCompanionBuilder,
          (
            LegacyQuoteEventSnapshotRow,
            $$LegacyQuoteEventSnapshotsTableReferences,
          ),
          LegacyQuoteEventSnapshotRow,
          PrefetchHooks Function({bool quoteId})
        > {
  $$LegacyQuoteEventSnapshotsTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyQuoteEventSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyQuoteEventSnapshotsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyQuoteEventSnapshotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyQuoteEventSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> quoteId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String?> eventDate = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<String?> venueName = const Value.absent(),
                Value<String?> addressSummary = const Value.absent(),
                Value<int?> guestCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteEventSnapshotsCompanion(
                quoteId: quoteId,
                name: name,
                type: type,
                eventDate: eventDate,
                startTime: startTime,
                endTime: endTime,
                venueName: venueName,
                addressSummary: addressSummary,
                guestCount: guestCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String quoteId,
                Value<String?> name = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String?> eventDate = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<String?> venueName = const Value.absent(),
                Value<String?> addressSummary = const Value.absent(),
                Value<int?> guestCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteEventSnapshotsCompanion.insert(
                quoteId: quoteId,
                name: name,
                type: type,
                eventDate: eventDate,
                startTime: startTime,
                endTime: endTime,
                venueName: venueName,
                addressSummary: addressSummary,
                guestCount: guestCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyQuoteEventSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quoteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (quoteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.quoteId,
                                referencedTable:
                                    $$LegacyQuoteEventSnapshotsTableReferences
                                        ._quoteIdTable(db),
                                referencedColumn:
                                    $$LegacyQuoteEventSnapshotsTableReferences
                                        ._quoteIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LegacyQuoteEventSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyQuoteEventSnapshotsTable,
      LegacyQuoteEventSnapshotRow,
      $$LegacyQuoteEventSnapshotsTableFilterComposer,
      $$LegacyQuoteEventSnapshotsTableOrderingComposer,
      $$LegacyQuoteEventSnapshotsTableAnnotationComposer,
      $$LegacyQuoteEventSnapshotsTableCreateCompanionBuilder,
      $$LegacyQuoteEventSnapshotsTableUpdateCompanionBuilder,
      (LegacyQuoteEventSnapshotRow, $$LegacyQuoteEventSnapshotsTableReferences),
      LegacyQuoteEventSnapshotRow,
      PrefetchHooks Function({bool quoteId})
    >;
typedef $$LegacyQuoteCompanySnapshotsTableCreateCompanionBuilder =
    LegacyQuoteCompanySnapshotsCompanion Function({
      required String quoteId,
      required String captureStatus,
      required int capturedAt,
      Value<String?> logoReference,
      required String identTradeName,
      Value<String?> identLegalName,
      Value<String?> identCnpjDigits,
      Value<String?> identStateRegistration,
      Value<String?> contactPhoneDigits,
      Value<String?> contactWhatsappDigits,
      Value<String?> contactEmail,
      Value<String?> contactInstagram,
      Value<String?> contactWebsite,
      Value<String?> addrPostalCode,
      Value<String?> addrStreet,
      Value<String?> addrNumber,
      Value<String?> addrComplement,
      Value<String?> addrNeighborhood,
      Value<String?> addrCity,
      Value<String?> addrState,
      Value<String?> repFullName,
      Value<String?> repCpfDigits,
      Value<String?> repRole,
      Value<String?> payPixKeyType,
      Value<String?> payPixKey,
      Value<String?> payBeneficiaryName,
      Value<String?> payPaymentTerms,
      Value<int> rowid,
    });
typedef $$LegacyQuoteCompanySnapshotsTableUpdateCompanionBuilder =
    LegacyQuoteCompanySnapshotsCompanion Function({
      Value<String> quoteId,
      Value<String> captureStatus,
      Value<int> capturedAt,
      Value<String?> logoReference,
      Value<String> identTradeName,
      Value<String?> identLegalName,
      Value<String?> identCnpjDigits,
      Value<String?> identStateRegistration,
      Value<String?> contactPhoneDigits,
      Value<String?> contactWhatsappDigits,
      Value<String?> contactEmail,
      Value<String?> contactInstagram,
      Value<String?> contactWebsite,
      Value<String?> addrPostalCode,
      Value<String?> addrStreet,
      Value<String?> addrNumber,
      Value<String?> addrComplement,
      Value<String?> addrNeighborhood,
      Value<String?> addrCity,
      Value<String?> addrState,
      Value<String?> repFullName,
      Value<String?> repCpfDigits,
      Value<String?> repRole,
      Value<String?> payPixKeyType,
      Value<String?> payPixKey,
      Value<String?> payBeneficiaryName,
      Value<String?> payPaymentTerms,
      Value<int> rowid,
    });

final class $$LegacyQuoteCompanySnapshotsTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteCompanySnapshotsTable,
          LegacyQuoteCompanySnapshotRow
        > {
  $$LegacyQuoteCompanySnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyQuotesTable _quoteIdTable(_$LegacyAppDatabaseV10 db) => db
      .legacyQuotes
      .createAlias('quote_company_snapshots__quote_id__quotes__id');

  $$LegacyQuotesTableProcessedTableManager get quoteId {
    final $_column = $_itemColumn<String>('quote_id')!;

    final manager = $$LegacyQuotesTableTableManager(
      $_db,
      $_db.legacyQuotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LegacyQuoteCompanySnapshotsTableFilterComposer
    extends
        Composer<_$LegacyAppDatabaseV10, $LegacyQuoteCompanySnapshotsTable> {
  $$LegacyQuoteCompanySnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get captureStatus => $composableBuilder(
    column: $table.captureStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoReference => $composableBuilder(
    column: $table.logoReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identTradeName => $composableBuilder(
    column: $table.identTradeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identLegalName => $composableBuilder(
    column: $table.identLegalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identCnpjDigits => $composableBuilder(
    column: $table.identCnpjDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identStateRegistration => $composableBuilder(
    column: $table.identStateRegistration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPhoneDigits => $composableBuilder(
    column: $table.contactPhoneDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactWhatsappDigits => $composableBuilder(
    column: $table.contactWhatsappDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactEmail => $composableBuilder(
    column: $table.contactEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactInstagram => $composableBuilder(
    column: $table.contactInstagram,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactWebsite => $composableBuilder(
    column: $table.contactWebsite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addrPostalCode => $composableBuilder(
    column: $table.addrPostalCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addrStreet => $composableBuilder(
    column: $table.addrStreet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addrNumber => $composableBuilder(
    column: $table.addrNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addrComplement => $composableBuilder(
    column: $table.addrComplement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addrNeighborhood => $composableBuilder(
    column: $table.addrNeighborhood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addrCity => $composableBuilder(
    column: $table.addrCity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addrState => $composableBuilder(
    column: $table.addrState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repFullName => $composableBuilder(
    column: $table.repFullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repCpfDigits => $composableBuilder(
    column: $table.repCpfDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repRole => $composableBuilder(
    column: $table.repRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payPixKeyType => $composableBuilder(
    column: $table.payPixKeyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payPixKey => $composableBuilder(
    column: $table.payPixKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payBeneficiaryName => $composableBuilder(
    column: $table.payBeneficiaryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payPaymentTerms => $composableBuilder(
    column: $table.payPaymentTerms,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyQuotesTableFilterComposer get quoteId {
    final $$LegacyQuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteCompanySnapshotsTableOrderingComposer
    extends
        Composer<_$LegacyAppDatabaseV10, $LegacyQuoteCompanySnapshotsTable> {
  $$LegacyQuoteCompanySnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get captureStatus => $composableBuilder(
    column: $table.captureStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoReference => $composableBuilder(
    column: $table.logoReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identTradeName => $composableBuilder(
    column: $table.identTradeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identLegalName => $composableBuilder(
    column: $table.identLegalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identCnpjDigits => $composableBuilder(
    column: $table.identCnpjDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identStateRegistration => $composableBuilder(
    column: $table.identStateRegistration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPhoneDigits => $composableBuilder(
    column: $table.contactPhoneDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactWhatsappDigits => $composableBuilder(
    column: $table.contactWhatsappDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactEmail => $composableBuilder(
    column: $table.contactEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactInstagram => $composableBuilder(
    column: $table.contactInstagram,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactWebsite => $composableBuilder(
    column: $table.contactWebsite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addrPostalCode => $composableBuilder(
    column: $table.addrPostalCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addrStreet => $composableBuilder(
    column: $table.addrStreet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addrNumber => $composableBuilder(
    column: $table.addrNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addrComplement => $composableBuilder(
    column: $table.addrComplement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addrNeighborhood => $composableBuilder(
    column: $table.addrNeighborhood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addrCity => $composableBuilder(
    column: $table.addrCity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addrState => $composableBuilder(
    column: $table.addrState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repFullName => $composableBuilder(
    column: $table.repFullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repCpfDigits => $composableBuilder(
    column: $table.repCpfDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repRole => $composableBuilder(
    column: $table.repRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payPixKeyType => $composableBuilder(
    column: $table.payPixKeyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payPixKey => $composableBuilder(
    column: $table.payPixKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payBeneficiaryName => $composableBuilder(
    column: $table.payBeneficiaryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payPaymentTerms => $composableBuilder(
    column: $table.payPaymentTerms,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyQuotesTableOrderingComposer get quoteId {
    final $$LegacyQuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableOrderingComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteCompanySnapshotsTableAnnotationComposer
    extends
        Composer<_$LegacyAppDatabaseV10, $LegacyQuoteCompanySnapshotsTable> {
  $$LegacyQuoteCompanySnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get captureStatus => $composableBuilder(
    column: $table.captureStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoReference => $composableBuilder(
    column: $table.logoReference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get identTradeName => $composableBuilder(
    column: $table.identTradeName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get identLegalName => $composableBuilder(
    column: $table.identLegalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get identCnpjDigits => $composableBuilder(
    column: $table.identCnpjDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get identStateRegistration => $composableBuilder(
    column: $table.identStateRegistration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactPhoneDigits => $composableBuilder(
    column: $table.contactPhoneDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactWhatsappDigits => $composableBuilder(
    column: $table.contactWhatsappDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactEmail => $composableBuilder(
    column: $table.contactEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactInstagram => $composableBuilder(
    column: $table.contactInstagram,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactWebsite => $composableBuilder(
    column: $table.contactWebsite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addrPostalCode => $composableBuilder(
    column: $table.addrPostalCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addrStreet => $composableBuilder(
    column: $table.addrStreet,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addrNumber => $composableBuilder(
    column: $table.addrNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addrComplement => $composableBuilder(
    column: $table.addrComplement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addrNeighborhood => $composableBuilder(
    column: $table.addrNeighborhood,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addrCity =>
      $composableBuilder(column: $table.addrCity, builder: (column) => column);

  GeneratedColumn<String> get addrState =>
      $composableBuilder(column: $table.addrState, builder: (column) => column);

  GeneratedColumn<String> get repFullName => $composableBuilder(
    column: $table.repFullName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repCpfDigits => $composableBuilder(
    column: $table.repCpfDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repRole =>
      $composableBuilder(column: $table.repRole, builder: (column) => column);

  GeneratedColumn<String> get payPixKeyType => $composableBuilder(
    column: $table.payPixKeyType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payPixKey =>
      $composableBuilder(column: $table.payPixKey, builder: (column) => column);

  GeneratedColumn<String> get payBeneficiaryName => $composableBuilder(
    column: $table.payBeneficiaryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payPaymentTerms => $composableBuilder(
    column: $table.payPaymentTerms,
    builder: (column) => column,
  );

  $$LegacyQuotesTableAnnotationComposer get quoteId {
    final $$LegacyQuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteCompanySnapshotsTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteCompanySnapshotsTable,
          LegacyQuoteCompanySnapshotRow,
          $$LegacyQuoteCompanySnapshotsTableFilterComposer,
          $$LegacyQuoteCompanySnapshotsTableOrderingComposer,
          $$LegacyQuoteCompanySnapshotsTableAnnotationComposer,
          $$LegacyQuoteCompanySnapshotsTableCreateCompanionBuilder,
          $$LegacyQuoteCompanySnapshotsTableUpdateCompanionBuilder,
          (
            LegacyQuoteCompanySnapshotRow,
            $$LegacyQuoteCompanySnapshotsTableReferences,
          ),
          LegacyQuoteCompanySnapshotRow,
          PrefetchHooks Function({bool quoteId})
        > {
  $$LegacyQuoteCompanySnapshotsTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyQuoteCompanySnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyQuoteCompanySnapshotsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyQuoteCompanySnapshotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyQuoteCompanySnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> quoteId = const Value.absent(),
                Value<String> captureStatus = const Value.absent(),
                Value<int> capturedAt = const Value.absent(),
                Value<String?> logoReference = const Value.absent(),
                Value<String> identTradeName = const Value.absent(),
                Value<String?> identLegalName = const Value.absent(),
                Value<String?> identCnpjDigits = const Value.absent(),
                Value<String?> identStateRegistration = const Value.absent(),
                Value<String?> contactPhoneDigits = const Value.absent(),
                Value<String?> contactWhatsappDigits = const Value.absent(),
                Value<String?> contactEmail = const Value.absent(),
                Value<String?> contactInstagram = const Value.absent(),
                Value<String?> contactWebsite = const Value.absent(),
                Value<String?> addrPostalCode = const Value.absent(),
                Value<String?> addrStreet = const Value.absent(),
                Value<String?> addrNumber = const Value.absent(),
                Value<String?> addrComplement = const Value.absent(),
                Value<String?> addrNeighborhood = const Value.absent(),
                Value<String?> addrCity = const Value.absent(),
                Value<String?> addrState = const Value.absent(),
                Value<String?> repFullName = const Value.absent(),
                Value<String?> repCpfDigits = const Value.absent(),
                Value<String?> repRole = const Value.absent(),
                Value<String?> payPixKeyType = const Value.absent(),
                Value<String?> payPixKey = const Value.absent(),
                Value<String?> payBeneficiaryName = const Value.absent(),
                Value<String?> payPaymentTerms = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteCompanySnapshotsCompanion(
                quoteId: quoteId,
                captureStatus: captureStatus,
                capturedAt: capturedAt,
                logoReference: logoReference,
                identTradeName: identTradeName,
                identLegalName: identLegalName,
                identCnpjDigits: identCnpjDigits,
                identStateRegistration: identStateRegistration,
                contactPhoneDigits: contactPhoneDigits,
                contactWhatsappDigits: contactWhatsappDigits,
                contactEmail: contactEmail,
                contactInstagram: contactInstagram,
                contactWebsite: contactWebsite,
                addrPostalCode: addrPostalCode,
                addrStreet: addrStreet,
                addrNumber: addrNumber,
                addrComplement: addrComplement,
                addrNeighborhood: addrNeighborhood,
                addrCity: addrCity,
                addrState: addrState,
                repFullName: repFullName,
                repCpfDigits: repCpfDigits,
                repRole: repRole,
                payPixKeyType: payPixKeyType,
                payPixKey: payPixKey,
                payBeneficiaryName: payBeneficiaryName,
                payPaymentTerms: payPaymentTerms,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String quoteId,
                required String captureStatus,
                required int capturedAt,
                Value<String?> logoReference = const Value.absent(),
                required String identTradeName,
                Value<String?> identLegalName = const Value.absent(),
                Value<String?> identCnpjDigits = const Value.absent(),
                Value<String?> identStateRegistration = const Value.absent(),
                Value<String?> contactPhoneDigits = const Value.absent(),
                Value<String?> contactWhatsappDigits = const Value.absent(),
                Value<String?> contactEmail = const Value.absent(),
                Value<String?> contactInstagram = const Value.absent(),
                Value<String?> contactWebsite = const Value.absent(),
                Value<String?> addrPostalCode = const Value.absent(),
                Value<String?> addrStreet = const Value.absent(),
                Value<String?> addrNumber = const Value.absent(),
                Value<String?> addrComplement = const Value.absent(),
                Value<String?> addrNeighborhood = const Value.absent(),
                Value<String?> addrCity = const Value.absent(),
                Value<String?> addrState = const Value.absent(),
                Value<String?> repFullName = const Value.absent(),
                Value<String?> repCpfDigits = const Value.absent(),
                Value<String?> repRole = const Value.absent(),
                Value<String?> payPixKeyType = const Value.absent(),
                Value<String?> payPixKey = const Value.absent(),
                Value<String?> payBeneficiaryName = const Value.absent(),
                Value<String?> payPaymentTerms = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteCompanySnapshotsCompanion.insert(
                quoteId: quoteId,
                captureStatus: captureStatus,
                capturedAt: capturedAt,
                logoReference: logoReference,
                identTradeName: identTradeName,
                identLegalName: identLegalName,
                identCnpjDigits: identCnpjDigits,
                identStateRegistration: identStateRegistration,
                contactPhoneDigits: contactPhoneDigits,
                contactWhatsappDigits: contactWhatsappDigits,
                contactEmail: contactEmail,
                contactInstagram: contactInstagram,
                contactWebsite: contactWebsite,
                addrPostalCode: addrPostalCode,
                addrStreet: addrStreet,
                addrNumber: addrNumber,
                addrComplement: addrComplement,
                addrNeighborhood: addrNeighborhood,
                addrCity: addrCity,
                addrState: addrState,
                repFullName: repFullName,
                repCpfDigits: repCpfDigits,
                repRole: repRole,
                payPixKeyType: payPixKeyType,
                payPixKey: payPixKey,
                payBeneficiaryName: payBeneficiaryName,
                payPaymentTerms: payPaymentTerms,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyQuoteCompanySnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quoteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (quoteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.quoteId,
                                referencedTable:
                                    $$LegacyQuoteCompanySnapshotsTableReferences
                                        ._quoteIdTable(db),
                                referencedColumn:
                                    $$LegacyQuoteCompanySnapshotsTableReferences
                                        ._quoteIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LegacyQuoteCompanySnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyQuoteCompanySnapshotsTable,
      LegacyQuoteCompanySnapshotRow,
      $$LegacyQuoteCompanySnapshotsTableFilterComposer,
      $$LegacyQuoteCompanySnapshotsTableOrderingComposer,
      $$LegacyQuoteCompanySnapshotsTableAnnotationComposer,
      $$LegacyQuoteCompanySnapshotsTableCreateCompanionBuilder,
      $$LegacyQuoteCompanySnapshotsTableUpdateCompanionBuilder,
      (
        LegacyQuoteCompanySnapshotRow,
        $$LegacyQuoteCompanySnapshotsTableReferences,
      ),
      LegacyQuoteCompanySnapshotRow,
      PrefetchHooks Function({bool quoteId})
    >;
typedef $$LegacyQuoteLineItemsTableCreateCompanionBuilder =
    LegacyQuoteLineItemsCompanion Function({
      required String id,
      required String quoteId,
      required int sortOrder,
      Value<String?> catalogItemId,
      required String name,
      Value<String?> description,
      required String unit,
      required double quantity,
      required int unitPriceCents,
      required int lineTotalCents,
      Value<int> rowid,
    });
typedef $$LegacyQuoteLineItemsTableUpdateCompanionBuilder =
    LegacyQuoteLineItemsCompanion Function({
      Value<String> id,
      Value<String> quoteId,
      Value<int> sortOrder,
      Value<String?> catalogItemId,
      Value<String> name,
      Value<String?> description,
      Value<String> unit,
      Value<double> quantity,
      Value<int> unitPriceCents,
      Value<int> lineTotalCents,
      Value<int> rowid,
    });

final class $$LegacyQuoteLineItemsTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteLineItemsTable,
          LegacyQuoteLineItemRow
        > {
  $$LegacyQuoteLineItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyQuotesTable _quoteIdTable(_$LegacyAppDatabaseV10 db) =>
      db.legacyQuotes.createAlias('quote_line_items__quote_id__quotes__id');

  $$LegacyQuotesTableProcessedTableManager get quoteId {
    final $_column = $_itemColumn<String>('quote_id')!;

    final manager = $$LegacyQuotesTableTableManager(
      $_db,
      $_db.legacyQuotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $LegacyQuoteLinePackageComponentsTable,
    List<LegacyQuoteLinePackageComponentRow>
  >
  _legacyQuoteLinePackageComponentsRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteLinePackageComponents,
        aliasName:
            'quote_line_items__id__quote_line_package_components__line_item_id',
      );

  $$LegacyQuoteLinePackageComponentsTableProcessedTableManager
  get legacyQuoteLinePackageComponentsRefs {
    final manager = $$LegacyQuoteLinePackageComponentsTableTableManager(
      $_db,
      $_db.legacyQuoteLinePackageComponents,
    ).filter((f) => f.lineItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteLinePackageComponentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LegacyQuoteLineItemsTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteLineItemsTable> {
  $$LegacyQuoteLineItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogItemId => $composableBuilder(
    column: $table.catalogItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceCents => $composableBuilder(
    column: $table.unitPriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineTotalCents => $composableBuilder(
    column: $table.lineTotalCents,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyQuotesTableFilterComposer get quoteId {
    final $$LegacyQuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> legacyQuoteLinePackageComponentsRefs(
    Expression<bool> Function(
      $$LegacyQuoteLinePackageComponentsTableFilterComposer f,
    )
    f,
  ) {
    final $$LegacyQuoteLinePackageComponentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteLinePackageComponents,
          getReferencedColumn: (t) => t.lineItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteLinePackageComponentsTableFilterComposer(
                $db: $db,
                $table: $db.legacyQuoteLinePackageComponents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LegacyQuoteLineItemsTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteLineItemsTable> {
  $$LegacyQuoteLineItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogItemId => $composableBuilder(
    column: $table.catalogItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceCents => $composableBuilder(
    column: $table.unitPriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineTotalCents => $composableBuilder(
    column: $table.lineTotalCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyQuotesTableOrderingComposer get quoteId {
    final $$LegacyQuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableOrderingComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteLineItemsTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteLineItemsTable> {
  $$LegacyQuoteLineItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get catalogItemId => $composableBuilder(
    column: $table.catalogItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPriceCents => $composableBuilder(
    column: $table.unitPriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lineTotalCents => $composableBuilder(
    column: $table.lineTotalCents,
    builder: (column) => column,
  );

  $$LegacyQuotesTableAnnotationComposer get quoteId {
    final $$LegacyQuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> legacyQuoteLinePackageComponentsRefs<T extends Object>(
    Expression<T> Function(
      $$LegacyQuoteLinePackageComponentsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$LegacyQuoteLinePackageComponentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteLinePackageComponents,
          getReferencedColumn: (t) => t.lineItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteLinePackageComponentsTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteLinePackageComponents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LegacyQuoteLineItemsTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteLineItemsTable,
          LegacyQuoteLineItemRow,
          $$LegacyQuoteLineItemsTableFilterComposer,
          $$LegacyQuoteLineItemsTableOrderingComposer,
          $$LegacyQuoteLineItemsTableAnnotationComposer,
          $$LegacyQuoteLineItemsTableCreateCompanionBuilder,
          $$LegacyQuoteLineItemsTableUpdateCompanionBuilder,
          (LegacyQuoteLineItemRow, $$LegacyQuoteLineItemsTableReferences),
          LegacyQuoteLineItemRow,
          PrefetchHooks Function({
            bool quoteId,
            bool legacyQuoteLinePackageComponentsRefs,
          })
        > {
  $$LegacyQuoteLineItemsTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyQuoteLineItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyQuoteLineItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegacyQuoteLineItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyQuoteLineItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> quoteId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> catalogItemId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<int> unitPriceCents = const Value.absent(),
                Value<int> lineTotalCents = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteLineItemsCompanion(
                id: id,
                quoteId: quoteId,
                sortOrder: sortOrder,
                catalogItemId: catalogItemId,
                name: name,
                description: description,
                unit: unit,
                quantity: quantity,
                unitPriceCents: unitPriceCents,
                lineTotalCents: lineTotalCents,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String quoteId,
                required int sortOrder,
                Value<String?> catalogItemId = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                required String unit,
                required double quantity,
                required int unitPriceCents,
                required int lineTotalCents,
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteLineItemsCompanion.insert(
                id: id,
                quoteId: quoteId,
                sortOrder: sortOrder,
                catalogItemId: catalogItemId,
                name: name,
                description: description,
                unit: unit,
                quantity: quantity,
                unitPriceCents: unitPriceCents,
                lineTotalCents: lineTotalCents,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyQuoteLineItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                quoteId = false,
                legacyQuoteLinePackageComponentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (legacyQuoteLinePackageComponentsRefs)
                      db.legacyQuoteLinePackageComponents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (quoteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.quoteId,
                                    referencedTable:
                                        $$LegacyQuoteLineItemsTableReferences
                                            ._quoteIdTable(db),
                                    referencedColumn:
                                        $$LegacyQuoteLineItemsTableReferences
                                            ._quoteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (legacyQuoteLinePackageComponentsRefs)
                        await $_getPrefetchedData<
                          LegacyQuoteLineItemRow,
                          $LegacyQuoteLineItemsTable,
                          LegacyQuoteLinePackageComponentRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyQuoteLineItemsTableReferences
                              ._legacyQuoteLinePackageComponentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyQuoteLineItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteLinePackageComponentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lineItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LegacyQuoteLineItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyQuoteLineItemsTable,
      LegacyQuoteLineItemRow,
      $$LegacyQuoteLineItemsTableFilterComposer,
      $$LegacyQuoteLineItemsTableOrderingComposer,
      $$LegacyQuoteLineItemsTableAnnotationComposer,
      $$LegacyQuoteLineItemsTableCreateCompanionBuilder,
      $$LegacyQuoteLineItemsTableUpdateCompanionBuilder,
      (LegacyQuoteLineItemRow, $$LegacyQuoteLineItemsTableReferences),
      LegacyQuoteLineItemRow,
      PrefetchHooks Function({
        bool quoteId,
        bool legacyQuoteLinePackageComponentsRefs,
      })
    >;
typedef $$LegacyQuoteLinePackageComponentsTableCreateCompanionBuilder =
    LegacyQuoteLinePackageComponentsCompanion Function({
      required String id,
      required String lineItemId,
      required int sortOrder,
      Value<String?> catalogItemId,
      required String name,
      required String unit,
      required String typeLabel,
      required String categoryLabel,
      required double quantityPerPackage,
      Value<int> rowid,
    });
typedef $$LegacyQuoteLinePackageComponentsTableUpdateCompanionBuilder =
    LegacyQuoteLinePackageComponentsCompanion Function({
      Value<String> id,
      Value<String> lineItemId,
      Value<int> sortOrder,
      Value<String?> catalogItemId,
      Value<String> name,
      Value<String> unit,
      Value<String> typeLabel,
      Value<String> categoryLabel,
      Value<double> quantityPerPackage,
      Value<int> rowid,
    });

final class $$LegacyQuoteLinePackageComponentsTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteLinePackageComponentsTable,
          LegacyQuoteLinePackageComponentRow
        > {
  $$LegacyQuoteLinePackageComponentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyQuoteLineItemsTable _lineItemIdTable(
    _$LegacyAppDatabaseV10 db,
  ) => db.legacyQuoteLineItems.createAlias(
    'quote_line_package_components__line_item_id__quote_line_items__id',
  );

  $$LegacyQuoteLineItemsTableProcessedTableManager get lineItemId {
    final $_column = $_itemColumn<String>('line_item_id')!;

    final manager = $$LegacyQuoteLineItemsTableTableManager(
      $_db,
      $_db.legacyQuoteLineItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lineItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LegacyQuoteLinePackageComponentsTableFilterComposer
    extends
        Composer<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteLinePackageComponentsTable
        > {
  $$LegacyQuoteLinePackageComponentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogItemId => $composableBuilder(
    column: $table.catalogItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeLabel => $composableBuilder(
    column: $table.typeLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryLabel => $composableBuilder(
    column: $table.categoryLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityPerPackage => $composableBuilder(
    column: $table.quantityPerPackage,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyQuoteLineItemsTableFilterComposer get lineItemId {
    final $$LegacyQuoteLineItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lineItemId,
      referencedTable: $db.legacyQuoteLineItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuoteLineItemsTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuoteLineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteLinePackageComponentsTableOrderingComposer
    extends
        Composer<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteLinePackageComponentsTable
        > {
  $$LegacyQuoteLinePackageComponentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogItemId => $composableBuilder(
    column: $table.catalogItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeLabel => $composableBuilder(
    column: $table.typeLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryLabel => $composableBuilder(
    column: $table.categoryLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityPerPackage => $composableBuilder(
    column: $table.quantityPerPackage,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyQuoteLineItemsTableOrderingComposer get lineItemId {
    final $$LegacyQuoteLineItemsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.lineItemId,
          referencedTable: $db.legacyQuoteLineItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteLineItemsTableOrderingComposer(
                $db: $db,
                $table: $db.legacyQuoteLineItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$LegacyQuoteLinePackageComponentsTableAnnotationComposer
    extends
        Composer<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteLinePackageComponentsTable
        > {
  $$LegacyQuoteLinePackageComponentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get catalogItemId => $composableBuilder(
    column: $table.catalogItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get typeLabel =>
      $composableBuilder(column: $table.typeLabel, builder: (column) => column);

  GeneratedColumn<String> get categoryLabel => $composableBuilder(
    column: $table.categoryLabel,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantityPerPackage => $composableBuilder(
    column: $table.quantityPerPackage,
    builder: (column) => column,
  );

  $$LegacyQuoteLineItemsTableAnnotationComposer get lineItemId {
    final $$LegacyQuoteLineItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.lineItemId,
          referencedTable: $db.legacyQuoteLineItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteLineItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteLineItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$LegacyQuoteLinePackageComponentsTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteLinePackageComponentsTable,
          LegacyQuoteLinePackageComponentRow,
          $$LegacyQuoteLinePackageComponentsTableFilterComposer,
          $$LegacyQuoteLinePackageComponentsTableOrderingComposer,
          $$LegacyQuoteLinePackageComponentsTableAnnotationComposer,
          $$LegacyQuoteLinePackageComponentsTableCreateCompanionBuilder,
          $$LegacyQuoteLinePackageComponentsTableUpdateCompanionBuilder,
          (
            LegacyQuoteLinePackageComponentRow,
            $$LegacyQuoteLinePackageComponentsTableReferences,
          ),
          LegacyQuoteLinePackageComponentRow,
          PrefetchHooks Function({bool lineItemId})
        > {
  $$LegacyQuoteLinePackageComponentsTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyQuoteLinePackageComponentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyQuoteLinePackageComponentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyQuoteLinePackageComponentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyQuoteLinePackageComponentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lineItemId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> catalogItemId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> typeLabel = const Value.absent(),
                Value<String> categoryLabel = const Value.absent(),
                Value<double> quantityPerPackage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteLinePackageComponentsCompanion(
                id: id,
                lineItemId: lineItemId,
                sortOrder: sortOrder,
                catalogItemId: catalogItemId,
                name: name,
                unit: unit,
                typeLabel: typeLabel,
                categoryLabel: categoryLabel,
                quantityPerPackage: quantityPerPackage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lineItemId,
                required int sortOrder,
                Value<String?> catalogItemId = const Value.absent(),
                required String name,
                required String unit,
                required String typeLabel,
                required String categoryLabel,
                required double quantityPerPackage,
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteLinePackageComponentsCompanion.insert(
                id: id,
                lineItemId: lineItemId,
                sortOrder: sortOrder,
                catalogItemId: catalogItemId,
                name: name,
                unit: unit,
                typeLabel: typeLabel,
                categoryLabel: categoryLabel,
                quantityPerPackage: quantityPerPackage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyQuoteLinePackageComponentsTableReferences(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lineItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (lineItemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lineItemId,
                                referencedTable:
                                    $$LegacyQuoteLinePackageComponentsTableReferences
                                        ._lineItemIdTable(db),
                                referencedColumn:
                                    $$LegacyQuoteLinePackageComponentsTableReferences
                                        ._lineItemIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LegacyQuoteLinePackageComponentsTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyQuoteLinePackageComponentsTable,
      LegacyQuoteLinePackageComponentRow,
      $$LegacyQuoteLinePackageComponentsTableFilterComposer,
      $$LegacyQuoteLinePackageComponentsTableOrderingComposer,
      $$LegacyQuoteLinePackageComponentsTableAnnotationComposer,
      $$LegacyQuoteLinePackageComponentsTableCreateCompanionBuilder,
      $$LegacyQuoteLinePackageComponentsTableUpdateCompanionBuilder,
      (
        LegacyQuoteLinePackageComponentRow,
        $$LegacyQuoteLinePackageComponentsTableReferences,
      ),
      LegacyQuoteLinePackageComponentRow,
      PrefetchHooks Function({bool lineItemId})
    >;
typedef $$LegacyQuoteStatusHistoryTableCreateCompanionBuilder =
    LegacyQuoteStatusHistoryCompanion Function({
      required String id,
      required String quoteId,
      required int sortOrder,
      Value<String?> previousStatus,
      required String newStatus,
      required int changedAt,
      Value<int> rowid,
    });
typedef $$LegacyQuoteStatusHistoryTableUpdateCompanionBuilder =
    LegacyQuoteStatusHistoryCompanion Function({
      Value<String> id,
      Value<String> quoteId,
      Value<int> sortOrder,
      Value<String?> previousStatus,
      Value<String> newStatus,
      Value<int> changedAt,
      Value<int> rowid,
    });

final class $$LegacyQuoteStatusHistoryTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteStatusHistoryTable,
          LegacyQuoteStatusHistoryRow
        > {
  $$LegacyQuoteStatusHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyQuotesTable _quoteIdTable(_$LegacyAppDatabaseV10 db) =>
      db.legacyQuotes.createAlias('quote_status_history__quote_id__quotes__id');

  $$LegacyQuotesTableProcessedTableManager get quoteId {
    final $_column = $_itemColumn<String>('quote_id')!;

    final manager = $$LegacyQuotesTableTableManager(
      $_db,
      $_db.legacyQuotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LegacyQuoteStatusHistoryTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteStatusHistoryTable> {
  $$LegacyQuoteStatusHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousStatus => $composableBuilder(
    column: $table.previousStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newStatus => $composableBuilder(
    column: $table.newStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyQuotesTableFilterComposer get quoteId {
    final $$LegacyQuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteStatusHistoryTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteStatusHistoryTable> {
  $$LegacyQuoteStatusHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousStatus => $composableBuilder(
    column: $table.previousStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newStatus => $composableBuilder(
    column: $table.newStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyQuotesTableOrderingComposer get quoteId {
    final $$LegacyQuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableOrderingComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteStatusHistoryTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteStatusHistoryTable> {
  $$LegacyQuoteStatusHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get previousStatus => $composableBuilder(
    column: $table.previousStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get newStatus =>
      $composableBuilder(column: $table.newStatus, builder: (column) => column);

  GeneratedColumn<int> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  $$LegacyQuotesTableAnnotationComposer get quoteId {
    final $$LegacyQuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteStatusHistoryTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteStatusHistoryTable,
          LegacyQuoteStatusHistoryRow,
          $$LegacyQuoteStatusHistoryTableFilterComposer,
          $$LegacyQuoteStatusHistoryTableOrderingComposer,
          $$LegacyQuoteStatusHistoryTableAnnotationComposer,
          $$LegacyQuoteStatusHistoryTableCreateCompanionBuilder,
          $$LegacyQuoteStatusHistoryTableUpdateCompanionBuilder,
          (
            LegacyQuoteStatusHistoryRow,
            $$LegacyQuoteStatusHistoryTableReferences,
          ),
          LegacyQuoteStatusHistoryRow,
          PrefetchHooks Function({bool quoteId})
        > {
  $$LegacyQuoteStatusHistoryTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyQuoteStatusHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyQuoteStatusHistoryTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyQuoteStatusHistoryTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyQuoteStatusHistoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> quoteId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> previousStatus = const Value.absent(),
                Value<String> newStatus = const Value.absent(),
                Value<int> changedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteStatusHistoryCompanion(
                id: id,
                quoteId: quoteId,
                sortOrder: sortOrder,
                previousStatus: previousStatus,
                newStatus: newStatus,
                changedAt: changedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String quoteId,
                required int sortOrder,
                Value<String?> previousStatus = const Value.absent(),
                required String newStatus,
                required int changedAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteStatusHistoryCompanion.insert(
                id: id,
                quoteId: quoteId,
                sortOrder: sortOrder,
                previousStatus: previousStatus,
                newStatus: newStatus,
                changedAt: changedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyQuoteStatusHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quoteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (quoteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.quoteId,
                                referencedTable:
                                    $$LegacyQuoteStatusHistoryTableReferences
                                        ._quoteIdTable(db),
                                referencedColumn:
                                    $$LegacyQuoteStatusHistoryTableReferences
                                        ._quoteIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LegacyQuoteStatusHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyQuoteStatusHistoryTable,
      LegacyQuoteStatusHistoryRow,
      $$LegacyQuoteStatusHistoryTableFilterComposer,
      $$LegacyQuoteStatusHistoryTableOrderingComposer,
      $$LegacyQuoteStatusHistoryTableAnnotationComposer,
      $$LegacyQuoteStatusHistoryTableCreateCompanionBuilder,
      $$LegacyQuoteStatusHistoryTableUpdateCompanionBuilder,
      (LegacyQuoteStatusHistoryRow, $$LegacyQuoteStatusHistoryTableReferences),
      LegacyQuoteStatusHistoryRow,
      PrefetchHooks Function({bool quoteId})
    >;
typedef $$LegacyQuoteNumberSequencesTableCreateCompanionBuilder =
    LegacyQuoteNumberSequencesCompanion Function({
      Value<int> year,
      required int lastSequence,
    });
typedef $$LegacyQuoteNumberSequencesTableUpdateCompanionBuilder =
    LegacyQuoteNumberSequencesCompanion Function({
      Value<int> year,
      Value<int> lastSequence,
    });

class $$LegacyQuoteNumberSequencesTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteNumberSequencesTable> {
  $$LegacyQuoteNumberSequencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegacyQuoteNumberSequencesTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteNumberSequencesTable> {
  $$LegacyQuoteNumberSequencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegacyQuoteNumberSequencesTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteNumberSequencesTable> {
  $$LegacyQuoteNumberSequencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => column,
  );
}

class $$LegacyQuoteNumberSequencesTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteNumberSequencesTable,
          LegacyQuoteNumberSequenceRow,
          $$LegacyQuoteNumberSequencesTableFilterComposer,
          $$LegacyQuoteNumberSequencesTableOrderingComposer,
          $$LegacyQuoteNumberSequencesTableAnnotationComposer,
          $$LegacyQuoteNumberSequencesTableCreateCompanionBuilder,
          $$LegacyQuoteNumberSequencesTableUpdateCompanionBuilder,
          (
            LegacyQuoteNumberSequenceRow,
            BaseReferences<
              _$LegacyAppDatabaseV10,
              $LegacyQuoteNumberSequencesTable,
              LegacyQuoteNumberSequenceRow
            >,
          ),
          LegacyQuoteNumberSequenceRow,
          PrefetchHooks Function()
        > {
  $$LegacyQuoteNumberSequencesTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyQuoteNumberSequencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyQuoteNumberSequencesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyQuoteNumberSequencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyQuoteNumberSequencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> year = const Value.absent(),
                Value<int> lastSequence = const Value.absent(),
              }) => LegacyQuoteNumberSequencesCompanion(
                year: year,
                lastSequence: lastSequence,
              ),
          createCompanionCallback:
              ({
                Value<int> year = const Value.absent(),
                required int lastSequence,
              }) => LegacyQuoteNumberSequencesCompanion.insert(
                year: year,
                lastSequence: lastSequence,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegacyQuoteNumberSequencesTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyQuoteNumberSequencesTable,
      LegacyQuoteNumberSequenceRow,
      $$LegacyQuoteNumberSequencesTableFilterComposer,
      $$LegacyQuoteNumberSequencesTableOrderingComposer,
      $$LegacyQuoteNumberSequencesTableAnnotationComposer,
      $$LegacyQuoteNumberSequencesTableCreateCompanionBuilder,
      $$LegacyQuoteNumberSequencesTableUpdateCompanionBuilder,
      (
        LegacyQuoteNumberSequenceRow,
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteNumberSequencesTable,
          LegacyQuoteNumberSequenceRow
        >,
      ),
      LegacyQuoteNumberSequenceRow,
      PrefetchHooks Function()
    >;
typedef $$LegacyAgendaBlocksTableCreateCompanionBuilder =
    LegacyAgendaBlocksCompanion Function({
      required String id,
      required String title,
      Value<String?> notes,
      required int start,
      required int end,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LegacyAgendaBlocksTableUpdateCompanionBuilder =
    LegacyAgendaBlocksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> notes,
      Value<int> start,
      Value<int> end,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$LegacyAgendaBlocksTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyAgendaBlocksTable> {
  $$LegacyAgendaBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegacyAgendaBlocksTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyAgendaBlocksTable> {
  $$LegacyAgendaBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegacyAgendaBlocksTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyAgendaBlocksTable> {
  $$LegacyAgendaBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<int> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LegacyAgendaBlocksTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyAgendaBlocksTable,
          LegacyAgendaBlockRow,
          $$LegacyAgendaBlocksTableFilterComposer,
          $$LegacyAgendaBlocksTableOrderingComposer,
          $$LegacyAgendaBlocksTableAnnotationComposer,
          $$LegacyAgendaBlocksTableCreateCompanionBuilder,
          $$LegacyAgendaBlocksTableUpdateCompanionBuilder,
          (
            LegacyAgendaBlockRow,
            BaseReferences<
              _$LegacyAppDatabaseV10,
              $LegacyAgendaBlocksTable,
              LegacyAgendaBlockRow
            >,
          ),
          LegacyAgendaBlockRow,
          PrefetchHooks Function()
        > {
  $$LegacyAgendaBlocksTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyAgendaBlocksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyAgendaBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegacyAgendaBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegacyAgendaBlocksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> start = const Value.absent(),
                Value<int> end = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyAgendaBlocksCompanion(
                id: id,
                title: title,
                notes: notes,
                start: start,
                end: end,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> notes = const Value.absent(),
                required int start,
                required int end,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyAgendaBlocksCompanion.insert(
                id: id,
                title: title,
                notes: notes,
                start: start,
                end: end,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegacyAgendaBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyAgendaBlocksTable,
      LegacyAgendaBlockRow,
      $$LegacyAgendaBlocksTableFilterComposer,
      $$LegacyAgendaBlocksTableOrderingComposer,
      $$LegacyAgendaBlocksTableAnnotationComposer,
      $$LegacyAgendaBlocksTableCreateCompanionBuilder,
      $$LegacyAgendaBlocksTableUpdateCompanionBuilder,
      (
        LegacyAgendaBlockRow,
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyAgendaBlocksTable,
          LegacyAgendaBlockRow
        >,
      ),
      LegacyAgendaBlockRow,
      PrefetchHooks Function()
    >;
typedef $$LegacyFinancialCategoriesTableCreateCompanionBuilder =
    LegacyFinancialCategoriesCompanion Function({
      required String id,
      required String name,
      required String kind,
      required bool active,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$LegacyFinancialCategoriesTableUpdateCompanionBuilder =
    LegacyFinancialCategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> kind,
      Value<bool> active,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$LegacyFinancialCategoriesTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyFinancialCategoriesTable,
          LegacyFinancialCategoryRow
        > {
  $$LegacyFinancialCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $LegacyFinancialEntriesTable,
    List<LegacyFinancialEntryRow>
  >
  _legacyFinancialEntriesRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyFinancialEntries,
        aliasName: 'financial_categories__id__financial_entries__category_id',
      );

  $$LegacyFinancialEntriesTableProcessedTableManager
  get legacyFinancialEntriesRefs {
    final manager = $$LegacyFinancialEntriesTableTableManager(
      $_db,
      $_db.legacyFinancialEntries,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyFinancialEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LegacyFinancialCategoriesTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyFinancialCategoriesTable> {
  $$LegacyFinancialCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> legacyFinancialEntriesRefs(
    Expression<bool> Function($$LegacyFinancialEntriesTableFilterComposer f) f,
  ) {
    final $$LegacyFinancialEntriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyFinancialEntries,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyFinancialEntriesTableFilterComposer(
                $db: $db,
                $table: $db.legacyFinancialEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LegacyFinancialCategoriesTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyFinancialCategoriesTable> {
  $$LegacyFinancialCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegacyFinancialCategoriesTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyFinancialCategoriesTable> {
  $$LegacyFinancialCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> legacyFinancialEntriesRefs<T extends Object>(
    Expression<T> Function($$LegacyFinancialEntriesTableAnnotationComposer a) f,
  ) {
    final $$LegacyFinancialEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyFinancialEntries,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyFinancialEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyFinancialEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LegacyFinancialCategoriesTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyFinancialCategoriesTable,
          LegacyFinancialCategoryRow,
          $$LegacyFinancialCategoriesTableFilterComposer,
          $$LegacyFinancialCategoriesTableOrderingComposer,
          $$LegacyFinancialCategoriesTableAnnotationComposer,
          $$LegacyFinancialCategoriesTableCreateCompanionBuilder,
          $$LegacyFinancialCategoriesTableUpdateCompanionBuilder,
          (
            LegacyFinancialCategoryRow,
            $$LegacyFinancialCategoriesTableReferences,
          ),
          LegacyFinancialCategoryRow,
          PrefetchHooks Function({bool legacyFinancialEntriesRefs})
        > {
  $$LegacyFinancialCategoriesTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyFinancialCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyFinancialCategoriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyFinancialCategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyFinancialCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyFinancialCategoriesCompanion(
                id: id,
                name: name,
                kind: kind,
                active: active,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String kind,
                required bool active,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyFinancialCategoriesCompanion.insert(
                id: id,
                name: name,
                kind: kind,
                active: active,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyFinancialCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({legacyFinancialEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (legacyFinancialEntriesRefs) db.legacyFinancialEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (legacyFinancialEntriesRefs)
                    await $_getPrefetchedData<
                      LegacyFinancialCategoryRow,
                      $LegacyFinancialCategoriesTable,
                      LegacyFinancialEntryRow
                    >(
                      currentTable: table,
                      referencedTable:
                          $$LegacyFinancialCategoriesTableReferences
                              ._legacyFinancialEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LegacyFinancialCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).legacyFinancialEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LegacyFinancialCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyFinancialCategoriesTable,
      LegacyFinancialCategoryRow,
      $$LegacyFinancialCategoriesTableFilterComposer,
      $$LegacyFinancialCategoriesTableOrderingComposer,
      $$LegacyFinancialCategoriesTableAnnotationComposer,
      $$LegacyFinancialCategoriesTableCreateCompanionBuilder,
      $$LegacyFinancialCategoriesTableUpdateCompanionBuilder,
      (LegacyFinancialCategoryRow, $$LegacyFinancialCategoriesTableReferences),
      LegacyFinancialCategoryRow,
      PrefetchHooks Function({bool legacyFinancialEntriesRefs})
    >;
typedef $$LegacyFinancialEntriesTableCreateCompanionBuilder =
    LegacyFinancialEntriesCompanion Function({
      required String id,
      required String kind,
      required String description,
      required int amountCents,
      required String date,
      required String categoryId,
      required String status,
      Value<int?> paidAt,
      Value<String?> notes,
      Value<String?> quoteId,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LegacyFinancialEntriesTableUpdateCompanionBuilder =
    LegacyFinancialEntriesCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<String> description,
      Value<int> amountCents,
      Value<String> date,
      Value<String> categoryId,
      Value<String> status,
      Value<int?> paidAt,
      Value<String?> notes,
      Value<String?> quoteId,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$LegacyFinancialEntriesTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyFinancialEntriesTable,
          LegacyFinancialEntryRow
        > {
  $$LegacyFinancialEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyFinancialCategoriesTable _categoryIdTable(
    _$LegacyAppDatabaseV10 db,
  ) => db.legacyFinancialCategories.createAlias(
    'financial_entries__category_id__financial_categories__id',
  );

  $$LegacyFinancialCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$LegacyFinancialCategoriesTableTableManager(
      $_db,
      $_db.legacyFinancialCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LegacyQuotesTable _quoteIdTable(_$LegacyAppDatabaseV10 db) =>
      db.legacyQuotes.createAlias('financial_entries__quote_id__quotes__id');

  $$LegacyQuotesTableProcessedTableManager? get quoteId {
    final $_column = $_itemColumn<String>('quote_id');
    if ($_column == null) return null;
    final manager = $$LegacyQuotesTableTableManager(
      $_db,
      $_db.legacyQuotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LegacyFinancialEntriesTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyFinancialEntriesTable> {
  $$LegacyFinancialEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyFinancialCategoriesTableFilterComposer get categoryId {
    final $$LegacyFinancialCategoriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.legacyFinancialCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyFinancialCategoriesTableFilterComposer(
                $db: $db,
                $table: $db.legacyFinancialCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$LegacyQuotesTableFilterComposer get quoteId {
    final $$LegacyQuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyFinancialEntriesTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyFinancialEntriesTable> {
  $$LegacyFinancialEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyFinancialCategoriesTableOrderingComposer get categoryId {
    final $$LegacyFinancialCategoriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.legacyFinancialCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyFinancialCategoriesTableOrderingComposer(
                $db: $db,
                $table: $db.legacyFinancialCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$LegacyQuotesTableOrderingComposer get quoteId {
    final $$LegacyQuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableOrderingComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyFinancialEntriesTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyFinancialEntriesTable> {
  $$LegacyFinancialEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LegacyFinancialCategoriesTableAnnotationComposer get categoryId {
    final $$LegacyFinancialCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.legacyFinancialCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyFinancialCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyFinancialCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$LegacyQuotesTableAnnotationComposer get quoteId {
    final $$LegacyQuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyFinancialEntriesTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyFinancialEntriesTable,
          LegacyFinancialEntryRow,
          $$LegacyFinancialEntriesTableFilterComposer,
          $$LegacyFinancialEntriesTableOrderingComposer,
          $$LegacyFinancialEntriesTableAnnotationComposer,
          $$LegacyFinancialEntriesTableCreateCompanionBuilder,
          $$LegacyFinancialEntriesTableUpdateCompanionBuilder,
          (LegacyFinancialEntryRow, $$LegacyFinancialEntriesTableReferences),
          LegacyFinancialEntryRow,
          PrefetchHooks Function({bool categoryId, bool quoteId})
        > {
  $$LegacyFinancialEntriesTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyFinancialEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyFinancialEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyFinancialEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyFinancialEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> paidAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> quoteId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyFinancialEntriesCompanion(
                id: id,
                kind: kind,
                description: description,
                amountCents: amountCents,
                date: date,
                categoryId: categoryId,
                status: status,
                paidAt: paidAt,
                notes: notes,
                quoteId: quoteId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required String description,
                required int amountCents,
                required String date,
                required String categoryId,
                required String status,
                Value<int?> paidAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> quoteId = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyFinancialEntriesCompanion.insert(
                id: id,
                kind: kind,
                description: description,
                amountCents: amountCents,
                date: date,
                categoryId: categoryId,
                status: status,
                paidAt: paidAt,
                notes: notes,
                quoteId: quoteId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyFinancialEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false, quoteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable:
                                    $$LegacyFinancialEntriesTableReferences
                                        ._categoryIdTable(db),
                                referencedColumn:
                                    $$LegacyFinancialEntriesTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (quoteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.quoteId,
                                referencedTable:
                                    $$LegacyFinancialEntriesTableReferences
                                        ._quoteIdTable(db),
                                referencedColumn:
                                    $$LegacyFinancialEntriesTableReferences
                                        ._quoteIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LegacyFinancialEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyFinancialEntriesTable,
      LegacyFinancialEntryRow,
      $$LegacyFinancialEntriesTableFilterComposer,
      $$LegacyFinancialEntriesTableOrderingComposer,
      $$LegacyFinancialEntriesTableAnnotationComposer,
      $$LegacyFinancialEntriesTableCreateCompanionBuilder,
      $$LegacyFinancialEntriesTableUpdateCompanionBuilder,
      (LegacyFinancialEntryRow, $$LegacyFinancialEntriesTableReferences),
      LegacyFinancialEntryRow,
      PrefetchHooks Function({bool categoryId, bool quoteId})
    >;
typedef $$LegacyEquipmentCategoriesTableCreateCompanionBuilder =
    LegacyEquipmentCategoriesCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      required bool active,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LegacyEquipmentCategoriesTableUpdateCompanionBuilder =
    LegacyEquipmentCategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<bool> active,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$LegacyEquipmentCategoriesTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyEquipmentCategoriesTable,
          LegacyEquipmentCategoryRow
        > {
  $$LegacyEquipmentCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$LegacyEquipmentsTable, List<LegacyEquipmentRow>>
  _legacyEquipmentsRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyEquipments,
        aliasName: 'equipment_categories__id__equipment__category_id',
      );

  $$LegacyEquipmentsTableProcessedTableManager get legacyEquipmentsRefs {
    final manager = $$LegacyEquipmentsTableTableManager(
      $_db,
      $_db.legacyEquipments,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyEquipmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LegacyEquipmentCategoriesTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyEquipmentCategoriesTable> {
  $$LegacyEquipmentCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> legacyEquipmentsRefs(
    Expression<bool> Function($$LegacyEquipmentsTableFilterComposer f) f,
  ) {
    final $$LegacyEquipmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.legacyEquipments,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyEquipmentsTableFilterComposer(
            $db: $db,
            $table: $db.legacyEquipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LegacyEquipmentCategoriesTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyEquipmentCategoriesTable> {
  $$LegacyEquipmentCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegacyEquipmentCategoriesTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyEquipmentCategoriesTable> {
  $$LegacyEquipmentCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> legacyEquipmentsRefs<T extends Object>(
    Expression<T> Function($$LegacyEquipmentsTableAnnotationComposer a) f,
  ) {
    final $$LegacyEquipmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.legacyEquipments,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyEquipmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyEquipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LegacyEquipmentCategoriesTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyEquipmentCategoriesTable,
          LegacyEquipmentCategoryRow,
          $$LegacyEquipmentCategoriesTableFilterComposer,
          $$LegacyEquipmentCategoriesTableOrderingComposer,
          $$LegacyEquipmentCategoriesTableAnnotationComposer,
          $$LegacyEquipmentCategoriesTableCreateCompanionBuilder,
          $$LegacyEquipmentCategoriesTableUpdateCompanionBuilder,
          (
            LegacyEquipmentCategoryRow,
            $$LegacyEquipmentCategoriesTableReferences,
          ),
          LegacyEquipmentCategoryRow,
          PrefetchHooks Function({bool legacyEquipmentsRefs})
        > {
  $$LegacyEquipmentCategoriesTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyEquipmentCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyEquipmentCategoriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyEquipmentCategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyEquipmentCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyEquipmentCategoriesCompanion(
                id: id,
                name: name,
                description: description,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                required bool active,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyEquipmentCategoriesCompanion.insert(
                id: id,
                name: name,
                description: description,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyEquipmentCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({legacyEquipmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (legacyEquipmentsRefs) db.legacyEquipments,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (legacyEquipmentsRefs)
                    await $_getPrefetchedData<
                      LegacyEquipmentCategoryRow,
                      $LegacyEquipmentCategoriesTable,
                      LegacyEquipmentRow
                    >(
                      currentTable: table,
                      referencedTable:
                          $$LegacyEquipmentCategoriesTableReferences
                              ._legacyEquipmentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LegacyEquipmentCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).legacyEquipmentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LegacyEquipmentCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyEquipmentCategoriesTable,
      LegacyEquipmentCategoryRow,
      $$LegacyEquipmentCategoriesTableFilterComposer,
      $$LegacyEquipmentCategoriesTableOrderingComposer,
      $$LegacyEquipmentCategoriesTableAnnotationComposer,
      $$LegacyEquipmentCategoriesTableCreateCompanionBuilder,
      $$LegacyEquipmentCategoriesTableUpdateCompanionBuilder,
      (LegacyEquipmentCategoryRow, $$LegacyEquipmentCategoriesTableReferences),
      LegacyEquipmentCategoryRow,
      PrefetchHooks Function({bool legacyEquipmentsRefs})
    >;
typedef $$LegacyEquipmentsTableCreateCompanionBuilder =
    LegacyEquipmentsCompanion Function({
      required String id,
      required String name,
      required String description,
      required String categoryId,
      Value<String?> serialNumber,
      required int totalQuantity,
      required String status,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LegacyEquipmentsTableUpdateCompanionBuilder =
    LegacyEquipmentsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> description,
      Value<String> categoryId,
      Value<String?> serialNumber,
      Value<int> totalQuantity,
      Value<String> status,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$LegacyEquipmentsTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyEquipmentsTable,
          LegacyEquipmentRow
        > {
  $$LegacyEquipmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyEquipmentCategoriesTable _categoryIdTable(
    _$LegacyAppDatabaseV10 db,
  ) => db.legacyEquipmentCategories.createAlias(
    'equipment__category_id__equipment_categories__id',
  );

  $$LegacyEquipmentCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$LegacyEquipmentCategoriesTableTableManager(
      $_db,
      $_db.legacyEquipmentCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $LegacyQuoteEquipmentItemsTable,
    List<LegacyQuoteEquipmentRow>
  >
  _legacyQuoteEquipmentItemsRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteEquipmentItems,
        aliasName: 'equipment__id__quote_equipment__equipment_id',
      );

  $$LegacyQuoteEquipmentItemsTableProcessedTableManager
  get legacyQuoteEquipmentItemsRefs {
    final manager = $$LegacyQuoteEquipmentItemsTableTableManager(
      $_db,
      $_db.legacyQuoteEquipmentItems,
    ).filter((f) => f.equipmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteEquipmentItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LegacyEquipmentsTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyEquipmentsTable> {
  $$LegacyEquipmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuantity => $composableBuilder(
    column: $table.totalQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyEquipmentCategoriesTableFilterComposer get categoryId {
    final $$LegacyEquipmentCategoriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.legacyEquipmentCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyEquipmentCategoriesTableFilterComposer(
                $db: $db,
                $table: $db.legacyEquipmentCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<bool> legacyQuoteEquipmentItemsRefs(
    Expression<bool> Function($$LegacyQuoteEquipmentItemsTableFilterComposer f)
    f,
  ) {
    final $$LegacyQuoteEquipmentItemsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteEquipmentItems,
          getReferencedColumn: (t) => t.equipmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteEquipmentItemsTableFilterComposer(
                $db: $db,
                $table: $db.legacyQuoteEquipmentItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LegacyEquipmentsTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyEquipmentsTable> {
  $$LegacyEquipmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuantity => $composableBuilder(
    column: $table.totalQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyEquipmentCategoriesTableOrderingComposer get categoryId {
    final $$LegacyEquipmentCategoriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.legacyEquipmentCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyEquipmentCategoriesTableOrderingComposer(
                $db: $db,
                $table: $db.legacyEquipmentCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$LegacyEquipmentsTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyEquipmentsTable> {
  $$LegacyEquipmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalQuantity => $composableBuilder(
    column: $table.totalQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LegacyEquipmentCategoriesTableAnnotationComposer get categoryId {
    final $$LegacyEquipmentCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.legacyEquipmentCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyEquipmentCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyEquipmentCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> legacyQuoteEquipmentItemsRefs<T extends Object>(
    Expression<T> Function($$LegacyQuoteEquipmentItemsTableAnnotationComposer a)
    f,
  ) {
    final $$LegacyQuoteEquipmentItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteEquipmentItems,
          getReferencedColumn: (t) => t.equipmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteEquipmentItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteEquipmentItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LegacyEquipmentsTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyEquipmentsTable,
          LegacyEquipmentRow,
          $$LegacyEquipmentsTableFilterComposer,
          $$LegacyEquipmentsTableOrderingComposer,
          $$LegacyEquipmentsTableAnnotationComposer,
          $$LegacyEquipmentsTableCreateCompanionBuilder,
          $$LegacyEquipmentsTableUpdateCompanionBuilder,
          (LegacyEquipmentRow, $$LegacyEquipmentsTableReferences),
          LegacyEquipmentRow,
          PrefetchHooks Function({
            bool categoryId,
            bool legacyQuoteEquipmentItemsRefs,
          })
        > {
  $$LegacyEquipmentsTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyEquipmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyEquipmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegacyEquipmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegacyEquipmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String?> serialNumber = const Value.absent(),
                Value<int> totalQuantity = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyEquipmentsCompanion(
                id: id,
                name: name,
                description: description,
                categoryId: categoryId,
                serialNumber: serialNumber,
                totalQuantity: totalQuantity,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String description,
                required String categoryId,
                Value<String?> serialNumber = const Value.absent(),
                required int totalQuantity,
                required String status,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyEquipmentsCompanion.insert(
                id: id,
                name: name,
                description: description,
                categoryId: categoryId,
                serialNumber: serialNumber,
                totalQuantity: totalQuantity,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyEquipmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryId = false, legacyQuoteEquipmentItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (legacyQuoteEquipmentItemsRefs)
                      db.legacyQuoteEquipmentItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$LegacyEquipmentsTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$LegacyEquipmentsTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (legacyQuoteEquipmentItemsRefs)
                        await $_getPrefetchedData<
                          LegacyEquipmentRow,
                          $LegacyEquipmentsTable,
                          LegacyQuoteEquipmentRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyEquipmentsTableReferences
                              ._legacyQuoteEquipmentItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyEquipmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteEquipmentItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.equipmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LegacyEquipmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyEquipmentsTable,
      LegacyEquipmentRow,
      $$LegacyEquipmentsTableFilterComposer,
      $$LegacyEquipmentsTableOrderingComposer,
      $$LegacyEquipmentsTableAnnotationComposer,
      $$LegacyEquipmentsTableCreateCompanionBuilder,
      $$LegacyEquipmentsTableUpdateCompanionBuilder,
      (LegacyEquipmentRow, $$LegacyEquipmentsTableReferences),
      LegacyEquipmentRow,
      PrefetchHooks Function({
        bool categoryId,
        bool legacyQuoteEquipmentItemsRefs,
      })
    >;
typedef $$LegacyQuoteEquipmentItemsTableCreateCompanionBuilder =
    LegacyQuoteEquipmentItemsCompanion Function({
      required String id,
      required String quoteId,
      required String equipmentId,
      required int quantity,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LegacyQuoteEquipmentItemsTableUpdateCompanionBuilder =
    LegacyQuoteEquipmentItemsCompanion Function({
      Value<String> id,
      Value<String> quoteId,
      Value<String> equipmentId,
      Value<int> quantity,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$LegacyQuoteEquipmentItemsTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteEquipmentItemsTable,
          LegacyQuoteEquipmentRow
        > {
  $$LegacyQuoteEquipmentItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyQuotesTable _quoteIdTable(_$LegacyAppDatabaseV10 db) =>
      db.legacyQuotes.createAlias('quote_equipment__quote_id__quotes__id');

  $$LegacyQuotesTableProcessedTableManager get quoteId {
    final $_column = $_itemColumn<String>('quote_id')!;

    final manager = $$LegacyQuotesTableTableManager(
      $_db,
      $_db.legacyQuotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LegacyEquipmentsTable _equipmentIdTable(_$LegacyAppDatabaseV10 db) =>
      db.legacyEquipments.createAlias(
        'quote_equipment__equipment_id__equipment__id',
      );

  $$LegacyEquipmentsTableProcessedTableManager get equipmentId {
    final $_column = $_itemColumn<String>('equipment_id')!;

    final manager = $$LegacyEquipmentsTableTableManager(
      $_db,
      $_db.legacyEquipments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LegacyQuoteEquipmentItemsTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteEquipmentItemsTable> {
  $$LegacyQuoteEquipmentItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyQuotesTableFilterComposer get quoteId {
    final $$LegacyQuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyEquipmentsTableFilterComposer get equipmentId {
    final $$LegacyEquipmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.legacyEquipments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyEquipmentsTableFilterComposer(
            $db: $db,
            $table: $db.legacyEquipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteEquipmentItemsTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteEquipmentItemsTable> {
  $$LegacyQuoteEquipmentItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyQuotesTableOrderingComposer get quoteId {
    final $$LegacyQuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableOrderingComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyEquipmentsTableOrderingComposer get equipmentId {
    final $$LegacyEquipmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.legacyEquipments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyEquipmentsTableOrderingComposer(
            $db: $db,
            $table: $db.legacyEquipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteEquipmentItemsTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteEquipmentItemsTable> {
  $$LegacyQuoteEquipmentItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LegacyQuotesTableAnnotationComposer get quoteId {
    final $$LegacyQuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyEquipmentsTableAnnotationComposer get equipmentId {
    final $$LegacyEquipmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.legacyEquipments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyEquipmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyEquipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteEquipmentItemsTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteEquipmentItemsTable,
          LegacyQuoteEquipmentRow,
          $$LegacyQuoteEquipmentItemsTableFilterComposer,
          $$LegacyQuoteEquipmentItemsTableOrderingComposer,
          $$LegacyQuoteEquipmentItemsTableAnnotationComposer,
          $$LegacyQuoteEquipmentItemsTableCreateCompanionBuilder,
          $$LegacyQuoteEquipmentItemsTableUpdateCompanionBuilder,
          (LegacyQuoteEquipmentRow, $$LegacyQuoteEquipmentItemsTableReferences),
          LegacyQuoteEquipmentRow,
          PrefetchHooks Function({bool quoteId, bool equipmentId})
        > {
  $$LegacyQuoteEquipmentItemsTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyQuoteEquipmentItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyQuoteEquipmentItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyQuoteEquipmentItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyQuoteEquipmentItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> quoteId = const Value.absent(),
                Value<String> equipmentId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteEquipmentItemsCompanion(
                id: id,
                quoteId: quoteId,
                equipmentId: equipmentId,
                quantity: quantity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String quoteId,
                required String equipmentId,
                required int quantity,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteEquipmentItemsCompanion.insert(
                id: id,
                quoteId: quoteId,
                equipmentId: equipmentId,
                quantity: quantity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyQuoteEquipmentItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quoteId = false, equipmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (quoteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.quoteId,
                                referencedTable:
                                    $$LegacyQuoteEquipmentItemsTableReferences
                                        ._quoteIdTable(db),
                                referencedColumn:
                                    $$LegacyQuoteEquipmentItemsTableReferences
                                        ._quoteIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (equipmentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.equipmentId,
                                referencedTable:
                                    $$LegacyQuoteEquipmentItemsTableReferences
                                        ._equipmentIdTable(db),
                                referencedColumn:
                                    $$LegacyQuoteEquipmentItemsTableReferences
                                        ._equipmentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LegacyQuoteEquipmentItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyQuoteEquipmentItemsTable,
      LegacyQuoteEquipmentRow,
      $$LegacyQuoteEquipmentItemsTableFilterComposer,
      $$LegacyQuoteEquipmentItemsTableOrderingComposer,
      $$LegacyQuoteEquipmentItemsTableAnnotationComposer,
      $$LegacyQuoteEquipmentItemsTableCreateCompanionBuilder,
      $$LegacyQuoteEquipmentItemsTableUpdateCompanionBuilder,
      (LegacyQuoteEquipmentRow, $$LegacyQuoteEquipmentItemsTableReferences),
      LegacyQuoteEquipmentRow,
      PrefetchHooks Function({bool quoteId, bool equipmentId})
    >;
typedef $$LegacyTeamRolesTableCreateCompanionBuilder =
    LegacyTeamRolesCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      required bool active,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LegacyTeamRolesTableUpdateCompanionBuilder =
    LegacyTeamRolesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<bool> active,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$LegacyTeamRolesTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyTeamRolesTable,
          LegacyTeamRoleRow
        > {
  $$LegacyTeamRolesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$LegacyTeamMembersTable, List<LegacyTeamMemberRow>>
  _legacyTeamMembersRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyTeamMembers,
        aliasName: 'team_roles__id__team_members__role_id',
      );

  $$LegacyTeamMembersTableProcessedTableManager get legacyTeamMembersRefs {
    final manager = $$LegacyTeamMembersTableTableManager(
      $_db,
      $_db.legacyTeamMembers,
    ).filter((f) => f.roleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyTeamMembersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LegacyQuoteTeamMembersTable,
    List<LegacyQuoteTeamMemberRow>
  >
  _legacyQuoteTeamMembersRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteTeamMembers,
        aliasName: 'team_roles__id__quote_team_members__role_id',
      );

  $$LegacyQuoteTeamMembersTableProcessedTableManager
  get legacyQuoteTeamMembersRefs {
    final manager = $$LegacyQuoteTeamMembersTableTableManager(
      $_db,
      $_db.legacyQuoteTeamMembers,
    ).filter((f) => f.roleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteTeamMembersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LegacyTeamRolesTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyTeamRolesTable> {
  $$LegacyTeamRolesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> legacyTeamMembersRefs(
    Expression<bool> Function($$LegacyTeamMembersTableFilterComposer f) f,
  ) {
    final $$LegacyTeamMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.legacyTeamMembers,
      getReferencedColumn: (t) => t.roleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyTeamMembersTableFilterComposer(
            $db: $db,
            $table: $db.legacyTeamMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> legacyQuoteTeamMembersRefs(
    Expression<bool> Function($$LegacyQuoteTeamMembersTableFilterComposer f) f,
  ) {
    final $$LegacyQuoteTeamMembersTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteTeamMembers,
          getReferencedColumn: (t) => t.roleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteTeamMembersTableFilterComposer(
                $db: $db,
                $table: $db.legacyQuoteTeamMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LegacyTeamRolesTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyTeamRolesTable> {
  $$LegacyTeamRolesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegacyTeamRolesTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyTeamRolesTable> {
  $$LegacyTeamRolesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> legacyTeamMembersRefs<T extends Object>(
    Expression<T> Function($$LegacyTeamMembersTableAnnotationComposer a) f,
  ) {
    final $$LegacyTeamMembersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyTeamMembers,
          getReferencedColumn: (t) => t.roleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyTeamMembersTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyTeamMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> legacyQuoteTeamMembersRefs<T extends Object>(
    Expression<T> Function($$LegacyQuoteTeamMembersTableAnnotationComposer a) f,
  ) {
    final $$LegacyQuoteTeamMembersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteTeamMembers,
          getReferencedColumn: (t) => t.roleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteTeamMembersTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteTeamMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LegacyTeamRolesTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyTeamRolesTable,
          LegacyTeamRoleRow,
          $$LegacyTeamRolesTableFilterComposer,
          $$LegacyTeamRolesTableOrderingComposer,
          $$LegacyTeamRolesTableAnnotationComposer,
          $$LegacyTeamRolesTableCreateCompanionBuilder,
          $$LegacyTeamRolesTableUpdateCompanionBuilder,
          (LegacyTeamRoleRow, $$LegacyTeamRolesTableReferences),
          LegacyTeamRoleRow,
          PrefetchHooks Function({
            bool legacyTeamMembersRefs,
            bool legacyQuoteTeamMembersRefs,
          })
        > {
  $$LegacyTeamRolesTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyTeamRolesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyTeamRolesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegacyTeamRolesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegacyTeamRolesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyTeamRolesCompanion(
                id: id,
                name: name,
                description: description,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                required bool active,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyTeamRolesCompanion.insert(
                id: id,
                name: name,
                description: description,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyTeamRolesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                legacyTeamMembersRefs = false,
                legacyQuoteTeamMembersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (legacyTeamMembersRefs) db.legacyTeamMembers,
                    if (legacyQuoteTeamMembersRefs) db.legacyQuoteTeamMembers,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (legacyTeamMembersRefs)
                        await $_getPrefetchedData<
                          LegacyTeamRoleRow,
                          $LegacyTeamRolesTable,
                          LegacyTeamMemberRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyTeamRolesTableReferences
                              ._legacyTeamMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyTeamRolesTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyTeamMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.roleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (legacyQuoteTeamMembersRefs)
                        await $_getPrefetchedData<
                          LegacyTeamRoleRow,
                          $LegacyTeamRolesTable,
                          LegacyQuoteTeamMemberRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyTeamRolesTableReferences
                              ._legacyQuoteTeamMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyTeamRolesTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteTeamMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.roleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LegacyTeamRolesTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyTeamRolesTable,
      LegacyTeamRoleRow,
      $$LegacyTeamRolesTableFilterComposer,
      $$LegacyTeamRolesTableOrderingComposer,
      $$LegacyTeamRolesTableAnnotationComposer,
      $$LegacyTeamRolesTableCreateCompanionBuilder,
      $$LegacyTeamRolesTableUpdateCompanionBuilder,
      (LegacyTeamRoleRow, $$LegacyTeamRolesTableReferences),
      LegacyTeamRoleRow,
      PrefetchHooks Function({
        bool legacyTeamMembersRefs,
        bool legacyQuoteTeamMembersRefs,
      })
    >;
typedef $$LegacyTeamMembersTableCreateCompanionBuilder =
    LegacyTeamMembersCompanion Function({
      required String id,
      required String name,
      required String phone,
      Value<String?> email,
      required String roleId,
      Value<String?> observations,
      required int dailyRate,
      required String status,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LegacyTeamMembersTableUpdateCompanionBuilder =
    LegacyTeamMembersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> phone,
      Value<String?> email,
      Value<String> roleId,
      Value<String?> observations,
      Value<int> dailyRate,
      Value<String> status,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$LegacyTeamMembersTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyTeamMembersTable,
          LegacyTeamMemberRow
        > {
  $$LegacyTeamMembersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyTeamRolesTable _roleIdTable(_$LegacyAppDatabaseV10 db) =>
      db.legacyTeamRoles.createAlias('team_members__role_id__team_roles__id');

  $$LegacyTeamRolesTableProcessedTableManager get roleId {
    final $_column = $_itemColumn<String>('role_id')!;

    final manager = $$LegacyTeamRolesTableTableManager(
      $_db,
      $_db.legacyTeamRoles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $LegacyQuoteTeamMembersTable,
    List<LegacyQuoteTeamMemberRow>
  >
  _legacyQuoteTeamMembersRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteTeamMembers,
        aliasName: 'team_members__id__quote_team_members__team_member_id',
      );

  $$LegacyQuoteTeamMembersTableProcessedTableManager
  get legacyQuoteTeamMembersRefs {
    final manager = $$LegacyQuoteTeamMembersTableTableManager(
      $_db,
      $_db.legacyQuoteTeamMembers,
    ).filter((f) => f.teamMemberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteTeamMembersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LegacyQuoteVehiclesTable,
    List<LegacyQuoteVehicleRow>
  >
  _legacyQuoteVehiclesRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteVehicles,
        aliasName: 'team_members__id__quote_vehicles__driver_team_member_id',
      );

  $$LegacyQuoteVehiclesTableProcessedTableManager get legacyQuoteVehiclesRefs {
    final manager =
        $$LegacyQuoteVehiclesTableTableManager(
          $_db,
          $_db.legacyQuoteVehicles,
        ).filter(
          (f) => f.driverTeamMemberId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteVehiclesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LegacyTeamMembersTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyTeamMembersTable> {
  $$LegacyTeamMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyRate => $composableBuilder(
    column: $table.dailyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyTeamRolesTableFilterComposer get roleId {
    final $$LegacyTeamRolesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.legacyTeamRoles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyTeamRolesTableFilterComposer(
            $db: $db,
            $table: $db.legacyTeamRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> legacyQuoteTeamMembersRefs(
    Expression<bool> Function($$LegacyQuoteTeamMembersTableFilterComposer f) f,
  ) {
    final $$LegacyQuoteTeamMembersTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteTeamMembers,
          getReferencedColumn: (t) => t.teamMemberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteTeamMembersTableFilterComposer(
                $db: $db,
                $table: $db.legacyQuoteTeamMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> legacyQuoteVehiclesRefs(
    Expression<bool> Function($$LegacyQuoteVehiclesTableFilterComposer f) f,
  ) {
    final $$LegacyQuoteVehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.legacyQuoteVehicles,
      getReferencedColumn: (t) => t.driverTeamMemberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuoteVehiclesTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuoteVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LegacyTeamMembersTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyTeamMembersTable> {
  $$LegacyTeamMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyRate => $composableBuilder(
    column: $table.dailyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyTeamRolesTableOrderingComposer get roleId {
    final $$LegacyTeamRolesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.legacyTeamRoles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyTeamRolesTableOrderingComposer(
            $db: $db,
            $table: $db.legacyTeamRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyTeamMembersTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyTeamMembersTable> {
  $$LegacyTeamMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyRate =>
      $composableBuilder(column: $table.dailyRate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LegacyTeamRolesTableAnnotationComposer get roleId {
    final $$LegacyTeamRolesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.legacyTeamRoles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyTeamRolesTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyTeamRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> legacyQuoteTeamMembersRefs<T extends Object>(
    Expression<T> Function($$LegacyQuoteTeamMembersTableAnnotationComposer a) f,
  ) {
    final $$LegacyQuoteTeamMembersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteTeamMembers,
          getReferencedColumn: (t) => t.teamMemberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteTeamMembersTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteTeamMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> legacyQuoteVehiclesRefs<T extends Object>(
    Expression<T> Function($$LegacyQuoteVehiclesTableAnnotationComposer a) f,
  ) {
    final $$LegacyQuoteVehiclesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteVehicles,
          getReferencedColumn: (t) => t.driverTeamMemberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteVehiclesTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteVehicles,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LegacyTeamMembersTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyTeamMembersTable,
          LegacyTeamMemberRow,
          $$LegacyTeamMembersTableFilterComposer,
          $$LegacyTeamMembersTableOrderingComposer,
          $$LegacyTeamMembersTableAnnotationComposer,
          $$LegacyTeamMembersTableCreateCompanionBuilder,
          $$LegacyTeamMembersTableUpdateCompanionBuilder,
          (LegacyTeamMemberRow, $$LegacyTeamMembersTableReferences),
          LegacyTeamMemberRow,
          PrefetchHooks Function({
            bool roleId,
            bool legacyQuoteTeamMembersRefs,
            bool legacyQuoteVehiclesRefs,
          })
        > {
  $$LegacyTeamMembersTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyTeamMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyTeamMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegacyTeamMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegacyTeamMembersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> roleId = const Value.absent(),
                Value<String?> observations = const Value.absent(),
                Value<int> dailyRate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyTeamMembersCompanion(
                id: id,
                name: name,
                phone: phone,
                email: email,
                roleId: roleId,
                observations: observations,
                dailyRate: dailyRate,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String phone,
                Value<String?> email = const Value.absent(),
                required String roleId,
                Value<String?> observations = const Value.absent(),
                required int dailyRate,
                required String status,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyTeamMembersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                email: email,
                roleId: roleId,
                observations: observations,
                dailyRate: dailyRate,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyTeamMembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                roleId = false,
                legacyQuoteTeamMembersRefs = false,
                legacyQuoteVehiclesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (legacyQuoteTeamMembersRefs) db.legacyQuoteTeamMembers,
                    if (legacyQuoteVehiclesRefs) db.legacyQuoteVehicles,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (roleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.roleId,
                                    referencedTable:
                                        $$LegacyTeamMembersTableReferences
                                            ._roleIdTable(db),
                                    referencedColumn:
                                        $$LegacyTeamMembersTableReferences
                                            ._roleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (legacyQuoteTeamMembersRefs)
                        await $_getPrefetchedData<
                          LegacyTeamMemberRow,
                          $LegacyTeamMembersTable,
                          LegacyQuoteTeamMemberRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyTeamMembersTableReferences
                              ._legacyQuoteTeamMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyTeamMembersTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteTeamMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamMemberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (legacyQuoteVehiclesRefs)
                        await $_getPrefetchedData<
                          LegacyTeamMemberRow,
                          $LegacyTeamMembersTable,
                          LegacyQuoteVehicleRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyTeamMembersTableReferences
                              ._legacyQuoteVehiclesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyTeamMembersTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteVehiclesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.driverTeamMemberId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LegacyTeamMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyTeamMembersTable,
      LegacyTeamMemberRow,
      $$LegacyTeamMembersTableFilterComposer,
      $$LegacyTeamMembersTableOrderingComposer,
      $$LegacyTeamMembersTableAnnotationComposer,
      $$LegacyTeamMembersTableCreateCompanionBuilder,
      $$LegacyTeamMembersTableUpdateCompanionBuilder,
      (LegacyTeamMemberRow, $$LegacyTeamMembersTableReferences),
      LegacyTeamMemberRow,
      PrefetchHooks Function({
        bool roleId,
        bool legacyQuoteTeamMembersRefs,
        bool legacyQuoteVehiclesRefs,
      })
    >;
typedef $$LegacyQuoteTeamMembersTableCreateCompanionBuilder =
    LegacyQuoteTeamMembersCompanion Function({
      required String id,
      required String quoteId,
      required String teamMemberId,
      required String roleId,
      required int dailyRate,
      Value<String?> notes,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LegacyQuoteTeamMembersTableUpdateCompanionBuilder =
    LegacyQuoteTeamMembersCompanion Function({
      Value<String> id,
      Value<String> quoteId,
      Value<String> teamMemberId,
      Value<String> roleId,
      Value<int> dailyRate,
      Value<String?> notes,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$LegacyQuoteTeamMembersTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteTeamMembersTable,
          LegacyQuoteTeamMemberRow
        > {
  $$LegacyQuoteTeamMembersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyQuotesTable _quoteIdTable(_$LegacyAppDatabaseV10 db) =>
      db.legacyQuotes.createAlias('quote_team_members__quote_id__quotes__id');

  $$LegacyQuotesTableProcessedTableManager get quoteId {
    final $_column = $_itemColumn<String>('quote_id')!;

    final manager = $$LegacyQuotesTableTableManager(
      $_db,
      $_db.legacyQuotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LegacyTeamMembersTable _teamMemberIdTable(
    _$LegacyAppDatabaseV10 db,
  ) => db.legacyTeamMembers.createAlias(
    'quote_team_members__team_member_id__team_members__id',
  );

  $$LegacyTeamMembersTableProcessedTableManager get teamMemberId {
    final $_column = $_itemColumn<String>('team_member_id')!;

    final manager = $$LegacyTeamMembersTableTableManager(
      $_db,
      $_db.legacyTeamMembers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LegacyTeamRolesTable _roleIdTable(_$LegacyAppDatabaseV10 db) => db
      .legacyTeamRoles
      .createAlias('quote_team_members__role_id__team_roles__id');

  $$LegacyTeamRolesTableProcessedTableManager get roleId {
    final $_column = $_itemColumn<String>('role_id')!;

    final manager = $$LegacyTeamRolesTableTableManager(
      $_db,
      $_db.legacyTeamRoles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LegacyQuoteTeamMembersTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteTeamMembersTable> {
  $$LegacyQuoteTeamMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyRate => $composableBuilder(
    column: $table.dailyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyQuotesTableFilterComposer get quoteId {
    final $$LegacyQuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyTeamMembersTableFilterComposer get teamMemberId {
    final $$LegacyTeamMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamMemberId,
      referencedTable: $db.legacyTeamMembers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyTeamMembersTableFilterComposer(
            $db: $db,
            $table: $db.legacyTeamMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyTeamRolesTableFilterComposer get roleId {
    final $$LegacyTeamRolesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.legacyTeamRoles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyTeamRolesTableFilterComposer(
            $db: $db,
            $table: $db.legacyTeamRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteTeamMembersTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteTeamMembersTable> {
  $$LegacyQuoteTeamMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyRate => $composableBuilder(
    column: $table.dailyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyQuotesTableOrderingComposer get quoteId {
    final $$LegacyQuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableOrderingComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyTeamMembersTableOrderingComposer get teamMemberId {
    final $$LegacyTeamMembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamMemberId,
      referencedTable: $db.legacyTeamMembers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyTeamMembersTableOrderingComposer(
            $db: $db,
            $table: $db.legacyTeamMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyTeamRolesTableOrderingComposer get roleId {
    final $$LegacyTeamRolesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.legacyTeamRoles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyTeamRolesTableOrderingComposer(
            $db: $db,
            $table: $db.legacyTeamRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteTeamMembersTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteTeamMembersTable> {
  $$LegacyQuoteTeamMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dailyRate =>
      $composableBuilder(column: $table.dailyRate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LegacyQuotesTableAnnotationComposer get quoteId {
    final $$LegacyQuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyTeamMembersTableAnnotationComposer get teamMemberId {
    final $$LegacyTeamMembersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.teamMemberId,
          referencedTable: $db.legacyTeamMembers,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyTeamMembersTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyTeamMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$LegacyTeamRolesTableAnnotationComposer get roleId {
    final $$LegacyTeamRolesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.legacyTeamRoles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyTeamRolesTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyTeamRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteTeamMembersTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteTeamMembersTable,
          LegacyQuoteTeamMemberRow,
          $$LegacyQuoteTeamMembersTableFilterComposer,
          $$LegacyQuoteTeamMembersTableOrderingComposer,
          $$LegacyQuoteTeamMembersTableAnnotationComposer,
          $$LegacyQuoteTeamMembersTableCreateCompanionBuilder,
          $$LegacyQuoteTeamMembersTableUpdateCompanionBuilder,
          (LegacyQuoteTeamMemberRow, $$LegacyQuoteTeamMembersTableReferences),
          LegacyQuoteTeamMemberRow,
          PrefetchHooks Function({bool quoteId, bool teamMemberId, bool roleId})
        > {
  $$LegacyQuoteTeamMembersTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyQuoteTeamMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyQuoteTeamMembersTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyQuoteTeamMembersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyQuoteTeamMembersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> quoteId = const Value.absent(),
                Value<String> teamMemberId = const Value.absent(),
                Value<String> roleId = const Value.absent(),
                Value<int> dailyRate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteTeamMembersCompanion(
                id: id,
                quoteId: quoteId,
                teamMemberId: teamMemberId,
                roleId: roleId,
                dailyRate: dailyRate,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String quoteId,
                required String teamMemberId,
                required String roleId,
                required int dailyRate,
                Value<String?> notes = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteTeamMembersCompanion.insert(
                id: id,
                quoteId: quoteId,
                teamMemberId: teamMemberId,
                roleId: roleId,
                dailyRate: dailyRate,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyQuoteTeamMembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({quoteId = false, teamMemberId = false, roleId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (quoteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.quoteId,
                                    referencedTable:
                                        $$LegacyQuoteTeamMembersTableReferences
                                            ._quoteIdTable(db),
                                    referencedColumn:
                                        $$LegacyQuoteTeamMembersTableReferences
                                            ._quoteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (teamMemberId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.teamMemberId,
                                    referencedTable:
                                        $$LegacyQuoteTeamMembersTableReferences
                                            ._teamMemberIdTable(db),
                                    referencedColumn:
                                        $$LegacyQuoteTeamMembersTableReferences
                                            ._teamMemberIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (roleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.roleId,
                                    referencedTable:
                                        $$LegacyQuoteTeamMembersTableReferences
                                            ._roleIdTable(db),
                                    referencedColumn:
                                        $$LegacyQuoteTeamMembersTableReferences
                                            ._roleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$LegacyQuoteTeamMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyQuoteTeamMembersTable,
      LegacyQuoteTeamMemberRow,
      $$LegacyQuoteTeamMembersTableFilterComposer,
      $$LegacyQuoteTeamMembersTableOrderingComposer,
      $$LegacyQuoteTeamMembersTableAnnotationComposer,
      $$LegacyQuoteTeamMembersTableCreateCompanionBuilder,
      $$LegacyQuoteTeamMembersTableUpdateCompanionBuilder,
      (LegacyQuoteTeamMemberRow, $$LegacyQuoteTeamMembersTableReferences),
      LegacyQuoteTeamMemberRow,
      PrefetchHooks Function({bool quoteId, bool teamMemberId, bool roleId})
    >;
typedef $$LegacyVehicleTypesTableCreateCompanionBuilder =
    LegacyVehicleTypesCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      required bool active,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LegacyVehicleTypesTableUpdateCompanionBuilder =
    LegacyVehicleTypesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<bool> active,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$LegacyVehicleTypesTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyVehicleTypesTable,
          LegacyVehicleTypeRow
        > {
  $$LegacyVehicleTypesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$LegacyVehiclesTable, List<LegacyVehicleRow>>
  _legacyVehiclesRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyVehicles,
        aliasName: 'vehicle_types__id__vehicles__vehicle_type_id',
      );

  $$LegacyVehiclesTableProcessedTableManager get legacyVehiclesRefs {
    final manager = $$LegacyVehiclesTableTableManager(
      $_db,
      $_db.legacyVehicles,
    ).filter((f) => f.vehicleTypeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_legacyVehiclesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LegacyVehicleTypesTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyVehicleTypesTable> {
  $$LegacyVehicleTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> legacyVehiclesRefs(
    Expression<bool> Function($$LegacyVehiclesTableFilterComposer f) f,
  ) {
    final $$LegacyVehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.legacyVehicles,
      getReferencedColumn: (t) => t.vehicleTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyVehiclesTableFilterComposer(
            $db: $db,
            $table: $db.legacyVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LegacyVehicleTypesTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyVehicleTypesTable> {
  $$LegacyVehicleTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegacyVehicleTypesTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyVehicleTypesTable> {
  $$LegacyVehicleTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> legacyVehiclesRefs<T extends Object>(
    Expression<T> Function($$LegacyVehiclesTableAnnotationComposer a) f,
  ) {
    final $$LegacyVehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.legacyVehicles,
      getReferencedColumn: (t) => t.vehicleTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyVehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LegacyVehicleTypesTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyVehicleTypesTable,
          LegacyVehicleTypeRow,
          $$LegacyVehicleTypesTableFilterComposer,
          $$LegacyVehicleTypesTableOrderingComposer,
          $$LegacyVehicleTypesTableAnnotationComposer,
          $$LegacyVehicleTypesTableCreateCompanionBuilder,
          $$LegacyVehicleTypesTableUpdateCompanionBuilder,
          (LegacyVehicleTypeRow, $$LegacyVehicleTypesTableReferences),
          LegacyVehicleTypeRow,
          PrefetchHooks Function({bool legacyVehiclesRefs})
        > {
  $$LegacyVehicleTypesTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyVehicleTypesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyVehicleTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegacyVehicleTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegacyVehicleTypesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyVehicleTypesCompanion(
                id: id,
                name: name,
                description: description,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                required bool active,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyVehicleTypesCompanion.insert(
                id: id,
                name: name,
                description: description,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyVehicleTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({legacyVehiclesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (legacyVehiclesRefs) db.legacyVehicles,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (legacyVehiclesRefs)
                    await $_getPrefetchedData<
                      LegacyVehicleTypeRow,
                      $LegacyVehicleTypesTable,
                      LegacyVehicleRow
                    >(
                      currentTable: table,
                      referencedTable: $$LegacyVehicleTypesTableReferences
                          ._legacyVehiclesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LegacyVehicleTypesTableReferences(
                            db,
                            table,
                            p0,
                          ).legacyVehiclesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.vehicleTypeId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LegacyVehicleTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyVehicleTypesTable,
      LegacyVehicleTypeRow,
      $$LegacyVehicleTypesTableFilterComposer,
      $$LegacyVehicleTypesTableOrderingComposer,
      $$LegacyVehicleTypesTableAnnotationComposer,
      $$LegacyVehicleTypesTableCreateCompanionBuilder,
      $$LegacyVehicleTypesTableUpdateCompanionBuilder,
      (LegacyVehicleTypeRow, $$LegacyVehicleTypesTableReferences),
      LegacyVehicleTypeRow,
      PrefetchHooks Function({bool legacyVehiclesRefs})
    >;
typedef $$LegacyVehiclesTableCreateCompanionBuilder =
    LegacyVehiclesCompanion Function({
      required String id,
      required String plate,
      required String description,
      required String vehicleTypeId,
      required double payloadCapacityKg,
      required double volumeCapacityM3,
      Value<String?> observations,
      required String status,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LegacyVehiclesTableUpdateCompanionBuilder =
    LegacyVehiclesCompanion Function({
      Value<String> id,
      Value<String> plate,
      Value<String> description,
      Value<String> vehicleTypeId,
      Value<double> payloadCapacityKg,
      Value<double> volumeCapacityM3,
      Value<String?> observations,
      Value<String> status,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$LegacyVehiclesTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyVehiclesTable,
          LegacyVehicleRow
        > {
  $$LegacyVehiclesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyVehicleTypesTable _vehicleTypeIdTable(
    _$LegacyAppDatabaseV10 db,
  ) => db.legacyVehicleTypes.createAlias(
    'vehicles__vehicle_type_id__vehicle_types__id',
  );

  $$LegacyVehicleTypesTableProcessedTableManager get vehicleTypeId {
    final $_column = $_itemColumn<String>('vehicle_type_id')!;

    final manager = $$LegacyVehicleTypesTableTableManager(
      $_db,
      $_db.legacyVehicleTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $LegacyQuoteVehiclesTable,
    List<LegacyQuoteVehicleRow>
  >
  _legacyQuoteVehiclesRefsTable(_$LegacyAppDatabaseV10 db) =>
      MultiTypedResultKey.fromTable(
        db.legacyQuoteVehicles,
        aliasName: 'vehicles__id__quote_vehicles__vehicle_id',
      );

  $$LegacyQuoteVehiclesTableProcessedTableManager get legacyQuoteVehiclesRefs {
    final manager = $$LegacyQuoteVehiclesTableTableManager(
      $_db,
      $_db.legacyQuoteVehicles,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _legacyQuoteVehiclesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LegacyVehiclesTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyVehiclesTable> {
  $$LegacyVehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get payloadCapacityKg => $composableBuilder(
    column: $table.payloadCapacityKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get volumeCapacityM3 => $composableBuilder(
    column: $table.volumeCapacityM3,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyVehicleTypesTableFilterComposer get vehicleTypeId {
    final $$LegacyVehicleTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleTypeId,
      referencedTable: $db.legacyVehicleTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyVehicleTypesTableFilterComposer(
            $db: $db,
            $table: $db.legacyVehicleTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> legacyQuoteVehiclesRefs(
    Expression<bool> Function($$LegacyQuoteVehiclesTableFilterComposer f) f,
  ) {
    final $$LegacyQuoteVehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.legacyQuoteVehicles,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuoteVehiclesTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuoteVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LegacyVehiclesTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyVehiclesTable> {
  $$LegacyVehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get payloadCapacityKg => $composableBuilder(
    column: $table.payloadCapacityKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get volumeCapacityM3 => $composableBuilder(
    column: $table.volumeCapacityM3,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyVehicleTypesTableOrderingComposer get vehicleTypeId {
    final $$LegacyVehicleTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleTypeId,
      referencedTable: $db.legacyVehicleTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyVehicleTypesTableOrderingComposer(
            $db: $db,
            $table: $db.legacyVehicleTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyVehiclesTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyVehiclesTable> {
  $$LegacyVehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get plate =>
      $composableBuilder(column: $table.plate, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get payloadCapacityKg => $composableBuilder(
    column: $table.payloadCapacityKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get volumeCapacityM3 => $composableBuilder(
    column: $table.volumeCapacityM3,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LegacyVehicleTypesTableAnnotationComposer get vehicleTypeId {
    final $$LegacyVehicleTypesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.vehicleTypeId,
          referencedTable: $db.legacyVehicleTypes,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyVehicleTypesTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyVehicleTypes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> legacyQuoteVehiclesRefs<T extends Object>(
    Expression<T> Function($$LegacyQuoteVehiclesTableAnnotationComposer a) f,
  ) {
    final $$LegacyQuoteVehiclesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.legacyQuoteVehicles,
          getReferencedColumn: (t) => t.vehicleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyQuoteVehiclesTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyQuoteVehicles,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LegacyVehiclesTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyVehiclesTable,
          LegacyVehicleRow,
          $$LegacyVehiclesTableFilterComposer,
          $$LegacyVehiclesTableOrderingComposer,
          $$LegacyVehiclesTableAnnotationComposer,
          $$LegacyVehiclesTableCreateCompanionBuilder,
          $$LegacyVehiclesTableUpdateCompanionBuilder,
          (LegacyVehicleRow, $$LegacyVehiclesTableReferences),
          LegacyVehicleRow,
          PrefetchHooks Function({
            bool vehicleTypeId,
            bool legacyQuoteVehiclesRefs,
          })
        > {
  $$LegacyVehiclesTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyVehiclesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyVehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegacyVehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegacyVehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> plate = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> vehicleTypeId = const Value.absent(),
                Value<double> payloadCapacityKg = const Value.absent(),
                Value<double> volumeCapacityM3 = const Value.absent(),
                Value<String?> observations = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyVehiclesCompanion(
                id: id,
                plate: plate,
                description: description,
                vehicleTypeId: vehicleTypeId,
                payloadCapacityKg: payloadCapacityKg,
                volumeCapacityM3: volumeCapacityM3,
                observations: observations,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String plate,
                required String description,
                required String vehicleTypeId,
                required double payloadCapacityKg,
                required double volumeCapacityM3,
                Value<String?> observations = const Value.absent(),
                required String status,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyVehiclesCompanion.insert(
                id: id,
                plate: plate,
                description: description,
                vehicleTypeId: vehicleTypeId,
                payloadCapacityKg: payloadCapacityKg,
                volumeCapacityM3: volumeCapacityM3,
                observations: observations,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyVehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({vehicleTypeId = false, legacyQuoteVehiclesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (legacyQuoteVehiclesRefs) db.legacyQuoteVehicles,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (vehicleTypeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.vehicleTypeId,
                                    referencedTable:
                                        $$LegacyVehiclesTableReferences
                                            ._vehicleTypeIdTable(db),
                                    referencedColumn:
                                        $$LegacyVehiclesTableReferences
                                            ._vehicleTypeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (legacyQuoteVehiclesRefs)
                        await $_getPrefetchedData<
                          LegacyVehicleRow,
                          $LegacyVehiclesTable,
                          LegacyQuoteVehicleRow
                        >(
                          currentTable: table,
                          referencedTable: $$LegacyVehiclesTableReferences
                              ._legacyQuoteVehiclesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegacyVehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).legacyQuoteVehiclesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LegacyVehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyVehiclesTable,
      LegacyVehicleRow,
      $$LegacyVehiclesTableFilterComposer,
      $$LegacyVehiclesTableOrderingComposer,
      $$LegacyVehiclesTableAnnotationComposer,
      $$LegacyVehiclesTableCreateCompanionBuilder,
      $$LegacyVehiclesTableUpdateCompanionBuilder,
      (LegacyVehicleRow, $$LegacyVehiclesTableReferences),
      LegacyVehicleRow,
      PrefetchHooks Function({bool vehicleTypeId, bool legacyQuoteVehiclesRefs})
    >;
typedef $$LegacyQuoteVehiclesTableCreateCompanionBuilder =
    LegacyQuoteVehiclesCompanion Function({
      required String id,
      required String quoteId,
      required String vehicleId,
      Value<String?> driverTeamMemberId,
      Value<int?> plannedDepartureAt,
      Value<int?> plannedReturnAt,
      required int freightCostCents,
      Value<String?> notes,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LegacyQuoteVehiclesTableUpdateCompanionBuilder =
    LegacyQuoteVehiclesCompanion Function({
      Value<String> id,
      Value<String> quoteId,
      Value<String> vehicleId,
      Value<String?> driverTeamMemberId,
      Value<int?> plannedDepartureAt,
      Value<int?> plannedReturnAt,
      Value<int> freightCostCents,
      Value<String?> notes,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$LegacyQuoteVehiclesTableReferences
    extends
        BaseReferences<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteVehiclesTable,
          LegacyQuoteVehicleRow
        > {
  $$LegacyQuoteVehiclesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LegacyQuotesTable _quoteIdTable(_$LegacyAppDatabaseV10 db) =>
      db.legacyQuotes.createAlias('quote_vehicles__quote_id__quotes__id');

  $$LegacyQuotesTableProcessedTableManager get quoteId {
    final $_column = $_itemColumn<String>('quote_id')!;

    final manager = $$LegacyQuotesTableTableManager(
      $_db,
      $_db.legacyQuotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LegacyVehiclesTable _vehicleIdTable(_$LegacyAppDatabaseV10 db) =>
      db.legacyVehicles.createAlias('quote_vehicles__vehicle_id__vehicles__id');

  $$LegacyVehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<String>('vehicle_id')!;

    final manager = $$LegacyVehiclesTableTableManager(
      $_db,
      $_db.legacyVehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LegacyTeamMembersTable _driverTeamMemberIdTable(
    _$LegacyAppDatabaseV10 db,
  ) => db.legacyTeamMembers.createAlias(
    'quote_vehicles__driver_team_member_id__team_members__id',
  );

  $$LegacyTeamMembersTableProcessedTableManager? get driverTeamMemberId {
    final $_column = $_itemColumn<String>('driver_team_member_id');
    if ($_column == null) return null;
    final manager = $$LegacyTeamMembersTableTableManager(
      $_db,
      $_db.legacyTeamMembers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_driverTeamMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LegacyQuoteVehiclesTableFilterComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteVehiclesTable> {
  $$LegacyQuoteVehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedDepartureAt => $composableBuilder(
    column: $table.plannedDepartureAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedReturnAt => $composableBuilder(
    column: $table.plannedReturnAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get freightCostCents => $composableBuilder(
    column: $table.freightCostCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LegacyQuotesTableFilterComposer get quoteId {
    final $$LegacyQuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableFilterComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyVehiclesTableFilterComposer get vehicleId {
    final $$LegacyVehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.legacyVehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyVehiclesTableFilterComposer(
            $db: $db,
            $table: $db.legacyVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyTeamMembersTableFilterComposer get driverTeamMemberId {
    final $$LegacyTeamMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.driverTeamMemberId,
      referencedTable: $db.legacyTeamMembers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyTeamMembersTableFilterComposer(
            $db: $db,
            $table: $db.legacyTeamMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteVehiclesTableOrderingComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteVehiclesTable> {
  $$LegacyQuoteVehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedDepartureAt => $composableBuilder(
    column: $table.plannedDepartureAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedReturnAt => $composableBuilder(
    column: $table.plannedReturnAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get freightCostCents => $composableBuilder(
    column: $table.freightCostCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegacyQuotesTableOrderingComposer get quoteId {
    final $$LegacyQuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableOrderingComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyVehiclesTableOrderingComposer get vehicleId {
    final $$LegacyVehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.legacyVehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyVehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.legacyVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyTeamMembersTableOrderingComposer get driverTeamMemberId {
    final $$LegacyTeamMembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.driverTeamMemberId,
      referencedTable: $db.legacyTeamMembers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyTeamMembersTableOrderingComposer(
            $db: $db,
            $table: $db.legacyTeamMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LegacyQuoteVehiclesTableAnnotationComposer
    extends Composer<_$LegacyAppDatabaseV10, $LegacyQuoteVehiclesTable> {
  $$LegacyQuoteVehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get plannedDepartureAt => $composableBuilder(
    column: $table.plannedDepartureAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedReturnAt => $composableBuilder(
    column: $table.plannedReturnAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get freightCostCents => $composableBuilder(
    column: $table.freightCostCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LegacyQuotesTableAnnotationComposer get quoteId {
    final $$LegacyQuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.legacyQuotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyQuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyQuotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyVehiclesTableAnnotationComposer get vehicleId {
    final $$LegacyVehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.legacyVehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegacyVehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.legacyVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegacyTeamMembersTableAnnotationComposer get driverTeamMemberId {
    final $$LegacyTeamMembersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.driverTeamMemberId,
          referencedTable: $db.legacyTeamMembers,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LegacyTeamMembersTableAnnotationComposer(
                $db: $db,
                $table: $db.legacyTeamMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$LegacyQuoteVehiclesTableTableManager
    extends
        RootTableManager<
          _$LegacyAppDatabaseV10,
          $LegacyQuoteVehiclesTable,
          LegacyQuoteVehicleRow,
          $$LegacyQuoteVehiclesTableFilterComposer,
          $$LegacyQuoteVehiclesTableOrderingComposer,
          $$LegacyQuoteVehiclesTableAnnotationComposer,
          $$LegacyQuoteVehiclesTableCreateCompanionBuilder,
          $$LegacyQuoteVehiclesTableUpdateCompanionBuilder,
          (LegacyQuoteVehicleRow, $$LegacyQuoteVehiclesTableReferences),
          LegacyQuoteVehicleRow,
          PrefetchHooks Function({
            bool quoteId,
            bool vehicleId,
            bool driverTeamMemberId,
          })
        > {
  $$LegacyQuoteVehiclesTableTableManager(
    _$LegacyAppDatabaseV10 db,
    $LegacyQuoteVehiclesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyQuoteVehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegacyQuoteVehiclesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyQuoteVehiclesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> quoteId = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String?> driverTeamMemberId = const Value.absent(),
                Value<int?> plannedDepartureAt = const Value.absent(),
                Value<int?> plannedReturnAt = const Value.absent(),
                Value<int> freightCostCents = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteVehiclesCompanion(
                id: id,
                quoteId: quoteId,
                vehicleId: vehicleId,
                driverTeamMemberId: driverTeamMemberId,
                plannedDepartureAt: plannedDepartureAt,
                plannedReturnAt: plannedReturnAt,
                freightCostCents: freightCostCents,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String quoteId,
                required String vehicleId,
                Value<String?> driverTeamMemberId = const Value.absent(),
                Value<int?> plannedDepartureAt = const Value.absent(),
                Value<int?> plannedReturnAt = const Value.absent(),
                required int freightCostCents,
                Value<String?> notes = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LegacyQuoteVehiclesCompanion.insert(
                id: id,
                quoteId: quoteId,
                vehicleId: vehicleId,
                driverTeamMemberId: driverTeamMemberId,
                plannedDepartureAt: plannedDepartureAt,
                plannedReturnAt: plannedReturnAt,
                freightCostCents: freightCostCents,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegacyQuoteVehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                quoteId = false,
                vehicleId = false,
                driverTeamMemberId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (quoteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.quoteId,
                                    referencedTable:
                                        $$LegacyQuoteVehiclesTableReferences
                                            ._quoteIdTable(db),
                                    referencedColumn:
                                        $$LegacyQuoteVehiclesTableReferences
                                            ._quoteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (vehicleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.vehicleId,
                                    referencedTable:
                                        $$LegacyQuoteVehiclesTableReferences
                                            ._vehicleIdTable(db),
                                    referencedColumn:
                                        $$LegacyQuoteVehiclesTableReferences
                                            ._vehicleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (driverTeamMemberId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.driverTeamMemberId,
                                    referencedTable:
                                        $$LegacyQuoteVehiclesTableReferences
                                            ._driverTeamMemberIdTable(db),
                                    referencedColumn:
                                        $$LegacyQuoteVehiclesTableReferences
                                            ._driverTeamMemberIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$LegacyQuoteVehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$LegacyAppDatabaseV10,
      $LegacyQuoteVehiclesTable,
      LegacyQuoteVehicleRow,
      $$LegacyQuoteVehiclesTableFilterComposer,
      $$LegacyQuoteVehiclesTableOrderingComposer,
      $$LegacyQuoteVehiclesTableAnnotationComposer,
      $$LegacyQuoteVehiclesTableCreateCompanionBuilder,
      $$LegacyQuoteVehiclesTableUpdateCompanionBuilder,
      (LegacyQuoteVehicleRow, $$LegacyQuoteVehiclesTableReferences),
      LegacyQuoteVehicleRow,
      PrefetchHooks Function({
        bool quoteId,
        bool vehicleId,
        bool driverTeamMemberId,
      })
    >;

class $LegacyAppDatabaseV10Manager {
  final _$LegacyAppDatabaseV10 _db;
  $LegacyAppDatabaseV10Manager(this._db);
  $$LegacyClientsTableTableManager get legacyClients =>
      $$LegacyClientsTableTableManager(_db, _db.legacyClients);
  $$LegacyCatalogItemsTableTableManager get legacyCatalogItems =>
      $$LegacyCatalogItemsTableTableManager(_db, _db.legacyCatalogItems);
  $$LegacyCatalogPackageComponentsTableTableManager
  get legacyCatalogPackageComponents =>
      $$LegacyCatalogPackageComponentsTableTableManager(
        _db,
        _db.legacyCatalogPackageComponents,
      );
  $$LegacyCompanyProfilesTableTableManager get legacyCompanyProfiles =>
      $$LegacyCompanyProfilesTableTableManager(_db, _db.legacyCompanyProfiles);
  $$LegacyQuotesTableTableManager get legacyQuotes =>
      $$LegacyQuotesTableTableManager(_db, _db.legacyQuotes);
  $$LegacyQuoteClientSnapshotsTableTableManager
  get legacyQuoteClientSnapshots =>
      $$LegacyQuoteClientSnapshotsTableTableManager(
        _db,
        _db.legacyQuoteClientSnapshots,
      );
  $$LegacyQuoteEventSnapshotsTableTableManager get legacyQuoteEventSnapshots =>
      $$LegacyQuoteEventSnapshotsTableTableManager(
        _db,
        _db.legacyQuoteEventSnapshots,
      );
  $$LegacyQuoteCompanySnapshotsTableTableManager
  get legacyQuoteCompanySnapshots =>
      $$LegacyQuoteCompanySnapshotsTableTableManager(
        _db,
        _db.legacyQuoteCompanySnapshots,
      );
  $$LegacyQuoteLineItemsTableTableManager get legacyQuoteLineItems =>
      $$LegacyQuoteLineItemsTableTableManager(_db, _db.legacyQuoteLineItems);
  $$LegacyQuoteLinePackageComponentsTableTableManager
  get legacyQuoteLinePackageComponents =>
      $$LegacyQuoteLinePackageComponentsTableTableManager(
        _db,
        _db.legacyQuoteLinePackageComponents,
      );
  $$LegacyQuoteStatusHistoryTableTableManager get legacyQuoteStatusHistory =>
      $$LegacyQuoteStatusHistoryTableTableManager(
        _db,
        _db.legacyQuoteStatusHistory,
      );
  $$LegacyQuoteNumberSequencesTableTableManager
  get legacyQuoteNumberSequences =>
      $$LegacyQuoteNumberSequencesTableTableManager(
        _db,
        _db.legacyQuoteNumberSequences,
      );
  $$LegacyAgendaBlocksTableTableManager get legacyAgendaBlocks =>
      $$LegacyAgendaBlocksTableTableManager(_db, _db.legacyAgendaBlocks);
  $$LegacyFinancialCategoriesTableTableManager get legacyFinancialCategories =>
      $$LegacyFinancialCategoriesTableTableManager(
        _db,
        _db.legacyFinancialCategories,
      );
  $$LegacyFinancialEntriesTableTableManager get legacyFinancialEntries =>
      $$LegacyFinancialEntriesTableTableManager(
        _db,
        _db.legacyFinancialEntries,
      );
  $$LegacyEquipmentCategoriesTableTableManager get legacyEquipmentCategories =>
      $$LegacyEquipmentCategoriesTableTableManager(
        _db,
        _db.legacyEquipmentCategories,
      );
  $$LegacyEquipmentsTableTableManager get legacyEquipments =>
      $$LegacyEquipmentsTableTableManager(_db, _db.legacyEquipments);
  $$LegacyQuoteEquipmentItemsTableTableManager get legacyQuoteEquipmentItems =>
      $$LegacyQuoteEquipmentItemsTableTableManager(
        _db,
        _db.legacyQuoteEquipmentItems,
      );
  $$LegacyTeamRolesTableTableManager get legacyTeamRoles =>
      $$LegacyTeamRolesTableTableManager(_db, _db.legacyTeamRoles);
  $$LegacyTeamMembersTableTableManager get legacyTeamMembers =>
      $$LegacyTeamMembersTableTableManager(_db, _db.legacyTeamMembers);
  $$LegacyQuoteTeamMembersTableTableManager get legacyQuoteTeamMembers =>
      $$LegacyQuoteTeamMembersTableTableManager(
        _db,
        _db.legacyQuoteTeamMembers,
      );
  $$LegacyVehicleTypesTableTableManager get legacyVehicleTypes =>
      $$LegacyVehicleTypesTableTableManager(_db, _db.legacyVehicleTypes);
  $$LegacyVehiclesTableTableManager get legacyVehicles =>
      $$LegacyVehiclesTableTableManager(_db, _db.legacyVehicles);
  $$LegacyQuoteVehiclesTableTableManager get legacyQuoteVehicles =>
      $$LegacyQuoteVehiclesTableTableManager(_db, _db.legacyQuoteVehicles);
}
