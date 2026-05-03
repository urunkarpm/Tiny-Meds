// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MedicineInventoryTable extends MedicineInventory
    with TableInfo<$MedicineInventoryTable, MedicineInventoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicineInventoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<MedicineForm, String> form =
      GeneratedColumn<String>('form', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<MedicineForm>($MedicineInventoryTable.$converterform);
  static const VerificationMeta _strengthMeta =
      const VerificationMeta('strength');
  @override
  late final GeneratedColumn<String> strength = GeneratedColumn<String>(
      'strength', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _openedDateMeta =
      const VerificationMeta('openedDate');
  @override
  late final GeneratedColumn<DateTime> openedDate = GeneratedColumn<DateTime>(
      'opened_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _lowStockThresholdMeta =
      const VerificationMeta('lowStockThreshold');
  @override
  late final GeneratedColumn<int> lowStockThreshold = GeneratedColumn<int>(
      'low_stock_threshold', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isDisposedMeta =
      const VerificationMeta('isDisposed');
  @override
  late final GeneratedColumn<bool> isDisposed = GeneratedColumn<bool>(
      'is_disposed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_disposed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        brand,
        form,
        strength,
        quantity,
        unit,
        expiryDate,
        openedDate,
        location,
        lowStockThreshold,
        isDisposed,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicine_inventory';
  @override
  VerificationContext validateIntegrity(
      Insertable<MedicineInventoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('strength')) {
      context.handle(_strengthMeta,
          strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    } else if (isInserting) {
      context.missing(_expiryDateMeta);
    }
    if (data.containsKey('opened_date')) {
      context.handle(
          _openedDateMeta,
          openedDate.isAcceptableOrUnknown(
              data['opened_date']!, _openedDateMeta));
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    }
    if (data.containsKey('low_stock_threshold')) {
      context.handle(
          _lowStockThresholdMeta,
          lowStockThreshold.isAcceptableOrUnknown(
              data['low_stock_threshold']!, _lowStockThresholdMeta));
    }
    if (data.containsKey('is_disposed')) {
      context.handle(
          _isDisposedMeta,
          isDisposed.isAcceptableOrUnknown(
              data['is_disposed']!, _isDisposedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicineInventoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicineInventoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand']),
      form: $MedicineInventoryTable.$converterform.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}form'])!),
      strength: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}strength']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date'])!,
      openedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}opened_date']),
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      lowStockThreshold: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}low_stock_threshold']),
      isDisposed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_disposed'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MedicineInventoryTable createAlias(String alias) {
    return $MedicineInventoryTable(attachedDatabase, alias);
  }

  static TypeConverter<MedicineForm, String> $converterform =
      MedicineFormConverter();
}

class MedicineInventoryData extends DataClass
    implements Insertable<MedicineInventoryData> {
  /// Primary key, auto-increment
  final int id;

  /// Medicine name (required)
  final String name;

  /// Brand name (optional)
  final String? brand;

  /// Medicine form: liquid, tablet, cream, inhaler, other (required)
  final MedicineForm form;

  /// Strength (optional, e.g., "500mg", "10%")
  final String? strength;

  /// Quantity available (required)
  final int quantity;

  /// Unit of measurement (required, e.g., mL, mg, tablets)
  final String unit;

  /// Expiry date (required)
  final DateTime expiryDate;

  /// Date when the item was opened (optional, for post-open shelf life)
  final DateTime? openedDate;

  /// Storage location (optional, e.g., "Bathroom cabinet", "Diaper bag")
  final String? location;

  /// Low stock threshold for alerts (optional)
  final int? lowStockThreshold;

  /// Whether the item has been disposed
  final bool isDisposed;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;
  const MedicineInventoryData(
      {required this.id,
      required this.name,
      this.brand,
      required this.form,
      this.strength,
      required this.quantity,
      required this.unit,
      required this.expiryDate,
      this.openedDate,
      this.location,
      this.lowStockThreshold,
      required this.isDisposed,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    {
      map['form'] =
          Variable<String>($MedicineInventoryTable.$converterform.toSql(form));
    }
    if (!nullToAbsent || strength != null) {
      map['strength'] = Variable<String>(strength);
    }
    map['quantity'] = Variable<int>(quantity);
    map['unit'] = Variable<String>(unit);
    map['expiry_date'] = Variable<DateTime>(expiryDate);
    if (!nullToAbsent || openedDate != null) {
      map['opened_date'] = Variable<DateTime>(openedDate);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || lowStockThreshold != null) {
      map['low_stock_threshold'] = Variable<int>(lowStockThreshold);
    }
    map['is_disposed'] = Variable<bool>(isDisposed);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicineInventoryCompanion toCompanion(bool nullToAbsent) {
    return MedicineInventoryCompanion(
      id: Value(id),
      name: Value(name),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      form: Value(form),
      strength: strength == null && nullToAbsent
          ? const Value.absent()
          : Value(strength),
      quantity: Value(quantity),
      unit: Value(unit),
      expiryDate: Value(expiryDate),
      openedDate: openedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(openedDate),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      lowStockThreshold: lowStockThreshold == null && nullToAbsent
          ? const Value.absent()
          : Value(lowStockThreshold),
      isDisposed: Value(isDisposed),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicineInventoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicineInventoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      form: serializer.fromJson<MedicineForm>(json['form']),
      strength: serializer.fromJson<String?>(json['strength']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      expiryDate: serializer.fromJson<DateTime>(json['expiryDate']),
      openedDate: serializer.fromJson<DateTime?>(json['openedDate']),
      location: serializer.fromJson<String?>(json['location']),
      lowStockThreshold: serializer.fromJson<int?>(json['lowStockThreshold']),
      isDisposed: serializer.fromJson<bool>(json['isDisposed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'form': serializer.toJson<MedicineForm>(form),
      'strength': serializer.toJson<String?>(strength),
      'quantity': serializer.toJson<int>(quantity),
      'unit': serializer.toJson<String>(unit),
      'expiryDate': serializer.toJson<DateTime>(expiryDate),
      'openedDate': serializer.toJson<DateTime?>(openedDate),
      'location': serializer.toJson<String?>(location),
      'lowStockThreshold': serializer.toJson<int?>(lowStockThreshold),
      'isDisposed': serializer.toJson<bool>(isDisposed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MedicineInventoryData copyWith(
          {int? id,
          String? name,
          Value<String?> brand = const Value.absent(),
          MedicineForm? form,
          Value<String?> strength = const Value.absent(),
          int? quantity,
          String? unit,
          DateTime? expiryDate,
          Value<DateTime?> openedDate = const Value.absent(),
          Value<String?> location = const Value.absent(),
          Value<int?> lowStockThreshold = const Value.absent(),
          bool? isDisposed,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MedicineInventoryData(
        id: id ?? this.id,
        name: name ?? this.name,
        brand: brand.present ? brand.value : this.brand,
        form: form ?? this.form,
        strength: strength.present ? strength.value : this.strength,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        expiryDate: expiryDate ?? this.expiryDate,
        openedDate: openedDate.present ? openedDate.value : this.openedDate,
        location: location.present ? location.value : this.location,
        lowStockThreshold: lowStockThreshold.present
            ? lowStockThreshold.value
            : this.lowStockThreshold,
        isDisposed: isDisposed ?? this.isDisposed,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MedicineInventoryData copyWithCompanion(MedicineInventoryCompanion data) {
    return MedicineInventoryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      form: data.form.present ? data.form.value : this.form,
      strength: data.strength.present ? data.strength.value : this.strength,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      openedDate:
          data.openedDate.present ? data.openedDate.value : this.openedDate,
      location: data.location.present ? data.location.value : this.location,
      lowStockThreshold: data.lowStockThreshold.present
          ? data.lowStockThreshold.value
          : this.lowStockThreshold,
      isDisposed:
          data.isDisposed.present ? data.isDisposed.value : this.isDisposed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicineInventoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('form: $form, ')
          ..write('strength: $strength, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('openedDate: $openedDate, ')
          ..write('location: $location, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('isDisposed: $isDisposed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      brand,
      form,
      strength,
      quantity,
      unit,
      expiryDate,
      openedDate,
      location,
      lowStockThreshold,
      isDisposed,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicineInventoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.form == this.form &&
          other.strength == this.strength &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.expiryDate == this.expiryDate &&
          other.openedDate == this.openedDate &&
          other.location == this.location &&
          other.lowStockThreshold == this.lowStockThreshold &&
          other.isDisposed == this.isDisposed &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicineInventoryCompanion
    extends UpdateCompanion<MedicineInventoryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> brand;
  final Value<MedicineForm> form;
  final Value<String?> strength;
  final Value<int> quantity;
  final Value<String> unit;
  final Value<DateTime> expiryDate;
  final Value<DateTime?> openedDate;
  final Value<String?> location;
  final Value<int?> lowStockThreshold;
  final Value<bool> isDisposed;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MedicineInventoryCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.form = const Value.absent(),
    this.strength = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.openedDate = const Value.absent(),
    this.location = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.isDisposed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MedicineInventoryCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.brand = const Value.absent(),
    required MedicineForm form,
    this.strength = const Value.absent(),
    required int quantity,
    required String unit,
    required DateTime expiryDate,
    this.openedDate = const Value.absent(),
    this.location = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.isDisposed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        form = Value(form),
        quantity = Value(quantity),
        unit = Value(unit),
        expiryDate = Value(expiryDate);
  static Insertable<MedicineInventoryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? form,
    Expression<String>? strength,
    Expression<int>? quantity,
    Expression<String>? unit,
    Expression<DateTime>? expiryDate,
    Expression<DateTime>? openedDate,
    Expression<String>? location,
    Expression<int>? lowStockThreshold,
    Expression<bool>? isDisposed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (form != null) 'form': form,
      if (strength != null) 'strength': strength,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (openedDate != null) 'opened_date': openedDate,
      if (location != null) 'location': location,
      if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
      if (isDisposed != null) 'is_disposed': isDisposed,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MedicineInventoryCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? brand,
      Value<MedicineForm>? form,
      Value<String?>? strength,
      Value<int>? quantity,
      Value<String>? unit,
      Value<DateTime>? expiryDate,
      Value<DateTime?>? openedDate,
      Value<String?>? location,
      Value<int?>? lowStockThreshold,
      Value<bool>? isDisposed,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MedicineInventoryCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      form: form ?? this.form,
      strength: strength ?? this.strength,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      openedDate: openedDate ?? this.openedDate,
      location: location ?? this.location,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      isDisposed: isDisposed ?? this.isDisposed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(
          $MedicineInventoryTable.$converterform.toSql(form.value));
    }
    if (strength.present) {
      map['strength'] = Variable<String>(strength.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (openedDate.present) {
      map['opened_date'] = Variable<DateTime>(openedDate.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (lowStockThreshold.present) {
      map['low_stock_threshold'] = Variable<int>(lowStockThreshold.value);
    }
    if (isDisposed.present) {
      map['is_disposed'] = Variable<bool>(isDisposed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicineInventoryCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('form: $form, ')
          ..write('strength: $strength, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('openedDate: $openedDate, ')
          ..write('location: $location, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('isDisposed: $isDisposed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AlertsTable extends Alerts with TableInfo<$AlertsTable, AlertData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _medicineIdMeta =
      const VerificationMeta('medicineId');
  @override
  late final GeneratedColumn<int> medicineId = GeneratedColumn<int>(
      'medicine_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES medicine_inventory (id)'));
  @override
  late final GeneratedColumnWithTypeConverter<AlertType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<AlertType>($AlertsTable.$convertertype);
  static const VerificationMeta _triggerDateMeta =
      const VerificationMeta('triggerDate');
  @override
  late final GeneratedColumn<DateTime> triggerDate = GeneratedColumn<DateTime>(
      'trigger_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<RecurrencePattern?, String>
      recurrence = GeneratedColumn<String>('recurrence', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<RecurrencePattern?>(
              $AlertsTable.$converterrecurrencen);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastNotifiedMeta =
      const VerificationMeta('lastNotified');
  @override
  late final GeneratedColumn<DateTime> lastNotified = GeneratedColumn<DateTime>(
      'last_notified', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        medicineId,
        type,
        triggerDate,
        recurrence,
        isActive,
        lastNotified,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alerts';
  @override
  VerificationContext validateIntegrity(Insertable<AlertData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medicine_id')) {
      context.handle(
          _medicineIdMeta,
          medicineId.isAcceptableOrUnknown(
              data['medicine_id']!, _medicineIdMeta));
    } else if (isInserting) {
      context.missing(_medicineIdMeta);
    }
    if (data.containsKey('trigger_date')) {
      context.handle(
          _triggerDateMeta,
          triggerDate.isAcceptableOrUnknown(
              data['trigger_date']!, _triggerDateMeta));
    } else if (isInserting) {
      context.missing(_triggerDateMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('last_notified')) {
      context.handle(
          _lastNotifiedMeta,
          lastNotified.isAcceptableOrUnknown(
              data['last_notified']!, _lastNotifiedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlertData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      medicineId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}medicine_id'])!,
      type: $AlertsTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      triggerDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}trigger_date'])!,
      recurrence: $AlertsTable.$converterrecurrencen.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurrence'])),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      lastNotified: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_notified']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AlertsTable createAlias(String alias) {
    return $AlertsTable(attachedDatabase, alias);
  }

  static TypeConverter<AlertType, String> $convertertype = AlertTypeConverter();
  static TypeConverter<RecurrencePattern, String> $converterrecurrence =
      RecurrencePatternConverter();
  static TypeConverter<RecurrencePattern?, String?> $converterrecurrencen =
      NullAwareTypeConverter.wrap($converterrecurrence);
}

class AlertData extends DataClass implements Insertable<AlertData> {
  /// Primary key, auto-increment
  final int id;

  /// Foreign key to MedicineInventory
  final int medicineId;

  /// Alert type: expiry, low_stock, dose_reminder
  final AlertType type;

  /// Trigger date/time for the alert
  final DateTime triggerDate;

  /// Recurrence pattern: none, daily, weekly, custom
  final RecurrencePattern? recurrence;

  /// Whether the alert is active
  final bool isActive;

  /// Last time this alert was notified
  final DateTime? lastNotified;

  /// Creation timestamp
  final DateTime createdAt;
  const AlertData(
      {required this.id,
      required this.medicineId,
      required this.type,
      required this.triggerDate,
      this.recurrence,
      required this.isActive,
      this.lastNotified,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medicine_id'] = Variable<int>(medicineId);
    {
      map['type'] = Variable<String>($AlertsTable.$convertertype.toSql(type));
    }
    map['trigger_date'] = Variable<DateTime>(triggerDate);
    if (!nullToAbsent || recurrence != null) {
      map['recurrence'] = Variable<String>(
          $AlertsTable.$converterrecurrencen.toSql(recurrence));
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || lastNotified != null) {
      map['last_notified'] = Variable<DateTime>(lastNotified);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AlertsCompanion toCompanion(bool nullToAbsent) {
    return AlertsCompanion(
      id: Value(id),
      medicineId: Value(medicineId),
      type: Value(type),
      triggerDate: Value(triggerDate),
      recurrence: recurrence == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrence),
      isActive: Value(isActive),
      lastNotified: lastNotified == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNotified),
      createdAt: Value(createdAt),
    );
  }

  factory AlertData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertData(
      id: serializer.fromJson<int>(json['id']),
      medicineId: serializer.fromJson<int>(json['medicineId']),
      type: serializer.fromJson<AlertType>(json['type']),
      triggerDate: serializer.fromJson<DateTime>(json['triggerDate']),
      recurrence: serializer.fromJson<RecurrencePattern?>(json['recurrence']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastNotified: serializer.fromJson<DateTime?>(json['lastNotified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicineId': serializer.toJson<int>(medicineId),
      'type': serializer.toJson<AlertType>(type),
      'triggerDate': serializer.toJson<DateTime>(triggerDate),
      'recurrence': serializer.toJson<RecurrencePattern?>(recurrence),
      'isActive': serializer.toJson<bool>(isActive),
      'lastNotified': serializer.toJson<DateTime?>(lastNotified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AlertData copyWith(
          {int? id,
          int? medicineId,
          AlertType? type,
          DateTime? triggerDate,
          Value<RecurrencePattern?> recurrence = const Value.absent(),
          bool? isActive,
          Value<DateTime?> lastNotified = const Value.absent(),
          DateTime? createdAt}) =>
      AlertData(
        id: id ?? this.id,
        medicineId: medicineId ?? this.medicineId,
        type: type ?? this.type,
        triggerDate: triggerDate ?? this.triggerDate,
        recurrence: recurrence.present ? recurrence.value : this.recurrence,
        isActive: isActive ?? this.isActive,
        lastNotified:
            lastNotified.present ? lastNotified.value : this.lastNotified,
        createdAt: createdAt ?? this.createdAt,
      );
  AlertData copyWithCompanion(AlertsCompanion data) {
    return AlertData(
      id: data.id.present ? data.id.value : this.id,
      medicineId:
          data.medicineId.present ? data.medicineId.value : this.medicineId,
      type: data.type.present ? data.type.value : this.type,
      triggerDate:
          data.triggerDate.present ? data.triggerDate.value : this.triggerDate,
      recurrence:
          data.recurrence.present ? data.recurrence.value : this.recurrence,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastNotified: data.lastNotified.present
          ? data.lastNotified.value
          : this.lastNotified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlertData(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('type: $type, ')
          ..write('triggerDate: $triggerDate, ')
          ..write('recurrence: $recurrence, ')
          ..write('isActive: $isActive, ')
          ..write('lastNotified: $lastNotified, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, medicineId, type, triggerDate, recurrence,
      isActive, lastNotified, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertData &&
          other.id == this.id &&
          other.medicineId == this.medicineId &&
          other.type == this.type &&
          other.triggerDate == this.triggerDate &&
          other.recurrence == this.recurrence &&
          other.isActive == this.isActive &&
          other.lastNotified == this.lastNotified &&
          other.createdAt == this.createdAt);
}

class AlertsCompanion extends UpdateCompanion<AlertData> {
  final Value<int> id;
  final Value<int> medicineId;
  final Value<AlertType> type;
  final Value<DateTime> triggerDate;
  final Value<RecurrencePattern?> recurrence;
  final Value<bool> isActive;
  final Value<DateTime?> lastNotified;
  final Value<DateTime> createdAt;
  const AlertsCompanion({
    this.id = const Value.absent(),
    this.medicineId = const Value.absent(),
    this.type = const Value.absent(),
    this.triggerDate = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastNotified = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AlertsCompanion.insert({
    this.id = const Value.absent(),
    required int medicineId,
    required AlertType type,
    required DateTime triggerDate,
    this.recurrence = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastNotified = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : medicineId = Value(medicineId),
        type = Value(type),
        triggerDate = Value(triggerDate);
  static Insertable<AlertData> custom({
    Expression<int>? id,
    Expression<int>? medicineId,
    Expression<String>? type,
    Expression<DateTime>? triggerDate,
    Expression<String>? recurrence,
    Expression<bool>? isActive,
    Expression<DateTime>? lastNotified,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicineId != null) 'medicine_id': medicineId,
      if (type != null) 'type': type,
      if (triggerDate != null) 'trigger_date': triggerDate,
      if (recurrence != null) 'recurrence': recurrence,
      if (isActive != null) 'is_active': isActive,
      if (lastNotified != null) 'last_notified': lastNotified,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AlertsCompanion copyWith(
      {Value<int>? id,
      Value<int>? medicineId,
      Value<AlertType>? type,
      Value<DateTime>? triggerDate,
      Value<RecurrencePattern?>? recurrence,
      Value<bool>? isActive,
      Value<DateTime?>? lastNotified,
      Value<DateTime>? createdAt}) {
    return AlertsCompanion(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      type: type ?? this.type,
      triggerDate: triggerDate ?? this.triggerDate,
      recurrence: recurrence ?? this.recurrence,
      isActive: isActive ?? this.isActive,
      lastNotified: lastNotified ?? this.lastNotified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicineId.present) {
      map['medicine_id'] = Variable<int>(medicineId.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($AlertsTable.$convertertype.toSql(type.value));
    }
    if (triggerDate.present) {
      map['trigger_date'] = Variable<DateTime>(triggerDate.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(
          $AlertsTable.$converterrecurrencen.toSql(recurrence.value));
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastNotified.present) {
      map['last_notified'] = Variable<DateTime>(lastNotified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertsCompanion(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('type: $type, ')
          ..write('triggerDate: $triggerDate, ')
          ..write('recurrence: $recurrence, ')
          ..write('isActive: $isActive, ')
          ..write('lastNotified: $lastNotified, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicineInventoryTable medicineInventory =
      $MedicineInventoryTable(this);
  late final $AlertsTable alerts = $AlertsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [medicineInventory, alerts];
}

typedef $$MedicineInventoryTableCreateCompanionBuilder
    = MedicineInventoryCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> brand,
  required MedicineForm form,
  Value<String?> strength,
  required int quantity,
  required String unit,
  required DateTime expiryDate,
  Value<DateTime?> openedDate,
  Value<String?> location,
  Value<int?> lowStockThreshold,
  Value<bool> isDisposed,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$MedicineInventoryTableUpdateCompanionBuilder
    = MedicineInventoryCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> brand,
  Value<MedicineForm> form,
  Value<String?> strength,
  Value<int> quantity,
  Value<String> unit,
  Value<DateTime> expiryDate,
  Value<DateTime?> openedDate,
  Value<String?> location,
  Value<int?> lowStockThreshold,
  Value<bool> isDisposed,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$MedicineInventoryTableReferences extends BaseReferences<
    _$AppDatabase, $MedicineInventoryTable, MedicineInventoryData> {
  $$MedicineInventoryTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AlertsTable, List<AlertData>> _alertsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.alerts,
          aliasName: $_aliasNameGenerator(
              db.medicineInventory.id, db.alerts.medicineId));

  $$AlertsTableProcessedTableManager get alertsRefs {
    final manager = $$AlertsTableTableManager($_db, $_db.alerts)
        .filter((f) => f.medicineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_alertsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MedicineInventoryTableFilterComposer
    extends Composer<_$AppDatabase, $MedicineInventoryTable> {
  $$MedicineInventoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<MedicineForm, MedicineForm, String> get form =>
      $composableBuilder(
          column: $table.form,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get strength => $composableBuilder(
      column: $table.strength, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get openedDate => $composableBuilder(
      column: $table.openedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lowStockThreshold => $composableBuilder(
      column: $table.lowStockThreshold,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDisposed => $composableBuilder(
      column: $table.isDisposed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> alertsRefs(
      Expression<bool> Function($$AlertsTableFilterComposer f) f) {
    final $$AlertsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.medicineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableFilterComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicineInventoryTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicineInventoryTable> {
  $$MedicineInventoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get form => $composableBuilder(
      column: $table.form, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get strength => $composableBuilder(
      column: $table.strength, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get openedDate => $composableBuilder(
      column: $table.openedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lowStockThreshold => $composableBuilder(
      column: $table.lowStockThreshold,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDisposed => $composableBuilder(
      column: $table.isDisposed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MedicineInventoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicineInventoryTable> {
  $$MedicineInventoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MedicineForm, String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<String> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<DateTime> get openedDate => $composableBuilder(
      column: $table.openedDate, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<int> get lowStockThreshold => $composableBuilder(
      column: $table.lowStockThreshold, builder: (column) => column);

  GeneratedColumn<bool> get isDisposed => $composableBuilder(
      column: $table.isDisposed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> alertsRefs<T extends Object>(
      Expression<T> Function($$AlertsTableAnnotationComposer a) f) {
    final $$AlertsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.medicineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableAnnotationComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicineInventoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicineInventoryTable,
    MedicineInventoryData,
    $$MedicineInventoryTableFilterComposer,
    $$MedicineInventoryTableOrderingComposer,
    $$MedicineInventoryTableAnnotationComposer,
    $$MedicineInventoryTableCreateCompanionBuilder,
    $$MedicineInventoryTableUpdateCompanionBuilder,
    (MedicineInventoryData, $$MedicineInventoryTableReferences),
    MedicineInventoryData,
    PrefetchHooks Function({bool alertsRefs})> {
  $$MedicineInventoryTableTableManager(
      _$AppDatabase db, $MedicineInventoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicineInventoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicineInventoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicineInventoryTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<MedicineForm> form = const Value.absent(),
            Value<String?> strength = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<DateTime> expiryDate = const Value.absent(),
            Value<DateTime?> openedDate = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<int?> lowStockThreshold = const Value.absent(),
            Value<bool> isDisposed = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MedicineInventoryCompanion(
            id: id,
            name: name,
            brand: brand,
            form: form,
            strength: strength,
            quantity: quantity,
            unit: unit,
            expiryDate: expiryDate,
            openedDate: openedDate,
            location: location,
            lowStockThreshold: lowStockThreshold,
            isDisposed: isDisposed,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> brand = const Value.absent(),
            required MedicineForm form,
            Value<String?> strength = const Value.absent(),
            required int quantity,
            required String unit,
            required DateTime expiryDate,
            Value<DateTime?> openedDate = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<int?> lowStockThreshold = const Value.absent(),
            Value<bool> isDisposed = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MedicineInventoryCompanion.insert(
            id: id,
            name: name,
            brand: brand,
            form: form,
            strength: strength,
            quantity: quantity,
            unit: unit,
            expiryDate: expiryDate,
            openedDate: openedDate,
            location: location,
            lowStockThreshold: lowStockThreshold,
            isDisposed: isDisposed,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MedicineInventoryTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({alertsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (alertsRefs) db.alerts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (alertsRefs)
                    await $_getPrefetchedData<MedicineInventoryData,
                            $MedicineInventoryTable, AlertData>(
                        currentTable: table,
                        referencedTable: $$MedicineInventoryTableReferences
                            ._alertsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MedicineInventoryTableReferences(db, table, p0)
                                .alertsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.medicineId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MedicineInventoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicineInventoryTable,
    MedicineInventoryData,
    $$MedicineInventoryTableFilterComposer,
    $$MedicineInventoryTableOrderingComposer,
    $$MedicineInventoryTableAnnotationComposer,
    $$MedicineInventoryTableCreateCompanionBuilder,
    $$MedicineInventoryTableUpdateCompanionBuilder,
    (MedicineInventoryData, $$MedicineInventoryTableReferences),
    MedicineInventoryData,
    PrefetchHooks Function({bool alertsRefs})>;
typedef $$AlertsTableCreateCompanionBuilder = AlertsCompanion Function({
  Value<int> id,
  required int medicineId,
  required AlertType type,
  required DateTime triggerDate,
  Value<RecurrencePattern?> recurrence,
  Value<bool> isActive,
  Value<DateTime?> lastNotified,
  Value<DateTime> createdAt,
});
typedef $$AlertsTableUpdateCompanionBuilder = AlertsCompanion Function({
  Value<int> id,
  Value<int> medicineId,
  Value<AlertType> type,
  Value<DateTime> triggerDate,
  Value<RecurrencePattern?> recurrence,
  Value<bool> isActive,
  Value<DateTime?> lastNotified,
  Value<DateTime> createdAt,
});

final class $$AlertsTableReferences
    extends BaseReferences<_$AppDatabase, $AlertsTable, AlertData> {
  $$AlertsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicineInventoryTable _medicineIdTable(_$AppDatabase db) =>
      db.medicineInventory.createAlias(
          $_aliasNameGenerator(db.alerts.medicineId, db.medicineInventory.id));

  $$MedicineInventoryTableProcessedTableManager get medicineId {
    final $_column = $_itemColumn<int>('medicine_id')!;

    final manager =
        $$MedicineInventoryTableTableManager($_db, $_db.medicineInventory)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AlertsTableFilterComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AlertType, AlertType, String> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get triggerDate => $composableBuilder(
      column: $table.triggerDate, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<RecurrencePattern?, RecurrencePattern, String>
      get recurrence => $composableBuilder(
          column: $table.recurrence,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastNotified => $composableBuilder(
      column: $table.lastNotified, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$MedicineInventoryTableFilterComposer get medicineId {
    final $$MedicineInventoryTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicineId,
        referencedTable: $db.medicineInventory,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineInventoryTableFilterComposer(
              $db: $db,
              $table: $db.medicineInventory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlertsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get triggerDate => $composableBuilder(
      column: $table.triggerDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrence => $composableBuilder(
      column: $table.recurrence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastNotified => $composableBuilder(
      column: $table.lastNotified,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$MedicineInventoryTableOrderingComposer get medicineId {
    final $$MedicineInventoryTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicineId,
        referencedTable: $db.medicineInventory,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineInventoryTableOrderingComposer(
              $db: $db,
              $table: $db.medicineInventory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlertsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AlertType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get triggerDate => $composableBuilder(
      column: $table.triggerDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RecurrencePattern?, String> get recurrence =>
      $composableBuilder(
          column: $table.recurrence, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get lastNotified => $composableBuilder(
      column: $table.lastNotified, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicineInventoryTableAnnotationComposer get medicineId {
    final $$MedicineInventoryTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.medicineId,
            referencedTable: $db.medicineInventory,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MedicineInventoryTableAnnotationComposer(
                  $db: $db,
                  $table: $db.medicineInventory,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$AlertsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlertsTable,
    AlertData,
    $$AlertsTableFilterComposer,
    $$AlertsTableOrderingComposer,
    $$AlertsTableAnnotationComposer,
    $$AlertsTableCreateCompanionBuilder,
    $$AlertsTableUpdateCompanionBuilder,
    (AlertData, $$AlertsTableReferences),
    AlertData,
    PrefetchHooks Function({bool medicineId})> {
  $$AlertsTableTableManager(_$AppDatabase db, $AlertsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> medicineId = const Value.absent(),
            Value<AlertType> type = const Value.absent(),
            Value<DateTime> triggerDate = const Value.absent(),
            Value<RecurrencePattern?> recurrence = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> lastNotified = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AlertsCompanion(
            id: id,
            medicineId: medicineId,
            type: type,
            triggerDate: triggerDate,
            recurrence: recurrence,
            isActive: isActive,
            lastNotified: lastNotified,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int medicineId,
            required AlertType type,
            required DateTime triggerDate,
            Value<RecurrencePattern?> recurrence = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> lastNotified = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AlertsCompanion.insert(
            id: id,
            medicineId: medicineId,
            type: type,
            triggerDate: triggerDate,
            recurrence: recurrence,
            isActive: isActive,
            lastNotified: lastNotified,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AlertsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({medicineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (medicineId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.medicineId,
                    referencedTable:
                        $$AlertsTableReferences._medicineIdTable(db),
                    referencedColumn:
                        $$AlertsTableReferences._medicineIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AlertsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlertsTable,
    AlertData,
    $$AlertsTableFilterComposer,
    $$AlertsTableOrderingComposer,
    $$AlertsTableAnnotationComposer,
    $$AlertsTableCreateCompanionBuilder,
    $$AlertsTableUpdateCompanionBuilder,
    (AlertData, $$AlertsTableReferences),
    AlertData,
    PrefetchHooks Function({bool medicineId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicineInventoryTableTableManager get medicineInventory =>
      $$MedicineInventoryTableTableManager(_db, _db.medicineInventory);
  $$AlertsTableTableManager get alerts =>
      $$AlertsTableTableManager(_db, _db.alerts);
}
