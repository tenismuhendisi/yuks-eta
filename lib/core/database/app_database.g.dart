// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _creditBalanceMeta =
      const VerificationMeta('creditBalance');
  @override
  late final GeneratedColumn<double> creditBalance = GeneratedColumn<double>(
      'credit_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, email, password, role, phone, creditBalance, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('credit_balance')) {
      context.handle(
          _creditBalanceMeta,
          creditBalance.isAcceptableOrUnknown(
              data['credit_balance']!, _creditBalanceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      creditBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_balance'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String? phone;
  final double creditBalance;
  final DateTime createdAt;
  const User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.role,
      this.phone,
      required this.creditBalance,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['credit_balance'] = Variable<double>(creditBalance);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      password: Value(password),
      role: Value(role),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      creditBalance: Value(creditBalance),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      role: serializer.fromJson<String>(json['role']),
      phone: serializer.fromJson<String?>(json['phone']),
      creditBalance: serializer.fromJson<double>(json['creditBalance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'role': serializer.toJson<String>(role),
      'phone': serializer.toJson<String?>(phone),
      'creditBalance': serializer.toJson<double>(creditBalance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith(
          {String? id,
          String? name,
          String? email,
          String? password,
          String? role,
          Value<String?> phone = const Value.absent(),
          double? creditBalance,
          DateTime? createdAt}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        role: role ?? this.role,
        phone: phone.present ? phone.value : this.phone,
        creditBalance: creditBalance ?? this.creditBalance,
        createdAt: createdAt ?? this.createdAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      role: data.role.present ? data.role.value : this.role,
      phone: data.phone.present ? data.phone.value : this.phone,
      creditBalance: data.creditBalance.present
          ? data.creditBalance.value
          : this.creditBalance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('creditBalance: $creditBalance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, email, password, role, phone, creditBalance, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.password == this.password &&
          other.role == this.role &&
          other.phone == this.phone &&
          other.creditBalance == this.creditBalance &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> password;
  final Value<String> role;
  final Value<String?> phone;
  final Value<double> creditBalance;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
    this.phone = const Value.absent(),
    this.creditBalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    required String email,
    required String password,
    required String role,
    this.phone = const Value.absent(),
    this.creditBalance = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        email = Value(email),
        password = Value(password),
        role = Value(role),
        createdAt = Value(createdAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? role,
    Expression<String>? phone,
    Expression<double>? creditBalance,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (phone != null) 'phone': phone,
      if (creditBalance != null) 'credit_balance': creditBalance,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? email,
      Value<String>? password,
      Value<String>? role,
      Value<String?>? phone,
      Value<double>? creditBalance,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      creditBalance: creditBalance ?? this.creditBalance,
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
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (creditBalance.present) {
      map['credit_balance'] = Variable<double>(creditBalance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('creditBalance: $creditBalance, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CourtsTable extends Courts with TableInfo<$CourtsTable, Court> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CourtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
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
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courts';
  @override
  VerificationContext validateIntegrity(Insertable<Court> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Court map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Court(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $CourtsTable createAlias(String alias) {
    return $CourtsTable(attachedDatabase, alias);
  }
}

class Court extends DataClass implements Insertable<Court> {
  final String id;
  final String name;
  final int sortOrder;
  final bool isActive;
  const Court(
      {required this.id,
      required this.name,
      required this.sortOrder,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CourtsCompanion toCompanion(bool nullToAbsent) {
    return CourtsCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory Court.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Court(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Court copyWith({String? id, String? name, int? sortOrder, bool? isActive}) =>
      Court(
        id: id ?? this.id,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
      );
  Court copyWithCompanion(CourtsCompanion data) {
    return Court(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Court(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Court &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class CourtsCompanion extends UpdateCompanion<Court> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const CourtsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CourtsCompanion.insert({
    required String id,
    required String name,
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Court> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CourtsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? sortOrder,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return CourtsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
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
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CourtsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CourtBlocksTable extends CourtBlocks
    with TableInfo<$CourtBlocksTable, CourtBlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CourtBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _courtIdMeta =
      const VerificationMeta('courtId');
  @override
  late final GeneratedColumn<String> courtId = GeneratedColumn<String>(
      'court_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES courts (id)'));
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdByIdMeta =
      const VerificationMeta('createdById');
  @override
  late final GeneratedColumn<String> createdById = GeneratedColumn<String>(
      'created_by_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, courtId, startTime, endTime, reason, createdById];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'court_blocks';
  @override
  VerificationContext validateIntegrity(Insertable<CourtBlock> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('court_id')) {
      context.handle(_courtIdMeta,
          courtId.isAcceptableOrUnknown(data['court_id']!, _courtIdMeta));
    } else if (isInserting) {
      context.missing(_courtIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('created_by_id')) {
      context.handle(
          _createdByIdMeta,
          createdById.isAcceptableOrUnknown(
              data['created_by_id']!, _createdByIdMeta));
    } else if (isInserting) {
      context.missing(_createdByIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CourtBlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CourtBlock(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      courtId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}court_id'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      createdById: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by_id'])!,
    );
  }

  @override
  $CourtBlocksTable createAlias(String alias) {
    return $CourtBlocksTable(attachedDatabase, alias);
  }
}

class CourtBlock extends DataClass implements Insertable<CourtBlock> {
  final String id;
  final String courtId;
  final DateTime startTime;
  final DateTime endTime;
  final String? reason;
  final String createdById;
  const CourtBlock(
      {required this.id,
      required this.courtId,
      required this.startTime,
      required this.endTime,
      this.reason,
      required this.createdById});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['court_id'] = Variable<String>(courtId);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['created_by_id'] = Variable<String>(createdById);
    return map;
  }

  CourtBlocksCompanion toCompanion(bool nullToAbsent) {
    return CourtBlocksCompanion(
      id: Value(id),
      courtId: Value(courtId),
      startTime: Value(startTime),
      endTime: Value(endTime),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      createdById: Value(createdById),
    );
  }

  factory CourtBlock.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CourtBlock(
      id: serializer.fromJson<String>(json['id']),
      courtId: serializer.fromJson<String>(json['courtId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      reason: serializer.fromJson<String?>(json['reason']),
      createdById: serializer.fromJson<String>(json['createdById']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courtId': serializer.toJson<String>(courtId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'reason': serializer.toJson<String?>(reason),
      'createdById': serializer.toJson<String>(createdById),
    };
  }

  CourtBlock copyWith(
          {String? id,
          String? courtId,
          DateTime? startTime,
          DateTime? endTime,
          Value<String?> reason = const Value.absent(),
          String? createdById}) =>
      CourtBlock(
        id: id ?? this.id,
        courtId: courtId ?? this.courtId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        reason: reason.present ? reason.value : this.reason,
        createdById: createdById ?? this.createdById,
      );
  CourtBlock copyWithCompanion(CourtBlocksCompanion data) {
    return CourtBlock(
      id: data.id.present ? data.id.value : this.id,
      courtId: data.courtId.present ? data.courtId.value : this.courtId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdById:
          data.createdById.present ? data.createdById.value : this.createdById,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CourtBlock(')
          ..write('id: $id, ')
          ..write('courtId: $courtId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('reason: $reason, ')
          ..write('createdById: $createdById')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, courtId, startTime, endTime, reason, createdById);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CourtBlock &&
          other.id == this.id &&
          other.courtId == this.courtId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.reason == this.reason &&
          other.createdById == this.createdById);
}

class CourtBlocksCompanion extends UpdateCompanion<CourtBlock> {
  final Value<String> id;
  final Value<String> courtId;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<String?> reason;
  final Value<String> createdById;
  final Value<int> rowid;
  const CourtBlocksCompanion({
    this.id = const Value.absent(),
    this.courtId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdById = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CourtBlocksCompanion.insert({
    required String id,
    required String courtId,
    required DateTime startTime,
    required DateTime endTime,
    this.reason = const Value.absent(),
    required String createdById,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        courtId = Value(courtId),
        startTime = Value(startTime),
        endTime = Value(endTime),
        createdById = Value(createdById);
  static Insertable<CourtBlock> custom({
    Expression<String>? id,
    Expression<String>? courtId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? reason,
    Expression<String>? createdById,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courtId != null) 'court_id': courtId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (reason != null) 'reason': reason,
      if (createdById != null) 'created_by_id': createdById,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CourtBlocksCompanion copyWith(
      {Value<String>? id,
      Value<String>? courtId,
      Value<DateTime>? startTime,
      Value<DateTime>? endTime,
      Value<String?>? reason,
      Value<String>? createdById,
      Value<int>? rowid}) {
    return CourtBlocksCompanion(
      id: id ?? this.id,
      courtId: courtId ?? this.courtId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reason: reason ?? this.reason,
      createdById: createdById ?? this.createdById,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (courtId.present) {
      map['court_id'] = Variable<String>(courtId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdById.present) {
      map['created_by_id'] = Variable<String>(createdById.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CourtBlocksCompanion(')
          ..write('id: $id, ')
          ..write('courtId: $courtId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('reason: $reason, ')
          ..write('createdById: $createdById, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CourtRentalsTable extends CourtRentals
    with TableInfo<$CourtRentalsTable, CourtRental> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CourtRentalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _courtIdMeta =
      const VerificationMeta('courtId');
  @override
  late final GeneratedColumn<String> courtId = GeneratedColumn<String>(
      'court_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES courts (id)'));
  static const VerificationMeta _athleteIdMeta =
      const VerificationMeta('athleteId');
  @override
  late final GeneratedColumn<String> athleteId = GeneratedColumn<String>(
      'athlete_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _creditCostMeta =
      const VerificationMeta('creditCost');
  @override
  late final GeneratedColumn<double> creditCost = GeneratedColumn<double>(
      'credit_cost', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
        courtId,
        athleteId,
        startTime,
        endTime,
        creditCost,
        notes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'court_rentals';
  @override
  VerificationContext validateIntegrity(Insertable<CourtRental> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('court_id')) {
      context.handle(_courtIdMeta,
          courtId.isAcceptableOrUnknown(data['court_id']!, _courtIdMeta));
    } else if (isInserting) {
      context.missing(_courtIdMeta);
    }
    if (data.containsKey('athlete_id')) {
      context.handle(_athleteIdMeta,
          athleteId.isAcceptableOrUnknown(data['athlete_id']!, _athleteIdMeta));
    } else if (isInserting) {
      context.missing(_athleteIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('credit_cost')) {
      context.handle(
          _creditCostMeta,
          creditCost.isAcceptableOrUnknown(
              data['credit_cost']!, _creditCostMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
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
  CourtRental map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CourtRental(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      courtId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}court_id'])!,
      athleteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}athlete_id'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time'])!,
      creditCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_cost'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CourtRentalsTable createAlias(String alias) {
    return $CourtRentalsTable(attachedDatabase, alias);
  }
}

class CourtRental extends DataClass implements Insertable<CourtRental> {
  final String id;
  final String courtId;
  final String athleteId;
  final DateTime startTime;
  final DateTime endTime;
  final double creditCost;
  final String? notes;
  final DateTime createdAt;
  const CourtRental(
      {required this.id,
      required this.courtId,
      required this.athleteId,
      required this.startTime,
      required this.endTime,
      required this.creditCost,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['court_id'] = Variable<String>(courtId);
    map['athlete_id'] = Variable<String>(athleteId);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['credit_cost'] = Variable<double>(creditCost);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CourtRentalsCompanion toCompanion(bool nullToAbsent) {
    return CourtRentalsCompanion(
      id: Value(id),
      courtId: Value(courtId),
      athleteId: Value(athleteId),
      startTime: Value(startTime),
      endTime: Value(endTime),
      creditCost: Value(creditCost),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory CourtRental.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CourtRental(
      id: serializer.fromJson<String>(json['id']),
      courtId: serializer.fromJson<String>(json['courtId']),
      athleteId: serializer.fromJson<String>(json['athleteId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      creditCost: serializer.fromJson<double>(json['creditCost']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courtId': serializer.toJson<String>(courtId),
      'athleteId': serializer.toJson<String>(athleteId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'creditCost': serializer.toJson<double>(creditCost),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CourtRental copyWith(
          {String? id,
          String? courtId,
          String? athleteId,
          DateTime? startTime,
          DateTime? endTime,
          double? creditCost,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      CourtRental(
        id: id ?? this.id,
        courtId: courtId ?? this.courtId,
        athleteId: athleteId ?? this.athleteId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        creditCost: creditCost ?? this.creditCost,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  CourtRental copyWithCompanion(CourtRentalsCompanion data) {
    return CourtRental(
      id: data.id.present ? data.id.value : this.id,
      courtId: data.courtId.present ? data.courtId.value : this.courtId,
      athleteId: data.athleteId.present ? data.athleteId.value : this.athleteId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      creditCost:
          data.creditCost.present ? data.creditCost.value : this.creditCost,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CourtRental(')
          ..write('id: $id, ')
          ..write('courtId: $courtId, ')
          ..write('athleteId: $athleteId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('creditCost: $creditCost, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, courtId, athleteId, startTime, endTime, creditCost, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CourtRental &&
          other.id == this.id &&
          other.courtId == this.courtId &&
          other.athleteId == this.athleteId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.creditCost == this.creditCost &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class CourtRentalsCompanion extends UpdateCompanion<CourtRental> {
  final Value<String> id;
  final Value<String> courtId;
  final Value<String> athleteId;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<double> creditCost;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CourtRentalsCompanion({
    this.id = const Value.absent(),
    this.courtId = const Value.absent(),
    this.athleteId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.creditCost = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CourtRentalsCompanion.insert({
    required String id,
    required String courtId,
    required String athleteId,
    required DateTime startTime,
    required DateTime endTime,
    this.creditCost = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        courtId = Value(courtId),
        athleteId = Value(athleteId),
        startTime = Value(startTime),
        endTime = Value(endTime);
  static Insertable<CourtRental> custom({
    Expression<String>? id,
    Expression<String>? courtId,
    Expression<String>? athleteId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<double>? creditCost,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courtId != null) 'court_id': courtId,
      if (athleteId != null) 'athlete_id': athleteId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (creditCost != null) 'credit_cost': creditCost,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CourtRentalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? courtId,
      Value<String>? athleteId,
      Value<DateTime>? startTime,
      Value<DateTime>? endTime,
      Value<double>? creditCost,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CourtRentalsCompanion(
      id: id ?? this.id,
      courtId: courtId ?? this.courtId,
      athleteId: athleteId ?? this.athleteId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      creditCost: creditCost ?? this.creditCost,
      notes: notes ?? this.notes,
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
    if (courtId.present) {
      map['court_id'] = Variable<String>(courtId.value);
    }
    if (athleteId.present) {
      map['athlete_id'] = Variable<String>(athleteId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (creditCost.present) {
      map['credit_cost'] = Variable<double>(creditCost.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CourtRentalsCompanion(')
          ..write('id: $id, ')
          ..write('courtId: $courtId, ')
          ..write('athleteId: $athleteId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('creditCost: $creditCost, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditTransactionsTable extends CreditTransactions
    with TableInfo<$CreditTransactionsTable, CreditTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rentalIdMeta =
      const VerificationMeta('rentalId');
  @override
  late final GeneratedColumn<String> rentalId = GeneratedColumn<String>(
      'rental_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES court_rentals (id)'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _balanceAfterMeta =
      const VerificationMeta('balanceAfter');
  @override
  late final GeneratedColumn<double> balanceAfter = GeneratedColumn<double>(
      'balance_after', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        amount,
        type,
        rentalId,
        description,
        balanceAfter,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_transactions';
  @override
  VerificationContext validateIntegrity(Insertable<CreditTransaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('rental_id')) {
      context.handle(_rentalIdMeta,
          rentalId.isAcceptableOrUnknown(data['rental_id']!, _rentalIdMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('balance_after')) {
      context.handle(
          _balanceAfterMeta,
          balanceAfter.isAcceptableOrUnknown(
              data['balance_after']!, _balanceAfterMeta));
    } else if (isInserting) {
      context.missing(_balanceAfterMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditTransaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      rentalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rental_id']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      balanceAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance_after'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CreditTransactionsTable createAlias(String alias) {
    return $CreditTransactionsTable(attachedDatabase, alias);
  }
}

class CreditTransaction extends DataClass
    implements Insertable<CreditTransaction> {
  final String id;
  final String userId;
  final double amount;
  final String type;
  final String? rentalId;
  final String description;
  final double balanceAfter;
  final DateTime createdAt;
  const CreditTransaction(
      {required this.id,
      required this.userId,
      required this.amount,
      required this.type,
      this.rentalId,
      required this.description,
      required this.balanceAfter,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || rentalId != null) {
      map['rental_id'] = Variable<String>(rentalId);
    }
    map['description'] = Variable<String>(description);
    map['balance_after'] = Variable<double>(balanceAfter);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CreditTransactionsCompanion toCompanion(bool nullToAbsent) {
    return CreditTransactionsCompanion(
      id: Value(id),
      userId: Value(userId),
      amount: Value(amount),
      type: Value(type),
      rentalId: rentalId == null && nullToAbsent
          ? const Value.absent()
          : Value(rentalId),
      description: Value(description),
      balanceAfter: Value(balanceAfter),
      createdAt: Value(createdAt),
    );
  }

  factory CreditTransaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditTransaction(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      rentalId: serializer.fromJson<String?>(json['rentalId']),
      description: serializer.fromJson<String>(json['description']),
      balanceAfter: serializer.fromJson<double>(json['balanceAfter']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'rentalId': serializer.toJson<String?>(rentalId),
      'description': serializer.toJson<String>(description),
      'balanceAfter': serializer.toJson<double>(balanceAfter),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CreditTransaction copyWith(
          {String? id,
          String? userId,
          double? amount,
          String? type,
          Value<String?> rentalId = const Value.absent(),
          String? description,
          double? balanceAfter,
          DateTime? createdAt}) =>
      CreditTransaction(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        rentalId: rentalId.present ? rentalId.value : this.rentalId,
        description: description ?? this.description,
        balanceAfter: balanceAfter ?? this.balanceAfter,
        createdAt: createdAt ?? this.createdAt,
      );
  CreditTransaction copyWithCompanion(CreditTransactionsCompanion data) {
    return CreditTransaction(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      rentalId: data.rentalId.present ? data.rentalId.value : this.rentalId,
      description:
          data.description.present ? data.description.value : this.description,
      balanceAfter: data.balanceAfter.present
          ? data.balanceAfter.value
          : this.balanceAfter,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditTransaction(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('rentalId: $rentalId, ')
          ..write('description: $description, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, amount, type, rentalId, description, balanceAfter, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditTransaction &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.rentalId == this.rentalId &&
          other.description == this.description &&
          other.balanceAfter == this.balanceAfter &&
          other.createdAt == this.createdAt);
}

class CreditTransactionsCompanion extends UpdateCompanion<CreditTransaction> {
  final Value<String> id;
  final Value<String> userId;
  final Value<double> amount;
  final Value<String> type;
  final Value<String?> rentalId;
  final Value<String> description;
  final Value<double> balanceAfter;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CreditTransactionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.rentalId = const Value.absent(),
    this.description = const Value.absent(),
    this.balanceAfter = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditTransactionsCompanion.insert({
    required String id,
    required String userId,
    required double amount,
    required String type,
    this.rentalId = const Value.absent(),
    required String description,
    required double balanceAfter,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        amount = Value(amount),
        type = Value(type),
        description = Value(description),
        balanceAfter = Value(balanceAfter),
        createdAt = Value(createdAt);
  static Insertable<CreditTransaction> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? rentalId,
    Expression<String>? description,
    Expression<double>? balanceAfter,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (rentalId != null) 'rental_id': rentalId,
      if (description != null) 'description': description,
      if (balanceAfter != null) 'balance_after': balanceAfter,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditTransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<double>? amount,
      Value<String>? type,
      Value<String?>? rentalId,
      Value<String>? description,
      Value<double>? balanceAfter,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CreditTransactionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      rentalId: rentalId ?? this.rentalId,
      description: description ?? this.description,
      balanceAfter: balanceAfter ?? this.balanceAfter,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rentalId.present) {
      map['rental_id'] = Variable<String>(rentalId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (balanceAfter.present) {
      map['balance_after'] = Variable<double>(balanceAfter.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('rentalId: $rentalId, ')
          ..write('description: $description, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonsTable extends Lessons with TableInfo<$LessonsTable, Lesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _coachIdMeta =
      const VerificationMeta('coachId');
  @override
  late final GeneratedColumn<String> coachId = GeneratedColumn<String>(
      'coach_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _courtIdMeta =
      const VerificationMeta('courtId');
  @override
  late final GeneratedColumn<String> courtId = GeneratedColumn<String>(
      'court_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES courts (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _maxParticipantsMeta =
      const VerificationMeta('maxParticipants');
  @override
  late final GeneratedColumn<int> maxParticipants = GeneratedColumn<int>(
      'max_participants', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _isTemplateMeta =
      const VerificationMeta('isTemplate');
  @override
  late final GeneratedColumn<bool> isTemplate = GeneratedColumn<bool>(
      'is_template', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_template" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('confirmed'));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _seriesIdMeta =
      const VerificationMeta('seriesId');
  @override
  late final GeneratedColumn<String> seriesId = GeneratedColumn<String>(
      'series_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _representativeUserIdMeta =
      const VerificationMeta('representativeUserId');
  @override
  late final GeneratedColumn<String> representativeUserId =
      GeneratedColumn<String>(
          'representative_user_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints:
              GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        coachId,
        courtId,
        type,
        startTime,
        endTime,
        maxParticipants,
        isTemplate,
        status,
        price,
        title,
        notes,
        seriesId,
        colorHex,
        representativeUserId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(Insertable<Lesson> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('coach_id')) {
      context.handle(_coachIdMeta,
          coachId.isAcceptableOrUnknown(data['coach_id']!, _coachIdMeta));
    } else if (isInserting) {
      context.missing(_coachIdMeta);
    }
    if (data.containsKey('court_id')) {
      context.handle(_courtIdMeta,
          courtId.isAcceptableOrUnknown(data['court_id']!, _courtIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('max_participants')) {
      context.handle(
          _maxParticipantsMeta,
          maxParticipants.isAcceptableOrUnknown(
              data['max_participants']!, _maxParticipantsMeta));
    }
    if (data.containsKey('is_template')) {
      context.handle(
          _isTemplateMeta,
          isTemplate.isAcceptableOrUnknown(
              data['is_template']!, _isTemplateMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('series_id')) {
      context.handle(_seriesIdMeta,
          seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta));
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    }
    if (data.containsKey('representative_user_id')) {
      context.handle(
          _representativeUserIdMeta,
          representativeUserId.isAcceptableOrUnknown(
              data['representative_user_id']!, _representativeUserIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lesson(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      coachId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coach_id'])!,
      courtId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}court_id']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time'])!,
      maxParticipants: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_participants'])!,
      isTemplate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_template'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      seriesId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}series_id']),
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex']),
      representativeUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}representative_user_id']),
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class Lesson extends DataClass implements Insertable<Lesson> {
  final String id;
  final String coachId;
  final String? courtId;
  final String type;
  final DateTime startTime;
  final DateTime endTime;
  final int maxParticipants;
  final bool isTemplate;

  /// 'tentative' | 'confirmed'
  final String status;
  final double? price;
  final String? title;
  final String? notes;

  /// Haftalık tekrar serisi kimliği (olası dersler).
  final String? seriesId;

  /// Özel renk (#RRGGBB). Boşsa antrenör rengi kullanılır.
  final String? colorHex;

  /// Grup dersi temsilci öğrencisi.
  final String? representativeUserId;
  const Lesson(
      {required this.id,
      required this.coachId,
      this.courtId,
      required this.type,
      required this.startTime,
      required this.endTime,
      required this.maxParticipants,
      required this.isTemplate,
      required this.status,
      this.price,
      this.title,
      this.notes,
      this.seriesId,
      this.colorHex,
      this.representativeUserId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['coach_id'] = Variable<String>(coachId);
    if (!nullToAbsent || courtId != null) {
      map['court_id'] = Variable<String>(courtId);
    }
    map['type'] = Variable<String>(type);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['max_participants'] = Variable<int>(maxParticipants);
    map['is_template'] = Variable<bool>(isTemplate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || seriesId != null) {
      map['series_id'] = Variable<String>(seriesId);
    }
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    if (!nullToAbsent || representativeUserId != null) {
      map['representative_user_id'] = Variable<String>(representativeUserId);
    }
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      coachId: Value(coachId),
      courtId: courtId == null && nullToAbsent
          ? const Value.absent()
          : Value(courtId),
      type: Value(type),
      startTime: Value(startTime),
      endTime: Value(endTime),
      maxParticipants: Value(maxParticipants),
      isTemplate: Value(isTemplate),
      status: Value(status),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      seriesId: seriesId == null && nullToAbsent
          ? const Value.absent()
          : Value(seriesId),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      representativeUserId: representativeUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(representativeUserId),
    );
  }

  factory Lesson.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lesson(
      id: serializer.fromJson<String>(json['id']),
      coachId: serializer.fromJson<String>(json['coachId']),
      courtId: serializer.fromJson<String?>(json['courtId']),
      type: serializer.fromJson<String>(json['type']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      maxParticipants: serializer.fromJson<int>(json['maxParticipants']),
      isTemplate: serializer.fromJson<bool>(json['isTemplate']),
      status: serializer.fromJson<String>(json['status']),
      price: serializer.fromJson<double?>(json['price']),
      title: serializer.fromJson<String?>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      seriesId: serializer.fromJson<String?>(json['seriesId']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      representativeUserId:
          serializer.fromJson<String?>(json['representativeUserId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'coachId': serializer.toJson<String>(coachId),
      'courtId': serializer.toJson<String?>(courtId),
      'type': serializer.toJson<String>(type),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'maxParticipants': serializer.toJson<int>(maxParticipants),
      'isTemplate': serializer.toJson<bool>(isTemplate),
      'status': serializer.toJson<String>(status),
      'price': serializer.toJson<double?>(price),
      'title': serializer.toJson<String?>(title),
      'notes': serializer.toJson<String?>(notes),
      'seriesId': serializer.toJson<String?>(seriesId),
      'colorHex': serializer.toJson<String?>(colorHex),
      'representativeUserId': serializer.toJson<String?>(representativeUserId),
    };
  }

  Lesson copyWith(
          {String? id,
          String? coachId,
          Value<String?> courtId = const Value.absent(),
          String? type,
          DateTime? startTime,
          DateTime? endTime,
          int? maxParticipants,
          bool? isTemplate,
          String? status,
          Value<double?> price = const Value.absent(),
          Value<String?> title = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> seriesId = const Value.absent(),
          Value<String?> colorHex = const Value.absent(),
          Value<String?> representativeUserId = const Value.absent()}) =>
      Lesson(
        id: id ?? this.id,
        coachId: coachId ?? this.coachId,
        courtId: courtId.present ? courtId.value : this.courtId,
        type: type ?? this.type,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        maxParticipants: maxParticipants ?? this.maxParticipants,
        isTemplate: isTemplate ?? this.isTemplate,
        status: status ?? this.status,
        price: price.present ? price.value : this.price,
        title: title.present ? title.value : this.title,
        notes: notes.present ? notes.value : this.notes,
        seriesId: seriesId.present ? seriesId.value : this.seriesId,
        colorHex: colorHex.present ? colorHex.value : this.colorHex,
        representativeUserId: representativeUserId.present
            ? representativeUserId.value
            : this.representativeUserId,
      );
  Lesson copyWithCompanion(LessonsCompanion data) {
    return Lesson(
      id: data.id.present ? data.id.value : this.id,
      coachId: data.coachId.present ? data.coachId.value : this.coachId,
      courtId: data.courtId.present ? data.courtId.value : this.courtId,
      type: data.type.present ? data.type.value : this.type,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      maxParticipants: data.maxParticipants.present
          ? data.maxParticipants.value
          : this.maxParticipants,
      isTemplate:
          data.isTemplate.present ? data.isTemplate.value : this.isTemplate,
      status: data.status.present ? data.status.value : this.status,
      price: data.price.present ? data.price.value : this.price,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      representativeUserId: data.representativeUserId.present
          ? data.representativeUserId.value
          : this.representativeUserId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lesson(')
          ..write('id: $id, ')
          ..write('coachId: $coachId, ')
          ..write('courtId: $courtId, ')
          ..write('type: $type, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('maxParticipants: $maxParticipants, ')
          ..write('isTemplate: $isTemplate, ')
          ..write('status: $status, ')
          ..write('price: $price, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('seriesId: $seriesId, ')
          ..write('colorHex: $colorHex, ')
          ..write('representativeUserId: $representativeUserId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      coachId,
      courtId,
      type,
      startTime,
      endTime,
      maxParticipants,
      isTemplate,
      status,
      price,
      title,
      notes,
      seriesId,
      colorHex,
      representativeUserId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lesson &&
          other.id == this.id &&
          other.coachId == this.coachId &&
          other.courtId == this.courtId &&
          other.type == this.type &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.maxParticipants == this.maxParticipants &&
          other.isTemplate == this.isTemplate &&
          other.status == this.status &&
          other.price == this.price &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.seriesId == this.seriesId &&
          other.colorHex == this.colorHex &&
          other.representativeUserId == this.representativeUserId);
}

class LessonsCompanion extends UpdateCompanion<Lesson> {
  final Value<String> id;
  final Value<String> coachId;
  final Value<String?> courtId;
  final Value<String> type;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<int> maxParticipants;
  final Value<bool> isTemplate;
  final Value<String> status;
  final Value<double?> price;
  final Value<String?> title;
  final Value<String?> notes;
  final Value<String?> seriesId;
  final Value<String?> colorHex;
  final Value<String?> representativeUserId;
  final Value<int> rowid;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.coachId = const Value.absent(),
    this.courtId = const Value.absent(),
    this.type = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.maxParticipants = const Value.absent(),
    this.isTemplate = const Value.absent(),
    this.status = const Value.absent(),
    this.price = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.seriesId = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.representativeUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonsCompanion.insert({
    required String id,
    required String coachId,
    this.courtId = const Value.absent(),
    required String type,
    required DateTime startTime,
    required DateTime endTime,
    this.maxParticipants = const Value.absent(),
    this.isTemplate = const Value.absent(),
    this.status = const Value.absent(),
    this.price = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.seriesId = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.representativeUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        coachId = Value(coachId),
        type = Value(type),
        startTime = Value(startTime),
        endTime = Value(endTime);
  static Insertable<Lesson> custom({
    Expression<String>? id,
    Expression<String>? coachId,
    Expression<String>? courtId,
    Expression<String>? type,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? maxParticipants,
    Expression<bool>? isTemplate,
    Expression<String>? status,
    Expression<double>? price,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? seriesId,
    Expression<String>? colorHex,
    Expression<String>? representativeUserId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (coachId != null) 'coach_id': coachId,
      if (courtId != null) 'court_id': courtId,
      if (type != null) 'type': type,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (maxParticipants != null) 'max_participants': maxParticipants,
      if (isTemplate != null) 'is_template': isTemplate,
      if (status != null) 'status': status,
      if (price != null) 'price': price,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (seriesId != null) 'series_id': seriesId,
      if (colorHex != null) 'color_hex': colorHex,
      if (representativeUserId != null)
        'representative_user_id': representativeUserId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonsCompanion copyWith(
      {Value<String>? id,
      Value<String>? coachId,
      Value<String?>? courtId,
      Value<String>? type,
      Value<DateTime>? startTime,
      Value<DateTime>? endTime,
      Value<int>? maxParticipants,
      Value<bool>? isTemplate,
      Value<String>? status,
      Value<double?>? price,
      Value<String?>? title,
      Value<String?>? notes,
      Value<String?>? seriesId,
      Value<String?>? colorHex,
      Value<String?>? representativeUserId,
      Value<int>? rowid}) {
    return LessonsCompanion(
      id: id ?? this.id,
      coachId: coachId ?? this.coachId,
      courtId: courtId ?? this.courtId,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      isTemplate: isTemplate ?? this.isTemplate,
      status: status ?? this.status,
      price: price ?? this.price,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      seriesId: seriesId ?? this.seriesId,
      colorHex: colorHex ?? this.colorHex,
      representativeUserId: representativeUserId ?? this.representativeUserId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (coachId.present) {
      map['coach_id'] = Variable<String>(coachId.value);
    }
    if (courtId.present) {
      map['court_id'] = Variable<String>(courtId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (maxParticipants.present) {
      map['max_participants'] = Variable<int>(maxParticipants.value);
    }
    if (isTemplate.present) {
      map['is_template'] = Variable<bool>(isTemplate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (seriesId.present) {
      map['series_id'] = Variable<String>(seriesId.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (representativeUserId.present) {
      map['representative_user_id'] =
          Variable<String>(representativeUserId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('coachId: $coachId, ')
          ..write('courtId: $courtId, ')
          ..write('type: $type, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('maxParticipants: $maxParticipants, ')
          ..write('isTemplate: $isTemplate, ')
          ..write('status: $status, ')
          ..write('price: $price, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('seriesId: $seriesId, ')
          ..write('colorHex: $colorHex, ')
          ..write('representativeUserId: $representativeUserId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonParticipantsTable extends LessonParticipants
    with TableInfo<$LessonParticipantsTable, LessonParticipant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonParticipantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES lessons (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, lessonId, userId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_participants';
  @override
  VerificationContext validateIntegrity(Insertable<LessonParticipant> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonParticipant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonParticipant(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
    );
  }

  @override
  $LessonParticipantsTable createAlias(String alias) {
    return $LessonParticipantsTable(attachedDatabase, alias);
  }
}

class LessonParticipant extends DataClass
    implements Insertable<LessonParticipant> {
  final String id;
  final String lessonId;
  final String userId;
  const LessonParticipant(
      {required this.id, required this.lessonId, required this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['user_id'] = Variable<String>(userId);
    return map;
  }

  LessonParticipantsCompanion toCompanion(bool nullToAbsent) {
    return LessonParticipantsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      userId: Value(userId),
    );
  }

  factory LessonParticipant.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonParticipant(
      id: serializer.fromJson<String>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      userId: serializer.fromJson<String>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'userId': serializer.toJson<String>(userId),
    };
  }

  LessonParticipant copyWith({String? id, String? lessonId, String? userId}) =>
      LessonParticipant(
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        userId: userId ?? this.userId,
      );
  LessonParticipant copyWithCompanion(LessonParticipantsCompanion data) {
    return LessonParticipant(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonParticipant(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lessonId, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonParticipant &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.userId == this.userId);
}

class LessonParticipantsCompanion extends UpdateCompanion<LessonParticipant> {
  final Value<String> id;
  final Value<String> lessonId;
  final Value<String> userId;
  final Value<int> rowid;
  const LessonParticipantsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonParticipantsCompanion.insert({
    required String id,
    required String lessonId,
    required String userId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        lessonId = Value(lessonId),
        userId = Value(userId);
  static Insertable<LessonParticipant> custom({
    Expression<String>? id,
    Expression<String>? lessonId,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonParticipantsCompanion copyWith(
      {Value<String>? id,
      Value<String>? lessonId,
      Value<String>? userId,
      Value<int>? rowid}) {
    return LessonParticipantsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonParticipantsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdByIdMeta =
      const VerificationMeta('createdById');
  @override
  late final GeneratedColumn<String> createdById = GeneratedColumn<String>(
      'created_by_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        amount,
        description,
        dueDate,
        paidAt,
        status,
        createdById,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<Payment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_by_id')) {
      context.handle(
          _createdByIdMeta,
          createdById.isAcceptableOrUnknown(
              data['created_by_id']!, _createdByIdMeta));
    } else if (isInserting) {
      context.missing(_createdByIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdById: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final String id;
  final String userId;
  final double amount;
  final String description;
  final DateTime dueDate;
  final DateTime? paidAt;
  final String status;
  final String createdById;
  final DateTime createdAt;
  const Payment(
      {required this.id,
      required this.userId,
      required this.amount,
      required this.description,
      required this.dueDate,
      this.paidAt,
      required this.status,
      required this.createdById,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['amount'] = Variable<double>(amount);
    map['description'] = Variable<String>(description);
    map['due_date'] = Variable<DateTime>(dueDate);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    map['status'] = Variable<String>(status);
    map['created_by_id'] = Variable<String>(createdById);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      userId: Value(userId),
      amount: Value(amount),
      description: Value(description),
      dueDate: Value(dueDate),
      paidAt:
          paidAt == null && nullToAbsent ? const Value.absent() : Value(paidAt),
      status: Value(status),
      createdById: Value(createdById),
      createdAt: Value(createdAt),
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String>(json['description']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
      status: serializer.fromJson<String>(json['status']),
      createdById: serializer.fromJson<String>(json['createdById']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String>(description),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
      'status': serializer.toJson<String>(status),
      'createdById': serializer.toJson<String>(createdById),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Payment copyWith(
          {String? id,
          String? userId,
          double? amount,
          String? description,
          DateTime? dueDate,
          Value<DateTime?> paidAt = const Value.absent(),
          String? status,
          String? createdById,
          DateTime? createdAt}) =>
      Payment(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        amount: amount ?? this.amount,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        paidAt: paidAt.present ? paidAt.value : this.paidAt,
        status: status ?? this.status,
        createdById: createdById ?? this.createdById,
        createdAt: createdAt ?? this.createdAt,
      );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      amount: data.amount.present ? data.amount.value : this.amount,
      description:
          data.description.present ? data.description.value : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      status: data.status.present ? data.status.value : this.status,
      createdById:
          data.createdById.present ? data.createdById.value : this.createdById,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('paidAt: $paidAt, ')
          ..write('status: $status, ')
          ..write('createdById: $createdById, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, amount, description, dueDate,
      paidAt, status, createdById, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.paidAt == this.paidAt &&
          other.status == this.status &&
          other.createdById == this.createdById &&
          other.createdAt == this.createdAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<String> id;
  final Value<String> userId;
  final Value<double> amount;
  final Value<String> description;
  final Value<DateTime> dueDate;
  final Value<DateTime?> paidAt;
  final Value<String> status;
  final Value<String> createdById;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.status = const Value.absent(),
    this.createdById = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String id,
    required String userId,
    required double amount,
    required String description,
    required DateTime dueDate,
    this.paidAt = const Value.absent(),
    required String status,
    required String createdById,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        amount = Value(amount),
        description = Value(description),
        dueDate = Value(dueDate),
        status = Value(status),
        createdById = Value(createdById),
        createdAt = Value(createdAt);
  static Insertable<Payment> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? paidAt,
    Expression<String>? status,
    Expression<String>? createdById,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (paidAt != null) 'paid_at': paidAt,
      if (status != null) 'status': status,
      if (createdById != null) 'created_by_id': createdById,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<double>? amount,
      Value<String>? description,
      Value<DateTime>? dueDate,
      Value<DateTime?>? paidAt,
      Value<String>? status,
      Value<String>? createdById,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PaymentsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      paidAt: paidAt ?? this.paidAt,
      status: status ?? this.status,
      createdById: createdById ?? this.createdById,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdById.present) {
      map['created_by_id'] = Variable<String>(createdById.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('paidAt: $paidAt, ')
          ..write('status: $status, ')
          ..write('createdById: $createdById, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudentProfilesTable extends StudentProfiles
    with TableInfo<$StudentProfilesTable, StudentProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _coachIdMeta =
      const VerificationMeta('coachId');
  @override
  late final GeneratedColumn<String> coachId = GeneratedColumn<String>(
      'coach_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
      'age', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [userId, coachId, age, level, notes, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'student_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<StudentProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('coach_id')) {
      context.handle(_coachIdMeta,
          coachId.isAcceptableOrUnknown(data['coach_id']!, _coachIdMeta));
    } else if (isInserting) {
      context.missing(_coachIdMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age']!, _ageMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  StudentProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentProfile(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      coachId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coach_id'])!,
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age']),
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $StudentProfilesTable createAlias(String alias) {
    return $StudentProfilesTable(attachedDatabase, alias);
  }
}

class StudentProfile extends DataClass implements Insertable<StudentProfile> {
  final String userId;
  final String coachId;
  final int? age;
  final String? level;
  final String? notes;
  final DateTime updatedAt;
  const StudentProfile(
      {required this.userId,
      required this.coachId,
      this.age,
      this.level,
      this.notes,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['coach_id'] = Variable<String>(coachId);
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<String>(level);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StudentProfilesCompanion toCompanion(bool nullToAbsent) {
    return StudentProfilesCompanion(
      userId: Value(userId),
      coachId: Value(coachId),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      level:
          level == null && nullToAbsent ? const Value.absent() : Value(level),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      updatedAt: Value(updatedAt),
    );
  }

  factory StudentProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentProfile(
      userId: serializer.fromJson<String>(json['userId']),
      coachId: serializer.fromJson<String>(json['coachId']),
      age: serializer.fromJson<int?>(json['age']),
      level: serializer.fromJson<String?>(json['level']),
      notes: serializer.fromJson<String?>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'coachId': serializer.toJson<String>(coachId),
      'age': serializer.toJson<int?>(age),
      'level': serializer.toJson<String?>(level),
      'notes': serializer.toJson<String?>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StudentProfile copyWith(
          {String? userId,
          String? coachId,
          Value<int?> age = const Value.absent(),
          Value<String?> level = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? updatedAt}) =>
      StudentProfile(
        userId: userId ?? this.userId,
        coachId: coachId ?? this.coachId,
        age: age.present ? age.value : this.age,
        level: level.present ? level.value : this.level,
        notes: notes.present ? notes.value : this.notes,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  StudentProfile copyWithCompanion(StudentProfilesCompanion data) {
    return StudentProfile(
      userId: data.userId.present ? data.userId.value : this.userId,
      coachId: data.coachId.present ? data.coachId.value : this.coachId,
      age: data.age.present ? data.age.value : this.age,
      level: data.level.present ? data.level.value : this.level,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentProfile(')
          ..write('userId: $userId, ')
          ..write('coachId: $coachId, ')
          ..write('age: $age, ')
          ..write('level: $level, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, coachId, age, level, notes, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentProfile &&
          other.userId == this.userId &&
          other.coachId == this.coachId &&
          other.age == this.age &&
          other.level == this.level &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt);
}

class StudentProfilesCompanion extends UpdateCompanion<StudentProfile> {
  final Value<String> userId;
  final Value<String> coachId;
  final Value<int?> age;
  final Value<String?> level;
  final Value<String?> notes;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StudentProfilesCompanion({
    this.userId = const Value.absent(),
    this.coachId = const Value.absent(),
    this.age = const Value.absent(),
    this.level = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentProfilesCompanion.insert({
    required String userId,
    required String coachId,
    this.age = const Value.absent(),
    this.level = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        coachId = Value(coachId),
        updatedAt = Value(updatedAt);
  static Insertable<StudentProfile> custom({
    Expression<String>? userId,
    Expression<String>? coachId,
    Expression<int>? age,
    Expression<String>? level,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (coachId != null) 'coach_id': coachId,
      if (age != null) 'age': age,
      if (level != null) 'level': level,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentProfilesCompanion copyWith(
      {Value<String>? userId,
      Value<String>? coachId,
      Value<int?>? age,
      Value<String?>? level,
      Value<String?>? notes,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return StudentProfilesCompanion(
      userId: userId ?? this.userId,
      coachId: coachId ?? this.coachId,
      age: age ?? this.age,
      level: level ?? this.level,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (coachId.present) {
      map['coach_id'] = Variable<String>(coachId.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentProfilesCompanion(')
          ..write('userId: $userId, ')
          ..write('coachId: $coachId, ')
          ..write('age: $age, ')
          ..write('level: $level, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParentAthleteLinksTable extends ParentAthleteLinks
    with TableInfo<$ParentAthleteLinksTable, ParentAthleteLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParentAthleteLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _athleteIdMeta =
      const VerificationMeta('athleteId');
  @override
  late final GeneratedColumn<String> athleteId = GeneratedColumn<String>(
      'athlete_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  @override
  List<GeneratedColumn> get $columns => [parentId, athleteId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parent_athlete_links';
  @override
  VerificationContext validateIntegrity(Insertable<ParentAthleteLink> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    if (data.containsKey('athlete_id')) {
      context.handle(_athleteIdMeta,
          athleteId.isAcceptableOrUnknown(data['athlete_id']!, _athleteIdMeta));
    } else if (isInserting) {
      context.missing(_athleteIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {parentId, athleteId};
  @override
  ParentAthleteLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParentAthleteLink(
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id'])!,
      athleteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}athlete_id'])!,
    );
  }

  @override
  $ParentAthleteLinksTable createAlias(String alias) {
    return $ParentAthleteLinksTable(attachedDatabase, alias);
  }
}

class ParentAthleteLink extends DataClass
    implements Insertable<ParentAthleteLink> {
  final String parentId;
  final String athleteId;
  const ParentAthleteLink({required this.parentId, required this.athleteId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['parent_id'] = Variable<String>(parentId);
    map['athlete_id'] = Variable<String>(athleteId);
    return map;
  }

  ParentAthleteLinksCompanion toCompanion(bool nullToAbsent) {
    return ParentAthleteLinksCompanion(
      parentId: Value(parentId),
      athleteId: Value(athleteId),
    );
  }

  factory ParentAthleteLink.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParentAthleteLink(
      parentId: serializer.fromJson<String>(json['parentId']),
      athleteId: serializer.fromJson<String>(json['athleteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'parentId': serializer.toJson<String>(parentId),
      'athleteId': serializer.toJson<String>(athleteId),
    };
  }

  ParentAthleteLink copyWith({String? parentId, String? athleteId}) =>
      ParentAthleteLink(
        parentId: parentId ?? this.parentId,
        athleteId: athleteId ?? this.athleteId,
      );
  ParentAthleteLink copyWithCompanion(ParentAthleteLinksCompanion data) {
    return ParentAthleteLink(
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      athleteId: data.athleteId.present ? data.athleteId.value : this.athleteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParentAthleteLink(')
          ..write('parentId: $parentId, ')
          ..write('athleteId: $athleteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(parentId, athleteId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParentAthleteLink &&
          other.parentId == this.parentId &&
          other.athleteId == this.athleteId);
}

class ParentAthleteLinksCompanion extends UpdateCompanion<ParentAthleteLink> {
  final Value<String> parentId;
  final Value<String> athleteId;
  final Value<int> rowid;
  const ParentAthleteLinksCompanion({
    this.parentId = const Value.absent(),
    this.athleteId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParentAthleteLinksCompanion.insert({
    required String parentId,
    required String athleteId,
    this.rowid = const Value.absent(),
  })  : parentId = Value(parentId),
        athleteId = Value(athleteId);
  static Insertable<ParentAthleteLink> custom({
    Expression<String>? parentId,
    Expression<String>? athleteId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (parentId != null) 'parent_id': parentId,
      if (athleteId != null) 'athlete_id': athleteId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParentAthleteLinksCompanion copyWith(
      {Value<String>? parentId, Value<String>? athleteId, Value<int>? rowid}) {
    return ParentAthleteLinksCompanion(
      parentId: parentId ?? this.parentId,
      athleteId: athleteId ?? this.athleteId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (athleteId.present) {
      map['athlete_id'] = Variable<String>(athleteId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParentAthleteLinksCompanion(')
          ..write('parentId: $parentId, ')
          ..write('athleteId: $athleteId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonAttendancesTable extends LessonAttendances
    with TableInfo<$LessonAttendancesTable, LessonAttendance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonAttendancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES lessons (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _markedAtMeta =
      const VerificationMeta('markedAt');
  @override
  late final GeneratedColumn<DateTime> markedAt = GeneratedColumn<DateTime>(
      'marked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _markedByIdMeta =
      const VerificationMeta('markedById');
  @override
  late final GeneratedColumn<String> markedById = GeneratedColumn<String>(
      'marked_by_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, lessonId, userId, status, markedAt, markedById, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_attendances';
  @override
  VerificationContext validateIntegrity(Insertable<LessonAttendance> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('marked_at')) {
      context.handle(_markedAtMeta,
          markedAt.isAcceptableOrUnknown(data['marked_at']!, _markedAtMeta));
    } else if (isInserting) {
      context.missing(_markedAtMeta);
    }
    if (data.containsKey('marked_by_id')) {
      context.handle(
          _markedByIdMeta,
          markedById.isAcceptableOrUnknown(
              data['marked_by_id']!, _markedByIdMeta));
    } else if (isInserting) {
      context.missing(_markedByIdMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonAttendance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonAttendance(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      markedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}marked_at'])!,
      markedById: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}marked_by_id'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $LessonAttendancesTable createAlias(String alias) {
    return $LessonAttendancesTable(attachedDatabase, alias);
  }
}

class LessonAttendance extends DataClass
    implements Insertable<LessonAttendance> {
  final String id;
  final String lessonId;
  final String userId;
  final String status;
  final DateTime markedAt;
  final String markedById;
  final String? notes;
  const LessonAttendance(
      {required this.id,
      required this.lessonId,
      required this.userId,
      required this.status,
      required this.markedAt,
      required this.markedById,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['user_id'] = Variable<String>(userId);
    map['status'] = Variable<String>(status);
    map['marked_at'] = Variable<DateTime>(markedAt);
    map['marked_by_id'] = Variable<String>(markedById);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  LessonAttendancesCompanion toCompanion(bool nullToAbsent) {
    return LessonAttendancesCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      userId: Value(userId),
      status: Value(status),
      markedAt: Value(markedAt),
      markedById: Value(markedById),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory LessonAttendance.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonAttendance(
      id: serializer.fromJson<String>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      userId: serializer.fromJson<String>(json['userId']),
      status: serializer.fromJson<String>(json['status']),
      markedAt: serializer.fromJson<DateTime>(json['markedAt']),
      markedById: serializer.fromJson<String>(json['markedById']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'userId': serializer.toJson<String>(userId),
      'status': serializer.toJson<String>(status),
      'markedAt': serializer.toJson<DateTime>(markedAt),
      'markedById': serializer.toJson<String>(markedById),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  LessonAttendance copyWith(
          {String? id,
          String? lessonId,
          String? userId,
          String? status,
          DateTime? markedAt,
          String? markedById,
          Value<String?> notes = const Value.absent()}) =>
      LessonAttendance(
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        userId: userId ?? this.userId,
        status: status ?? this.status,
        markedAt: markedAt ?? this.markedAt,
        markedById: markedById ?? this.markedById,
        notes: notes.present ? notes.value : this.notes,
      );
  LessonAttendance copyWithCompanion(LessonAttendancesCompanion data) {
    return LessonAttendance(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      userId: data.userId.present ? data.userId.value : this.userId,
      status: data.status.present ? data.status.value : this.status,
      markedAt: data.markedAt.present ? data.markedAt.value : this.markedAt,
      markedById:
          data.markedById.present ? data.markedById.value : this.markedById,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonAttendance(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('userId: $userId, ')
          ..write('status: $status, ')
          ..write('markedAt: $markedAt, ')
          ..write('markedById: $markedById, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lessonId, userId, status, markedAt, markedById, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonAttendance &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.userId == this.userId &&
          other.status == this.status &&
          other.markedAt == this.markedAt &&
          other.markedById == this.markedById &&
          other.notes == this.notes);
}

class LessonAttendancesCompanion extends UpdateCompanion<LessonAttendance> {
  final Value<String> id;
  final Value<String> lessonId;
  final Value<String> userId;
  final Value<String> status;
  final Value<DateTime> markedAt;
  final Value<String> markedById;
  final Value<String?> notes;
  final Value<int> rowid;
  const LessonAttendancesCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.userId = const Value.absent(),
    this.status = const Value.absent(),
    this.markedAt = const Value.absent(),
    this.markedById = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonAttendancesCompanion.insert({
    required String id,
    required String lessonId,
    required String userId,
    required String status,
    required DateTime markedAt,
    required String markedById,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        lessonId = Value(lessonId),
        userId = Value(userId),
        status = Value(status),
        markedAt = Value(markedAt),
        markedById = Value(markedById);
  static Insertable<LessonAttendance> custom({
    Expression<String>? id,
    Expression<String>? lessonId,
    Expression<String>? userId,
    Expression<String>? status,
    Expression<DateTime>? markedAt,
    Expression<String>? markedById,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (userId != null) 'user_id': userId,
      if (status != null) 'status': status,
      if (markedAt != null) 'marked_at': markedAt,
      if (markedById != null) 'marked_by_id': markedById,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonAttendancesCompanion copyWith(
      {Value<String>? id,
      Value<String>? lessonId,
      Value<String>? userId,
      Value<String>? status,
      Value<DateTime>? markedAt,
      Value<String>? markedById,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return LessonAttendancesCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      markedAt: markedAt ?? this.markedAt,
      markedById: markedById ?? this.markedById,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (markedAt.present) {
      map['marked_at'] = Variable<DateTime>(markedAt.value);
    }
    if (markedById.present) {
      map['marked_by_id'] = Variable<String>(markedById.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonAttendancesCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('userId: $userId, ')
          ..write('status: $status, ')
          ..write('markedAt: $markedAt, ')
          ..write('markedById: $markedById, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeeklyCourtRightsTable extends WeeklyCourtRights
    with TableInfo<$WeeklyCourtRightsTable, WeeklyCourtRight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyCourtRightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weekdayMeta =
      const VerificationMeta('weekday');
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
      'weekday', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _courtIdMeta =
      const VerificationMeta('courtId');
  @override
  late final GeneratedColumn<String> courtId = GeneratedColumn<String>(
      'court_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES courts (id)'));
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
      'hour', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _coachIdMeta =
      const VerificationMeta('coachId');
  @override
  late final GeneratedColumn<String> coachId = GeneratedColumn<String>(
      'coach_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, weekday, courtId, hour, coachId, label, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_court_rights';
  @override
  VerificationContext validateIntegrity(Insertable<WeeklyCourtRight> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(_weekdayMeta,
          weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta));
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('court_id')) {
      context.handle(_courtIdMeta,
          courtId.isAcceptableOrUnknown(data['court_id']!, _courtIdMeta));
    } else if (isInserting) {
      context.missing(_courtIdMeta);
    }
    if (data.containsKey('hour')) {
      context.handle(
          _hourMeta, hour.isAcceptableOrUnknown(data['hour']!, _hourMeta));
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('coach_id')) {
      context.handle(_coachIdMeta,
          coachId.isAcceptableOrUnknown(data['coach_id']!, _coachIdMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {weekday, courtId, hour},
      ];
  @override
  WeeklyCourtRight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyCourtRight(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      weekday: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekday'])!,
      courtId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}court_id'])!,
      hour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hour'])!,
      coachId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coach_id']),
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $WeeklyCourtRightsTable createAlias(String alias) {
    return $WeeklyCourtRightsTable(attachedDatabase, alias);
  }
}

class WeeklyCourtRight extends DataClass
    implements Insertable<WeeklyCourtRight> {
  final String id;

  /// DateTime.monday = 1 … saturday = 6
  final int weekday;
  final String courtId;
  final int hour;
  final String? coachId;
  final String? label;
  final DateTime updatedAt;
  const WeeklyCourtRight(
      {required this.id,
      required this.weekday,
      required this.courtId,
      required this.hour,
      this.coachId,
      this.label,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['weekday'] = Variable<int>(weekday);
    map['court_id'] = Variable<String>(courtId);
    map['hour'] = Variable<int>(hour);
    if (!nullToAbsent || coachId != null) {
      map['coach_id'] = Variable<String>(coachId);
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WeeklyCourtRightsCompanion toCompanion(bool nullToAbsent) {
    return WeeklyCourtRightsCompanion(
      id: Value(id),
      weekday: Value(weekday),
      courtId: Value(courtId),
      hour: Value(hour),
      coachId: coachId == null && nullToAbsent
          ? const Value.absent()
          : Value(coachId),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
      updatedAt: Value(updatedAt),
    );
  }

  factory WeeklyCourtRight.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyCourtRight(
      id: serializer.fromJson<String>(json['id']),
      weekday: serializer.fromJson<int>(json['weekday']),
      courtId: serializer.fromJson<String>(json['courtId']),
      hour: serializer.fromJson<int>(json['hour']),
      coachId: serializer.fromJson<String?>(json['coachId']),
      label: serializer.fromJson<String?>(json['label']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'weekday': serializer.toJson<int>(weekday),
      'courtId': serializer.toJson<String>(courtId),
      'hour': serializer.toJson<int>(hour),
      'coachId': serializer.toJson<String?>(coachId),
      'label': serializer.toJson<String?>(label),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WeeklyCourtRight copyWith(
          {String? id,
          int? weekday,
          String? courtId,
          int? hour,
          Value<String?> coachId = const Value.absent(),
          Value<String?> label = const Value.absent(),
          DateTime? updatedAt}) =>
      WeeklyCourtRight(
        id: id ?? this.id,
        weekday: weekday ?? this.weekday,
        courtId: courtId ?? this.courtId,
        hour: hour ?? this.hour,
        coachId: coachId.present ? coachId.value : this.coachId,
        label: label.present ? label.value : this.label,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  WeeklyCourtRight copyWithCompanion(WeeklyCourtRightsCompanion data) {
    return WeeklyCourtRight(
      id: data.id.present ? data.id.value : this.id,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      courtId: data.courtId.present ? data.courtId.value : this.courtId,
      hour: data.hour.present ? data.hour.value : this.hour,
      coachId: data.coachId.present ? data.coachId.value : this.coachId,
      label: data.label.present ? data.label.value : this.label,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyCourtRight(')
          ..write('id: $id, ')
          ..write('weekday: $weekday, ')
          ..write('courtId: $courtId, ')
          ..write('hour: $hour, ')
          ..write('coachId: $coachId, ')
          ..write('label: $label, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, weekday, courtId, hour, coachId, label, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyCourtRight &&
          other.id == this.id &&
          other.weekday == this.weekday &&
          other.courtId == this.courtId &&
          other.hour == this.hour &&
          other.coachId == this.coachId &&
          other.label == this.label &&
          other.updatedAt == this.updatedAt);
}

class WeeklyCourtRightsCompanion extends UpdateCompanion<WeeklyCourtRight> {
  final Value<String> id;
  final Value<int> weekday;
  final Value<String> courtId;
  final Value<int> hour;
  final Value<String?> coachId;
  final Value<String?> label;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WeeklyCourtRightsCompanion({
    this.id = const Value.absent(),
    this.weekday = const Value.absent(),
    this.courtId = const Value.absent(),
    this.hour = const Value.absent(),
    this.coachId = const Value.absent(),
    this.label = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeeklyCourtRightsCompanion.insert({
    required String id,
    required int weekday,
    required String courtId,
    required int hour,
    this.coachId = const Value.absent(),
    this.label = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        weekday = Value(weekday),
        courtId = Value(courtId),
        hour = Value(hour),
        updatedAt = Value(updatedAt);
  static Insertable<WeeklyCourtRight> custom({
    Expression<String>? id,
    Expression<int>? weekday,
    Expression<String>? courtId,
    Expression<int>? hour,
    Expression<String>? coachId,
    Expression<String>? label,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekday != null) 'weekday': weekday,
      if (courtId != null) 'court_id': courtId,
      if (hour != null) 'hour': hour,
      if (coachId != null) 'coach_id': coachId,
      if (label != null) 'label': label,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeeklyCourtRightsCompanion copyWith(
      {Value<String>? id,
      Value<int>? weekday,
      Value<String>? courtId,
      Value<int>? hour,
      Value<String?>? coachId,
      Value<String?>? label,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return WeeklyCourtRightsCompanion(
      id: id ?? this.id,
      weekday: weekday ?? this.weekday,
      courtId: courtId ?? this.courtId,
      hour: hour ?? this.hour,
      coachId: coachId ?? this.coachId,
      label: label ?? this.label,
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
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (courtId.present) {
      map['court_id'] = Variable<String>(courtId.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (coachId.present) {
      map['coach_id'] = Variable<String>(coachId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyCourtRightsCompanion(')
          ..write('id: $id, ')
          ..write('weekday: $weekday, ')
          ..write('courtId: $courtId, ')
          ..write('hour: $hour, ')
          ..write('coachId: $coachId, ')
          ..write('label: $label, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanChangeRequestsTable extends PlanChangeRequests
    with TableInfo<$PlanChangeRequestsTable, PlanChangeRequest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanChangeRequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _requesterIdMeta =
      const VerificationMeta('requesterId');
  @override
  late final GeneratedColumn<String> requesterId = GeneratedColumn<String>(
      'requester_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _weekdayMeta =
      const VerificationMeta('weekday');
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
      'weekday', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _courtIdMeta =
      const VerificationMeta('courtId');
  @override
  late final GeneratedColumn<String> courtId = GeneratedColumn<String>(
      'court_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES courts (id)'));
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
      'hour', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fromCoachIdMeta =
      const VerificationMeta('fromCoachId');
  @override
  late final GeneratedColumn<String> fromCoachId = GeneratedColumn<String>(
      'from_coach_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _toCoachIdMeta =
      const VerificationMeta('toCoachId');
  @override
  late final GeneratedColumn<String> toCoachId = GeneratedColumn<String>(
      'to_coach_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _resolvedAtMeta =
      const VerificationMeta('resolvedAt');
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
      'resolved_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _resolvedByIdMeta =
      const VerificationMeta('resolvedById');
  @override
  late final GeneratedColumn<String> resolvedById = GeneratedColumn<String>(
      'resolved_by_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        requesterId,
        weekday,
        courtId,
        hour,
        fromCoachId,
        toCoachId,
        note,
        status,
        createdAt,
        resolvedAt,
        resolvedById
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_change_requests';
  @override
  VerificationContext validateIntegrity(Insertable<PlanChangeRequest> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('requester_id')) {
      context.handle(
          _requesterIdMeta,
          requesterId.isAcceptableOrUnknown(
              data['requester_id']!, _requesterIdMeta));
    } else if (isInserting) {
      context.missing(_requesterIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(_weekdayMeta,
          weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta));
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('court_id')) {
      context.handle(_courtIdMeta,
          courtId.isAcceptableOrUnknown(data['court_id']!, _courtIdMeta));
    } else if (isInserting) {
      context.missing(_courtIdMeta);
    }
    if (data.containsKey('hour')) {
      context.handle(
          _hourMeta, hour.isAcceptableOrUnknown(data['hour']!, _hourMeta));
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('from_coach_id')) {
      context.handle(
          _fromCoachIdMeta,
          fromCoachId.isAcceptableOrUnknown(
              data['from_coach_id']!, _fromCoachIdMeta));
    }
    if (data.containsKey('to_coach_id')) {
      context.handle(
          _toCoachIdMeta,
          toCoachId.isAcceptableOrUnknown(
              data['to_coach_id']!, _toCoachIdMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
          _resolvedAtMeta,
          resolvedAt.isAcceptableOrUnknown(
              data['resolved_at']!, _resolvedAtMeta));
    }
    if (data.containsKey('resolved_by_id')) {
      context.handle(
          _resolvedByIdMeta,
          resolvedById.isAcceptableOrUnknown(
              data['resolved_by_id']!, _resolvedByIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanChangeRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanChangeRequest(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      requesterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}requester_id'])!,
      weekday: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekday'])!,
      courtId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}court_id'])!,
      hour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hour'])!,
      fromCoachId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_coach_id']),
      toCoachId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_coach_id']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      resolvedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}resolved_at']),
      resolvedById: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resolved_by_id']),
    );
  }

  @override
  $PlanChangeRequestsTable createAlias(String alias) {
    return $PlanChangeRequestsTable(attachedDatabase, alias);
  }
}

class PlanChangeRequest extends DataClass
    implements Insertable<PlanChangeRequest> {
  final String id;
  final String requesterId;
  final int weekday;
  final String courtId;
  final int hour;
  final String? fromCoachId;
  final String? toCoachId;
  final String? note;

  /// pending | approved | rejected
  final String status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolvedById;
  const PlanChangeRequest(
      {required this.id,
      required this.requesterId,
      required this.weekday,
      required this.courtId,
      required this.hour,
      this.fromCoachId,
      this.toCoachId,
      this.note,
      required this.status,
      required this.createdAt,
      this.resolvedAt,
      this.resolvedById});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['requester_id'] = Variable<String>(requesterId);
    map['weekday'] = Variable<int>(weekday);
    map['court_id'] = Variable<String>(courtId);
    map['hour'] = Variable<int>(hour);
    if (!nullToAbsent || fromCoachId != null) {
      map['from_coach_id'] = Variable<String>(fromCoachId);
    }
    if (!nullToAbsent || toCoachId != null) {
      map['to_coach_id'] = Variable<String>(toCoachId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    if (!nullToAbsent || resolvedById != null) {
      map['resolved_by_id'] = Variable<String>(resolvedById);
    }
    return map;
  }

  PlanChangeRequestsCompanion toCompanion(bool nullToAbsent) {
    return PlanChangeRequestsCompanion(
      id: Value(id),
      requesterId: Value(requesterId),
      weekday: Value(weekday),
      courtId: Value(courtId),
      hour: Value(hour),
      fromCoachId: fromCoachId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromCoachId),
      toCoachId: toCoachId == null && nullToAbsent
          ? const Value.absent()
          : Value(toCoachId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
      createdAt: Value(createdAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
      resolvedById: resolvedById == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedById),
    );
  }

  factory PlanChangeRequest.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanChangeRequest(
      id: serializer.fromJson<String>(json['id']),
      requesterId: serializer.fromJson<String>(json['requesterId']),
      weekday: serializer.fromJson<int>(json['weekday']),
      courtId: serializer.fromJson<String>(json['courtId']),
      hour: serializer.fromJson<int>(json['hour']),
      fromCoachId: serializer.fromJson<String?>(json['fromCoachId']),
      toCoachId: serializer.fromJson<String?>(json['toCoachId']),
      note: serializer.fromJson<String?>(json['note']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
      resolvedById: serializer.fromJson<String?>(json['resolvedById']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'requesterId': serializer.toJson<String>(requesterId),
      'weekday': serializer.toJson<int>(weekday),
      'courtId': serializer.toJson<String>(courtId),
      'hour': serializer.toJson<int>(hour),
      'fromCoachId': serializer.toJson<String?>(fromCoachId),
      'toCoachId': serializer.toJson<String?>(toCoachId),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
      'resolvedById': serializer.toJson<String?>(resolvedById),
    };
  }

  PlanChangeRequest copyWith(
          {String? id,
          String? requesterId,
          int? weekday,
          String? courtId,
          int? hour,
          Value<String?> fromCoachId = const Value.absent(),
          Value<String?> toCoachId = const Value.absent(),
          Value<String?> note = const Value.absent(),
          String? status,
          DateTime? createdAt,
          Value<DateTime?> resolvedAt = const Value.absent(),
          Value<String?> resolvedById = const Value.absent()}) =>
      PlanChangeRequest(
        id: id ?? this.id,
        requesterId: requesterId ?? this.requesterId,
        weekday: weekday ?? this.weekday,
        courtId: courtId ?? this.courtId,
        hour: hour ?? this.hour,
        fromCoachId: fromCoachId.present ? fromCoachId.value : this.fromCoachId,
        toCoachId: toCoachId.present ? toCoachId.value : this.toCoachId,
        note: note.present ? note.value : this.note,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
        resolvedById:
            resolvedById.present ? resolvedById.value : this.resolvedById,
      );
  PlanChangeRequest copyWithCompanion(PlanChangeRequestsCompanion data) {
    return PlanChangeRequest(
      id: data.id.present ? data.id.value : this.id,
      requesterId:
          data.requesterId.present ? data.requesterId.value : this.requesterId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      courtId: data.courtId.present ? data.courtId.value : this.courtId,
      hour: data.hour.present ? data.hour.value : this.hour,
      fromCoachId:
          data.fromCoachId.present ? data.fromCoachId.value : this.fromCoachId,
      toCoachId: data.toCoachId.present ? data.toCoachId.value : this.toCoachId,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolvedAt:
          data.resolvedAt.present ? data.resolvedAt.value : this.resolvedAt,
      resolvedById: data.resolvedById.present
          ? data.resolvedById.value
          : this.resolvedById,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanChangeRequest(')
          ..write('id: $id, ')
          ..write('requesterId: $requesterId, ')
          ..write('weekday: $weekday, ')
          ..write('courtId: $courtId, ')
          ..write('hour: $hour, ')
          ..write('fromCoachId: $fromCoachId, ')
          ..write('toCoachId: $toCoachId, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('resolvedById: $resolvedById')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      requesterId,
      weekday,
      courtId,
      hour,
      fromCoachId,
      toCoachId,
      note,
      status,
      createdAt,
      resolvedAt,
      resolvedById);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanChangeRequest &&
          other.id == this.id &&
          other.requesterId == this.requesterId &&
          other.weekday == this.weekday &&
          other.courtId == this.courtId &&
          other.hour == this.hour &&
          other.fromCoachId == this.fromCoachId &&
          other.toCoachId == this.toCoachId &&
          other.note == this.note &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.resolvedAt == this.resolvedAt &&
          other.resolvedById == this.resolvedById);
}

class PlanChangeRequestsCompanion extends UpdateCompanion<PlanChangeRequest> {
  final Value<String> id;
  final Value<String> requesterId;
  final Value<int> weekday;
  final Value<String> courtId;
  final Value<int> hour;
  final Value<String?> fromCoachId;
  final Value<String?> toCoachId;
  final Value<String?> note;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> resolvedAt;
  final Value<String?> resolvedById;
  final Value<int> rowid;
  const PlanChangeRequestsCompanion({
    this.id = const Value.absent(),
    this.requesterId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.courtId = const Value.absent(),
    this.hour = const Value.absent(),
    this.fromCoachId = const Value.absent(),
    this.toCoachId = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.resolvedById = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanChangeRequestsCompanion.insert({
    required String id,
    required String requesterId,
    required int weekday,
    required String courtId,
    required int hour,
    this.fromCoachId = const Value.absent(),
    this.toCoachId = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.resolvedAt = const Value.absent(),
    this.resolvedById = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        requesterId = Value(requesterId),
        weekday = Value(weekday),
        courtId = Value(courtId),
        hour = Value(hour),
        createdAt = Value(createdAt);
  static Insertable<PlanChangeRequest> custom({
    Expression<String>? id,
    Expression<String>? requesterId,
    Expression<int>? weekday,
    Expression<String>? courtId,
    Expression<int>? hour,
    Expression<String>? fromCoachId,
    Expression<String>? toCoachId,
    Expression<String>? note,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? resolvedAt,
    Expression<String>? resolvedById,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (requesterId != null) 'requester_id': requesterId,
      if (weekday != null) 'weekday': weekday,
      if (courtId != null) 'court_id': courtId,
      if (hour != null) 'hour': hour,
      if (fromCoachId != null) 'from_coach_id': fromCoachId,
      if (toCoachId != null) 'to_coach_id': toCoachId,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (resolvedById != null) 'resolved_by_id': resolvedById,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanChangeRequestsCompanion copyWith(
      {Value<String>? id,
      Value<String>? requesterId,
      Value<int>? weekday,
      Value<String>? courtId,
      Value<int>? hour,
      Value<String?>? fromCoachId,
      Value<String?>? toCoachId,
      Value<String?>? note,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime?>? resolvedAt,
      Value<String?>? resolvedById,
      Value<int>? rowid}) {
    return PlanChangeRequestsCompanion(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      weekday: weekday ?? this.weekday,
      courtId: courtId ?? this.courtId,
      hour: hour ?? this.hour,
      fromCoachId: fromCoachId ?? this.fromCoachId,
      toCoachId: toCoachId ?? this.toCoachId,
      note: note ?? this.note,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolvedById: resolvedById ?? this.resolvedById,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (requesterId.present) {
      map['requester_id'] = Variable<String>(requesterId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (courtId.present) {
      map['court_id'] = Variable<String>(courtId.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (fromCoachId.present) {
      map['from_coach_id'] = Variable<String>(fromCoachId.value);
    }
    if (toCoachId.present) {
      map['to_coach_id'] = Variable<String>(toCoachId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (resolvedById.present) {
      map['resolved_by_id'] = Variable<String>(resolvedById.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanChangeRequestsCompanion(')
          ..write('id: $id, ')
          ..write('requesterId: $requesterId, ')
          ..write('weekday: $weekday, ')
          ..write('courtId: $courtId, ')
          ..write('hour: $hour, ')
          ..write('fromCoachId: $fromCoachId, ')
          ..write('toCoachId: $toCoachId, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('resolvedById: $resolvedById, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $CourtsTable courts = $CourtsTable(this);
  late final $CourtBlocksTable courtBlocks = $CourtBlocksTable(this);
  late final $CourtRentalsTable courtRentals = $CourtRentalsTable(this);
  late final $CreditTransactionsTable creditTransactions =
      $CreditTransactionsTable(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $LessonParticipantsTable lessonParticipants =
      $LessonParticipantsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $StudentProfilesTable studentProfiles =
      $StudentProfilesTable(this);
  late final $ParentAthleteLinksTable parentAthleteLinks =
      $ParentAthleteLinksTable(this);
  late final $LessonAttendancesTable lessonAttendances =
      $LessonAttendancesTable(this);
  late final $WeeklyCourtRightsTable weeklyCourtRights =
      $WeeklyCourtRightsTable(this);
  late final $PlanChangeRequestsTable planChangeRequests =
      $PlanChangeRequestsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        courts,
        courtBlocks,
        courtRentals,
        creditTransactions,
        lessons,
        lessonParticipants,
        payments,
        studentProfiles,
        parentAthleteLinks,
        lessonAttendances,
        weeklyCourtRights,
        planChangeRequests
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String name,
  required String email,
  required String password,
  required String role,
  Value<String?> phone,
  Value<double> creditBalance,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> email,
  Value<String> password,
  Value<String> role,
  Value<String?> phone,
  Value<double> creditBalance,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CourtBlocksTable, List<CourtBlock>>
      _courtBlocksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.courtBlocks,
          aliasName:
              $_aliasNameGenerator(db.users.id, db.courtBlocks.createdById));

  $$CourtBlocksTableProcessedTableManager get courtBlocksRefs {
    final manager = $$CourtBlocksTableTableManager($_db, $_db.courtBlocks)
        .filter((f) => f.createdById.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_courtBlocksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CourtRentalsTable, List<CourtRental>>
      _courtRentalsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.courtRentals,
              aliasName:
                  $_aliasNameGenerator(db.users.id, db.courtRentals.athleteId));

  $$CourtRentalsTableProcessedTableManager get courtRentalsRefs {
    final manager = $$CourtRentalsTableTableManager($_db, $_db.courtRentals)
        .filter((f) => f.athleteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_courtRentalsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CreditTransactionsTable, List<CreditTransaction>>
      _creditTransactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.creditTransactions,
              aliasName: $_aliasNameGenerator(
                  db.users.id, db.creditTransactions.userId));

  $$CreditTransactionsTableProcessedTableManager get creditTransactionsRefs {
    final manager =
        $$CreditTransactionsTableTableManager($_db, $_db.creditTransactions)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_creditTransactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LessonParticipantsTable, List<LessonParticipant>>
      _lessonParticipantsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.lessonParticipants,
              aliasName: $_aliasNameGenerator(
                  db.users.id, db.lessonParticipants.userId));

  $$LessonParticipantsTableProcessedTableManager get lessonParticipantsRefs {
    final manager =
        $$LessonParticipantsTableTableManager($_db, $_db.lessonParticipants)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_lessonParticipantsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WeeklyCourtRightsTable, List<WeeklyCourtRight>>
      _weeklyCourtRightsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.weeklyCourtRights,
              aliasName: $_aliasNameGenerator(
                  db.users.id, db.weeklyCourtRights.coachId));

  $$WeeklyCourtRightsTableProcessedTableManager get weeklyCourtRightsRefs {
    final manager =
        $$WeeklyCourtRightsTableTableManager($_db, $_db.weeklyCourtRights)
            .filter((f) => f.coachId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_weeklyCourtRightsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creditBalance => $composableBuilder(
      column: $table.creditBalance, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> courtBlocksRefs(
      Expression<bool> Function($$CourtBlocksTableFilterComposer f) f) {
    final $$CourtBlocksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.courtBlocks,
        getReferencedColumn: (t) => t.createdById,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtBlocksTableFilterComposer(
              $db: $db,
              $table: $db.courtBlocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> courtRentalsRefs(
      Expression<bool> Function($$CourtRentalsTableFilterComposer f) f) {
    final $$CourtRentalsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.courtRentals,
        getReferencedColumn: (t) => t.athleteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtRentalsTableFilterComposer(
              $db: $db,
              $table: $db.courtRentals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> creditTransactionsRefs(
      Expression<bool> Function($$CreditTransactionsTableFilterComposer f) f) {
    final $$CreditTransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.creditTransactions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CreditTransactionsTableFilterComposer(
              $db: $db,
              $table: $db.creditTransactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> lessonParticipantsRefs(
      Expression<bool> Function($$LessonParticipantsTableFilterComposer f) f) {
    final $$LessonParticipantsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonParticipants,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonParticipantsTableFilterComposer(
              $db: $db,
              $table: $db.lessonParticipants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> weeklyCourtRightsRefs(
      Expression<bool> Function($$WeeklyCourtRightsTableFilterComposer f) f) {
    final $$WeeklyCourtRightsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.weeklyCourtRights,
        getReferencedColumn: (t) => t.coachId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WeeklyCourtRightsTableFilterComposer(
              $db: $db,
              $table: $db.weeklyCourtRights,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creditBalance => $composableBuilder(
      column: $table.creditBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
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

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<double> get creditBalance => $composableBuilder(
      column: $table.creditBalance, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> courtBlocksRefs<T extends Object>(
      Expression<T> Function($$CourtBlocksTableAnnotationComposer a) f) {
    final $$CourtBlocksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.courtBlocks,
        getReferencedColumn: (t) => t.createdById,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtBlocksTableAnnotationComposer(
              $db: $db,
              $table: $db.courtBlocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> courtRentalsRefs<T extends Object>(
      Expression<T> Function($$CourtRentalsTableAnnotationComposer a) f) {
    final $$CourtRentalsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.courtRentals,
        getReferencedColumn: (t) => t.athleteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtRentalsTableAnnotationComposer(
              $db: $db,
              $table: $db.courtRentals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> creditTransactionsRefs<T extends Object>(
      Expression<T> Function($$CreditTransactionsTableAnnotationComposer a) f) {
    final $$CreditTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.creditTransactions,
            getReferencedColumn: (t) => t.userId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CreditTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.creditTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> lessonParticipantsRefs<T extends Object>(
      Expression<T> Function($$LessonParticipantsTableAnnotationComposer a) f) {
    final $$LessonParticipantsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.lessonParticipants,
            getReferencedColumn: (t) => t.userId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$LessonParticipantsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.lessonParticipants,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> weeklyCourtRightsRefs<T extends Object>(
      Expression<T> Function($$WeeklyCourtRightsTableAnnotationComposer a) f) {
    final $$WeeklyCourtRightsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.weeklyCourtRights,
            getReferencedColumn: (t) => t.coachId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WeeklyCourtRightsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.weeklyCourtRights,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool courtBlocksRefs,
        bool courtRentalsRefs,
        bool creditTransactionsRefs,
        bool lessonParticipantsRefs,
        bool weeklyCourtRightsRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<double> creditBalance = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            name: name,
            email: email,
            password: password,
            role: role,
            phone: phone,
            creditBalance: creditBalance,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String email,
            required String password,
            required String role,
            Value<String?> phone = const Value.absent(),
            Value<double> creditBalance = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            name: name,
            email: email,
            password: password,
            role: role,
            phone: phone,
            creditBalance: creditBalance,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {courtBlocksRefs = false,
              courtRentalsRefs = false,
              creditTransactionsRefs = false,
              lessonParticipantsRefs = false,
              weeklyCourtRightsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (courtBlocksRefs) db.courtBlocks,
                if (courtRentalsRefs) db.courtRentals,
                if (creditTransactionsRefs) db.creditTransactions,
                if (lessonParticipantsRefs) db.lessonParticipants,
                if (weeklyCourtRightsRefs) db.weeklyCourtRights
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (courtBlocksRefs)
                    await $_getPrefetchedData<User, $UsersTable, CourtBlock>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._courtBlocksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .courtBlocksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.createdById == item.id),
                        typedResults: items),
                  if (courtRentalsRefs)
                    await $_getPrefetchedData<User, $UsersTable, CourtRental>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._courtRentalsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .courtRentalsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.athleteId == item.id),
                        typedResults: items),
                  if (creditTransactionsRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            CreditTransaction>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._creditTransactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .creditTransactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (lessonParticipantsRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            LessonParticipant>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._lessonParticipantsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .lessonParticipantsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (weeklyCourtRightsRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            WeeklyCourtRight>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._weeklyCourtRightsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .weeklyCourtRightsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.coachId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool courtBlocksRefs,
        bool courtRentalsRefs,
        bool creditTransactionsRefs,
        bool lessonParticipantsRefs,
        bool weeklyCourtRightsRefs})>;
typedef $$CourtsTableCreateCompanionBuilder = CourtsCompanion Function({
  required String id,
  required String name,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$CourtsTableUpdateCompanionBuilder = CourtsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<int> rowid,
});

final class $$CourtsTableReferences
    extends BaseReferences<_$AppDatabase, $CourtsTable, Court> {
  $$CourtsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CourtBlocksTable, List<CourtBlock>>
      _courtBlocksRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.courtBlocks,
              aliasName:
                  $_aliasNameGenerator(db.courts.id, db.courtBlocks.courtId));

  $$CourtBlocksTableProcessedTableManager get courtBlocksRefs {
    final manager = $$CourtBlocksTableTableManager($_db, $_db.courtBlocks)
        .filter((f) => f.courtId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_courtBlocksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CourtRentalsTable, List<CourtRental>>
      _courtRentalsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.courtRentals,
              aliasName:
                  $_aliasNameGenerator(db.courts.id, db.courtRentals.courtId));

  $$CourtRentalsTableProcessedTableManager get courtRentalsRefs {
    final manager = $$CourtRentalsTableTableManager($_db, $_db.courtRentals)
        .filter((f) => f.courtId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_courtRentalsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LessonsTable, List<Lesson>> _lessonsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.lessons,
          aliasName: $_aliasNameGenerator(db.courts.id, db.lessons.courtId));

  $$LessonsTableProcessedTableManager get lessonsRefs {
    final manager = $$LessonsTableTableManager($_db, $_db.lessons)
        .filter((f) => f.courtId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WeeklyCourtRightsTable, List<WeeklyCourtRight>>
      _weeklyCourtRightsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.weeklyCourtRights,
              aliasName: $_aliasNameGenerator(
                  db.courts.id, db.weeklyCourtRights.courtId));

  $$WeeklyCourtRightsTableProcessedTableManager get weeklyCourtRightsRefs {
    final manager =
        $$WeeklyCourtRightsTableTableManager($_db, $_db.weeklyCourtRights)
            .filter((f) => f.courtId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_weeklyCourtRightsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PlanChangeRequestsTable, List<PlanChangeRequest>>
      _planChangeRequestsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.planChangeRequests,
              aliasName: $_aliasNameGenerator(
                  db.courts.id, db.planChangeRequests.courtId));

  $$PlanChangeRequestsTableProcessedTableManager get planChangeRequestsRefs {
    final manager =
        $$PlanChangeRequestsTableTableManager($_db, $_db.planChangeRequests)
            .filter((f) => f.courtId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_planChangeRequestsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CourtsTableFilterComposer
    extends Composer<_$AppDatabase, $CourtsTable> {
  $$CourtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> courtBlocksRefs(
      Expression<bool> Function($$CourtBlocksTableFilterComposer f) f) {
    final $$CourtBlocksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.courtBlocks,
        getReferencedColumn: (t) => t.courtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtBlocksTableFilterComposer(
              $db: $db,
              $table: $db.courtBlocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> courtRentalsRefs(
      Expression<bool> Function($$CourtRentalsTableFilterComposer f) f) {
    final $$CourtRentalsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.courtRentals,
        getReferencedColumn: (t) => t.courtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtRentalsTableFilterComposer(
              $db: $db,
              $table: $db.courtRentals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> lessonsRefs(
      Expression<bool> Function($$LessonsTableFilterComposer f) f) {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.courtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableFilterComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> weeklyCourtRightsRefs(
      Expression<bool> Function($$WeeklyCourtRightsTableFilterComposer f) f) {
    final $$WeeklyCourtRightsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.weeklyCourtRights,
        getReferencedColumn: (t) => t.courtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WeeklyCourtRightsTableFilterComposer(
              $db: $db,
              $table: $db.weeklyCourtRights,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> planChangeRequestsRefs(
      Expression<bool> Function($$PlanChangeRequestsTableFilterComposer f) f) {
    final $$PlanChangeRequestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.planChangeRequests,
        getReferencedColumn: (t) => t.courtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanChangeRequestsTableFilterComposer(
              $db: $db,
              $table: $db.planChangeRequests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CourtsTableOrderingComposer
    extends Composer<_$AppDatabase, $CourtsTable> {
  $$CourtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$CourtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CourtsTable> {
  $$CourtsTableAnnotationComposer({
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

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> courtBlocksRefs<T extends Object>(
      Expression<T> Function($$CourtBlocksTableAnnotationComposer a) f) {
    final $$CourtBlocksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.courtBlocks,
        getReferencedColumn: (t) => t.courtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtBlocksTableAnnotationComposer(
              $db: $db,
              $table: $db.courtBlocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> courtRentalsRefs<T extends Object>(
      Expression<T> Function($$CourtRentalsTableAnnotationComposer a) f) {
    final $$CourtRentalsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.courtRentals,
        getReferencedColumn: (t) => t.courtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtRentalsTableAnnotationComposer(
              $db: $db,
              $table: $db.courtRentals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> lessonsRefs<T extends Object>(
      Expression<T> Function($$LessonsTableAnnotationComposer a) f) {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.courtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableAnnotationComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> weeklyCourtRightsRefs<T extends Object>(
      Expression<T> Function($$WeeklyCourtRightsTableAnnotationComposer a) f) {
    final $$WeeklyCourtRightsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.weeklyCourtRights,
            getReferencedColumn: (t) => t.courtId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WeeklyCourtRightsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.weeklyCourtRights,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> planChangeRequestsRefs<T extends Object>(
      Expression<T> Function($$PlanChangeRequestsTableAnnotationComposer a) f) {
    final $$PlanChangeRequestsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.planChangeRequests,
            getReferencedColumn: (t) => t.courtId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PlanChangeRequestsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.planChangeRequests,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CourtsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CourtsTable,
    Court,
    $$CourtsTableFilterComposer,
    $$CourtsTableOrderingComposer,
    $$CourtsTableAnnotationComposer,
    $$CourtsTableCreateCompanionBuilder,
    $$CourtsTableUpdateCompanionBuilder,
    (Court, $$CourtsTableReferences),
    Court,
    PrefetchHooks Function(
        {bool courtBlocksRefs,
        bool courtRentalsRefs,
        bool lessonsRefs,
        bool weeklyCourtRightsRefs,
        bool planChangeRequestsRefs})> {
  $$CourtsTableTableManager(_$AppDatabase db, $CourtsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CourtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CourtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CourtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CourtsCompanion(
            id: id,
            name: name,
            sortOrder: sortOrder,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CourtsCompanion.insert(
            id: id,
            name: name,
            sortOrder: sortOrder,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CourtsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {courtBlocksRefs = false,
              courtRentalsRefs = false,
              lessonsRefs = false,
              weeklyCourtRightsRefs = false,
              planChangeRequestsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (courtBlocksRefs) db.courtBlocks,
                if (courtRentalsRefs) db.courtRentals,
                if (lessonsRefs) db.lessons,
                if (weeklyCourtRightsRefs) db.weeklyCourtRights,
                if (planChangeRequestsRefs) db.planChangeRequests
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (courtBlocksRefs)
                    await $_getPrefetchedData<Court, $CourtsTable, CourtBlock>(
                        currentTable: table,
                        referencedTable:
                            $$CourtsTableReferences._courtBlocksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CourtsTableReferences(db, table, p0)
                                .courtBlocksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.courtId == item.id),
                        typedResults: items),
                  if (courtRentalsRefs)
                    await $_getPrefetchedData<Court, $CourtsTable, CourtRental>(
                        currentTable: table,
                        referencedTable:
                            $$CourtsTableReferences._courtRentalsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CourtsTableReferences(db, table, p0)
                                .courtRentalsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.courtId == item.id),
                        typedResults: items),
                  if (lessonsRefs)
                    await $_getPrefetchedData<Court, $CourtsTable, Lesson>(
                        currentTable: table,
                        referencedTable:
                            $$CourtsTableReferences._lessonsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CourtsTableReferences(db, table, p0).lessonsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.courtId == item.id),
                        typedResults: items),
                  if (weeklyCourtRightsRefs)
                    await $_getPrefetchedData<Court, $CourtsTable,
                            WeeklyCourtRight>(
                        currentTable: table,
                        referencedTable: $$CourtsTableReferences
                            ._weeklyCourtRightsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CourtsTableReferences(db, table, p0)
                                .weeklyCourtRightsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.courtId == item.id),
                        typedResults: items),
                  if (planChangeRequestsRefs)
                    await $_getPrefetchedData<Court, $CourtsTable,
                            PlanChangeRequest>(
                        currentTable: table,
                        referencedTable: $$CourtsTableReferences
                            ._planChangeRequestsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CourtsTableReferences(db, table, p0)
                                .planChangeRequestsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.courtId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CourtsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CourtsTable,
    Court,
    $$CourtsTableFilterComposer,
    $$CourtsTableOrderingComposer,
    $$CourtsTableAnnotationComposer,
    $$CourtsTableCreateCompanionBuilder,
    $$CourtsTableUpdateCompanionBuilder,
    (Court, $$CourtsTableReferences),
    Court,
    PrefetchHooks Function(
        {bool courtBlocksRefs,
        bool courtRentalsRefs,
        bool lessonsRefs,
        bool weeklyCourtRightsRefs,
        bool planChangeRequestsRefs})>;
typedef $$CourtBlocksTableCreateCompanionBuilder = CourtBlocksCompanion
    Function({
  required String id,
  required String courtId,
  required DateTime startTime,
  required DateTime endTime,
  Value<String?> reason,
  required String createdById,
  Value<int> rowid,
});
typedef $$CourtBlocksTableUpdateCompanionBuilder = CourtBlocksCompanion
    Function({
  Value<String> id,
  Value<String> courtId,
  Value<DateTime> startTime,
  Value<DateTime> endTime,
  Value<String?> reason,
  Value<String> createdById,
  Value<int> rowid,
});

final class $$CourtBlocksTableReferences
    extends BaseReferences<_$AppDatabase, $CourtBlocksTable, CourtBlock> {
  $$CourtBlocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CourtsTable _courtIdTable(_$AppDatabase db) => db.courts
      .createAlias($_aliasNameGenerator(db.courtBlocks.courtId, db.courts.id));

  $$CourtsTableProcessedTableManager get courtId {
    final $_column = $_itemColumn<String>('court_id')!;

    final manager = $$CourtsTableTableManager($_db, $_db.courts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courtIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _createdByIdTable(_$AppDatabase db) =>
      db.users.createAlias(
          $_aliasNameGenerator(db.courtBlocks.createdById, db.users.id));

  $$UsersTableProcessedTableManager get createdById {
    final $_column = $_itemColumn<String>('created_by_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_createdByIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CourtBlocksTableFilterComposer
    extends Composer<_$AppDatabase, $CourtBlocksTable> {
  $$CourtBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  $$CourtsTableFilterComposer get courtId {
    final $$CourtsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableFilterComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get createdById {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.createdById,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CourtBlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $CourtBlocksTable> {
  $$CourtBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  $$CourtsTableOrderingComposer get courtId {
    final $$CourtsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableOrderingComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get createdById {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.createdById,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CourtBlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CourtBlocksTable> {
  $$CourtBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  $$CourtsTableAnnotationComposer get courtId {
    final $$CourtsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableAnnotationComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get createdById {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.createdById,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CourtBlocksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CourtBlocksTable,
    CourtBlock,
    $$CourtBlocksTableFilterComposer,
    $$CourtBlocksTableOrderingComposer,
    $$CourtBlocksTableAnnotationComposer,
    $$CourtBlocksTableCreateCompanionBuilder,
    $$CourtBlocksTableUpdateCompanionBuilder,
    (CourtBlock, $$CourtBlocksTableReferences),
    CourtBlock,
    PrefetchHooks Function({bool courtId, bool createdById})> {
  $$CourtBlocksTableTableManager(_$AppDatabase db, $CourtBlocksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CourtBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CourtBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CourtBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> courtId = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime> endTime = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String> createdById = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CourtBlocksCompanion(
            id: id,
            courtId: courtId,
            startTime: startTime,
            endTime: endTime,
            reason: reason,
            createdById: createdById,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String courtId,
            required DateTime startTime,
            required DateTime endTime,
            Value<String?> reason = const Value.absent(),
            required String createdById,
            Value<int> rowid = const Value.absent(),
          }) =>
              CourtBlocksCompanion.insert(
            id: id,
            courtId: courtId,
            startTime: startTime,
            endTime: endTime,
            reason: reason,
            createdById: createdById,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CourtBlocksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({courtId = false, createdById = false}) {
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
                if (courtId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.courtId,
                    referencedTable:
                        $$CourtBlocksTableReferences._courtIdTable(db),
                    referencedColumn:
                        $$CourtBlocksTableReferences._courtIdTable(db).id,
                  ) as T;
                }
                if (createdById) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.createdById,
                    referencedTable:
                        $$CourtBlocksTableReferences._createdByIdTable(db),
                    referencedColumn:
                        $$CourtBlocksTableReferences._createdByIdTable(db).id,
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

typedef $$CourtBlocksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CourtBlocksTable,
    CourtBlock,
    $$CourtBlocksTableFilterComposer,
    $$CourtBlocksTableOrderingComposer,
    $$CourtBlocksTableAnnotationComposer,
    $$CourtBlocksTableCreateCompanionBuilder,
    $$CourtBlocksTableUpdateCompanionBuilder,
    (CourtBlock, $$CourtBlocksTableReferences),
    CourtBlock,
    PrefetchHooks Function({bool courtId, bool createdById})>;
typedef $$CourtRentalsTableCreateCompanionBuilder = CourtRentalsCompanion
    Function({
  required String id,
  required String courtId,
  required String athleteId,
  required DateTime startTime,
  required DateTime endTime,
  Value<double> creditCost,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$CourtRentalsTableUpdateCompanionBuilder = CourtRentalsCompanion
    Function({
  Value<String> id,
  Value<String> courtId,
  Value<String> athleteId,
  Value<DateTime> startTime,
  Value<DateTime> endTime,
  Value<double> creditCost,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$CourtRentalsTableReferences
    extends BaseReferences<_$AppDatabase, $CourtRentalsTable, CourtRental> {
  $$CourtRentalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CourtsTable _courtIdTable(_$AppDatabase db) => db.courts
      .createAlias($_aliasNameGenerator(db.courtRentals.courtId, db.courts.id));

  $$CourtsTableProcessedTableManager get courtId {
    final $_column = $_itemColumn<String>('court_id')!;

    final manager = $$CourtsTableTableManager($_db, $_db.courts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courtIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _athleteIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.courtRentals.athleteId, db.users.id));

  $$UsersTableProcessedTableManager get athleteId {
    final $_column = $_itemColumn<String>('athlete_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_athleteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$CreditTransactionsTable, List<CreditTransaction>>
      _creditTransactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.creditTransactions,
              aliasName: $_aliasNameGenerator(
                  db.courtRentals.id, db.creditTransactions.rentalId));

  $$CreditTransactionsTableProcessedTableManager get creditTransactionsRefs {
    final manager = $$CreditTransactionsTableTableManager(
            $_db, $_db.creditTransactions)
        .filter((f) => f.rentalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_creditTransactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CourtRentalsTableFilterComposer
    extends Composer<_$AppDatabase, $CourtRentalsTable> {
  $$CourtRentalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creditCost => $composableBuilder(
      column: $table.creditCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CourtsTableFilterComposer get courtId {
    final $$CourtsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableFilterComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get athleteId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.athleteId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> creditTransactionsRefs(
      Expression<bool> Function($$CreditTransactionsTableFilterComposer f) f) {
    final $$CreditTransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.creditTransactions,
        getReferencedColumn: (t) => t.rentalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CreditTransactionsTableFilterComposer(
              $db: $db,
              $table: $db.creditTransactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CourtRentalsTableOrderingComposer
    extends Composer<_$AppDatabase, $CourtRentalsTable> {
  $$CourtRentalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creditCost => $composableBuilder(
      column: $table.creditCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CourtsTableOrderingComposer get courtId {
    final $$CourtsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableOrderingComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get athleteId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.athleteId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CourtRentalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CourtRentalsTable> {
  $$CourtRentalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<double> get creditCost => $composableBuilder(
      column: $table.creditCost, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CourtsTableAnnotationComposer get courtId {
    final $$CourtsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableAnnotationComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get athleteId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.athleteId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> creditTransactionsRefs<T extends Object>(
      Expression<T> Function($$CreditTransactionsTableAnnotationComposer a) f) {
    final $$CreditTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.creditTransactions,
            getReferencedColumn: (t) => t.rentalId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CreditTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.creditTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CourtRentalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CourtRentalsTable,
    CourtRental,
    $$CourtRentalsTableFilterComposer,
    $$CourtRentalsTableOrderingComposer,
    $$CourtRentalsTableAnnotationComposer,
    $$CourtRentalsTableCreateCompanionBuilder,
    $$CourtRentalsTableUpdateCompanionBuilder,
    (CourtRental, $$CourtRentalsTableReferences),
    CourtRental,
    PrefetchHooks Function(
        {bool courtId, bool athleteId, bool creditTransactionsRefs})> {
  $$CourtRentalsTableTableManager(_$AppDatabase db, $CourtRentalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CourtRentalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CourtRentalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CourtRentalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> courtId = const Value.absent(),
            Value<String> athleteId = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime> endTime = const Value.absent(),
            Value<double> creditCost = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CourtRentalsCompanion(
            id: id,
            courtId: courtId,
            athleteId: athleteId,
            startTime: startTime,
            endTime: endTime,
            creditCost: creditCost,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String courtId,
            required String athleteId,
            required DateTime startTime,
            required DateTime endTime,
            Value<double> creditCost = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CourtRentalsCompanion.insert(
            id: id,
            courtId: courtId,
            athleteId: athleteId,
            startTime: startTime,
            endTime: endTime,
            creditCost: creditCost,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CourtRentalsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {courtId = false,
              athleteId = false,
              creditTransactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (creditTransactionsRefs) db.creditTransactions
              ],
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
                if (courtId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.courtId,
                    referencedTable:
                        $$CourtRentalsTableReferences._courtIdTable(db),
                    referencedColumn:
                        $$CourtRentalsTableReferences._courtIdTable(db).id,
                  ) as T;
                }
                if (athleteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.athleteId,
                    referencedTable:
                        $$CourtRentalsTableReferences._athleteIdTable(db),
                    referencedColumn:
                        $$CourtRentalsTableReferences._athleteIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (creditTransactionsRefs)
                    await $_getPrefetchedData<CourtRental, $CourtRentalsTable,
                            CreditTransaction>(
                        currentTable: table,
                        referencedTable: $$CourtRentalsTableReferences
                            ._creditTransactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CourtRentalsTableReferences(db, table, p0)
                                .creditTransactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.rentalId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CourtRentalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CourtRentalsTable,
    CourtRental,
    $$CourtRentalsTableFilterComposer,
    $$CourtRentalsTableOrderingComposer,
    $$CourtRentalsTableAnnotationComposer,
    $$CourtRentalsTableCreateCompanionBuilder,
    $$CourtRentalsTableUpdateCompanionBuilder,
    (CourtRental, $$CourtRentalsTableReferences),
    CourtRental,
    PrefetchHooks Function(
        {bool courtId, bool athleteId, bool creditTransactionsRefs})>;
typedef $$CreditTransactionsTableCreateCompanionBuilder
    = CreditTransactionsCompanion Function({
  required String id,
  required String userId,
  required double amount,
  required String type,
  Value<String?> rentalId,
  required String description,
  required double balanceAfter,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$CreditTransactionsTableUpdateCompanionBuilder
    = CreditTransactionsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<double> amount,
  Value<String> type,
  Value<String?> rentalId,
  Value<String> description,
  Value<double> balanceAfter,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$CreditTransactionsTableReferences extends BaseReferences<
    _$AppDatabase, $CreditTransactionsTable, CreditTransaction> {
  $$CreditTransactionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.creditTransactions.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CourtRentalsTable _rentalIdTable(_$AppDatabase db) =>
      db.courtRentals.createAlias($_aliasNameGenerator(
          db.creditTransactions.rentalId, db.courtRentals.id));

  $$CourtRentalsTableProcessedTableManager? get rentalId {
    final $_column = $_itemColumn<String>('rental_id');
    if ($_column == null) return null;
    final manager = $$CourtRentalsTableTableManager($_db, $_db.courtRentals)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rentalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CreditTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $CreditTransactionsTable> {
  $$CreditTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balanceAfter => $composableBuilder(
      column: $table.balanceAfter, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CourtRentalsTableFilterComposer get rentalId {
    final $$CourtRentalsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rentalId,
        referencedTable: $db.courtRentals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtRentalsTableFilterComposer(
              $db: $db,
              $table: $db.courtRentals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CreditTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditTransactionsTable> {
  $$CreditTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balanceAfter => $composableBuilder(
      column: $table.balanceAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CourtRentalsTableOrderingComposer get rentalId {
    final $$CourtRentalsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rentalId,
        referencedTable: $db.courtRentals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtRentalsTableOrderingComposer(
              $db: $db,
              $table: $db.courtRentals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CreditTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditTransactionsTable> {
  $$CreditTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get balanceAfter => $composableBuilder(
      column: $table.balanceAfter, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CourtRentalsTableAnnotationComposer get rentalId {
    final $$CourtRentalsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rentalId,
        referencedTable: $db.courtRentals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtRentalsTableAnnotationComposer(
              $db: $db,
              $table: $db.courtRentals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CreditTransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CreditTransactionsTable,
    CreditTransaction,
    $$CreditTransactionsTableFilterComposer,
    $$CreditTransactionsTableOrderingComposer,
    $$CreditTransactionsTableAnnotationComposer,
    $$CreditTransactionsTableCreateCompanionBuilder,
    $$CreditTransactionsTableUpdateCompanionBuilder,
    (CreditTransaction, $$CreditTransactionsTableReferences),
    CreditTransaction,
    PrefetchHooks Function({bool userId, bool rentalId})> {
  $$CreditTransactionsTableTableManager(
      _$AppDatabase db, $CreditTransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditTransactionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> rentalId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<double> balanceAfter = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditTransactionsCompanion(
            id: id,
            userId: userId,
            amount: amount,
            type: type,
            rentalId: rentalId,
            description: description,
            balanceAfter: balanceAfter,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required double amount,
            required String type,
            Value<String?> rentalId = const Value.absent(),
            required String description,
            required double balanceAfter,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditTransactionsCompanion.insert(
            id: id,
            userId: userId,
            amount: amount,
            type: type,
            rentalId: rentalId,
            description: description,
            balanceAfter: balanceAfter,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CreditTransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false, rentalId = false}) {
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
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$CreditTransactionsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$CreditTransactionsTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (rentalId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.rentalId,
                    referencedTable:
                        $$CreditTransactionsTableReferences._rentalIdTable(db),
                    referencedColumn: $$CreditTransactionsTableReferences
                        ._rentalIdTable(db)
                        .id,
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

typedef $$CreditTransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CreditTransactionsTable,
    CreditTransaction,
    $$CreditTransactionsTableFilterComposer,
    $$CreditTransactionsTableOrderingComposer,
    $$CreditTransactionsTableAnnotationComposer,
    $$CreditTransactionsTableCreateCompanionBuilder,
    $$CreditTransactionsTableUpdateCompanionBuilder,
    (CreditTransaction, $$CreditTransactionsTableReferences),
    CreditTransaction,
    PrefetchHooks Function({bool userId, bool rentalId})>;
typedef $$LessonsTableCreateCompanionBuilder = LessonsCompanion Function({
  required String id,
  required String coachId,
  Value<String?> courtId,
  required String type,
  required DateTime startTime,
  required DateTime endTime,
  Value<int> maxParticipants,
  Value<bool> isTemplate,
  Value<String> status,
  Value<double?> price,
  Value<String?> title,
  Value<String?> notes,
  Value<String?> seriesId,
  Value<String?> colorHex,
  Value<String?> representativeUserId,
  Value<int> rowid,
});
typedef $$LessonsTableUpdateCompanionBuilder = LessonsCompanion Function({
  Value<String> id,
  Value<String> coachId,
  Value<String?> courtId,
  Value<String> type,
  Value<DateTime> startTime,
  Value<DateTime> endTime,
  Value<int> maxParticipants,
  Value<bool> isTemplate,
  Value<String> status,
  Value<double?> price,
  Value<String?> title,
  Value<String?> notes,
  Value<String?> seriesId,
  Value<String?> colorHex,
  Value<String?> representativeUserId,
  Value<int> rowid,
});

final class $$LessonsTableReferences
    extends BaseReferences<_$AppDatabase, $LessonsTable, Lesson> {
  $$LessonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _coachIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.lessons.coachId, db.users.id));

  $$UsersTableProcessedTableManager get coachId {
    final $_column = $_itemColumn<String>('coach_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_coachIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CourtsTable _courtIdTable(_$AppDatabase db) => db.courts
      .createAlias($_aliasNameGenerator(db.lessons.courtId, db.courts.id));

  $$CourtsTableProcessedTableManager? get courtId {
    final $_column = $_itemColumn<String>('court_id');
    if ($_column == null) return null;
    final manager = $$CourtsTableTableManager($_db, $_db.courts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courtIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _representativeUserIdTable(_$AppDatabase db) =>
      db.users.createAlias(
          $_aliasNameGenerator(db.lessons.representativeUserId, db.users.id));

  $$UsersTableProcessedTableManager? get representativeUserId {
    final $_column = $_itemColumn<String>('representative_user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item =
        $_typedResult.readTableOrNull(_representativeUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$LessonParticipantsTable, List<LessonParticipant>>
      _lessonParticipantsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.lessonParticipants,
              aliasName: $_aliasNameGenerator(
                  db.lessons.id, db.lessonParticipants.lessonId));

  $$LessonParticipantsTableProcessedTableManager get lessonParticipantsRefs {
    final manager = $$LessonParticipantsTableTableManager(
            $_db, $_db.lessonParticipants)
        .filter((f) => f.lessonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_lessonParticipantsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LessonAttendancesTable, List<LessonAttendance>>
      _lessonAttendancesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.lessonAttendances,
              aliasName: $_aliasNameGenerator(
                  db.lessons.id, db.lessonAttendances.lessonId));

  $$LessonAttendancesTableProcessedTableManager get lessonAttendancesRefs {
    final manager = $$LessonAttendancesTableTableManager(
            $_db, $_db.lessonAttendances)
        .filter((f) => f.lessonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_lessonAttendancesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxParticipants => $composableBuilder(
      column: $table.maxParticipants,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isTemplate => $composableBuilder(
      column: $table.isTemplate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get seriesId => $composableBuilder(
      column: $table.seriesId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get coachId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.coachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CourtsTableFilterComposer get courtId {
    final $$CourtsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableFilterComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get representativeUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.representativeUserId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> lessonParticipantsRefs(
      Expression<bool> Function($$LessonParticipantsTableFilterComposer f) f) {
    final $$LessonParticipantsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonParticipants,
        getReferencedColumn: (t) => t.lessonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonParticipantsTableFilterComposer(
              $db: $db,
              $table: $db.lessonParticipants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> lessonAttendancesRefs(
      Expression<bool> Function($$LessonAttendancesTableFilterComposer f) f) {
    final $$LessonAttendancesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessonAttendances,
        getReferencedColumn: (t) => t.lessonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonAttendancesTableFilterComposer(
              $db: $db,
              $table: $db.lessonAttendances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxParticipants => $composableBuilder(
      column: $table.maxParticipants,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isTemplate => $composableBuilder(
      column: $table.isTemplate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get seriesId => $composableBuilder(
      column: $table.seriesId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get coachId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.coachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CourtsTableOrderingComposer get courtId {
    final $$CourtsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableOrderingComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get representativeUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.representativeUserId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get maxParticipants => $composableBuilder(
      column: $table.maxParticipants, builder: (column) => column);

  GeneratedColumn<bool> get isTemplate => $composableBuilder(
      column: $table.isTemplate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get seriesId =>
      $composableBuilder(column: $table.seriesId, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  $$UsersTableAnnotationComposer get coachId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.coachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CourtsTableAnnotationComposer get courtId {
    final $$CourtsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableAnnotationComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get representativeUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.representativeUserId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> lessonParticipantsRefs<T extends Object>(
      Expression<T> Function($$LessonParticipantsTableAnnotationComposer a) f) {
    final $$LessonParticipantsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.lessonParticipants,
            getReferencedColumn: (t) => t.lessonId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$LessonParticipantsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.lessonParticipants,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> lessonAttendancesRefs<T extends Object>(
      Expression<T> Function($$LessonAttendancesTableAnnotationComposer a) f) {
    final $$LessonAttendancesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.lessonAttendances,
            getReferencedColumn: (t) => t.lessonId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$LessonAttendancesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.lessonAttendances,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$LessonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonsTable,
    Lesson,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (Lesson, $$LessonsTableReferences),
    Lesson,
    PrefetchHooks Function(
        {bool coachId,
        bool courtId,
        bool representativeUserId,
        bool lessonParticipantsRefs,
        bool lessonAttendancesRefs})> {
  $$LessonsTableTableManager(_$AppDatabase db, $LessonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> coachId = const Value.absent(),
            Value<String?> courtId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime> endTime = const Value.absent(),
            Value<int> maxParticipants = const Value.absent(),
            Value<bool> isTemplate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double?> price = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> seriesId = const Value.absent(),
            Value<String?> colorHex = const Value.absent(),
            Value<String?> representativeUserId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonsCompanion(
            id: id,
            coachId: coachId,
            courtId: courtId,
            type: type,
            startTime: startTime,
            endTime: endTime,
            maxParticipants: maxParticipants,
            isTemplate: isTemplate,
            status: status,
            price: price,
            title: title,
            notes: notes,
            seriesId: seriesId,
            colorHex: colorHex,
            representativeUserId: representativeUserId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String coachId,
            Value<String?> courtId = const Value.absent(),
            required String type,
            required DateTime startTime,
            required DateTime endTime,
            Value<int> maxParticipants = const Value.absent(),
            Value<bool> isTemplate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double?> price = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> seriesId = const Value.absent(),
            Value<String?> colorHex = const Value.absent(),
            Value<String?> representativeUserId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonsCompanion.insert(
            id: id,
            coachId: coachId,
            courtId: courtId,
            type: type,
            startTime: startTime,
            endTime: endTime,
            maxParticipants: maxParticipants,
            isTemplate: isTemplate,
            status: status,
            price: price,
            title: title,
            notes: notes,
            seriesId: seriesId,
            colorHex: colorHex,
            representativeUserId: representativeUserId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$LessonsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {coachId = false,
              courtId = false,
              representativeUserId = false,
              lessonParticipantsRefs = false,
              lessonAttendancesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (lessonParticipantsRefs) db.lessonParticipants,
                if (lessonAttendancesRefs) db.lessonAttendances
              ],
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
                if (coachId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.coachId,
                    referencedTable: $$LessonsTableReferences._coachIdTable(db),
                    referencedColumn:
                        $$LessonsTableReferences._coachIdTable(db).id,
                  ) as T;
                }
                if (courtId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.courtId,
                    referencedTable: $$LessonsTableReferences._courtIdTable(db),
                    referencedColumn:
                        $$LessonsTableReferences._courtIdTable(db).id,
                  ) as T;
                }
                if (representativeUserId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.representativeUserId,
                    referencedTable:
                        $$LessonsTableReferences._representativeUserIdTable(db),
                    referencedColumn: $$LessonsTableReferences
                        ._representativeUserIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lessonParticipantsRefs)
                    await $_getPrefetchedData<Lesson, $LessonsTable,
                            LessonParticipant>(
                        currentTable: table,
                        referencedTable: $$LessonsTableReferences
                            ._lessonParticipantsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LessonsTableReferences(db, table, p0)
                                .lessonParticipantsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.lessonId == item.id),
                        typedResults: items),
                  if (lessonAttendancesRefs)
                    await $_getPrefetchedData<Lesson, $LessonsTable,
                            LessonAttendance>(
                        currentTable: table,
                        referencedTable: $$LessonsTableReferences
                            ._lessonAttendancesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LessonsTableReferences(db, table, p0)
                                .lessonAttendancesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.lessonId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LessonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonsTable,
    Lesson,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (Lesson, $$LessonsTableReferences),
    Lesson,
    PrefetchHooks Function(
        {bool coachId,
        bool courtId,
        bool representativeUserId,
        bool lessonParticipantsRefs,
        bool lessonAttendancesRefs})>;
typedef $$LessonParticipantsTableCreateCompanionBuilder
    = LessonParticipantsCompanion Function({
  required String id,
  required String lessonId,
  required String userId,
  Value<int> rowid,
});
typedef $$LessonParticipantsTableUpdateCompanionBuilder
    = LessonParticipantsCompanion Function({
  Value<String> id,
  Value<String> lessonId,
  Value<String> userId,
  Value<int> rowid,
});

final class $$LessonParticipantsTableReferences extends BaseReferences<
    _$AppDatabase, $LessonParticipantsTable, LessonParticipant> {
  $$LessonParticipantsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias(
          $_aliasNameGenerator(db.lessonParticipants.lessonId, db.lessons.id));

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<String>('lesson_id')!;

    final manager = $$LessonsTableTableManager($_db, $_db.lessons)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.lessonParticipants.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LessonParticipantsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonParticipantsTable> {
  $$LessonParticipantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableFilterComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonParticipantsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonParticipantsTable> {
  $$LessonParticipantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableOrderingComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonParticipantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonParticipantsTable> {
  $$LessonParticipantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableAnnotationComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonParticipantsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonParticipantsTable,
    LessonParticipant,
    $$LessonParticipantsTableFilterComposer,
    $$LessonParticipantsTableOrderingComposer,
    $$LessonParticipantsTableAnnotationComposer,
    $$LessonParticipantsTableCreateCompanionBuilder,
    $$LessonParticipantsTableUpdateCompanionBuilder,
    (LessonParticipant, $$LessonParticipantsTableReferences),
    LessonParticipant,
    PrefetchHooks Function({bool lessonId, bool userId})> {
  $$LessonParticipantsTableTableManager(
      _$AppDatabase db, $LessonParticipantsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonParticipantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonParticipantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonParticipantsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonParticipantsCompanion(
            id: id,
            lessonId: lessonId,
            userId: userId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String lessonId,
            required String userId,
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonParticipantsCompanion.insert(
            id: id,
            lessonId: lessonId,
            userId: userId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LessonParticipantsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({lessonId = false, userId = false}) {
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
                if (lessonId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lessonId,
                    referencedTable:
                        $$LessonParticipantsTableReferences._lessonIdTable(db),
                    referencedColumn: $$LessonParticipantsTableReferences
                        ._lessonIdTable(db)
                        .id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$LessonParticipantsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$LessonParticipantsTableReferences._userIdTable(db).id,
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

typedef $$LessonParticipantsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonParticipantsTable,
    LessonParticipant,
    $$LessonParticipantsTableFilterComposer,
    $$LessonParticipantsTableOrderingComposer,
    $$LessonParticipantsTableAnnotationComposer,
    $$LessonParticipantsTableCreateCompanionBuilder,
    $$LessonParticipantsTableUpdateCompanionBuilder,
    (LessonParticipant, $$LessonParticipantsTableReferences),
    LessonParticipant,
    PrefetchHooks Function({bool lessonId, bool userId})>;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  required String id,
  required String userId,
  required double amount,
  required String description,
  required DateTime dueDate,
  Value<DateTime?> paidAt,
  required String status,
  required String createdById,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<double> amount,
  Value<String> description,
  Value<DateTime> dueDate,
  Value<DateTime?> paidAt,
  Value<String> status,
  Value<String> createdById,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.payments.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _createdByIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.payments.createdById, db.users.id));

  $$UsersTableProcessedTableManager get createdById {
    final $_column = $_itemColumn<String>('created_by_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_createdByIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get createdById {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.createdById,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get createdById {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.createdById,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get createdById {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.createdById,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, $$PaymentsTableReferences),
    Payment,
    PrefetchHooks Function({bool userId, bool createdById})> {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<DateTime?> paidAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> createdById = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion(
            id: id,
            userId: userId,
            amount: amount,
            description: description,
            dueDate: dueDate,
            paidAt: paidAt,
            status: status,
            createdById: createdById,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required double amount,
            required String description,
            required DateTime dueDate,
            Value<DateTime?> paidAt = const Value.absent(),
            required String status,
            required String createdById,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion.insert(
            id: id,
            userId: userId,
            amount: amount,
            description: description,
            dueDate: dueDate,
            paidAt: paidAt,
            status: status,
            createdById: createdById,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PaymentsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({userId = false, createdById = false}) {
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
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable: $$PaymentsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$PaymentsTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (createdById) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.createdById,
                    referencedTable:
                        $$PaymentsTableReferences._createdByIdTable(db),
                    referencedColumn:
                        $$PaymentsTableReferences._createdByIdTable(db).id,
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

typedef $$PaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, $$PaymentsTableReferences),
    Payment,
    PrefetchHooks Function({bool userId, bool createdById})>;
typedef $$StudentProfilesTableCreateCompanionBuilder = StudentProfilesCompanion
    Function({
  required String userId,
  required String coachId,
  Value<int?> age,
  Value<String?> level,
  Value<String?> notes,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$StudentProfilesTableUpdateCompanionBuilder = StudentProfilesCompanion
    Function({
  Value<String> userId,
  Value<String> coachId,
  Value<int?> age,
  Value<String?> level,
  Value<String?> notes,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$StudentProfilesTableReferences extends BaseReferences<
    _$AppDatabase, $StudentProfilesTable, StudentProfile> {
  $$StudentProfilesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.studentProfiles.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _coachIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.studentProfiles.coachId, db.users.id));

  $$UsersTableProcessedTableManager get coachId {
    final $_column = $_itemColumn<String>('coach_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_coachIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StudentProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $StudentProfilesTable> {
  $$StudentProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get coachId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.coachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StudentProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentProfilesTable> {
  $$StudentProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get coachId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.coachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StudentProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentProfilesTable> {
  $$StudentProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get coachId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.coachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StudentProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudentProfilesTable,
    StudentProfile,
    $$StudentProfilesTableFilterComposer,
    $$StudentProfilesTableOrderingComposer,
    $$StudentProfilesTableAnnotationComposer,
    $$StudentProfilesTableCreateCompanionBuilder,
    $$StudentProfilesTableUpdateCompanionBuilder,
    (StudentProfile, $$StudentProfilesTableReferences),
    StudentProfile,
    PrefetchHooks Function({bool userId, bool coachId})> {
  $$StudentProfilesTableTableManager(
      _$AppDatabase db, $StudentProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<String> coachId = const Value.absent(),
            Value<int?> age = const Value.absent(),
            Value<String?> level = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentProfilesCompanion(
            userId: userId,
            coachId: coachId,
            age: age,
            level: level,
            notes: notes,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required String coachId,
            Value<int?> age = const Value.absent(),
            Value<String?> level = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentProfilesCompanion.insert(
            userId: userId,
            coachId: coachId,
            age: age,
            level: level,
            notes: notes,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StudentProfilesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false, coachId = false}) {
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
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$StudentProfilesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$StudentProfilesTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (coachId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.coachId,
                    referencedTable:
                        $$StudentProfilesTableReferences._coachIdTable(db),
                    referencedColumn:
                        $$StudentProfilesTableReferences._coachIdTable(db).id,
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

typedef $$StudentProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudentProfilesTable,
    StudentProfile,
    $$StudentProfilesTableFilterComposer,
    $$StudentProfilesTableOrderingComposer,
    $$StudentProfilesTableAnnotationComposer,
    $$StudentProfilesTableCreateCompanionBuilder,
    $$StudentProfilesTableUpdateCompanionBuilder,
    (StudentProfile, $$StudentProfilesTableReferences),
    StudentProfile,
    PrefetchHooks Function({bool userId, bool coachId})>;
typedef $$ParentAthleteLinksTableCreateCompanionBuilder
    = ParentAthleteLinksCompanion Function({
  required String parentId,
  required String athleteId,
  Value<int> rowid,
});
typedef $$ParentAthleteLinksTableUpdateCompanionBuilder
    = ParentAthleteLinksCompanion Function({
  Value<String> parentId,
  Value<String> athleteId,
  Value<int> rowid,
});

final class $$ParentAthleteLinksTableReferences extends BaseReferences<
    _$AppDatabase, $ParentAthleteLinksTable, ParentAthleteLink> {
  $$ParentAthleteLinksTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _parentIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.parentAthleteLinks.parentId, db.users.id));

  $$UsersTableProcessedTableManager get parentId {
    final $_column = $_itemColumn<String>('parent_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _athleteIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.parentAthleteLinks.athleteId, db.users.id));

  $$UsersTableProcessedTableManager get athleteId {
    final $_column = $_itemColumn<String>('athlete_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_athleteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ParentAthleteLinksTableFilterComposer
    extends Composer<_$AppDatabase, $ParentAthleteLinksTable> {
  $$ParentAthleteLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$UsersTableFilterComposer get parentId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get athleteId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.athleteId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ParentAthleteLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $ParentAthleteLinksTable> {
  $$ParentAthleteLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$UsersTableOrderingComposer get parentId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get athleteId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.athleteId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ParentAthleteLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParentAthleteLinksTable> {
  $$ParentAthleteLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$UsersTableAnnotationComposer get parentId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get athleteId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.athleteId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ParentAthleteLinksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ParentAthleteLinksTable,
    ParentAthleteLink,
    $$ParentAthleteLinksTableFilterComposer,
    $$ParentAthleteLinksTableOrderingComposer,
    $$ParentAthleteLinksTableAnnotationComposer,
    $$ParentAthleteLinksTableCreateCompanionBuilder,
    $$ParentAthleteLinksTableUpdateCompanionBuilder,
    (ParentAthleteLink, $$ParentAthleteLinksTableReferences),
    ParentAthleteLink,
    PrefetchHooks Function({bool parentId, bool athleteId})> {
  $$ParentAthleteLinksTableTableManager(
      _$AppDatabase db, $ParentAthleteLinksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParentAthleteLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParentAthleteLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParentAthleteLinksTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> parentId = const Value.absent(),
            Value<String> athleteId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ParentAthleteLinksCompanion(
            parentId: parentId,
            athleteId: athleteId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String parentId,
            required String athleteId,
            Value<int> rowid = const Value.absent(),
          }) =>
              ParentAthleteLinksCompanion.insert(
            parentId: parentId,
            athleteId: athleteId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ParentAthleteLinksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({parentId = false, athleteId = false}) {
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
                if (parentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable:
                        $$ParentAthleteLinksTableReferences._parentIdTable(db),
                    referencedColumn: $$ParentAthleteLinksTableReferences
                        ._parentIdTable(db)
                        .id,
                  ) as T;
                }
                if (athleteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.athleteId,
                    referencedTable:
                        $$ParentAthleteLinksTableReferences._athleteIdTable(db),
                    referencedColumn: $$ParentAthleteLinksTableReferences
                        ._athleteIdTable(db)
                        .id,
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

typedef $$ParentAthleteLinksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ParentAthleteLinksTable,
    ParentAthleteLink,
    $$ParentAthleteLinksTableFilterComposer,
    $$ParentAthleteLinksTableOrderingComposer,
    $$ParentAthleteLinksTableAnnotationComposer,
    $$ParentAthleteLinksTableCreateCompanionBuilder,
    $$ParentAthleteLinksTableUpdateCompanionBuilder,
    (ParentAthleteLink, $$ParentAthleteLinksTableReferences),
    ParentAthleteLink,
    PrefetchHooks Function({bool parentId, bool athleteId})>;
typedef $$LessonAttendancesTableCreateCompanionBuilder
    = LessonAttendancesCompanion Function({
  required String id,
  required String lessonId,
  required String userId,
  required String status,
  required DateTime markedAt,
  required String markedById,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$LessonAttendancesTableUpdateCompanionBuilder
    = LessonAttendancesCompanion Function({
  Value<String> id,
  Value<String> lessonId,
  Value<String> userId,
  Value<String> status,
  Value<DateTime> markedAt,
  Value<String> markedById,
  Value<String?> notes,
  Value<int> rowid,
});

final class $$LessonAttendancesTableReferences extends BaseReferences<
    _$AppDatabase, $LessonAttendancesTable, LessonAttendance> {
  $$LessonAttendancesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias(
          $_aliasNameGenerator(db.lessonAttendances.lessonId, db.lessons.id));

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<String>('lesson_id')!;

    final manager = $$LessonsTableTableManager($_db, $_db.lessons)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.lessonAttendances.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _markedByIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.lessonAttendances.markedById, db.users.id));

  $$UsersTableProcessedTableManager get markedById {
    final $_column = $_itemColumn<String>('marked_by_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_markedByIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LessonAttendancesTableFilterComposer
    extends Composer<_$AppDatabase, $LessonAttendancesTable> {
  $$LessonAttendancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get markedAt => $composableBuilder(
      column: $table.markedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableFilterComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get markedById {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.markedById,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonAttendancesTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonAttendancesTable> {
  $$LessonAttendancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get markedAt => $composableBuilder(
      column: $table.markedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableOrderingComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get markedById {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.markedById,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonAttendancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonAttendancesTable> {
  $$LessonAttendancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get markedAt =>
      $composableBuilder(column: $table.markedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lessonId,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableAnnotationComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get markedById {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.markedById,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonAttendancesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonAttendancesTable,
    LessonAttendance,
    $$LessonAttendancesTableFilterComposer,
    $$LessonAttendancesTableOrderingComposer,
    $$LessonAttendancesTableAnnotationComposer,
    $$LessonAttendancesTableCreateCompanionBuilder,
    $$LessonAttendancesTableUpdateCompanionBuilder,
    (LessonAttendance, $$LessonAttendancesTableReferences),
    LessonAttendance,
    PrefetchHooks Function({bool lessonId, bool userId, bool markedById})> {
  $$LessonAttendancesTableTableManager(
      _$AppDatabase db, $LessonAttendancesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonAttendancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonAttendancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonAttendancesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> markedAt = const Value.absent(),
            Value<String> markedById = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonAttendancesCompanion(
            id: id,
            lessonId: lessonId,
            userId: userId,
            status: status,
            markedAt: markedAt,
            markedById: markedById,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String lessonId,
            required String userId,
            required String status,
            required DateTime markedAt,
            required String markedById,
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonAttendancesCompanion.insert(
            id: id,
            lessonId: lessonId,
            userId: userId,
            status: status,
            markedAt: markedAt,
            markedById: markedById,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LessonAttendancesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {lessonId = false, userId = false, markedById = false}) {
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
                if (lessonId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lessonId,
                    referencedTable:
                        $$LessonAttendancesTableReferences._lessonIdTable(db),
                    referencedColumn: $$LessonAttendancesTableReferences
                        ._lessonIdTable(db)
                        .id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$LessonAttendancesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$LessonAttendancesTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (markedById) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.markedById,
                    referencedTable:
                        $$LessonAttendancesTableReferences._markedByIdTable(db),
                    referencedColumn: $$LessonAttendancesTableReferences
                        ._markedByIdTable(db)
                        .id,
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

typedef $$LessonAttendancesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonAttendancesTable,
    LessonAttendance,
    $$LessonAttendancesTableFilterComposer,
    $$LessonAttendancesTableOrderingComposer,
    $$LessonAttendancesTableAnnotationComposer,
    $$LessonAttendancesTableCreateCompanionBuilder,
    $$LessonAttendancesTableUpdateCompanionBuilder,
    (LessonAttendance, $$LessonAttendancesTableReferences),
    LessonAttendance,
    PrefetchHooks Function({bool lessonId, bool userId, bool markedById})>;
typedef $$WeeklyCourtRightsTableCreateCompanionBuilder
    = WeeklyCourtRightsCompanion Function({
  required String id,
  required int weekday,
  required String courtId,
  required int hour,
  Value<String?> coachId,
  Value<String?> label,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$WeeklyCourtRightsTableUpdateCompanionBuilder
    = WeeklyCourtRightsCompanion Function({
  Value<String> id,
  Value<int> weekday,
  Value<String> courtId,
  Value<int> hour,
  Value<String?> coachId,
  Value<String?> label,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$WeeklyCourtRightsTableReferences extends BaseReferences<
    _$AppDatabase, $WeeklyCourtRightsTable, WeeklyCourtRight> {
  $$WeeklyCourtRightsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CourtsTable _courtIdTable(_$AppDatabase db) => db.courts.createAlias(
      $_aliasNameGenerator(db.weeklyCourtRights.courtId, db.courts.id));

  $$CourtsTableProcessedTableManager get courtId {
    final $_column = $_itemColumn<String>('court_id')!;

    final manager = $$CourtsTableTableManager($_db, $_db.courts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courtIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _coachIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.weeklyCourtRights.coachId, db.users.id));

  $$UsersTableProcessedTableManager? get coachId {
    final $_column = $_itemColumn<String>('coach_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_coachIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WeeklyCourtRightsTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyCourtRightsTable> {
  $$WeeklyCourtRightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekday => $composableBuilder(
      column: $table.weekday, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CourtsTableFilterComposer get courtId {
    final $$CourtsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableFilterComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get coachId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.coachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WeeklyCourtRightsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyCourtRightsTable> {
  $$WeeklyCourtRightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekday => $composableBuilder(
      column: $table.weekday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CourtsTableOrderingComposer get courtId {
    final $$CourtsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableOrderingComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get coachId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.coachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WeeklyCourtRightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyCourtRightsTable> {
  $$WeeklyCourtRightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CourtsTableAnnotationComposer get courtId {
    final $$CourtsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableAnnotationComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get coachId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.coachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WeeklyCourtRightsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WeeklyCourtRightsTable,
    WeeklyCourtRight,
    $$WeeklyCourtRightsTableFilterComposer,
    $$WeeklyCourtRightsTableOrderingComposer,
    $$WeeklyCourtRightsTableAnnotationComposer,
    $$WeeklyCourtRightsTableCreateCompanionBuilder,
    $$WeeklyCourtRightsTableUpdateCompanionBuilder,
    (WeeklyCourtRight, $$WeeklyCourtRightsTableReferences),
    WeeklyCourtRight,
    PrefetchHooks Function({bool courtId, bool coachId})> {
  $$WeeklyCourtRightsTableTableManager(
      _$AppDatabase db, $WeeklyCourtRightsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyCourtRightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyCourtRightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyCourtRightsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> weekday = const Value.absent(),
            Value<String> courtId = const Value.absent(),
            Value<int> hour = const Value.absent(),
            Value<String?> coachId = const Value.absent(),
            Value<String?> label = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WeeklyCourtRightsCompanion(
            id: id,
            weekday: weekday,
            courtId: courtId,
            hour: hour,
            coachId: coachId,
            label: label,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int weekday,
            required String courtId,
            required int hour,
            Value<String?> coachId = const Value.absent(),
            Value<String?> label = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              WeeklyCourtRightsCompanion.insert(
            id: id,
            weekday: weekday,
            courtId: courtId,
            hour: hour,
            coachId: coachId,
            label: label,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WeeklyCourtRightsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({courtId = false, coachId = false}) {
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
                if (courtId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.courtId,
                    referencedTable:
                        $$WeeklyCourtRightsTableReferences._courtIdTable(db),
                    referencedColumn:
                        $$WeeklyCourtRightsTableReferences._courtIdTable(db).id,
                  ) as T;
                }
                if (coachId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.coachId,
                    referencedTable:
                        $$WeeklyCourtRightsTableReferences._coachIdTable(db),
                    referencedColumn:
                        $$WeeklyCourtRightsTableReferences._coachIdTable(db).id,
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

typedef $$WeeklyCourtRightsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WeeklyCourtRightsTable,
    WeeklyCourtRight,
    $$WeeklyCourtRightsTableFilterComposer,
    $$WeeklyCourtRightsTableOrderingComposer,
    $$WeeklyCourtRightsTableAnnotationComposer,
    $$WeeklyCourtRightsTableCreateCompanionBuilder,
    $$WeeklyCourtRightsTableUpdateCompanionBuilder,
    (WeeklyCourtRight, $$WeeklyCourtRightsTableReferences),
    WeeklyCourtRight,
    PrefetchHooks Function({bool courtId, bool coachId})>;
typedef $$PlanChangeRequestsTableCreateCompanionBuilder
    = PlanChangeRequestsCompanion Function({
  required String id,
  required String requesterId,
  required int weekday,
  required String courtId,
  required int hour,
  Value<String?> fromCoachId,
  Value<String?> toCoachId,
  Value<String?> note,
  Value<String> status,
  required DateTime createdAt,
  Value<DateTime?> resolvedAt,
  Value<String?> resolvedById,
  Value<int> rowid,
});
typedef $$PlanChangeRequestsTableUpdateCompanionBuilder
    = PlanChangeRequestsCompanion Function({
  Value<String> id,
  Value<String> requesterId,
  Value<int> weekday,
  Value<String> courtId,
  Value<int> hour,
  Value<String?> fromCoachId,
  Value<String?> toCoachId,
  Value<String?> note,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime?> resolvedAt,
  Value<String?> resolvedById,
  Value<int> rowid,
});

final class $$PlanChangeRequestsTableReferences extends BaseReferences<
    _$AppDatabase, $PlanChangeRequestsTable, PlanChangeRequest> {
  $$PlanChangeRequestsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _requesterIdTable(_$AppDatabase db) =>
      db.users.createAlias(
          $_aliasNameGenerator(db.planChangeRequests.requesterId, db.users.id));

  $$UsersTableProcessedTableManager get requesterId {
    final $_column = $_itemColumn<String>('requester_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_requesterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CourtsTable _courtIdTable(_$AppDatabase db) => db.courts.createAlias(
      $_aliasNameGenerator(db.planChangeRequests.courtId, db.courts.id));

  $$CourtsTableProcessedTableManager get courtId {
    final $_column = $_itemColumn<String>('court_id')!;

    final manager = $$CourtsTableTableManager($_db, $_db.courts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courtIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _fromCoachIdTable(_$AppDatabase db) =>
      db.users.createAlias(
          $_aliasNameGenerator(db.planChangeRequests.fromCoachId, db.users.id));

  $$UsersTableProcessedTableManager? get fromCoachId {
    final $_column = $_itemColumn<String>('from_coach_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromCoachIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _toCoachIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.planChangeRequests.toCoachId, db.users.id));

  $$UsersTableProcessedTableManager? get toCoachId {
    final $_column = $_itemColumn<String>('to_coach_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toCoachIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _resolvedByIdTable(_$AppDatabase db) =>
      db.users.createAlias($_aliasNameGenerator(
          db.planChangeRequests.resolvedById, db.users.id));

  $$UsersTableProcessedTableManager? get resolvedById {
    final $_column = $_itemColumn<String>('resolved_by_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_resolvedByIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlanChangeRequestsTableFilterComposer
    extends Composer<_$AppDatabase, $PlanChangeRequestsTable> {
  $$PlanChangeRequestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekday => $composableBuilder(
      column: $table.weekday, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get requesterId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.requesterId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CourtsTableFilterComposer get courtId {
    final $$CourtsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableFilterComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get fromCoachId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromCoachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get toCoachId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toCoachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get resolvedById {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.resolvedById,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlanChangeRequestsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanChangeRequestsTable> {
  $$PlanChangeRequestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekday => $composableBuilder(
      column: $table.weekday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get requesterId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.requesterId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CourtsTableOrderingComposer get courtId {
    final $$CourtsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableOrderingComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get fromCoachId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromCoachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get toCoachId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toCoachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get resolvedById {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.resolvedById,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlanChangeRequestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanChangeRequestsTable> {
  $$PlanChangeRequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get requesterId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.requesterId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CourtsTableAnnotationComposer get courtId {
    final $$CourtsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courtId,
        referencedTable: $db.courts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CourtsTableAnnotationComposer(
              $db: $db,
              $table: $db.courts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get fromCoachId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromCoachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get toCoachId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toCoachId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get resolvedById {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.resolvedById,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlanChangeRequestsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlanChangeRequestsTable,
    PlanChangeRequest,
    $$PlanChangeRequestsTableFilterComposer,
    $$PlanChangeRequestsTableOrderingComposer,
    $$PlanChangeRequestsTableAnnotationComposer,
    $$PlanChangeRequestsTableCreateCompanionBuilder,
    $$PlanChangeRequestsTableUpdateCompanionBuilder,
    (PlanChangeRequest, $$PlanChangeRequestsTableReferences),
    PlanChangeRequest,
    PrefetchHooks Function(
        {bool requesterId,
        bool courtId,
        bool fromCoachId,
        bool toCoachId,
        bool resolvedById})> {
  $$PlanChangeRequestsTableTableManager(
      _$AppDatabase db, $PlanChangeRequestsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanChangeRequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanChangeRequestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanChangeRequestsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> requesterId = const Value.absent(),
            Value<int> weekday = const Value.absent(),
            Value<String> courtId = const Value.absent(),
            Value<int> hour = const Value.absent(),
            Value<String?> fromCoachId = const Value.absent(),
            Value<String?> toCoachId = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> resolvedAt = const Value.absent(),
            Value<String?> resolvedById = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlanChangeRequestsCompanion(
            id: id,
            requesterId: requesterId,
            weekday: weekday,
            courtId: courtId,
            hour: hour,
            fromCoachId: fromCoachId,
            toCoachId: toCoachId,
            note: note,
            status: status,
            createdAt: createdAt,
            resolvedAt: resolvedAt,
            resolvedById: resolvedById,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String requesterId,
            required int weekday,
            required String courtId,
            required int hour,
            Value<String?> fromCoachId = const Value.absent(),
            Value<String?> toCoachId = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String> status = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> resolvedAt = const Value.absent(),
            Value<String?> resolvedById = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlanChangeRequestsCompanion.insert(
            id: id,
            requesterId: requesterId,
            weekday: weekday,
            courtId: courtId,
            hour: hour,
            fromCoachId: fromCoachId,
            toCoachId: toCoachId,
            note: note,
            status: status,
            createdAt: createdAt,
            resolvedAt: resolvedAt,
            resolvedById: resolvedById,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlanChangeRequestsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {requesterId = false,
              courtId = false,
              fromCoachId = false,
              toCoachId = false,
              resolvedById = false}) {
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
                if (requesterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.requesterId,
                    referencedTable: $$PlanChangeRequestsTableReferences
                        ._requesterIdTable(db),
                    referencedColumn: $$PlanChangeRequestsTableReferences
                        ._requesterIdTable(db)
                        .id,
                  ) as T;
                }
                if (courtId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.courtId,
                    referencedTable:
                        $$PlanChangeRequestsTableReferences._courtIdTable(db),
                    referencedColumn: $$PlanChangeRequestsTableReferences
                        ._courtIdTable(db)
                        .id,
                  ) as T;
                }
                if (fromCoachId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.fromCoachId,
                    referencedTable: $$PlanChangeRequestsTableReferences
                        ._fromCoachIdTable(db),
                    referencedColumn: $$PlanChangeRequestsTableReferences
                        ._fromCoachIdTable(db)
                        .id,
                  ) as T;
                }
                if (toCoachId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.toCoachId,
                    referencedTable:
                        $$PlanChangeRequestsTableReferences._toCoachIdTable(db),
                    referencedColumn: $$PlanChangeRequestsTableReferences
                        ._toCoachIdTable(db)
                        .id,
                  ) as T;
                }
                if (resolvedById) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.resolvedById,
                    referencedTable: $$PlanChangeRequestsTableReferences
                        ._resolvedByIdTable(db),
                    referencedColumn: $$PlanChangeRequestsTableReferences
                        ._resolvedByIdTable(db)
                        .id,
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

typedef $$PlanChangeRequestsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlanChangeRequestsTable,
    PlanChangeRequest,
    $$PlanChangeRequestsTableFilterComposer,
    $$PlanChangeRequestsTableOrderingComposer,
    $$PlanChangeRequestsTableAnnotationComposer,
    $$PlanChangeRequestsTableCreateCompanionBuilder,
    $$PlanChangeRequestsTableUpdateCompanionBuilder,
    (PlanChangeRequest, $$PlanChangeRequestsTableReferences),
    PlanChangeRequest,
    PrefetchHooks Function(
        {bool requesterId,
        bool courtId,
        bool fromCoachId,
        bool toCoachId,
        bool resolvedById})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$CourtsTableTableManager get courts =>
      $$CourtsTableTableManager(_db, _db.courts);
  $$CourtBlocksTableTableManager get courtBlocks =>
      $$CourtBlocksTableTableManager(_db, _db.courtBlocks);
  $$CourtRentalsTableTableManager get courtRentals =>
      $$CourtRentalsTableTableManager(_db, _db.courtRentals);
  $$CreditTransactionsTableTableManager get creditTransactions =>
      $$CreditTransactionsTableTableManager(_db, _db.creditTransactions);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$LessonParticipantsTableTableManager get lessonParticipants =>
      $$LessonParticipantsTableTableManager(_db, _db.lessonParticipants);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$StudentProfilesTableTableManager get studentProfiles =>
      $$StudentProfilesTableTableManager(_db, _db.studentProfiles);
  $$ParentAthleteLinksTableTableManager get parentAthleteLinks =>
      $$ParentAthleteLinksTableTableManager(_db, _db.parentAthleteLinks);
  $$LessonAttendancesTableTableManager get lessonAttendances =>
      $$LessonAttendancesTableTableManager(_db, _db.lessonAttendances);
  $$WeeklyCourtRightsTableTableManager get weeklyCourtRights =>
      $$WeeklyCourtRightsTableTableManager(_db, _db.weeklyCourtRights);
  $$PlanChangeRequestsTableTableManager get planChangeRequests =>
      $$PlanChangeRequestsTableTableManager(_db, _db.planChangeRequests);
}
