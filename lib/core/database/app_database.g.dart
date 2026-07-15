// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientsTable extends Clients with TableInfo<$ClientsTable, ClientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
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
    Insertable<ClientRow> instance, {
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
  ClientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientRow(
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
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class ClientRow extends DataClass implements Insertable<ClientRow> {
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
  const ClientRow({
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

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
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

  factory ClientRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientRow(
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

  ClientRow copyWith({
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
  }) => ClientRow(
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
  ClientRow copyWithCompanion(ClientsCompanion data) {
    return ClientRow(
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
    return (StringBuffer('ClientRow(')
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
      (other is ClientRow &&
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

class ClientsCompanion extends UpdateCompanion<ClientRow> {
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
  const ClientsCompanion({
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
  ClientsCompanion.insert({
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
  static Insertable<ClientRow> custom({
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

  ClientsCompanion copyWith({
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
    return ClientsCompanion(
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
    return (StringBuffer('ClientsCompanion(')
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

class $CatalogItemsTable extends CatalogItems
    with TableInfo<$CatalogItemsTable, CatalogItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogItemsTable(this.attachedDatabase, [this._alias]);
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
    Insertable<CatalogItemRow> instance, {
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
  CatalogItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogItemRow(
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
  $CatalogItemsTable createAlias(String alias) {
    return $CatalogItemsTable(attachedDatabase, alias);
  }
}

class CatalogItemRow extends DataClass implements Insertable<CatalogItemRow> {
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
  const CatalogItemRow({
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

  CatalogItemsCompanion toCompanion(bool nullToAbsent) {
    return CatalogItemsCompanion(
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

  factory CatalogItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogItemRow(
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

  CatalogItemRow copyWith({
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
  }) => CatalogItemRow(
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
  CatalogItemRow copyWithCompanion(CatalogItemsCompanion data) {
    return CatalogItemRow(
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
    return (StringBuffer('CatalogItemRow(')
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
      (other is CatalogItemRow &&
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

class CatalogItemsCompanion extends UpdateCompanion<CatalogItemRow> {
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
  const CatalogItemsCompanion({
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
  CatalogItemsCompanion.insert({
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
  static Insertable<CatalogItemRow> custom({
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

  CatalogItemsCompanion copyWith({
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
    return CatalogItemsCompanion(
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
    return (StringBuffer('CatalogItemsCompanion(')
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

class $CatalogPackageComponentsTable extends CatalogPackageComponents
    with TableInfo<$CatalogPackageComponentsTable, CatalogPackageComponentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogPackageComponentsTable(this.attachedDatabase, [this._alias]);
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
    Insertable<CatalogPackageComponentRow> instance, {
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
  CatalogPackageComponentRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogPackageComponentRow(
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
  $CatalogPackageComponentsTable createAlias(String alias) {
    return $CatalogPackageComponentsTable(attachedDatabase, alias);
  }
}

class CatalogPackageComponentRow extends DataClass
    implements Insertable<CatalogPackageComponentRow> {
  final String packageId;
  final String componentItemId;
  final String nameSnapshot;
  final String unitSnapshot;
  final String typeSnapshot;
  final String categorySnapshot;
  final double quantityPerPackage;
  const CatalogPackageComponentRow({
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

  CatalogPackageComponentsCompanion toCompanion(bool nullToAbsent) {
    return CatalogPackageComponentsCompanion(
      packageId: Value(packageId),
      componentItemId: Value(componentItemId),
      nameSnapshot: Value(nameSnapshot),
      unitSnapshot: Value(unitSnapshot),
      typeSnapshot: Value(typeSnapshot),
      categorySnapshot: Value(categorySnapshot),
      quantityPerPackage: Value(quantityPerPackage),
    );
  }

  factory CatalogPackageComponentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogPackageComponentRow(
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

  CatalogPackageComponentRow copyWith({
    String? packageId,
    String? componentItemId,
    String? nameSnapshot,
    String? unitSnapshot,
    String? typeSnapshot,
    String? categorySnapshot,
    double? quantityPerPackage,
  }) => CatalogPackageComponentRow(
    packageId: packageId ?? this.packageId,
    componentItemId: componentItemId ?? this.componentItemId,
    nameSnapshot: nameSnapshot ?? this.nameSnapshot,
    unitSnapshot: unitSnapshot ?? this.unitSnapshot,
    typeSnapshot: typeSnapshot ?? this.typeSnapshot,
    categorySnapshot: categorySnapshot ?? this.categorySnapshot,
    quantityPerPackage: quantityPerPackage ?? this.quantityPerPackage,
  );
  CatalogPackageComponentRow copyWithCompanion(
    CatalogPackageComponentsCompanion data,
  ) {
    return CatalogPackageComponentRow(
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
    return (StringBuffer('CatalogPackageComponentRow(')
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
      (other is CatalogPackageComponentRow &&
          other.packageId == this.packageId &&
          other.componentItemId == this.componentItemId &&
          other.nameSnapshot == this.nameSnapshot &&
          other.unitSnapshot == this.unitSnapshot &&
          other.typeSnapshot == this.typeSnapshot &&
          other.categorySnapshot == this.categorySnapshot &&
          other.quantityPerPackage == this.quantityPerPackage);
}

class CatalogPackageComponentsCompanion
    extends UpdateCompanion<CatalogPackageComponentRow> {
  final Value<String> packageId;
  final Value<String> componentItemId;
  final Value<String> nameSnapshot;
  final Value<String> unitSnapshot;
  final Value<String> typeSnapshot;
  final Value<String> categorySnapshot;
  final Value<double> quantityPerPackage;
  final Value<int> rowid;
  const CatalogPackageComponentsCompanion({
    this.packageId = const Value.absent(),
    this.componentItemId = const Value.absent(),
    this.nameSnapshot = const Value.absent(),
    this.unitSnapshot = const Value.absent(),
    this.typeSnapshot = const Value.absent(),
    this.categorySnapshot = const Value.absent(),
    this.quantityPerPackage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogPackageComponentsCompanion.insert({
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
  static Insertable<CatalogPackageComponentRow> custom({
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

  CatalogPackageComponentsCompanion copyWith({
    Value<String>? packageId,
    Value<String>? componentItemId,
    Value<String>? nameSnapshot,
    Value<String>? unitSnapshot,
    Value<String>? typeSnapshot,
    Value<String>? categorySnapshot,
    Value<double>? quantityPerPackage,
    Value<int>? rowid,
  }) {
    return CatalogPackageComponentsCompanion(
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
    return (StringBuffer('CatalogPackageComponentsCompanion(')
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

class $CompanyProfilesTable extends CompanyProfiles
    with TableInfo<$CompanyProfilesTable, CompanyProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompanyProfilesTable(this.attachedDatabase, [this._alias]);
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
    Insertable<CompanyProfileRow> instance, {
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
  CompanyProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompanyProfileRow(
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
  $CompanyProfilesTable createAlias(String alias) {
    return $CompanyProfilesTable(attachedDatabase, alias);
  }
}

class CompanyProfileRow extends DataClass
    implements Insertable<CompanyProfileRow> {
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
  const CompanyProfileRow({
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

  CompanyProfilesCompanion toCompanion(bool nullToAbsent) {
    return CompanyProfilesCompanion(
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

  factory CompanyProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompanyProfileRow(
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

  CompanyProfileRow copyWith({
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
  }) => CompanyProfileRow(
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
  CompanyProfileRow copyWithCompanion(CompanyProfilesCompanion data) {
    return CompanyProfileRow(
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
    return (StringBuffer('CompanyProfileRow(')
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
      (other is CompanyProfileRow &&
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

class CompanyProfilesCompanion extends UpdateCompanion<CompanyProfileRow> {
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
  const CompanyProfilesCompanion({
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
  CompanyProfilesCompanion.insert({
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
  static Insertable<CompanyProfileRow> custom({
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

  CompanyProfilesCompanion copyWith({
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
    return CompanyProfilesCompanion(
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
    return (StringBuffer('CompanyProfilesCompanion(')
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

class $QuotesTable extends Quotes with TableInfo<$QuotesTable, QuoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuotesTable(this.attachedDatabase, [this._alias]);
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
    Insertable<QuoteRow> instance, {
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
  QuoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuoteRow(
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
  $QuotesTable createAlias(String alias) {
    return $QuotesTable(attachedDatabase, alias);
  }
}

class QuoteRow extends DataClass implements Insertable<QuoteRow> {
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
  const QuoteRow({
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

  QuotesCompanion toCompanion(bool nullToAbsent) {
    return QuotesCompanion(
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

  factory QuoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuoteRow(
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

  QuoteRow copyWith({
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
  }) => QuoteRow(
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
  QuoteRow copyWithCompanion(QuotesCompanion data) {
    return QuoteRow(
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
    return (StringBuffer('QuoteRow(')
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
      (other is QuoteRow &&
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

class QuotesCompanion extends UpdateCompanion<QuoteRow> {
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
  const QuotesCompanion({
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
  QuotesCompanion.insert({
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
  static Insertable<QuoteRow> custom({
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

  QuotesCompanion copyWith({
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
    return QuotesCompanion(
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
    return (StringBuffer('QuotesCompanion(')
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

class $QuoteClientSnapshotsTable extends QuoteClientSnapshots
    with TableInfo<$QuoteClientSnapshotsTable, QuoteClientSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuoteClientSnapshotsTable(this.attachedDatabase, [this._alias]);
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
    Insertable<QuoteClientSnapshotRow> instance, {
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
  QuoteClientSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuoteClientSnapshotRow(
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
  $QuoteClientSnapshotsTable createAlias(String alias) {
    return $QuoteClientSnapshotsTable(attachedDatabase, alias);
  }
}

class QuoteClientSnapshotRow extends DataClass
    implements Insertable<QuoteClientSnapshotRow> {
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
  const QuoteClientSnapshotRow({
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

  QuoteClientSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return QuoteClientSnapshotsCompanion(
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

  factory QuoteClientSnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuoteClientSnapshotRow(
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

  QuoteClientSnapshotRow copyWith({
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
  }) => QuoteClientSnapshotRow(
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
  QuoteClientSnapshotRow copyWithCompanion(QuoteClientSnapshotsCompanion data) {
    return QuoteClientSnapshotRow(
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
    return (StringBuffer('QuoteClientSnapshotRow(')
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
      (other is QuoteClientSnapshotRow &&
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

class QuoteClientSnapshotsCompanion
    extends UpdateCompanion<QuoteClientSnapshotRow> {
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
  const QuoteClientSnapshotsCompanion({
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
  QuoteClientSnapshotsCompanion.insert({
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
  static Insertable<QuoteClientSnapshotRow> custom({
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

  QuoteClientSnapshotsCompanion copyWith({
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
    return QuoteClientSnapshotsCompanion(
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
    return (StringBuffer('QuoteClientSnapshotsCompanion(')
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

class $QuoteEventSnapshotsTable extends QuoteEventSnapshots
    with TableInfo<$QuoteEventSnapshotsTable, QuoteEventSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuoteEventSnapshotsTable(this.attachedDatabase, [this._alias]);
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
    Insertable<QuoteEventSnapshotRow> instance, {
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
  QuoteEventSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuoteEventSnapshotRow(
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
  $QuoteEventSnapshotsTable createAlias(String alias) {
    return $QuoteEventSnapshotsTable(attachedDatabase, alias);
  }
}

class QuoteEventSnapshotRow extends DataClass
    implements Insertable<QuoteEventSnapshotRow> {
  final String quoteId;
  final String? name;
  final String? type;
  final String? eventDate;
  final String? startTime;
  final String? endTime;
  final String? venueName;
  final String? addressSummary;
  final int? guestCount;
  const QuoteEventSnapshotRow({
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

  QuoteEventSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return QuoteEventSnapshotsCompanion(
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

  factory QuoteEventSnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuoteEventSnapshotRow(
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

  QuoteEventSnapshotRow copyWith({
    String? quoteId,
    Value<String?> name = const Value.absent(),
    Value<String?> type = const Value.absent(),
    Value<String?> eventDate = const Value.absent(),
    Value<String?> startTime = const Value.absent(),
    Value<String?> endTime = const Value.absent(),
    Value<String?> venueName = const Value.absent(),
    Value<String?> addressSummary = const Value.absent(),
    Value<int?> guestCount = const Value.absent(),
  }) => QuoteEventSnapshotRow(
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
  QuoteEventSnapshotRow copyWithCompanion(QuoteEventSnapshotsCompanion data) {
    return QuoteEventSnapshotRow(
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
    return (StringBuffer('QuoteEventSnapshotRow(')
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
      (other is QuoteEventSnapshotRow &&
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

class QuoteEventSnapshotsCompanion
    extends UpdateCompanion<QuoteEventSnapshotRow> {
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
  const QuoteEventSnapshotsCompanion({
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
  QuoteEventSnapshotsCompanion.insert({
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
  static Insertable<QuoteEventSnapshotRow> custom({
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

  QuoteEventSnapshotsCompanion copyWith({
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
    return QuoteEventSnapshotsCompanion(
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
    return (StringBuffer('QuoteEventSnapshotsCompanion(')
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

class $QuoteCompanySnapshotsTable extends QuoteCompanySnapshots
    with TableInfo<$QuoteCompanySnapshotsTable, QuoteCompanySnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuoteCompanySnapshotsTable(this.attachedDatabase, [this._alias]);
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
    Insertable<QuoteCompanySnapshotRow> instance, {
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
  QuoteCompanySnapshotRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuoteCompanySnapshotRow(
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
  $QuoteCompanySnapshotsTable createAlias(String alias) {
    return $QuoteCompanySnapshotsTable(attachedDatabase, alias);
  }
}

class QuoteCompanySnapshotRow extends DataClass
    implements Insertable<QuoteCompanySnapshotRow> {
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
  const QuoteCompanySnapshotRow({
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

  QuoteCompanySnapshotsCompanion toCompanion(bool nullToAbsent) {
    return QuoteCompanySnapshotsCompanion(
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

  factory QuoteCompanySnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuoteCompanySnapshotRow(
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

  QuoteCompanySnapshotRow copyWith({
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
  }) => QuoteCompanySnapshotRow(
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
  QuoteCompanySnapshotRow copyWithCompanion(
    QuoteCompanySnapshotsCompanion data,
  ) {
    return QuoteCompanySnapshotRow(
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
    return (StringBuffer('QuoteCompanySnapshotRow(')
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
      (other is QuoteCompanySnapshotRow &&
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

class QuoteCompanySnapshotsCompanion
    extends UpdateCompanion<QuoteCompanySnapshotRow> {
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
  const QuoteCompanySnapshotsCompanion({
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
  QuoteCompanySnapshotsCompanion.insert({
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
  static Insertable<QuoteCompanySnapshotRow> custom({
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

  QuoteCompanySnapshotsCompanion copyWith({
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
    return QuoteCompanySnapshotsCompanion(
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
    return (StringBuffer('QuoteCompanySnapshotsCompanion(')
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

class $QuoteLineItemsTable extends QuoteLineItems
    with TableInfo<$QuoteLineItemsTable, QuoteLineItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuoteLineItemsTable(this.attachedDatabase, [this._alias]);
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
    Insertable<QuoteLineItemRow> instance, {
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
  QuoteLineItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuoteLineItemRow(
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
  $QuoteLineItemsTable createAlias(String alias) {
    return $QuoteLineItemsTable(attachedDatabase, alias);
  }
}

class QuoteLineItemRow extends DataClass
    implements Insertable<QuoteLineItemRow> {
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
  const QuoteLineItemRow({
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

  QuoteLineItemsCompanion toCompanion(bool nullToAbsent) {
    return QuoteLineItemsCompanion(
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

  factory QuoteLineItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuoteLineItemRow(
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

  QuoteLineItemRow copyWith({
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
  }) => QuoteLineItemRow(
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
  QuoteLineItemRow copyWithCompanion(QuoteLineItemsCompanion data) {
    return QuoteLineItemRow(
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
    return (StringBuffer('QuoteLineItemRow(')
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
      (other is QuoteLineItemRow &&
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

class QuoteLineItemsCompanion extends UpdateCompanion<QuoteLineItemRow> {
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
  const QuoteLineItemsCompanion({
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
  QuoteLineItemsCompanion.insert({
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
  static Insertable<QuoteLineItemRow> custom({
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

  QuoteLineItemsCompanion copyWith({
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
    return QuoteLineItemsCompanion(
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
    return (StringBuffer('QuoteLineItemsCompanion(')
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

class $QuoteLinePackageComponentsTable extends QuoteLinePackageComponents
    with
        TableInfo<
          $QuoteLinePackageComponentsTable,
          QuoteLinePackageComponentRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuoteLinePackageComponentsTable(this.attachedDatabase, [this._alias]);
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
    Insertable<QuoteLinePackageComponentRow> instance, {
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
  QuoteLinePackageComponentRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuoteLinePackageComponentRow(
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
  $QuoteLinePackageComponentsTable createAlias(String alias) {
    return $QuoteLinePackageComponentsTable(attachedDatabase, alias);
  }
}

class QuoteLinePackageComponentRow extends DataClass
    implements Insertable<QuoteLinePackageComponentRow> {
  final String id;
  final String lineItemId;
  final int sortOrder;
  final String? catalogItemId;
  final String name;
  final String unit;
  final String typeLabel;
  final String categoryLabel;
  final double quantityPerPackage;
  const QuoteLinePackageComponentRow({
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

  QuoteLinePackageComponentsCompanion toCompanion(bool nullToAbsent) {
    return QuoteLinePackageComponentsCompanion(
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

  factory QuoteLinePackageComponentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuoteLinePackageComponentRow(
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

  QuoteLinePackageComponentRow copyWith({
    String? id,
    String? lineItemId,
    int? sortOrder,
    Value<String?> catalogItemId = const Value.absent(),
    String? name,
    String? unit,
    String? typeLabel,
    String? categoryLabel,
    double? quantityPerPackage,
  }) => QuoteLinePackageComponentRow(
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
  QuoteLinePackageComponentRow copyWithCompanion(
    QuoteLinePackageComponentsCompanion data,
  ) {
    return QuoteLinePackageComponentRow(
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
    return (StringBuffer('QuoteLinePackageComponentRow(')
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
      (other is QuoteLinePackageComponentRow &&
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

class QuoteLinePackageComponentsCompanion
    extends UpdateCompanion<QuoteLinePackageComponentRow> {
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
  const QuoteLinePackageComponentsCompanion({
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
  QuoteLinePackageComponentsCompanion.insert({
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
  static Insertable<QuoteLinePackageComponentRow> custom({
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

  QuoteLinePackageComponentsCompanion copyWith({
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
    return QuoteLinePackageComponentsCompanion(
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
    return (StringBuffer('QuoteLinePackageComponentsCompanion(')
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

class $QuoteStatusHistoryTable extends QuoteStatusHistory
    with TableInfo<$QuoteStatusHistoryTable, QuoteStatusHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuoteStatusHistoryTable(this.attachedDatabase, [this._alias]);
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
    Insertable<QuoteStatusHistoryRow> instance, {
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
  QuoteStatusHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuoteStatusHistoryRow(
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
  $QuoteStatusHistoryTable createAlias(String alias) {
    return $QuoteStatusHistoryTable(attachedDatabase, alias);
  }
}

class QuoteStatusHistoryRow extends DataClass
    implements Insertable<QuoteStatusHistoryRow> {
  final String id;
  final String quoteId;
  final int sortOrder;
  final String? previousStatus;
  final String newStatus;
  final int changedAt;
  const QuoteStatusHistoryRow({
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

  QuoteStatusHistoryCompanion toCompanion(bool nullToAbsent) {
    return QuoteStatusHistoryCompanion(
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

  factory QuoteStatusHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuoteStatusHistoryRow(
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

  QuoteStatusHistoryRow copyWith({
    String? id,
    String? quoteId,
    int? sortOrder,
    Value<String?> previousStatus = const Value.absent(),
    String? newStatus,
    int? changedAt,
  }) => QuoteStatusHistoryRow(
    id: id ?? this.id,
    quoteId: quoteId ?? this.quoteId,
    sortOrder: sortOrder ?? this.sortOrder,
    previousStatus: previousStatus.present
        ? previousStatus.value
        : this.previousStatus,
    newStatus: newStatus ?? this.newStatus,
    changedAt: changedAt ?? this.changedAt,
  );
  QuoteStatusHistoryRow copyWithCompanion(QuoteStatusHistoryCompanion data) {
    return QuoteStatusHistoryRow(
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
    return (StringBuffer('QuoteStatusHistoryRow(')
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
      (other is QuoteStatusHistoryRow &&
          other.id == this.id &&
          other.quoteId == this.quoteId &&
          other.sortOrder == this.sortOrder &&
          other.previousStatus == this.previousStatus &&
          other.newStatus == this.newStatus &&
          other.changedAt == this.changedAt);
}

class QuoteStatusHistoryCompanion
    extends UpdateCompanion<QuoteStatusHistoryRow> {
  final Value<String> id;
  final Value<String> quoteId;
  final Value<int> sortOrder;
  final Value<String?> previousStatus;
  final Value<String> newStatus;
  final Value<int> changedAt;
  final Value<int> rowid;
  const QuoteStatusHistoryCompanion({
    this.id = const Value.absent(),
    this.quoteId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.previousStatus = const Value.absent(),
    this.newStatus = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuoteStatusHistoryCompanion.insert({
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
  static Insertable<QuoteStatusHistoryRow> custom({
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

  QuoteStatusHistoryCompanion copyWith({
    Value<String>? id,
    Value<String>? quoteId,
    Value<int>? sortOrder,
    Value<String?>? previousStatus,
    Value<String>? newStatus,
    Value<int>? changedAt,
    Value<int>? rowid,
  }) {
    return QuoteStatusHistoryCompanion(
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
    return (StringBuffer('QuoteStatusHistoryCompanion(')
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

class $QuoteNumberSequencesTable extends QuoteNumberSequences
    with TableInfo<$QuoteNumberSequencesTable, QuoteNumberSequenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuoteNumberSequencesTable(this.attachedDatabase, [this._alias]);
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
    Insertable<QuoteNumberSequenceRow> instance, {
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
  QuoteNumberSequenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuoteNumberSequenceRow(
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
  $QuoteNumberSequencesTable createAlias(String alias) {
    return $QuoteNumberSequencesTable(attachedDatabase, alias);
  }
}

class QuoteNumberSequenceRow extends DataClass
    implements Insertable<QuoteNumberSequenceRow> {
  final int year;
  final int lastSequence;
  const QuoteNumberSequenceRow({
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

  QuoteNumberSequencesCompanion toCompanion(bool nullToAbsent) {
    return QuoteNumberSequencesCompanion(
      year: Value(year),
      lastSequence: Value(lastSequence),
    );
  }

  factory QuoteNumberSequenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuoteNumberSequenceRow(
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

  QuoteNumberSequenceRow copyWith({int? year, int? lastSequence}) =>
      QuoteNumberSequenceRow(
        year: year ?? this.year,
        lastSequence: lastSequence ?? this.lastSequence,
      );
  QuoteNumberSequenceRow copyWithCompanion(QuoteNumberSequencesCompanion data) {
    return QuoteNumberSequenceRow(
      year: data.year.present ? data.year.value : this.year,
      lastSequence: data.lastSequence.present
          ? data.lastSequence.value
          : this.lastSequence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuoteNumberSequenceRow(')
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
      (other is QuoteNumberSequenceRow &&
          other.year == this.year &&
          other.lastSequence == this.lastSequence);
}

class QuoteNumberSequencesCompanion
    extends UpdateCompanion<QuoteNumberSequenceRow> {
  final Value<int> year;
  final Value<int> lastSequence;
  const QuoteNumberSequencesCompanion({
    this.year = const Value.absent(),
    this.lastSequence = const Value.absent(),
  });
  QuoteNumberSequencesCompanion.insert({
    this.year = const Value.absent(),
    required int lastSequence,
  }) : lastSequence = Value(lastSequence);
  static Insertable<QuoteNumberSequenceRow> custom({
    Expression<int>? year,
    Expression<int>? lastSequence,
  }) {
    return RawValuesInsertable({
      if (year != null) 'year': year,
      if (lastSequence != null) 'last_sequence': lastSequence,
    });
  }

  QuoteNumberSequencesCompanion copyWith({
    Value<int>? year,
    Value<int>? lastSequence,
  }) {
    return QuoteNumberSequencesCompanion(
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
    return (StringBuffer('QuoteNumberSequencesCompanion(')
          ..write('year: $year, ')
          ..write('lastSequence: $lastSequence')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $CatalogItemsTable catalogItems = $CatalogItemsTable(this);
  late final $CatalogPackageComponentsTable catalogPackageComponents =
      $CatalogPackageComponentsTable(this);
  late final $CompanyProfilesTable companyProfiles = $CompanyProfilesTable(
    this,
  );
  late final $QuotesTable quotes = $QuotesTable(this);
  late final $QuoteClientSnapshotsTable quoteClientSnapshots =
      $QuoteClientSnapshotsTable(this);
  late final $QuoteEventSnapshotsTable quoteEventSnapshots =
      $QuoteEventSnapshotsTable(this);
  late final $QuoteCompanySnapshotsTable quoteCompanySnapshots =
      $QuoteCompanySnapshotsTable(this);
  late final $QuoteLineItemsTable quoteLineItems = $QuoteLineItemsTable(this);
  late final $QuoteLinePackageComponentsTable quoteLinePackageComponents =
      $QuoteLinePackageComponentsTable(this);
  late final $QuoteStatusHistoryTable quoteStatusHistory =
      $QuoteStatusHistoryTable(this);
  late final $QuoteNumberSequencesTable quoteNumberSequences =
      $QuoteNumberSequencesTable(this);
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
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clients,
    catalogItems,
    catalogPackageComponents,
    companyProfiles,
    quotes,
    quoteClientSnapshots,
    quoteEventSnapshots,
    quoteCompanySnapshots,
    quoteLineItems,
    quoteLinePackageComponents,
    quoteStatusHistory,
    quoteNumberSequences,
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
  ]);
}

typedef $$ClientsTableCreateCompanionBuilder =
    ClientsCompanion Function({
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
typedef $$ClientsTableUpdateCompanionBuilder =
    ClientsCompanion Function({
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

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
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

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
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

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
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

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          ClientRow,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (ClientRow, BaseReferences<_$AppDatabase, $ClientsTable, ClientRow>),
          ClientRow,
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
              }) => ClientsCompanion(
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
              }) => ClientsCompanion.insert(
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

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      ClientRow,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (ClientRow, BaseReferences<_$AppDatabase, $ClientsTable, ClientRow>),
      ClientRow,
      PrefetchHooks Function()
    >;
typedef $$CatalogItemsTableCreateCompanionBuilder =
    CatalogItemsCompanion Function({
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
typedef $$CatalogItemsTableUpdateCompanionBuilder =
    CatalogItemsCompanion Function({
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

final class $$CatalogItemsTableReferences
    extends BaseReferences<_$AppDatabase, $CatalogItemsTable, CatalogItemRow> {
  $$CatalogItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $CatalogPackageComponentsTable,
    List<CatalogPackageComponentRow>
  >
  _package_componentsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.catalogPackageComponents,
    aliasName: 'catalog_items__id__catalog_package_components__package_id',
  );

  $$CatalogPackageComponentsTableProcessedTableManager get package_components {
    final manager = $$CatalogPackageComponentsTableTableManager(
      $_db,
      $_db.catalogPackageComponents,
    ).filter((f) => f.packageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_package_componentsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CatalogPackageComponentsTable,
    List<CatalogPackageComponentRow>
  >
  _component_usagesTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.catalogPackageComponents,
    aliasName:
        'catalog_items__id__catalog_package_components__component_item_id',
  );

  $$CatalogPackageComponentsTableProcessedTableManager get component_usages {
    final manager =
        $$CatalogPackageComponentsTableTableManager(
          $_db,
          $_db.catalogPackageComponents,
        ).filter(
          (f) => f.componentItemId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_component_usagesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CatalogItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogItemsTable> {
  $$CatalogItemsTableFilterComposer({
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
    Expression<bool> Function($$CatalogPackageComponentsTableFilterComposer f)
    f,
  ) {
    final $$CatalogPackageComponentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.catalogPackageComponents,
          getReferencedColumn: (t) => t.packageId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CatalogPackageComponentsTableFilterComposer(
                $db: $db,
                $table: $db.catalogPackageComponents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> component_usages(
    Expression<bool> Function($$CatalogPackageComponentsTableFilterComposer f)
    f,
  ) {
    final $$CatalogPackageComponentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.catalogPackageComponents,
          getReferencedColumn: (t) => t.componentItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CatalogPackageComponentsTableFilterComposer(
                $db: $db,
                $table: $db.catalogPackageComponents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CatalogItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogItemsTable> {
  $$CatalogItemsTableOrderingComposer({
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

class $$CatalogItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogItemsTable> {
  $$CatalogItemsTableAnnotationComposer({
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
    Expression<T> Function($$CatalogPackageComponentsTableAnnotationComposer a)
    f,
  ) {
    final $$CatalogPackageComponentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.catalogPackageComponents,
          getReferencedColumn: (t) => t.packageId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CatalogPackageComponentsTableAnnotationComposer(
                $db: $db,
                $table: $db.catalogPackageComponents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> component_usages<T extends Object>(
    Expression<T> Function($$CatalogPackageComponentsTableAnnotationComposer a)
    f,
  ) {
    final $$CatalogPackageComponentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.catalogPackageComponents,
          getReferencedColumn: (t) => t.componentItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CatalogPackageComponentsTableAnnotationComposer(
                $db: $db,
                $table: $db.catalogPackageComponents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CatalogItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogItemsTable,
          CatalogItemRow,
          $$CatalogItemsTableFilterComposer,
          $$CatalogItemsTableOrderingComposer,
          $$CatalogItemsTableAnnotationComposer,
          $$CatalogItemsTableCreateCompanionBuilder,
          $$CatalogItemsTableUpdateCompanionBuilder,
          (CatalogItemRow, $$CatalogItemsTableReferences),
          CatalogItemRow,
          PrefetchHooks Function({
            bool package_components,
            bool component_usages,
          })
        > {
  $$CatalogItemsTableTableManager(_$AppDatabase db, $CatalogItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogItemsTableAnnotationComposer($db: db, $table: table),
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
              }) => CatalogItemsCompanion(
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
              }) => CatalogItemsCompanion.insert(
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
                  $$CatalogItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({package_components = false, component_usages = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (package_components) db.catalogPackageComponents,
                    if (component_usages) db.catalogPackageComponents,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (package_components)
                        await $_getPrefetchedData<
                          CatalogItemRow,
                          $CatalogItemsTable,
                          CatalogPackageComponentRow
                        >(
                          currentTable: table,
                          referencedTable: $$CatalogItemsTableReferences
                              ._package_componentsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CatalogItemsTableReferences(
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
                          CatalogItemRow,
                          $CatalogItemsTable,
                          CatalogPackageComponentRow
                        >(
                          currentTable: table,
                          referencedTable: $$CatalogItemsTableReferences
                              ._component_usagesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CatalogItemsTableReferences(
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

typedef $$CatalogItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogItemsTable,
      CatalogItemRow,
      $$CatalogItemsTableFilterComposer,
      $$CatalogItemsTableOrderingComposer,
      $$CatalogItemsTableAnnotationComposer,
      $$CatalogItemsTableCreateCompanionBuilder,
      $$CatalogItemsTableUpdateCompanionBuilder,
      (CatalogItemRow, $$CatalogItemsTableReferences),
      CatalogItemRow,
      PrefetchHooks Function({bool package_components, bool component_usages})
    >;
typedef $$CatalogPackageComponentsTableCreateCompanionBuilder =
    CatalogPackageComponentsCompanion Function({
      required String packageId,
      required String componentItemId,
      required String nameSnapshot,
      required String unitSnapshot,
      required String typeSnapshot,
      required String categorySnapshot,
      required double quantityPerPackage,
      Value<int> rowid,
    });
typedef $$CatalogPackageComponentsTableUpdateCompanionBuilder =
    CatalogPackageComponentsCompanion Function({
      Value<String> packageId,
      Value<String> componentItemId,
      Value<String> nameSnapshot,
      Value<String> unitSnapshot,
      Value<String> typeSnapshot,
      Value<String> categorySnapshot,
      Value<double> quantityPerPackage,
      Value<int> rowid,
    });

final class $$CatalogPackageComponentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CatalogPackageComponentsTable,
          CatalogPackageComponentRow
        > {
  $$CatalogPackageComponentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CatalogItemsTable _packageIdTable(_$AppDatabase db) => db.catalogItems
      .createAlias('catalog_package_components__package_id__catalog_items__id');

  $$CatalogItemsTableProcessedTableManager get packageId {
    final $_column = $_itemColumn<String>('package_id')!;

    final manager = $$CatalogItemsTableTableManager(
      $_db,
      $_db.catalogItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CatalogItemsTable _componentItemIdTable(_$AppDatabase db) =>
      db.catalogItems.createAlias(
        'catalog_package_components__component_item_id__catalog_items__id',
      );

  $$CatalogItemsTableProcessedTableManager get componentItemId {
    final $_column = $_itemColumn<String>('component_item_id')!;

    final manager = $$CatalogItemsTableTableManager(
      $_db,
      $_db.catalogItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_componentItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CatalogPackageComponentsTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogPackageComponentsTable> {
  $$CatalogPackageComponentsTableFilterComposer({
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

  $$CatalogItemsTableFilterComposer get packageId {
    final $$CatalogItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.catalogItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogItemsTableFilterComposer(
            $db: $db,
            $table: $db.catalogItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogItemsTableFilterComposer get componentItemId {
    final $$CatalogItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentItemId,
      referencedTable: $db.catalogItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogItemsTableFilterComposer(
            $db: $db,
            $table: $db.catalogItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CatalogPackageComponentsTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogPackageComponentsTable> {
  $$CatalogPackageComponentsTableOrderingComposer({
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

  $$CatalogItemsTableOrderingComposer get packageId {
    final $$CatalogItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.catalogItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogItemsTableOrderingComposer(
            $db: $db,
            $table: $db.catalogItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogItemsTableOrderingComposer get componentItemId {
    final $$CatalogItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentItemId,
      referencedTable: $db.catalogItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogItemsTableOrderingComposer(
            $db: $db,
            $table: $db.catalogItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CatalogPackageComponentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogPackageComponentsTable> {
  $$CatalogPackageComponentsTableAnnotationComposer({
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

  $$CatalogItemsTableAnnotationComposer get packageId {
    final $$CatalogItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageId,
      referencedTable: $db.catalogItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.catalogItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogItemsTableAnnotationComposer get componentItemId {
    final $$CatalogItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentItemId,
      referencedTable: $db.catalogItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.catalogItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CatalogPackageComponentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogPackageComponentsTable,
          CatalogPackageComponentRow,
          $$CatalogPackageComponentsTableFilterComposer,
          $$CatalogPackageComponentsTableOrderingComposer,
          $$CatalogPackageComponentsTableAnnotationComposer,
          $$CatalogPackageComponentsTableCreateCompanionBuilder,
          $$CatalogPackageComponentsTableUpdateCompanionBuilder,
          (
            CatalogPackageComponentRow,
            $$CatalogPackageComponentsTableReferences,
          ),
          CatalogPackageComponentRow,
          PrefetchHooks Function({bool packageId, bool componentItemId})
        > {
  $$CatalogPackageComponentsTableTableManager(
    _$AppDatabase db,
    $CatalogPackageComponentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogPackageComponentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CatalogPackageComponentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CatalogPackageComponentsTableAnnotationComposer(
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
              }) => CatalogPackageComponentsCompanion(
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
              }) => CatalogPackageComponentsCompanion.insert(
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
                  $$CatalogPackageComponentsTableReferences(db, table, e),
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
                                    $$CatalogPackageComponentsTableReferences
                                        ._packageIdTable(db),
                                referencedColumn:
                                    $$CatalogPackageComponentsTableReferences
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
                                    $$CatalogPackageComponentsTableReferences
                                        ._componentItemIdTable(db),
                                referencedColumn:
                                    $$CatalogPackageComponentsTableReferences
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

typedef $$CatalogPackageComponentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogPackageComponentsTable,
      CatalogPackageComponentRow,
      $$CatalogPackageComponentsTableFilterComposer,
      $$CatalogPackageComponentsTableOrderingComposer,
      $$CatalogPackageComponentsTableAnnotationComposer,
      $$CatalogPackageComponentsTableCreateCompanionBuilder,
      $$CatalogPackageComponentsTableUpdateCompanionBuilder,
      (CatalogPackageComponentRow, $$CatalogPackageComponentsTableReferences),
      CatalogPackageComponentRow,
      PrefetchHooks Function({bool packageId, bool componentItemId})
    >;
typedef $$CompanyProfilesTableCreateCompanionBuilder =
    CompanyProfilesCompanion Function({
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
typedef $$CompanyProfilesTableUpdateCompanionBuilder =
    CompanyProfilesCompanion Function({
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

class $$CompanyProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $CompanyProfilesTable> {
  $$CompanyProfilesTableFilterComposer({
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

class $$CompanyProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $CompanyProfilesTable> {
  $$CompanyProfilesTableOrderingComposer({
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

class $$CompanyProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompanyProfilesTable> {
  $$CompanyProfilesTableAnnotationComposer({
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

class $$CompanyProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompanyProfilesTable,
          CompanyProfileRow,
          $$CompanyProfilesTableFilterComposer,
          $$CompanyProfilesTableOrderingComposer,
          $$CompanyProfilesTableAnnotationComposer,
          $$CompanyProfilesTableCreateCompanionBuilder,
          $$CompanyProfilesTableUpdateCompanionBuilder,
          (
            CompanyProfileRow,
            BaseReferences<
              _$AppDatabase,
              $CompanyProfilesTable,
              CompanyProfileRow
            >,
          ),
          CompanyProfileRow,
          PrefetchHooks Function()
        > {
  $$CompanyProfilesTableTableManager(
    _$AppDatabase db,
    $CompanyProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompanyProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompanyProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompanyProfilesTableAnnotationComposer($db: db, $table: table),
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
              }) => CompanyProfilesCompanion(
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
              }) => CompanyProfilesCompanion.insert(
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

typedef $$CompanyProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompanyProfilesTable,
      CompanyProfileRow,
      $$CompanyProfilesTableFilterComposer,
      $$CompanyProfilesTableOrderingComposer,
      $$CompanyProfilesTableAnnotationComposer,
      $$CompanyProfilesTableCreateCompanionBuilder,
      $$CompanyProfilesTableUpdateCompanionBuilder,
      (
        CompanyProfileRow,
        BaseReferences<_$AppDatabase, $CompanyProfilesTable, CompanyProfileRow>,
      ),
      CompanyProfileRow,
      PrefetchHooks Function()
    >;
typedef $$QuotesTableCreateCompanionBuilder =
    QuotesCompanion Function({
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
typedef $$QuotesTableUpdateCompanionBuilder =
    QuotesCompanion Function({
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

final class $$QuotesTableReferences
    extends BaseReferences<_$AppDatabase, $QuotesTable, QuoteRow> {
  $$QuotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $QuoteClientSnapshotsTable,
    List<QuoteClientSnapshotRow>
  >
  _quoteClientSnapshotsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.quoteClientSnapshots,
        aliasName: 'quotes__id__quote_client_snapshots__quote_id',
      );

  $$QuoteClientSnapshotsTableProcessedTableManager
  get quoteClientSnapshotsRefs {
    final manager = $$QuoteClientSnapshotsTableTableManager(
      $_db,
      $_db.quoteClientSnapshots,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _quoteClientSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $QuoteEventSnapshotsTable,
    List<QuoteEventSnapshotRow>
  >
  _quoteEventSnapshotsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.quoteEventSnapshots,
        aliasName: 'quotes__id__quote_event_snapshots__quote_id',
      );

  $$QuoteEventSnapshotsTableProcessedTableManager get quoteEventSnapshotsRefs {
    final manager = $$QuoteEventSnapshotsTableTableManager(
      $_db,
      $_db.quoteEventSnapshots,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _quoteEventSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $QuoteCompanySnapshotsTable,
    List<QuoteCompanySnapshotRow>
  >
  _quoteCompanySnapshotsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.quoteCompanySnapshots,
        aliasName: 'quotes__id__quote_company_snapshots__quote_id',
      );

  $$QuoteCompanySnapshotsTableProcessedTableManager
  get quoteCompanySnapshotsRefs {
    final manager = $$QuoteCompanySnapshotsTableTableManager(
      $_db,
      $_db.quoteCompanySnapshots,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _quoteCompanySnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuoteLineItemsTable, List<QuoteLineItemRow>>
  _quoteLineItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quoteLineItems,
    aliasName: 'quotes__id__quote_line_items__quote_id',
  );

  $$QuoteLineItemsTableProcessedTableManager get quoteLineItemsRefs {
    final manager = $$QuoteLineItemsTableTableManager(
      $_db,
      $_db.quoteLineItems,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quoteLineItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $QuoteStatusHistoryTable,
    List<QuoteStatusHistoryRow>
  >
  _quoteStatusHistoryRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.quoteStatusHistory,
        aliasName: 'quotes__id__quote_status_history__quote_id',
      );

  $$QuoteStatusHistoryTableProcessedTableManager get quoteStatusHistoryRefs {
    final manager = $$QuoteStatusHistoryTableTableManager(
      $_db,
      $_db.quoteStatusHistory,
    ).filter((f) => f.quoteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _quoteStatusHistoryRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuotesTableFilterComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableFilterComposer({
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

  Expression<bool> quoteClientSnapshotsRefs(
    Expression<bool> Function($$QuoteClientSnapshotsTableFilterComposer f) f,
  ) {
    final $$QuoteClientSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quoteClientSnapshots,
      getReferencedColumn: (t) => t.quoteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuoteClientSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.quoteClientSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quoteEventSnapshotsRefs(
    Expression<bool> Function($$QuoteEventSnapshotsTableFilterComposer f) f,
  ) {
    final $$QuoteEventSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quoteEventSnapshots,
      getReferencedColumn: (t) => t.quoteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuoteEventSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.quoteEventSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quoteCompanySnapshotsRefs(
    Expression<bool> Function($$QuoteCompanySnapshotsTableFilterComposer f) f,
  ) {
    final $$QuoteCompanySnapshotsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.quoteCompanySnapshots,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuoteCompanySnapshotsTableFilterComposer(
                $db: $db,
                $table: $db.quoteCompanySnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> quoteLineItemsRefs(
    Expression<bool> Function($$QuoteLineItemsTableFilterComposer f) f,
  ) {
    final $$QuoteLineItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quoteLineItems,
      getReferencedColumn: (t) => t.quoteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuoteLineItemsTableFilterComposer(
            $db: $db,
            $table: $db.quoteLineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quoteStatusHistoryRefs(
    Expression<bool> Function($$QuoteStatusHistoryTableFilterComposer f) f,
  ) {
    final $$QuoteStatusHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quoteStatusHistory,
      getReferencedColumn: (t) => t.quoteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuoteStatusHistoryTableFilterComposer(
            $db: $db,
            $table: $db.quoteStatusHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuotesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableOrderingComposer({
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

class $$QuotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableAnnotationComposer({
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

  Expression<T> quoteClientSnapshotsRefs<T extends Object>(
    Expression<T> Function($$QuoteClientSnapshotsTableAnnotationComposer a) f,
  ) {
    final $$QuoteClientSnapshotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.quoteClientSnapshots,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuoteClientSnapshotsTableAnnotationComposer(
                $db: $db,
                $table: $db.quoteClientSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> quoteEventSnapshotsRefs<T extends Object>(
    Expression<T> Function($$QuoteEventSnapshotsTableAnnotationComposer a) f,
  ) {
    final $$QuoteEventSnapshotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.quoteEventSnapshots,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuoteEventSnapshotsTableAnnotationComposer(
                $db: $db,
                $table: $db.quoteEventSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> quoteCompanySnapshotsRefs<T extends Object>(
    Expression<T> Function($$QuoteCompanySnapshotsTableAnnotationComposer a) f,
  ) {
    final $$QuoteCompanySnapshotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.quoteCompanySnapshots,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuoteCompanySnapshotsTableAnnotationComposer(
                $db: $db,
                $table: $db.quoteCompanySnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> quoteLineItemsRefs<T extends Object>(
    Expression<T> Function($$QuoteLineItemsTableAnnotationComposer a) f,
  ) {
    final $$QuoteLineItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quoteLineItems,
      getReferencedColumn: (t) => t.quoteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuoteLineItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.quoteLineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quoteStatusHistoryRefs<T extends Object>(
    Expression<T> Function($$QuoteStatusHistoryTableAnnotationComposer a) f,
  ) {
    final $$QuoteStatusHistoryTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.quoteStatusHistory,
          getReferencedColumn: (t) => t.quoteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuoteStatusHistoryTableAnnotationComposer(
                $db: $db,
                $table: $db.quoteStatusHistory,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$QuotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuotesTable,
          QuoteRow,
          $$QuotesTableFilterComposer,
          $$QuotesTableOrderingComposer,
          $$QuotesTableAnnotationComposer,
          $$QuotesTableCreateCompanionBuilder,
          $$QuotesTableUpdateCompanionBuilder,
          (QuoteRow, $$QuotesTableReferences),
          QuoteRow,
          PrefetchHooks Function({
            bool quoteClientSnapshotsRefs,
            bool quoteEventSnapshotsRefs,
            bool quoteCompanySnapshotsRefs,
            bool quoteLineItemsRefs,
            bool quoteStatusHistoryRefs,
          })
        > {
  $$QuotesTableTableManager(_$AppDatabase db, $QuotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuotesTableAnnotationComposer($db: db, $table: table),
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
              }) => QuotesCompanion(
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
              }) => QuotesCompanion.insert(
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
                (e) =>
                    (e.readTable(table), $$QuotesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                quoteClientSnapshotsRefs = false,
                quoteEventSnapshotsRefs = false,
                quoteCompanySnapshotsRefs = false,
                quoteLineItemsRefs = false,
                quoteStatusHistoryRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (quoteClientSnapshotsRefs) db.quoteClientSnapshots,
                    if (quoteEventSnapshotsRefs) db.quoteEventSnapshots,
                    if (quoteCompanySnapshotsRefs) db.quoteCompanySnapshots,
                    if (quoteLineItemsRefs) db.quoteLineItems,
                    if (quoteStatusHistoryRefs) db.quoteStatusHistory,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (quoteClientSnapshotsRefs)
                        await $_getPrefetchedData<
                          QuoteRow,
                          $QuotesTable,
                          QuoteClientSnapshotRow
                        >(
                          currentTable: table,
                          referencedTable: $$QuotesTableReferences
                              ._quoteClientSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).quoteClientSnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quoteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quoteEventSnapshotsRefs)
                        await $_getPrefetchedData<
                          QuoteRow,
                          $QuotesTable,
                          QuoteEventSnapshotRow
                        >(
                          currentTable: table,
                          referencedTable: $$QuotesTableReferences
                              ._quoteEventSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).quoteEventSnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quoteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quoteCompanySnapshotsRefs)
                        await $_getPrefetchedData<
                          QuoteRow,
                          $QuotesTable,
                          QuoteCompanySnapshotRow
                        >(
                          currentTable: table,
                          referencedTable: $$QuotesTableReferences
                              ._quoteCompanySnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).quoteCompanySnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quoteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quoteLineItemsRefs)
                        await $_getPrefetchedData<
                          QuoteRow,
                          $QuotesTable,
                          QuoteLineItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$QuotesTableReferences
                              ._quoteLineItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).quoteLineItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quoteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quoteStatusHistoryRefs)
                        await $_getPrefetchedData<
                          QuoteRow,
                          $QuotesTable,
                          QuoteStatusHistoryRow
                        >(
                          currentTable: table,
                          referencedTable: $$QuotesTableReferences
                              ._quoteStatusHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuotesTableReferences(
                                db,
                                table,
                                p0,
                              ).quoteStatusHistoryRefs,
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

typedef $$QuotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuotesTable,
      QuoteRow,
      $$QuotesTableFilterComposer,
      $$QuotesTableOrderingComposer,
      $$QuotesTableAnnotationComposer,
      $$QuotesTableCreateCompanionBuilder,
      $$QuotesTableUpdateCompanionBuilder,
      (QuoteRow, $$QuotesTableReferences),
      QuoteRow,
      PrefetchHooks Function({
        bool quoteClientSnapshotsRefs,
        bool quoteEventSnapshotsRefs,
        bool quoteCompanySnapshotsRefs,
        bool quoteLineItemsRefs,
        bool quoteStatusHistoryRefs,
      })
    >;
typedef $$QuoteClientSnapshotsTableCreateCompanionBuilder =
    QuoteClientSnapshotsCompanion Function({
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
typedef $$QuoteClientSnapshotsTableUpdateCompanionBuilder =
    QuoteClientSnapshotsCompanion Function({
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

final class $$QuoteClientSnapshotsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $QuoteClientSnapshotsTable,
          QuoteClientSnapshotRow
        > {
  $$QuoteClientSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuotesTable _quoteIdTable(_$AppDatabase db) =>
      db.quotes.createAlias('quote_client_snapshots__quote_id__quotes__id');

  $$QuotesTableProcessedTableManager get quoteId {
    final $_column = $_itemColumn<String>('quote_id')!;

    final manager = $$QuotesTableTableManager(
      $_db,
      $_db.quotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuoteClientSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $QuoteClientSnapshotsTable> {
  $$QuoteClientSnapshotsTableFilterComposer({
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

  $$QuotesTableFilterComposer get quoteId {
    final $$QuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableFilterComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteClientSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuoteClientSnapshotsTable> {
  $$QuoteClientSnapshotsTableOrderingComposer({
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

  $$QuotesTableOrderingComposer get quoteId {
    final $$QuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableOrderingComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteClientSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuoteClientSnapshotsTable> {
  $$QuoteClientSnapshotsTableAnnotationComposer({
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

  $$QuotesTableAnnotationComposer get quoteId {
    final $$QuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteClientSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuoteClientSnapshotsTable,
          QuoteClientSnapshotRow,
          $$QuoteClientSnapshotsTableFilterComposer,
          $$QuoteClientSnapshotsTableOrderingComposer,
          $$QuoteClientSnapshotsTableAnnotationComposer,
          $$QuoteClientSnapshotsTableCreateCompanionBuilder,
          $$QuoteClientSnapshotsTableUpdateCompanionBuilder,
          (QuoteClientSnapshotRow, $$QuoteClientSnapshotsTableReferences),
          QuoteClientSnapshotRow,
          PrefetchHooks Function({bool quoteId})
        > {
  $$QuoteClientSnapshotsTableTableManager(
    _$AppDatabase db,
    $QuoteClientSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuoteClientSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuoteClientSnapshotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$QuoteClientSnapshotsTableAnnotationComposer(
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
              }) => QuoteClientSnapshotsCompanion(
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
              }) => QuoteClientSnapshotsCompanion.insert(
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
                  $$QuoteClientSnapshotsTableReferences(db, table, e),
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
                                    $$QuoteClientSnapshotsTableReferences
                                        ._quoteIdTable(db),
                                referencedColumn:
                                    $$QuoteClientSnapshotsTableReferences
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

typedef $$QuoteClientSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuoteClientSnapshotsTable,
      QuoteClientSnapshotRow,
      $$QuoteClientSnapshotsTableFilterComposer,
      $$QuoteClientSnapshotsTableOrderingComposer,
      $$QuoteClientSnapshotsTableAnnotationComposer,
      $$QuoteClientSnapshotsTableCreateCompanionBuilder,
      $$QuoteClientSnapshotsTableUpdateCompanionBuilder,
      (QuoteClientSnapshotRow, $$QuoteClientSnapshotsTableReferences),
      QuoteClientSnapshotRow,
      PrefetchHooks Function({bool quoteId})
    >;
typedef $$QuoteEventSnapshotsTableCreateCompanionBuilder =
    QuoteEventSnapshotsCompanion Function({
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
typedef $$QuoteEventSnapshotsTableUpdateCompanionBuilder =
    QuoteEventSnapshotsCompanion Function({
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

final class $$QuoteEventSnapshotsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $QuoteEventSnapshotsTable,
          QuoteEventSnapshotRow
        > {
  $$QuoteEventSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuotesTable _quoteIdTable(_$AppDatabase db) =>
      db.quotes.createAlias('quote_event_snapshots__quote_id__quotes__id');

  $$QuotesTableProcessedTableManager get quoteId {
    final $_column = $_itemColumn<String>('quote_id')!;

    final manager = $$QuotesTableTableManager(
      $_db,
      $_db.quotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuoteEventSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $QuoteEventSnapshotsTable> {
  $$QuoteEventSnapshotsTableFilterComposer({
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

  $$QuotesTableFilterComposer get quoteId {
    final $$QuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableFilterComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteEventSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuoteEventSnapshotsTable> {
  $$QuoteEventSnapshotsTableOrderingComposer({
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

  $$QuotesTableOrderingComposer get quoteId {
    final $$QuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableOrderingComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteEventSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuoteEventSnapshotsTable> {
  $$QuoteEventSnapshotsTableAnnotationComposer({
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

  $$QuotesTableAnnotationComposer get quoteId {
    final $$QuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteEventSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuoteEventSnapshotsTable,
          QuoteEventSnapshotRow,
          $$QuoteEventSnapshotsTableFilterComposer,
          $$QuoteEventSnapshotsTableOrderingComposer,
          $$QuoteEventSnapshotsTableAnnotationComposer,
          $$QuoteEventSnapshotsTableCreateCompanionBuilder,
          $$QuoteEventSnapshotsTableUpdateCompanionBuilder,
          (QuoteEventSnapshotRow, $$QuoteEventSnapshotsTableReferences),
          QuoteEventSnapshotRow,
          PrefetchHooks Function({bool quoteId})
        > {
  $$QuoteEventSnapshotsTableTableManager(
    _$AppDatabase db,
    $QuoteEventSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuoteEventSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuoteEventSnapshotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$QuoteEventSnapshotsTableAnnotationComposer(
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
              }) => QuoteEventSnapshotsCompanion(
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
              }) => QuoteEventSnapshotsCompanion.insert(
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
                  $$QuoteEventSnapshotsTableReferences(db, table, e),
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
                                    $$QuoteEventSnapshotsTableReferences
                                        ._quoteIdTable(db),
                                referencedColumn:
                                    $$QuoteEventSnapshotsTableReferences
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

typedef $$QuoteEventSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuoteEventSnapshotsTable,
      QuoteEventSnapshotRow,
      $$QuoteEventSnapshotsTableFilterComposer,
      $$QuoteEventSnapshotsTableOrderingComposer,
      $$QuoteEventSnapshotsTableAnnotationComposer,
      $$QuoteEventSnapshotsTableCreateCompanionBuilder,
      $$QuoteEventSnapshotsTableUpdateCompanionBuilder,
      (QuoteEventSnapshotRow, $$QuoteEventSnapshotsTableReferences),
      QuoteEventSnapshotRow,
      PrefetchHooks Function({bool quoteId})
    >;
typedef $$QuoteCompanySnapshotsTableCreateCompanionBuilder =
    QuoteCompanySnapshotsCompanion Function({
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
typedef $$QuoteCompanySnapshotsTableUpdateCompanionBuilder =
    QuoteCompanySnapshotsCompanion Function({
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

final class $$QuoteCompanySnapshotsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $QuoteCompanySnapshotsTable,
          QuoteCompanySnapshotRow
        > {
  $$QuoteCompanySnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuotesTable _quoteIdTable(_$AppDatabase db) =>
      db.quotes.createAlias('quote_company_snapshots__quote_id__quotes__id');

  $$QuotesTableProcessedTableManager get quoteId {
    final $_column = $_itemColumn<String>('quote_id')!;

    final manager = $$QuotesTableTableManager(
      $_db,
      $_db.quotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuoteCompanySnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $QuoteCompanySnapshotsTable> {
  $$QuoteCompanySnapshotsTableFilterComposer({
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

  $$QuotesTableFilterComposer get quoteId {
    final $$QuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableFilterComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteCompanySnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuoteCompanySnapshotsTable> {
  $$QuoteCompanySnapshotsTableOrderingComposer({
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

  $$QuotesTableOrderingComposer get quoteId {
    final $$QuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableOrderingComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteCompanySnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuoteCompanySnapshotsTable> {
  $$QuoteCompanySnapshotsTableAnnotationComposer({
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

  $$QuotesTableAnnotationComposer get quoteId {
    final $$QuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteCompanySnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuoteCompanySnapshotsTable,
          QuoteCompanySnapshotRow,
          $$QuoteCompanySnapshotsTableFilterComposer,
          $$QuoteCompanySnapshotsTableOrderingComposer,
          $$QuoteCompanySnapshotsTableAnnotationComposer,
          $$QuoteCompanySnapshotsTableCreateCompanionBuilder,
          $$QuoteCompanySnapshotsTableUpdateCompanionBuilder,
          (QuoteCompanySnapshotRow, $$QuoteCompanySnapshotsTableReferences),
          QuoteCompanySnapshotRow,
          PrefetchHooks Function({bool quoteId})
        > {
  $$QuoteCompanySnapshotsTableTableManager(
    _$AppDatabase db,
    $QuoteCompanySnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuoteCompanySnapshotsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$QuoteCompanySnapshotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$QuoteCompanySnapshotsTableAnnotationComposer(
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
              }) => QuoteCompanySnapshotsCompanion(
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
              }) => QuoteCompanySnapshotsCompanion.insert(
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
                  $$QuoteCompanySnapshotsTableReferences(db, table, e),
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
                                    $$QuoteCompanySnapshotsTableReferences
                                        ._quoteIdTable(db),
                                referencedColumn:
                                    $$QuoteCompanySnapshotsTableReferences
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

typedef $$QuoteCompanySnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuoteCompanySnapshotsTable,
      QuoteCompanySnapshotRow,
      $$QuoteCompanySnapshotsTableFilterComposer,
      $$QuoteCompanySnapshotsTableOrderingComposer,
      $$QuoteCompanySnapshotsTableAnnotationComposer,
      $$QuoteCompanySnapshotsTableCreateCompanionBuilder,
      $$QuoteCompanySnapshotsTableUpdateCompanionBuilder,
      (QuoteCompanySnapshotRow, $$QuoteCompanySnapshotsTableReferences),
      QuoteCompanySnapshotRow,
      PrefetchHooks Function({bool quoteId})
    >;
typedef $$QuoteLineItemsTableCreateCompanionBuilder =
    QuoteLineItemsCompanion Function({
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
typedef $$QuoteLineItemsTableUpdateCompanionBuilder =
    QuoteLineItemsCompanion Function({
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

final class $$QuoteLineItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $QuoteLineItemsTable, QuoteLineItemRow> {
  $$QuoteLineItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuotesTable _quoteIdTable(_$AppDatabase db) =>
      db.quotes.createAlias('quote_line_items__quote_id__quotes__id');

  $$QuotesTableProcessedTableManager get quoteId {
    final $_column = $_itemColumn<String>('quote_id')!;

    final manager = $$QuotesTableTableManager(
      $_db,
      $_db.quotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $QuoteLinePackageComponentsTable,
    List<QuoteLinePackageComponentRow>
  >
  _quoteLinePackageComponentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.quoteLinePackageComponents,
        aliasName:
            'quote_line_items__id__quote_line_package_components__line_item_id',
      );

  $$QuoteLinePackageComponentsTableProcessedTableManager
  get quoteLinePackageComponentsRefs {
    final manager = $$QuoteLinePackageComponentsTableTableManager(
      $_db,
      $_db.quoteLinePackageComponents,
    ).filter((f) => f.lineItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _quoteLinePackageComponentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuoteLineItemsTableFilterComposer
    extends Composer<_$AppDatabase, $QuoteLineItemsTable> {
  $$QuoteLineItemsTableFilterComposer({
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

  $$QuotesTableFilterComposer get quoteId {
    final $$QuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableFilterComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> quoteLinePackageComponentsRefs(
    Expression<bool> Function($$QuoteLinePackageComponentsTableFilterComposer f)
    f,
  ) {
    final $$QuoteLinePackageComponentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.quoteLinePackageComponents,
          getReferencedColumn: (t) => t.lineItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuoteLinePackageComponentsTableFilterComposer(
                $db: $db,
                $table: $db.quoteLinePackageComponents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$QuoteLineItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuoteLineItemsTable> {
  $$QuoteLineItemsTableOrderingComposer({
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

  $$QuotesTableOrderingComposer get quoteId {
    final $$QuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableOrderingComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteLineItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuoteLineItemsTable> {
  $$QuoteLineItemsTableAnnotationComposer({
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

  $$QuotesTableAnnotationComposer get quoteId {
    final $$QuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> quoteLinePackageComponentsRefs<T extends Object>(
    Expression<T> Function(
      $$QuoteLinePackageComponentsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$QuoteLinePackageComponentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.quoteLinePackageComponents,
          getReferencedColumn: (t) => t.lineItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuoteLinePackageComponentsTableAnnotationComposer(
                $db: $db,
                $table: $db.quoteLinePackageComponents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$QuoteLineItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuoteLineItemsTable,
          QuoteLineItemRow,
          $$QuoteLineItemsTableFilterComposer,
          $$QuoteLineItemsTableOrderingComposer,
          $$QuoteLineItemsTableAnnotationComposer,
          $$QuoteLineItemsTableCreateCompanionBuilder,
          $$QuoteLineItemsTableUpdateCompanionBuilder,
          (QuoteLineItemRow, $$QuoteLineItemsTableReferences),
          QuoteLineItemRow,
          PrefetchHooks Function({
            bool quoteId,
            bool quoteLinePackageComponentsRefs,
          })
        > {
  $$QuoteLineItemsTableTableManager(
    _$AppDatabase db,
    $QuoteLineItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuoteLineItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuoteLineItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuoteLineItemsTableAnnotationComposer($db: db, $table: table),
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
              }) => QuoteLineItemsCompanion(
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
              }) => QuoteLineItemsCompanion.insert(
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
                  $$QuoteLineItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({quoteId = false, quoteLinePackageComponentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (quoteLinePackageComponentsRefs)
                      db.quoteLinePackageComponents,
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
                                        $$QuoteLineItemsTableReferences
                                            ._quoteIdTable(db),
                                    referencedColumn:
                                        $$QuoteLineItemsTableReferences
                                            ._quoteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (quoteLinePackageComponentsRefs)
                        await $_getPrefetchedData<
                          QuoteLineItemRow,
                          $QuoteLineItemsTable,
                          QuoteLinePackageComponentRow
                        >(
                          currentTable: table,
                          referencedTable: $$QuoteLineItemsTableReferences
                              ._quoteLinePackageComponentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuoteLineItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).quoteLinePackageComponentsRefs,
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

typedef $$QuoteLineItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuoteLineItemsTable,
      QuoteLineItemRow,
      $$QuoteLineItemsTableFilterComposer,
      $$QuoteLineItemsTableOrderingComposer,
      $$QuoteLineItemsTableAnnotationComposer,
      $$QuoteLineItemsTableCreateCompanionBuilder,
      $$QuoteLineItemsTableUpdateCompanionBuilder,
      (QuoteLineItemRow, $$QuoteLineItemsTableReferences),
      QuoteLineItemRow,
      PrefetchHooks Function({
        bool quoteId,
        bool quoteLinePackageComponentsRefs,
      })
    >;
typedef $$QuoteLinePackageComponentsTableCreateCompanionBuilder =
    QuoteLinePackageComponentsCompanion Function({
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
typedef $$QuoteLinePackageComponentsTableUpdateCompanionBuilder =
    QuoteLinePackageComponentsCompanion Function({
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

final class $$QuoteLinePackageComponentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $QuoteLinePackageComponentsTable,
          QuoteLinePackageComponentRow
        > {
  $$QuoteLinePackageComponentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuoteLineItemsTable _lineItemIdTable(_$AppDatabase db) =>
      db.quoteLineItems.createAlias(
        'quote_line_package_components__line_item_id__quote_line_items__id',
      );

  $$QuoteLineItemsTableProcessedTableManager get lineItemId {
    final $_column = $_itemColumn<String>('line_item_id')!;

    final manager = $$QuoteLineItemsTableTableManager(
      $_db,
      $_db.quoteLineItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lineItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuoteLinePackageComponentsTableFilterComposer
    extends Composer<_$AppDatabase, $QuoteLinePackageComponentsTable> {
  $$QuoteLinePackageComponentsTableFilterComposer({
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

  $$QuoteLineItemsTableFilterComposer get lineItemId {
    final $$QuoteLineItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lineItemId,
      referencedTable: $db.quoteLineItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuoteLineItemsTableFilterComposer(
            $db: $db,
            $table: $db.quoteLineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteLinePackageComponentsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuoteLinePackageComponentsTable> {
  $$QuoteLinePackageComponentsTableOrderingComposer({
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

  $$QuoteLineItemsTableOrderingComposer get lineItemId {
    final $$QuoteLineItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lineItemId,
      referencedTable: $db.quoteLineItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuoteLineItemsTableOrderingComposer(
            $db: $db,
            $table: $db.quoteLineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteLinePackageComponentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuoteLinePackageComponentsTable> {
  $$QuoteLinePackageComponentsTableAnnotationComposer({
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

  $$QuoteLineItemsTableAnnotationComposer get lineItemId {
    final $$QuoteLineItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lineItemId,
      referencedTable: $db.quoteLineItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuoteLineItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.quoteLineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteLinePackageComponentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuoteLinePackageComponentsTable,
          QuoteLinePackageComponentRow,
          $$QuoteLinePackageComponentsTableFilterComposer,
          $$QuoteLinePackageComponentsTableOrderingComposer,
          $$QuoteLinePackageComponentsTableAnnotationComposer,
          $$QuoteLinePackageComponentsTableCreateCompanionBuilder,
          $$QuoteLinePackageComponentsTableUpdateCompanionBuilder,
          (
            QuoteLinePackageComponentRow,
            $$QuoteLinePackageComponentsTableReferences,
          ),
          QuoteLinePackageComponentRow,
          PrefetchHooks Function({bool lineItemId})
        > {
  $$QuoteLinePackageComponentsTableTableManager(
    _$AppDatabase db,
    $QuoteLinePackageComponentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuoteLinePackageComponentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$QuoteLinePackageComponentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$QuoteLinePackageComponentsTableAnnotationComposer(
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
              }) => QuoteLinePackageComponentsCompanion(
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
              }) => QuoteLinePackageComponentsCompanion.insert(
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
                  $$QuoteLinePackageComponentsTableReferences(db, table, e),
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
                                    $$QuoteLinePackageComponentsTableReferences
                                        ._lineItemIdTable(db),
                                referencedColumn:
                                    $$QuoteLinePackageComponentsTableReferences
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

typedef $$QuoteLinePackageComponentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuoteLinePackageComponentsTable,
      QuoteLinePackageComponentRow,
      $$QuoteLinePackageComponentsTableFilterComposer,
      $$QuoteLinePackageComponentsTableOrderingComposer,
      $$QuoteLinePackageComponentsTableAnnotationComposer,
      $$QuoteLinePackageComponentsTableCreateCompanionBuilder,
      $$QuoteLinePackageComponentsTableUpdateCompanionBuilder,
      (
        QuoteLinePackageComponentRow,
        $$QuoteLinePackageComponentsTableReferences,
      ),
      QuoteLinePackageComponentRow,
      PrefetchHooks Function({bool lineItemId})
    >;
typedef $$QuoteStatusHistoryTableCreateCompanionBuilder =
    QuoteStatusHistoryCompanion Function({
      required String id,
      required String quoteId,
      required int sortOrder,
      Value<String?> previousStatus,
      required String newStatus,
      required int changedAt,
      Value<int> rowid,
    });
typedef $$QuoteStatusHistoryTableUpdateCompanionBuilder =
    QuoteStatusHistoryCompanion Function({
      Value<String> id,
      Value<String> quoteId,
      Value<int> sortOrder,
      Value<String?> previousStatus,
      Value<String> newStatus,
      Value<int> changedAt,
      Value<int> rowid,
    });

final class $$QuoteStatusHistoryTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $QuoteStatusHistoryTable,
          QuoteStatusHistoryRow
        > {
  $$QuoteStatusHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuotesTable _quoteIdTable(_$AppDatabase db) =>
      db.quotes.createAlias('quote_status_history__quote_id__quotes__id');

  $$QuotesTableProcessedTableManager get quoteId {
    final $_column = $_itemColumn<String>('quote_id')!;

    final manager = $$QuotesTableTableManager(
      $_db,
      $_db.quotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuoteStatusHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $QuoteStatusHistoryTable> {
  $$QuoteStatusHistoryTableFilterComposer({
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

  $$QuotesTableFilterComposer get quoteId {
    final $$QuotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableFilterComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteStatusHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $QuoteStatusHistoryTable> {
  $$QuoteStatusHistoryTableOrderingComposer({
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

  $$QuotesTableOrderingComposer get quoteId {
    final $$QuotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableOrderingComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteStatusHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuoteStatusHistoryTable> {
  $$QuoteStatusHistoryTableAnnotationComposer({
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

  $$QuotesTableAnnotationComposer get quoteId {
    final $$QuotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quoteId,
      referencedTable: $db.quotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotesTableAnnotationComposer(
            $db: $db,
            $table: $db.quotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuoteStatusHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuoteStatusHistoryTable,
          QuoteStatusHistoryRow,
          $$QuoteStatusHistoryTableFilterComposer,
          $$QuoteStatusHistoryTableOrderingComposer,
          $$QuoteStatusHistoryTableAnnotationComposer,
          $$QuoteStatusHistoryTableCreateCompanionBuilder,
          $$QuoteStatusHistoryTableUpdateCompanionBuilder,
          (QuoteStatusHistoryRow, $$QuoteStatusHistoryTableReferences),
          QuoteStatusHistoryRow,
          PrefetchHooks Function({bool quoteId})
        > {
  $$QuoteStatusHistoryTableTableManager(
    _$AppDatabase db,
    $QuoteStatusHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuoteStatusHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuoteStatusHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuoteStatusHistoryTableAnnotationComposer(
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
              }) => QuoteStatusHistoryCompanion(
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
              }) => QuoteStatusHistoryCompanion.insert(
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
                  $$QuoteStatusHistoryTableReferences(db, table, e),
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
                                    $$QuoteStatusHistoryTableReferences
                                        ._quoteIdTable(db),
                                referencedColumn:
                                    $$QuoteStatusHistoryTableReferences
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

typedef $$QuoteStatusHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuoteStatusHistoryTable,
      QuoteStatusHistoryRow,
      $$QuoteStatusHistoryTableFilterComposer,
      $$QuoteStatusHistoryTableOrderingComposer,
      $$QuoteStatusHistoryTableAnnotationComposer,
      $$QuoteStatusHistoryTableCreateCompanionBuilder,
      $$QuoteStatusHistoryTableUpdateCompanionBuilder,
      (QuoteStatusHistoryRow, $$QuoteStatusHistoryTableReferences),
      QuoteStatusHistoryRow,
      PrefetchHooks Function({bool quoteId})
    >;
typedef $$QuoteNumberSequencesTableCreateCompanionBuilder =
    QuoteNumberSequencesCompanion Function({
      Value<int> year,
      required int lastSequence,
    });
typedef $$QuoteNumberSequencesTableUpdateCompanionBuilder =
    QuoteNumberSequencesCompanion Function({
      Value<int> year,
      Value<int> lastSequence,
    });

class $$QuoteNumberSequencesTableFilterComposer
    extends Composer<_$AppDatabase, $QuoteNumberSequencesTable> {
  $$QuoteNumberSequencesTableFilterComposer({
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

class $$QuoteNumberSequencesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuoteNumberSequencesTable> {
  $$QuoteNumberSequencesTableOrderingComposer({
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

class $$QuoteNumberSequencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuoteNumberSequencesTable> {
  $$QuoteNumberSequencesTableAnnotationComposer({
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

class $$QuoteNumberSequencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuoteNumberSequencesTable,
          QuoteNumberSequenceRow,
          $$QuoteNumberSequencesTableFilterComposer,
          $$QuoteNumberSequencesTableOrderingComposer,
          $$QuoteNumberSequencesTableAnnotationComposer,
          $$QuoteNumberSequencesTableCreateCompanionBuilder,
          $$QuoteNumberSequencesTableUpdateCompanionBuilder,
          (
            QuoteNumberSequenceRow,
            BaseReferences<
              _$AppDatabase,
              $QuoteNumberSequencesTable,
              QuoteNumberSequenceRow
            >,
          ),
          QuoteNumberSequenceRow,
          PrefetchHooks Function()
        > {
  $$QuoteNumberSequencesTableTableManager(
    _$AppDatabase db,
    $QuoteNumberSequencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuoteNumberSequencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuoteNumberSequencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$QuoteNumberSequencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> year = const Value.absent(),
                Value<int> lastSequence = const Value.absent(),
              }) => QuoteNumberSequencesCompanion(
                year: year,
                lastSequence: lastSequence,
              ),
          createCompanionCallback:
              ({
                Value<int> year = const Value.absent(),
                required int lastSequence,
              }) => QuoteNumberSequencesCompanion.insert(
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

typedef $$QuoteNumberSequencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuoteNumberSequencesTable,
      QuoteNumberSequenceRow,
      $$QuoteNumberSequencesTableFilterComposer,
      $$QuoteNumberSequencesTableOrderingComposer,
      $$QuoteNumberSequencesTableAnnotationComposer,
      $$QuoteNumberSequencesTableCreateCompanionBuilder,
      $$QuoteNumberSequencesTableUpdateCompanionBuilder,
      (
        QuoteNumberSequenceRow,
        BaseReferences<
          _$AppDatabase,
          $QuoteNumberSequencesTable,
          QuoteNumberSequenceRow
        >,
      ),
      QuoteNumberSequenceRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$CatalogItemsTableTableManager get catalogItems =>
      $$CatalogItemsTableTableManager(_db, _db.catalogItems);
  $$CatalogPackageComponentsTableTableManager get catalogPackageComponents =>
      $$CatalogPackageComponentsTableTableManager(
        _db,
        _db.catalogPackageComponents,
      );
  $$CompanyProfilesTableTableManager get companyProfiles =>
      $$CompanyProfilesTableTableManager(_db, _db.companyProfiles);
  $$QuotesTableTableManager get quotes =>
      $$QuotesTableTableManager(_db, _db.quotes);
  $$QuoteClientSnapshotsTableTableManager get quoteClientSnapshots =>
      $$QuoteClientSnapshotsTableTableManager(_db, _db.quoteClientSnapshots);
  $$QuoteEventSnapshotsTableTableManager get quoteEventSnapshots =>
      $$QuoteEventSnapshotsTableTableManager(_db, _db.quoteEventSnapshots);
  $$QuoteCompanySnapshotsTableTableManager get quoteCompanySnapshots =>
      $$QuoteCompanySnapshotsTableTableManager(_db, _db.quoteCompanySnapshots);
  $$QuoteLineItemsTableTableManager get quoteLineItems =>
      $$QuoteLineItemsTableTableManager(_db, _db.quoteLineItems);
  $$QuoteLinePackageComponentsTableTableManager
  get quoteLinePackageComponents =>
      $$QuoteLinePackageComponentsTableTableManager(
        _db,
        _db.quoteLinePackageComponents,
      );
  $$QuoteStatusHistoryTableTableManager get quoteStatusHistory =>
      $$QuoteStatusHistoryTableTableManager(_db, _db.quoteStatusHistory);
  $$QuoteNumberSequencesTableTableManager get quoteNumberSequences =>
      $$QuoteNumberSequencesTableTableManager(_db, _db.quoteNumberSequences);
}
