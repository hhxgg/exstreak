// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, ExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MuscleGroup, String> muscleGroup =
      GeneratedColumn<String>(
        'muscle_group',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MuscleGroup>($ExercisesTable.$convertermuscleGroup);
  @override
  late final GeneratedColumnWithTypeConverter<Equipment, String> equipment =
      GeneratedColumn<String>(
        'equipment',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Equipment>($ExercisesTable.$converterequipment);
  @override
  late final GeneratedColumnWithTypeConverter<Difficulty, String> difficulty =
      GeneratedColumn<String>(
        'difficulty',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Difficulty>($ExercisesTable.$converterdifficulty);
  @override
  late final GeneratedColumnWithTypeConverter<TrackingType, String>
  trackingType = GeneratedColumn<String>(
    'tracking_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TrackingType>($ExercisesTable.$convertertrackingType);
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('dumbbell'),
  );
  static const VerificationMeta _isBodyweightMeta = const VerificationMeta(
    'isBodyweight',
  );
  @override
  late final GeneratedColumn<bool> isBodyweight = GeneratedColumn<bool>(
    'is_bodyweight',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_bodyweight" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _intensityFactorMeta = const VerificationMeta(
    'intensityFactor',
  );
  @override
  late final GeneratedColumn<double> intensityFactor = GeneratedColumn<double>(
    'intensity_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _defaultRestSecondsMeta =
      const VerificationMeta('defaultRestSeconds');
  @override
  late final GeneratedColumn<int> defaultRestSeconds = GeneratedColumn<int>(
    'default_rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(90),
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavouriteMeta = const VerificationMeta(
    'isFavourite',
  );
  @override
  late final GeneratedColumn<bool> isFavourite = GeneratedColumn<bool>(
    'is_favourite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favourite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slug,
    name,
    muscleGroup,
    equipment,
    difficulty,
    trackingType,
    description,
    instructions,
    iconName,
    isBodyweight,
    intensityFactor,
    defaultRestSeconds,
    isCustom,
    isFavourite,
    isArchived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
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
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('is_bodyweight')) {
      context.handle(
        _isBodyweightMeta,
        isBodyweight.isAcceptableOrUnknown(
          data['is_bodyweight']!,
          _isBodyweightMeta,
        ),
      );
    }
    if (data.containsKey('intensity_factor')) {
      context.handle(
        _intensityFactorMeta,
        intensityFactor.isAcceptableOrUnknown(
          data['intensity_factor']!,
          _intensityFactorMeta,
        ),
      );
    }
    if (data.containsKey('default_rest_seconds')) {
      context.handle(
        _defaultRestSecondsMeta,
        defaultRestSeconds.isAcceptableOrUnknown(
          data['default_rest_seconds']!,
          _defaultRestSecondsMeta,
        ),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('is_favourite')) {
      context.handle(
        _isFavouriteMeta,
        isFavourite.isAcceptableOrUnknown(
          data['is_favourite']!,
          _isFavouriteMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      muscleGroup: $ExercisesTable.$convertermuscleGroup.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}muscle_group'],
        )!,
      ),
      equipment: $ExercisesTable.$converterequipment.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}equipment'],
        )!,
      ),
      difficulty: $ExercisesTable.$converterdifficulty.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}difficulty'],
        )!,
      ),
      trackingType: $ExercisesTable.$convertertrackingType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tracking_type'],
        )!,
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      )!,
      isBodyweight: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_bodyweight'],
      )!,
      intensityFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}intensity_factor'],
      )!,
      defaultRestSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_rest_seconds'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      isFavourite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favourite'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MuscleGroup, String, String> $convertermuscleGroup =
      const EnumNameConverter<MuscleGroup>(MuscleGroup.values);
  static JsonTypeConverter2<Equipment, String, String> $converterequipment =
      const EnumNameConverter<Equipment>(Equipment.values);
  static JsonTypeConverter2<Difficulty, String, String> $converterdifficulty =
      const EnumNameConverter<Difficulty>(Difficulty.values);
  static JsonTypeConverter2<TrackingType, String, String>
  $convertertrackingType = const EnumNameConverter<TrackingType>(
    TrackingType.values,
  );
}

class ExerciseRow extends DataClass implements Insertable<ExerciseRow> {
  final int id;

  /// Stable identifier for seeded exercises (`pushup`, `plank`, …) so the seed
  /// can be upgraded across app versions without duplicating rows. Null for
  /// user-created exercises.
  final String? slug;
  final String name;
  final MuscleGroup muscleGroup;
  final Equipment equipment;
  final Difficulty difficulty;
  final TrackingType trackingType;
  final String description;

  /// Newline-separated coaching cues.
  final String instructions;

  /// Key into `ExerciseIcons.registry`. Stored as a name rather than a raw
  /// codepoint so Flutter can still tree-shake the icon font in release builds.
  final String iconName;
  final bool isBodyweight;

  /// Approximate MET-style factor, used to weight "volume" across exercises
  /// so that 10 pull-ups do not read as equal effort to 10 crunches.
  final double intensityFactor;

  /// Default rest between sets, in seconds.
  final int defaultRestSeconds;
  final bool isCustom;
  final bool isFavourite;

  /// Soft delete: keeps historical workouts intact when a user removes an
  /// exercise from their library.
  final bool isArchived;
  final DateTime createdAt;
  const ExerciseRow({
    required this.id,
    this.slug,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    required this.trackingType,
    required this.description,
    required this.instructions,
    required this.iconName,
    required this.isBodyweight,
    required this.intensityFactor,
    required this.defaultRestSeconds,
    required this.isCustom,
    required this.isFavourite,
    required this.isArchived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || slug != null) {
      map['slug'] = Variable<String>(slug);
    }
    map['name'] = Variable<String>(name);
    {
      map['muscle_group'] = Variable<String>(
        $ExercisesTable.$convertermuscleGroup.toSql(muscleGroup),
      );
    }
    {
      map['equipment'] = Variable<String>(
        $ExercisesTable.$converterequipment.toSql(equipment),
      );
    }
    {
      map['difficulty'] = Variable<String>(
        $ExercisesTable.$converterdifficulty.toSql(difficulty),
      );
    }
    {
      map['tracking_type'] = Variable<String>(
        $ExercisesTable.$convertertrackingType.toSql(trackingType),
      );
    }
    map['description'] = Variable<String>(description);
    map['instructions'] = Variable<String>(instructions);
    map['icon_name'] = Variable<String>(iconName);
    map['is_bodyweight'] = Variable<bool>(isBodyweight);
    map['intensity_factor'] = Variable<double>(intensityFactor);
    map['default_rest_seconds'] = Variable<int>(defaultRestSeconds);
    map['is_custom'] = Variable<bool>(isCustom);
    map['is_favourite'] = Variable<bool>(isFavourite);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      slug: slug == null && nullToAbsent ? const Value.absent() : Value(slug),
      name: Value(name),
      muscleGroup: Value(muscleGroup),
      equipment: Value(equipment),
      difficulty: Value(difficulty),
      trackingType: Value(trackingType),
      description: Value(description),
      instructions: Value(instructions),
      iconName: Value(iconName),
      isBodyweight: Value(isBodyweight),
      intensityFactor: Value(intensityFactor),
      defaultRestSeconds: Value(defaultRestSeconds),
      isCustom: Value(isCustom),
      isFavourite: Value(isFavourite),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
    );
  }

  factory ExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseRow(
      id: serializer.fromJson<int>(json['id']),
      slug: serializer.fromJson<String?>(json['slug']),
      name: serializer.fromJson<String>(json['name']),
      muscleGroup: $ExercisesTable.$convertermuscleGroup.fromJson(
        serializer.fromJson<String>(json['muscleGroup']),
      ),
      equipment: $ExercisesTable.$converterequipment.fromJson(
        serializer.fromJson<String>(json['equipment']),
      ),
      difficulty: $ExercisesTable.$converterdifficulty.fromJson(
        serializer.fromJson<String>(json['difficulty']),
      ),
      trackingType: $ExercisesTable.$convertertrackingType.fromJson(
        serializer.fromJson<String>(json['trackingType']),
      ),
      description: serializer.fromJson<String>(json['description']),
      instructions: serializer.fromJson<String>(json['instructions']),
      iconName: serializer.fromJson<String>(json['iconName']),
      isBodyweight: serializer.fromJson<bool>(json['isBodyweight']),
      intensityFactor: serializer.fromJson<double>(json['intensityFactor']),
      defaultRestSeconds: serializer.fromJson<int>(json['defaultRestSeconds']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      isFavourite: serializer.fromJson<bool>(json['isFavourite']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slug': serializer.toJson<String?>(slug),
      'name': serializer.toJson<String>(name),
      'muscleGroup': serializer.toJson<String>(
        $ExercisesTable.$convertermuscleGroup.toJson(muscleGroup),
      ),
      'equipment': serializer.toJson<String>(
        $ExercisesTable.$converterequipment.toJson(equipment),
      ),
      'difficulty': serializer.toJson<String>(
        $ExercisesTable.$converterdifficulty.toJson(difficulty),
      ),
      'trackingType': serializer.toJson<String>(
        $ExercisesTable.$convertertrackingType.toJson(trackingType),
      ),
      'description': serializer.toJson<String>(description),
      'instructions': serializer.toJson<String>(instructions),
      'iconName': serializer.toJson<String>(iconName),
      'isBodyweight': serializer.toJson<bool>(isBodyweight),
      'intensityFactor': serializer.toJson<double>(intensityFactor),
      'defaultRestSeconds': serializer.toJson<int>(defaultRestSeconds),
      'isCustom': serializer.toJson<bool>(isCustom),
      'isFavourite': serializer.toJson<bool>(isFavourite),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExerciseRow copyWith({
    int? id,
    Value<String?> slug = const Value.absent(),
    String? name,
    MuscleGroup? muscleGroup,
    Equipment? equipment,
    Difficulty? difficulty,
    TrackingType? trackingType,
    String? description,
    String? instructions,
    String? iconName,
    bool? isBodyweight,
    double? intensityFactor,
    int? defaultRestSeconds,
    bool? isCustom,
    bool? isFavourite,
    bool? isArchived,
    DateTime? createdAt,
  }) => ExerciseRow(
    id: id ?? this.id,
    slug: slug.present ? slug.value : this.slug,
    name: name ?? this.name,
    muscleGroup: muscleGroup ?? this.muscleGroup,
    equipment: equipment ?? this.equipment,
    difficulty: difficulty ?? this.difficulty,
    trackingType: trackingType ?? this.trackingType,
    description: description ?? this.description,
    instructions: instructions ?? this.instructions,
    iconName: iconName ?? this.iconName,
    isBodyweight: isBodyweight ?? this.isBodyweight,
    intensityFactor: intensityFactor ?? this.intensityFactor,
    defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
    isCustom: isCustom ?? this.isCustom,
    isFavourite: isFavourite ?? this.isFavourite,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
  );
  ExerciseRow copyWithCompanion(ExercisesCompanion data) {
    return ExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      name: data.name.present ? data.name.value : this.name,
      muscleGroup: data.muscleGroup.present
          ? data.muscleGroup.value
          : this.muscleGroup,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      trackingType: data.trackingType.present
          ? data.trackingType.value
          : this.trackingType,
      description: data.description.present
          ? data.description.value
          : this.description,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      isBodyweight: data.isBodyweight.present
          ? data.isBodyweight.value
          : this.isBodyweight,
      intensityFactor: data.intensityFactor.present
          ? data.intensityFactor.value
          : this.intensityFactor,
      defaultRestSeconds: data.defaultRestSeconds.present
          ? data.defaultRestSeconds.value
          : this.defaultRestSeconds,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      isFavourite: data.isFavourite.present
          ? data.isFavourite.value
          : this.isFavourite,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseRow(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('equipment: $equipment, ')
          ..write('difficulty: $difficulty, ')
          ..write('trackingType: $trackingType, ')
          ..write('description: $description, ')
          ..write('instructions: $instructions, ')
          ..write('iconName: $iconName, ')
          ..write('isBodyweight: $isBodyweight, ')
          ..write('intensityFactor: $intensityFactor, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('isCustom: $isCustom, ')
          ..write('isFavourite: $isFavourite, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    slug,
    name,
    muscleGroup,
    equipment,
    difficulty,
    trackingType,
    description,
    instructions,
    iconName,
    isBodyweight,
    intensityFactor,
    defaultRestSeconds,
    isCustom,
    isFavourite,
    isArchived,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseRow &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.name == this.name &&
          other.muscleGroup == this.muscleGroup &&
          other.equipment == this.equipment &&
          other.difficulty == this.difficulty &&
          other.trackingType == this.trackingType &&
          other.description == this.description &&
          other.instructions == this.instructions &&
          other.iconName == this.iconName &&
          other.isBodyweight == this.isBodyweight &&
          other.intensityFactor == this.intensityFactor &&
          other.defaultRestSeconds == this.defaultRestSeconds &&
          other.isCustom == this.isCustom &&
          other.isFavourite == this.isFavourite &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt);
}

class ExercisesCompanion extends UpdateCompanion<ExerciseRow> {
  final Value<int> id;
  final Value<String?> slug;
  final Value<String> name;
  final Value<MuscleGroup> muscleGroup;
  final Value<Equipment> equipment;
  final Value<Difficulty> difficulty;
  final Value<TrackingType> trackingType;
  final Value<String> description;
  final Value<String> instructions;
  final Value<String> iconName;
  final Value<bool> isBodyweight;
  final Value<double> intensityFactor;
  final Value<int> defaultRestSeconds;
  final Value<bool> isCustom;
  final Value<bool> isFavourite;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.name = const Value.absent(),
    this.muscleGroup = const Value.absent(),
    this.equipment = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.trackingType = const Value.absent(),
    this.description = const Value.absent(),
    this.instructions = const Value.absent(),
    this.iconName = const Value.absent(),
    this.isBodyweight = const Value.absent(),
    this.intensityFactor = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isFavourite = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    required String name,
    required MuscleGroup muscleGroup,
    required Equipment equipment,
    required Difficulty difficulty,
    required TrackingType trackingType,
    this.description = const Value.absent(),
    this.instructions = const Value.absent(),
    this.iconName = const Value.absent(),
    this.isBodyweight = const Value.absent(),
    this.intensityFactor = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isFavourite = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       muscleGroup = Value(muscleGroup),
       equipment = Value(equipment),
       difficulty = Value(difficulty),
       trackingType = Value(trackingType);
  static Insertable<ExerciseRow> custom({
    Expression<int>? id,
    Expression<String>? slug,
    Expression<String>? name,
    Expression<String>? muscleGroup,
    Expression<String>? equipment,
    Expression<String>? difficulty,
    Expression<String>? trackingType,
    Expression<String>? description,
    Expression<String>? instructions,
    Expression<String>? iconName,
    Expression<bool>? isBodyweight,
    Expression<double>? intensityFactor,
    Expression<int>? defaultRestSeconds,
    Expression<bool>? isCustom,
    Expression<bool>? isFavourite,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (name != null) 'name': name,
      if (muscleGroup != null) 'muscle_group': muscleGroup,
      if (equipment != null) 'equipment': equipment,
      if (difficulty != null) 'difficulty': difficulty,
      if (trackingType != null) 'tracking_type': trackingType,
      if (description != null) 'description': description,
      if (instructions != null) 'instructions': instructions,
      if (iconName != null) 'icon_name': iconName,
      if (isBodyweight != null) 'is_bodyweight': isBodyweight,
      if (intensityFactor != null) 'intensity_factor': intensityFactor,
      if (defaultRestSeconds != null)
        'default_rest_seconds': defaultRestSeconds,
      if (isCustom != null) 'is_custom': isCustom,
      if (isFavourite != null) 'is_favourite': isFavourite,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExercisesCompanion copyWith({
    Value<int>? id,
    Value<String?>? slug,
    Value<String>? name,
    Value<MuscleGroup>? muscleGroup,
    Value<Equipment>? equipment,
    Value<Difficulty>? difficulty,
    Value<TrackingType>? trackingType,
    Value<String>? description,
    Value<String>? instructions,
    Value<String>? iconName,
    Value<bool>? isBodyweight,
    Value<double>? intensityFactor,
    Value<int>? defaultRestSeconds,
    Value<bool>? isCustom,
    Value<bool>? isFavourite,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      equipment: equipment ?? this.equipment,
      difficulty: difficulty ?? this.difficulty,
      trackingType: trackingType ?? this.trackingType,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      iconName: iconName ?? this.iconName,
      isBodyweight: isBodyweight ?? this.isBodyweight,
      intensityFactor: intensityFactor ?? this.intensityFactor,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      isCustom: isCustom ?? this.isCustom,
      isFavourite: isFavourite ?? this.isFavourite,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (muscleGroup.present) {
      map['muscle_group'] = Variable<String>(
        $ExercisesTable.$convertermuscleGroup.toSql(muscleGroup.value),
      );
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(
        $ExercisesTable.$converterequipment.toSql(equipment.value),
      );
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(
        $ExercisesTable.$converterdifficulty.toSql(difficulty.value),
      );
    }
    if (trackingType.present) {
      map['tracking_type'] = Variable<String>(
        $ExercisesTable.$convertertrackingType.toSql(trackingType.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (isBodyweight.present) {
      map['is_bodyweight'] = Variable<bool>(isBodyweight.value);
    }
    if (intensityFactor.present) {
      map['intensity_factor'] = Variable<double>(intensityFactor.value);
    }
    if (defaultRestSeconds.present) {
      map['default_rest_seconds'] = Variable<int>(defaultRestSeconds.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (isFavourite.present) {
      map['is_favourite'] = Variable<bool>(isFavourite.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('equipment: $equipment, ')
          ..write('difficulty: $difficulty, ')
          ..write('trackingType: $trackingType, ')
          ..write('description: $description, ')
          ..write('instructions: $instructions, ')
          ..write('iconName: $iconName, ')
          ..write('isBodyweight: $isBodyweight, ')
          ..write('intensityFactor: $intensityFactor, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('isCustom: $isCustom, ')
          ..write('isFavourite: $isFavourite, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts
    with TableInfo<$WorkoutsTable, WorkoutRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<int> dayKey = GeneratedColumn<int>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WorkoutSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WorkoutSource>($WorkoutsTable.$convertersource);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planLevelMeta = const VerificationMeta(
    'planLevel',
  );
  @override
  late final GeneratedColumn<int> planLevel = GeneratedColumn<int>(
    'plan_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planDayMeta = const VerificationMeta(
    'planDay',
  );
  @override
  late final GeneratedColumn<int> planDay = GeneratedColumn<int>(
    'plan_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SessionFeedback?, String>
  feedback = GeneratedColumn<String>(
    'feedback',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<SessionFeedback?>($WorkoutsTable.$converterfeedbackn);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _totalRepsMeta = const VerificationMeta(
    'totalReps',
  );
  @override
  late final GeneratedColumn<int> totalReps = GeneratedColumn<int>(
    'total_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalDurationSecondsMeta =
      const VerificationMeta('totalDurationSeconds');
  @override
  late final GeneratedColumn<int> totalDurationSeconds = GeneratedColumn<int>(
    'total_duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalVolumeMeta = const VerificationMeta(
    'totalVolume',
  );
  @override
  late final GeneratedColumn<double> totalVolume = GeneratedColumn<double>(
    'total_volume',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayKey,
    startedAt,
    completedAt,
    source,
    title,
    planId,
    planLevel,
    planDay,
    feedback,
    notes,
    isCompleted,
    totalReps,
    totalDurationSeconds,
    totalVolume,
    durationSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    }
    if (data.containsKey('plan_level')) {
      context.handle(
        _planLevelMeta,
        planLevel.isAcceptableOrUnknown(data['plan_level']!, _planLevelMeta),
      );
    }
    if (data.containsKey('plan_day')) {
      context.handle(
        _planDayMeta,
        planDay.isAcceptableOrUnknown(data['plan_day']!, _planDayMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('total_reps')) {
      context.handle(
        _totalRepsMeta,
        totalReps.isAcceptableOrUnknown(data['total_reps']!, _totalRepsMeta),
      );
    }
    if (data.containsKey('total_duration_seconds')) {
      context.handle(
        _totalDurationSecondsMeta,
        totalDurationSeconds.isAcceptableOrUnknown(
          data['total_duration_seconds']!,
          _totalDurationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('total_volume')) {
      context.handle(
        _totalVolumeMeta,
        totalVolume.isAcceptableOrUnknown(
          data['total_volume']!,
          _totalVolumeMeta,
        ),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_key'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      source: $WorkoutsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      ),
      planLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_level'],
      ),
      planDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_day'],
      ),
      feedback: $WorkoutsTable.$converterfeedbackn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}feedback'],
        ),
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      totalReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_reps'],
      )!,
      totalDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_duration_seconds'],
      )!,
      totalVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_volume'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WorkoutSource, String, String> $convertersource =
      const EnumNameConverter<WorkoutSource>(WorkoutSource.values);
  static JsonTypeConverter2<SessionFeedback, String, String>
  $converterfeedback = const EnumNameConverter<SessionFeedback>(
    SessionFeedback.values,
  );
  static JsonTypeConverter2<SessionFeedback?, String?, String?>
  $converterfeedbackn = JsonTypeConverter2.asNullable($converterfeedback);
}

class WorkoutRow extends DataClass implements Insertable<WorkoutRow> {
  final int id;

  /// Calendar day the workout is credited to, as `yyyyMMdd`. Denormalised from
  /// [startedAt] at insert time so streak queries never re-derive local dates.
  final int dayKey;
  final DateTime startedAt;
  final DateTime? completedAt;
  final WorkoutSource source;
  final String title;

  /// Plan identity, when [source] is [WorkoutSource.plan].
  final String? planId;
  final int? planLevel;
  final int? planDay;
  final SessionFeedback? feedback;
  final String notes;

  /// True once the session has been finished and committed to history.
  final bool isCompleted;

  /// Cached rollups so history and stats lists do not need to join sets.
  final int totalReps;
  final int totalDurationSeconds;
  final double totalVolume;
  final int durationSeconds;
  const WorkoutRow({
    required this.id,
    required this.dayKey,
    required this.startedAt,
    this.completedAt,
    required this.source,
    required this.title,
    this.planId,
    this.planLevel,
    this.planDay,
    this.feedback,
    required this.notes,
    required this.isCompleted,
    required this.totalReps,
    required this.totalDurationSeconds,
    required this.totalVolume,
    required this.durationSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_key'] = Variable<int>(dayKey);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    {
      map['source'] = Variable<String>(
        $WorkoutsTable.$convertersource.toSql(source),
      );
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || planId != null) {
      map['plan_id'] = Variable<String>(planId);
    }
    if (!nullToAbsent || planLevel != null) {
      map['plan_level'] = Variable<int>(planLevel);
    }
    if (!nullToAbsent || planDay != null) {
      map['plan_day'] = Variable<int>(planDay);
    }
    if (!nullToAbsent || feedback != null) {
      map['feedback'] = Variable<String>(
        $WorkoutsTable.$converterfeedbackn.toSql(feedback),
      );
    }
    map['notes'] = Variable<String>(notes);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['total_reps'] = Variable<int>(totalReps);
    map['total_duration_seconds'] = Variable<int>(totalDurationSeconds);
    map['total_volume'] = Variable<double>(totalVolume);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      dayKey: Value(dayKey),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      source: Value(source),
      title: Value(title),
      planId: planId == null && nullToAbsent
          ? const Value.absent()
          : Value(planId),
      planLevel: planLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(planLevel),
      planDay: planDay == null && nullToAbsent
          ? const Value.absent()
          : Value(planDay),
      feedback: feedback == null && nullToAbsent
          ? const Value.absent()
          : Value(feedback),
      notes: Value(notes),
      isCompleted: Value(isCompleted),
      totalReps: Value(totalReps),
      totalDurationSeconds: Value(totalDurationSeconds),
      totalVolume: Value(totalVolume),
      durationSeconds: Value(durationSeconds),
    );
  }

  factory WorkoutRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutRow(
      id: serializer.fromJson<int>(json['id']),
      dayKey: serializer.fromJson<int>(json['dayKey']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      source: $WorkoutsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      title: serializer.fromJson<String>(json['title']),
      planId: serializer.fromJson<String?>(json['planId']),
      planLevel: serializer.fromJson<int?>(json['planLevel']),
      planDay: serializer.fromJson<int?>(json['planDay']),
      feedback: $WorkoutsTable.$converterfeedbackn.fromJson(
        serializer.fromJson<String?>(json['feedback']),
      ),
      notes: serializer.fromJson<String>(json['notes']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      totalReps: serializer.fromJson<int>(json['totalReps']),
      totalDurationSeconds: serializer.fromJson<int>(
        json['totalDurationSeconds'],
      ),
      totalVolume: serializer.fromJson<double>(json['totalVolume']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayKey': serializer.toJson<int>(dayKey),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'source': serializer.toJson<String>(
        $WorkoutsTable.$convertersource.toJson(source),
      ),
      'title': serializer.toJson<String>(title),
      'planId': serializer.toJson<String?>(planId),
      'planLevel': serializer.toJson<int?>(planLevel),
      'planDay': serializer.toJson<int?>(planDay),
      'feedback': serializer.toJson<String?>(
        $WorkoutsTable.$converterfeedbackn.toJson(feedback),
      ),
      'notes': serializer.toJson<String>(notes),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'totalReps': serializer.toJson<int>(totalReps),
      'totalDurationSeconds': serializer.toJson<int>(totalDurationSeconds),
      'totalVolume': serializer.toJson<double>(totalVolume),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
    };
  }

  WorkoutRow copyWith({
    int? id,
    int? dayKey,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    WorkoutSource? source,
    String? title,
    Value<String?> planId = const Value.absent(),
    Value<int?> planLevel = const Value.absent(),
    Value<int?> planDay = const Value.absent(),
    Value<SessionFeedback?> feedback = const Value.absent(),
    String? notes,
    bool? isCompleted,
    int? totalReps,
    int? totalDurationSeconds,
    double? totalVolume,
    int? durationSeconds,
  }) => WorkoutRow(
    id: id ?? this.id,
    dayKey: dayKey ?? this.dayKey,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    source: source ?? this.source,
    title: title ?? this.title,
    planId: planId.present ? planId.value : this.planId,
    planLevel: planLevel.present ? planLevel.value : this.planLevel,
    planDay: planDay.present ? planDay.value : this.planDay,
    feedback: feedback.present ? feedback.value : this.feedback,
    notes: notes ?? this.notes,
    isCompleted: isCompleted ?? this.isCompleted,
    totalReps: totalReps ?? this.totalReps,
    totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
    totalVolume: totalVolume ?? this.totalVolume,
    durationSeconds: durationSeconds ?? this.durationSeconds,
  );
  WorkoutRow copyWithCompanion(WorkoutsCompanion data) {
    return WorkoutRow(
      id: data.id.present ? data.id.value : this.id,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      source: data.source.present ? data.source.value : this.source,
      title: data.title.present ? data.title.value : this.title,
      planId: data.planId.present ? data.planId.value : this.planId,
      planLevel: data.planLevel.present ? data.planLevel.value : this.planLevel,
      planDay: data.planDay.present ? data.planDay.value : this.planDay,
      feedback: data.feedback.present ? data.feedback.value : this.feedback,
      notes: data.notes.present ? data.notes.value : this.notes,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      totalReps: data.totalReps.present ? data.totalReps.value : this.totalReps,
      totalDurationSeconds: data.totalDurationSeconds.present
          ? data.totalDurationSeconds.value
          : this.totalDurationSeconds,
      totalVolume: data.totalVolume.present
          ? data.totalVolume.value
          : this.totalVolume,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutRow(')
          ..write('id: $id, ')
          ..write('dayKey: $dayKey, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('source: $source, ')
          ..write('title: $title, ')
          ..write('planId: $planId, ')
          ..write('planLevel: $planLevel, ')
          ..write('planDay: $planDay, ')
          ..write('feedback: $feedback, ')
          ..write('notes: $notes, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('totalReps: $totalReps, ')
          ..write('totalDurationSeconds: $totalDurationSeconds, ')
          ..write('totalVolume: $totalVolume, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dayKey,
    startedAt,
    completedAt,
    source,
    title,
    planId,
    planLevel,
    planDay,
    feedback,
    notes,
    isCompleted,
    totalReps,
    totalDurationSeconds,
    totalVolume,
    durationSeconds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutRow &&
          other.id == this.id &&
          other.dayKey == this.dayKey &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.source == this.source &&
          other.title == this.title &&
          other.planId == this.planId &&
          other.planLevel == this.planLevel &&
          other.planDay == this.planDay &&
          other.feedback == this.feedback &&
          other.notes == this.notes &&
          other.isCompleted == this.isCompleted &&
          other.totalReps == this.totalReps &&
          other.totalDurationSeconds == this.totalDurationSeconds &&
          other.totalVolume == this.totalVolume &&
          other.durationSeconds == this.durationSeconds);
}

class WorkoutsCompanion extends UpdateCompanion<WorkoutRow> {
  final Value<int> id;
  final Value<int> dayKey;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<WorkoutSource> source;
  final Value<String> title;
  final Value<String?> planId;
  final Value<int?> planLevel;
  final Value<int?> planDay;
  final Value<SessionFeedback?> feedback;
  final Value<String> notes;
  final Value<bool> isCompleted;
  final Value<int> totalReps;
  final Value<int> totalDurationSeconds;
  final Value<double> totalVolume;
  final Value<int> durationSeconds;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.title = const Value.absent(),
    this.planId = const Value.absent(),
    this.planLevel = const Value.absent(),
    this.planDay = const Value.absent(),
    this.feedback = const Value.absent(),
    this.notes = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.totalReps = const Value.absent(),
    this.totalDurationSeconds = const Value.absent(),
    this.totalVolume = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required int dayKey,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    required WorkoutSource source,
    this.title = const Value.absent(),
    this.planId = const Value.absent(),
    this.planLevel = const Value.absent(),
    this.planDay = const Value.absent(),
    this.feedback = const Value.absent(),
    this.notes = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.totalReps = const Value.absent(),
    this.totalDurationSeconds = const Value.absent(),
    this.totalVolume = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  }) : dayKey = Value(dayKey),
       startedAt = Value(startedAt),
       source = Value(source);
  static Insertable<WorkoutRow> custom({
    Expression<int>? id,
    Expression<int>? dayKey,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? source,
    Expression<String>? title,
    Expression<String>? planId,
    Expression<int>? planLevel,
    Expression<int>? planDay,
    Expression<String>? feedback,
    Expression<String>? notes,
    Expression<bool>? isCompleted,
    Expression<int>? totalReps,
    Expression<int>? totalDurationSeconds,
    Expression<double>? totalVolume,
    Expression<int>? durationSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayKey != null) 'day_key': dayKey,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (source != null) 'source': source,
      if (title != null) 'title': title,
      if (planId != null) 'plan_id': planId,
      if (planLevel != null) 'plan_level': planLevel,
      if (planDay != null) 'plan_day': planDay,
      if (feedback != null) 'feedback': feedback,
      if (notes != null) 'notes': notes,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (totalReps != null) 'total_reps': totalReps,
      if (totalDurationSeconds != null)
        'total_duration_seconds': totalDurationSeconds,
      if (totalVolume != null) 'total_volume': totalVolume,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
    });
  }

  WorkoutsCompanion copyWith({
    Value<int>? id,
    Value<int>? dayKey,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<WorkoutSource>? source,
    Value<String>? title,
    Value<String?>? planId,
    Value<int?>? planLevel,
    Value<int?>? planDay,
    Value<SessionFeedback?>? feedback,
    Value<String>? notes,
    Value<bool>? isCompleted,
    Value<int>? totalReps,
    Value<int>? totalDurationSeconds,
    Value<double>? totalVolume,
    Value<int>? durationSeconds,
  }) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      dayKey: dayKey ?? this.dayKey,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      source: source ?? this.source,
      title: title ?? this.title,
      planId: planId ?? this.planId,
      planLevel: planLevel ?? this.planLevel,
      planDay: planDay ?? this.planDay,
      feedback: feedback ?? this.feedback,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      totalReps: totalReps ?? this.totalReps,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      totalVolume: totalVolume ?? this.totalVolume,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<int>(dayKey.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $WorkoutsTable.$convertersource.toSql(source.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (planLevel.present) {
      map['plan_level'] = Variable<int>(planLevel.value);
    }
    if (planDay.present) {
      map['plan_day'] = Variable<int>(planDay.value);
    }
    if (feedback.present) {
      map['feedback'] = Variable<String>(
        $WorkoutsTable.$converterfeedbackn.toSql(feedback.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (totalReps.present) {
      map['total_reps'] = Variable<int>(totalReps.value);
    }
    if (totalDurationSeconds.present) {
      map['total_duration_seconds'] = Variable<int>(totalDurationSeconds.value);
    }
    if (totalVolume.present) {
      map['total_volume'] = Variable<double>(totalVolume.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('dayKey: $dayKey, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('source: $source, ')
          ..write('title: $title, ')
          ..write('planId: $planId, ')
          ..write('planLevel: $planLevel, ')
          ..write('planDay: $planDay, ')
          ..write('feedback: $feedback, ')
          ..write('notes: $notes, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('totalReps: $totalReps, ')
          ..write('totalDurationSeconds: $totalDurationSeconds, ')
          ..write('totalVolume: $totalVolume, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExercisesTable extends WorkoutExercises
    with TableInfo<$WorkoutExercisesTable, WorkoutExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TrackingType, String>
  trackingType = GeneratedColumn<String>(
    'tracking_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TrackingType>($WorkoutExercisesTable.$convertertrackingType);
  static const VerificationMeta _isSkippedMeta = const VerificationMeta(
    'isSkipped',
  );
  @override
  late final GeneratedColumn<bool> isSkipped = GeneratedColumn<bool>(
    'is_skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutId,
    exerciseId,
    position,
    exerciseName,
    trackingType,
    isSkipped,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('is_skipped')) {
      context.handle(
        _isSkippedMeta,
        isSkipped.isAcceptableOrUnknown(data['is_skipped']!, _isSkippedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {workoutId, position},
  ];
  @override
  WorkoutExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      trackingType: $WorkoutExercisesTable.$convertertrackingType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tracking_type'],
        )!,
      ),
      isSkipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_skipped'],
      )!,
    );
  }

  @override
  $WorkoutExercisesTable createAlias(String alias) {
    return $WorkoutExercisesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TrackingType, String, String>
  $convertertrackingType = const EnumNameConverter<TrackingType>(
    TrackingType.values,
  );
}

class WorkoutExerciseRow extends DataClass
    implements Insertable<WorkoutExerciseRow> {
  final int id;
  final int workoutId;

  /// Restricted rather than cascaded: deleting an exercise must not silently
  /// erase the history that references it. The repository archives instead.
  final int exerciseId;
  final int position;

  /// Snapshot of the name at the time of the workout, so renaming an exercise
  /// later does not rewrite history.
  final String exerciseName;
  final TrackingType trackingType;
  final bool isSkipped;
  const WorkoutExerciseRow({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.position,
    required this.exerciseName,
    required this.trackingType,
    required this.isSkipped,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_id'] = Variable<int>(workoutId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['position'] = Variable<int>(position);
    map['exercise_name'] = Variable<String>(exerciseName);
    {
      map['tracking_type'] = Variable<String>(
        $WorkoutExercisesTable.$convertertrackingType.toSql(trackingType),
      );
    }
    map['is_skipped'] = Variable<bool>(isSkipped);
    return map;
  }

  WorkoutExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExercisesCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      exerciseId: Value(exerciseId),
      position: Value(position),
      exerciseName: Value(exerciseName),
      trackingType: Value(trackingType),
      isSkipped: Value(isSkipped),
    );
  }

  factory WorkoutExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExerciseRow(
      id: serializer.fromJson<int>(json['id']),
      workoutId: serializer.fromJson<int>(json['workoutId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      position: serializer.fromJson<int>(json['position']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      trackingType: $WorkoutExercisesTable.$convertertrackingType.fromJson(
        serializer.fromJson<String>(json['trackingType']),
      ),
      isSkipped: serializer.fromJson<bool>(json['isSkipped']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutId': serializer.toJson<int>(workoutId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'position': serializer.toJson<int>(position),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'trackingType': serializer.toJson<String>(
        $WorkoutExercisesTable.$convertertrackingType.toJson(trackingType),
      ),
      'isSkipped': serializer.toJson<bool>(isSkipped),
    };
  }

  WorkoutExerciseRow copyWith({
    int? id,
    int? workoutId,
    int? exerciseId,
    int? position,
    String? exerciseName,
    TrackingType? trackingType,
    bool? isSkipped,
  }) => WorkoutExerciseRow(
    id: id ?? this.id,
    workoutId: workoutId ?? this.workoutId,
    exerciseId: exerciseId ?? this.exerciseId,
    position: position ?? this.position,
    exerciseName: exerciseName ?? this.exerciseName,
    trackingType: trackingType ?? this.trackingType,
    isSkipped: isSkipped ?? this.isSkipped,
  );
  WorkoutExerciseRow copyWithCompanion(WorkoutExercisesCompanion data) {
    return WorkoutExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      position: data.position.present ? data.position.value : this.position,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      trackingType: data.trackingType.present
          ? data.trackingType.value
          : this.trackingType,
      isSkipped: data.isSkipped.present ? data.isSkipped.value : this.isSkipped,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExerciseRow(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('position: $position, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('trackingType: $trackingType, ')
          ..write('isSkipped: $isSkipped')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutId,
    exerciseId,
    position,
    exerciseName,
    trackingType,
    isSkipped,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExerciseRow &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.exerciseId == this.exerciseId &&
          other.position == this.position &&
          other.exerciseName == this.exerciseName &&
          other.trackingType == this.trackingType &&
          other.isSkipped == this.isSkipped);
}

class WorkoutExercisesCompanion extends UpdateCompanion<WorkoutExerciseRow> {
  final Value<int> id;
  final Value<int> workoutId;
  final Value<int> exerciseId;
  final Value<int> position;
  final Value<String> exerciseName;
  final Value<TrackingType> trackingType;
  final Value<bool> isSkipped;
  const WorkoutExercisesCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.position = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.trackingType = const Value.absent(),
    this.isSkipped = const Value.absent(),
  });
  WorkoutExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int workoutId,
    required int exerciseId,
    required int position,
    required String exerciseName,
    required TrackingType trackingType,
    this.isSkipped = const Value.absent(),
  }) : workoutId = Value(workoutId),
       exerciseId = Value(exerciseId),
       position = Value(position),
       exerciseName = Value(exerciseName),
       trackingType = Value(trackingType);
  static Insertable<WorkoutExerciseRow> custom({
    Expression<int>? id,
    Expression<int>? workoutId,
    Expression<int>? exerciseId,
    Expression<int>? position,
    Expression<String>? exerciseName,
    Expression<String>? trackingType,
    Expression<bool>? isSkipped,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (position != null) 'position': position,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (trackingType != null) 'tracking_type': trackingType,
      if (isSkipped != null) 'is_skipped': isSkipped,
    });
  }

  WorkoutExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? workoutId,
    Value<int>? exerciseId,
    Value<int>? position,
    Value<String>? exerciseName,
    Value<TrackingType>? trackingType,
    Value<bool>? isSkipped,
  }) {
    return WorkoutExercisesCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      position: position ?? this.position,
      exerciseName: exerciseName ?? this.exerciseName,
      trackingType: trackingType ?? this.trackingType,
      isSkipped: isSkipped ?? this.isSkipped,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (trackingType.present) {
      map['tracking_type'] = Variable<String>(
        $WorkoutExercisesTable.$convertertrackingType.toSql(trackingType.value),
      );
    }
    if (isSkipped.present) {
      map['is_skipped'] = Variable<bool>(isSkipped.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercisesCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('position: $position, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('trackingType: $trackingType, ')
          ..write('isSkipped: $isSkipped')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, SetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workoutExerciseIdMeta = const VerificationMeta(
    'workoutExerciseId',
  );
  @override
  late final GeneratedColumn<int> workoutExerciseId = GeneratedColumn<int>(
    'workout_exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_exercises (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<int> targetValue = GeneratedColumn<int>(
    'target_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutExerciseId,
    position,
    targetValue,
    reps,
    weightKg,
    durationSeconds,
    distanceMeters,
    restSeconds,
    isCompleted,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_exercise_id')) {
      context.handle(
        _workoutExerciseIdMeta,
        workoutExerciseId.isAcceptableOrUnknown(
          data['workout_exercise_id']!,
          _workoutExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutExerciseIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workoutExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_exercise_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_value'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      )!,
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class SetRow extends DataClass implements Insertable<SetRow> {
  final int id;
  final int workoutExerciseId;
  final int position;

  /// What the plan asked for, in the exercise's target unit.
  final int? targetValue;

  /// What the user actually did.
  final int reps;
  final double weightKg;
  final int durationSeconds;
  final double distanceMeters;
  final int restSeconds;
  final bool isCompleted;
  final DateTime? completedAt;
  const SetRow({
    required this.id,
    required this.workoutExerciseId,
    required this.position,
    this.targetValue,
    required this.reps,
    required this.weightKg,
    required this.durationSeconds,
    required this.distanceMeters,
    required this.restSeconds,
    required this.isCompleted,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_exercise_id'] = Variable<int>(workoutExerciseId);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || targetValue != null) {
      map['target_value'] = Variable<int>(targetValue);
    }
    map['reps'] = Variable<int>(reps);
    map['weight_kg'] = Variable<double>(weightKg);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['distance_meters'] = Variable<double>(distanceMeters);
    map['rest_seconds'] = Variable<int>(restSeconds);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      workoutExerciseId: Value(workoutExerciseId),
      position: Value(position),
      targetValue: targetValue == null && nullToAbsent
          ? const Value.absent()
          : Value(targetValue),
      reps: Value(reps),
      weightKg: Value(weightKg),
      durationSeconds: Value(durationSeconds),
      distanceMeters: Value(distanceMeters),
      restSeconds: Value(restSeconds),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory SetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetRow(
      id: serializer.fromJson<int>(json['id']),
      workoutExerciseId: serializer.fromJson<int>(json['workoutExerciseId']),
      position: serializer.fromJson<int>(json['position']),
      targetValue: serializer.fromJson<int?>(json['targetValue']),
      reps: serializer.fromJson<int>(json['reps']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      distanceMeters: serializer.fromJson<double>(json['distanceMeters']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutExerciseId': serializer.toJson<int>(workoutExerciseId),
      'position': serializer.toJson<int>(position),
      'targetValue': serializer.toJson<int?>(targetValue),
      'reps': serializer.toJson<int>(reps),
      'weightKg': serializer.toJson<double>(weightKg),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'distanceMeters': serializer.toJson<double>(distanceMeters),
      'restSeconds': serializer.toJson<int>(restSeconds),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  SetRow copyWith({
    int? id,
    int? workoutExerciseId,
    int? position,
    Value<int?> targetValue = const Value.absent(),
    int? reps,
    double? weightKg,
    int? durationSeconds,
    double? distanceMeters,
    int? restSeconds,
    bool? isCompleted,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => SetRow(
    id: id ?? this.id,
    workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
    position: position ?? this.position,
    targetValue: targetValue.present ? targetValue.value : this.targetValue,
    reps: reps ?? this.reps,
    weightKg: weightKg ?? this.weightKg,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    distanceMeters: distanceMeters ?? this.distanceMeters,
    restSeconds: restSeconds ?? this.restSeconds,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  SetRow copyWithCompanion(WorkoutSetsCompanion data) {
    return SetRow(
      id: data.id.present ? data.id.value : this.id,
      workoutExerciseId: data.workoutExerciseId.present
          ? data.workoutExerciseId.value
          : this.workoutExerciseId,
      position: data.position.present ? data.position.value : this.position,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      reps: data.reps.present ? data.reps.value : this.reps,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetRow(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('position: $position, ')
          ..write('targetValue: $targetValue, ')
          ..write('reps: $reps, ')
          ..write('weightKg: $weightKg, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutExerciseId,
    position,
    targetValue,
    reps,
    weightKg,
    durationSeconds,
    distanceMeters,
    restSeconds,
    isCompleted,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetRow &&
          other.id == this.id &&
          other.workoutExerciseId == this.workoutExerciseId &&
          other.position == this.position &&
          other.targetValue == this.targetValue &&
          other.reps == this.reps &&
          other.weightKg == this.weightKg &&
          other.durationSeconds == this.durationSeconds &&
          other.distanceMeters == this.distanceMeters &&
          other.restSeconds == this.restSeconds &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt);
}

class WorkoutSetsCompanion extends UpdateCompanion<SetRow> {
  final Value<int> id;
  final Value<int> workoutExerciseId;
  final Value<int> position;
  final Value<int?> targetValue;
  final Value<int> reps;
  final Value<double> weightKg;
  final Value<int> durationSeconds;
  final Value<double> distanceMeters;
  final Value<int> restSeconds;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.workoutExerciseId = const Value.absent(),
    this.position = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.reps = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    this.id = const Value.absent(),
    required int workoutExerciseId,
    required int position,
    this.targetValue = const Value.absent(),
    this.reps = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
  }) : workoutExerciseId = Value(workoutExerciseId),
       position = Value(position);
  static Insertable<SetRow> custom({
    Expression<int>? id,
    Expression<int>? workoutExerciseId,
    Expression<int>? position,
    Expression<int>? targetValue,
    Expression<int>? reps,
    Expression<double>? weightKg,
    Expression<int>? durationSeconds,
    Expression<double>? distanceMeters,
    Expression<int>? restSeconds,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutExerciseId != null) 'workout_exercise_id': workoutExerciseId,
      if (position != null) 'position': position,
      if (targetValue != null) 'target_value': targetValue,
      if (reps != null) 'reps': reps,
      if (weightKg != null) 'weight_kg': weightKg,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<int>? id,
    Value<int>? workoutExerciseId,
    Value<int>? position,
    Value<int?>? targetValue,
    Value<int>? reps,
    Value<double>? weightKg,
    Value<int>? durationSeconds,
    Value<double>? distanceMeters,
    Value<int>? restSeconds,
    Value<bool>? isCompleted,
    Value<DateTime?>? completedAt,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
      position: position ?? this.position,
      targetValue: targetValue ?? this.targetValue,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      restSeconds: restSeconds ?? this.restSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutExerciseId.present) {
      map['workout_exercise_id'] = Variable<int>(workoutExerciseId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<int>(targetValue.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('position: $position, ')
          ..write('targetValue: $targetValue, ')
          ..write('reps: $reps, ')
          ..write('weightKg: $weightKg, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyActivitiesTable extends DailyActivities
    with TableInfo<$DailyActivitiesTable, DailyActivityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<int> dayKey = GeneratedColumn<int>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workoutCountMeta = const VerificationMeta(
    'workoutCount',
  );
  @override
  late final GeneratedColumn<int> workoutCount = GeneratedColumn<int>(
    'workout_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalRepsMeta = const VerificationMeta(
    'totalReps',
  );
  @override
  late final GeneratedColumn<int> totalReps = GeneratedColumn<int>(
    'total_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalDurationSecondsMeta =
      const VerificationMeta('totalDurationSeconds');
  @override
  late final GeneratedColumn<int> totalDurationSeconds = GeneratedColumn<int>(
    'total_duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalVolumeMeta = const VerificationMeta(
    'totalVolume',
  );
  @override
  late final GeneratedColumn<double> totalVolume = GeneratedColumn<double>(
    'total_volume',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFreezeMeta = const VerificationMeta(
    'isFreeze',
  );
  @override
  late final GeneratedColumn<bool> isFreeze = GeneratedColumn<bool>(
    'is_freeze',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_freeze" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    dayKey,
    workoutCount,
    totalReps,
    totalDurationSeconds,
    totalVolume,
    isFreeze,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyActivityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    }
    if (data.containsKey('workout_count')) {
      context.handle(
        _workoutCountMeta,
        workoutCount.isAcceptableOrUnknown(
          data['workout_count']!,
          _workoutCountMeta,
        ),
      );
    }
    if (data.containsKey('total_reps')) {
      context.handle(
        _totalRepsMeta,
        totalReps.isAcceptableOrUnknown(data['total_reps']!, _totalRepsMeta),
      );
    }
    if (data.containsKey('total_duration_seconds')) {
      context.handle(
        _totalDurationSecondsMeta,
        totalDurationSeconds.isAcceptableOrUnknown(
          data['total_duration_seconds']!,
          _totalDurationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('total_volume')) {
      context.handle(
        _totalVolumeMeta,
        totalVolume.isAcceptableOrUnknown(
          data['total_volume']!,
          _totalVolumeMeta,
        ),
      );
    }
    if (data.containsKey('is_freeze')) {
      context.handle(
        _isFreezeMeta,
        isFreeze.isAcceptableOrUnknown(data['is_freeze']!, _isFreezeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dayKey};
  @override
  DailyActivityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyActivityRow(
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_key'],
      )!,
      workoutCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_count'],
      )!,
      totalReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_reps'],
      )!,
      totalDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_duration_seconds'],
      )!,
      totalVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_volume'],
      )!,
      isFreeze: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_freeze'],
      )!,
    );
  }

  @override
  $DailyActivitiesTable createAlias(String alias) {
    return $DailyActivitiesTable(attachedDatabase, alias);
  }
}

class DailyActivityRow extends DataClass
    implements Insertable<DailyActivityRow> {
  /// `yyyyMMdd`.
  final int dayKey;
  final int workoutCount;
  final int totalReps;
  final int totalDurationSeconds;
  final double totalVolume;

  /// True when the day was covered by a streak freeze rather than a workout.
  final bool isFreeze;
  const DailyActivityRow({
    required this.dayKey,
    required this.workoutCount,
    required this.totalReps,
    required this.totalDurationSeconds,
    required this.totalVolume,
    required this.isFreeze,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day_key'] = Variable<int>(dayKey);
    map['workout_count'] = Variable<int>(workoutCount);
    map['total_reps'] = Variable<int>(totalReps);
    map['total_duration_seconds'] = Variable<int>(totalDurationSeconds);
    map['total_volume'] = Variable<double>(totalVolume);
    map['is_freeze'] = Variable<bool>(isFreeze);
    return map;
  }

  DailyActivitiesCompanion toCompanion(bool nullToAbsent) {
    return DailyActivitiesCompanion(
      dayKey: Value(dayKey),
      workoutCount: Value(workoutCount),
      totalReps: Value(totalReps),
      totalDurationSeconds: Value(totalDurationSeconds),
      totalVolume: Value(totalVolume),
      isFreeze: Value(isFreeze),
    );
  }

  factory DailyActivityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyActivityRow(
      dayKey: serializer.fromJson<int>(json['dayKey']),
      workoutCount: serializer.fromJson<int>(json['workoutCount']),
      totalReps: serializer.fromJson<int>(json['totalReps']),
      totalDurationSeconds: serializer.fromJson<int>(
        json['totalDurationSeconds'],
      ),
      totalVolume: serializer.fromJson<double>(json['totalVolume']),
      isFreeze: serializer.fromJson<bool>(json['isFreeze']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dayKey': serializer.toJson<int>(dayKey),
      'workoutCount': serializer.toJson<int>(workoutCount),
      'totalReps': serializer.toJson<int>(totalReps),
      'totalDurationSeconds': serializer.toJson<int>(totalDurationSeconds),
      'totalVolume': serializer.toJson<double>(totalVolume),
      'isFreeze': serializer.toJson<bool>(isFreeze),
    };
  }

  DailyActivityRow copyWith({
    int? dayKey,
    int? workoutCount,
    int? totalReps,
    int? totalDurationSeconds,
    double? totalVolume,
    bool? isFreeze,
  }) => DailyActivityRow(
    dayKey: dayKey ?? this.dayKey,
    workoutCount: workoutCount ?? this.workoutCount,
    totalReps: totalReps ?? this.totalReps,
    totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
    totalVolume: totalVolume ?? this.totalVolume,
    isFreeze: isFreeze ?? this.isFreeze,
  );
  DailyActivityRow copyWithCompanion(DailyActivitiesCompanion data) {
    return DailyActivityRow(
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      workoutCount: data.workoutCount.present
          ? data.workoutCount.value
          : this.workoutCount,
      totalReps: data.totalReps.present ? data.totalReps.value : this.totalReps,
      totalDurationSeconds: data.totalDurationSeconds.present
          ? data.totalDurationSeconds.value
          : this.totalDurationSeconds,
      totalVolume: data.totalVolume.present
          ? data.totalVolume.value
          : this.totalVolume,
      isFreeze: data.isFreeze.present ? data.isFreeze.value : this.isFreeze,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivityRow(')
          ..write('dayKey: $dayKey, ')
          ..write('workoutCount: $workoutCount, ')
          ..write('totalReps: $totalReps, ')
          ..write('totalDurationSeconds: $totalDurationSeconds, ')
          ..write('totalVolume: $totalVolume, ')
          ..write('isFreeze: $isFreeze')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    dayKey,
    workoutCount,
    totalReps,
    totalDurationSeconds,
    totalVolume,
    isFreeze,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyActivityRow &&
          other.dayKey == this.dayKey &&
          other.workoutCount == this.workoutCount &&
          other.totalReps == this.totalReps &&
          other.totalDurationSeconds == this.totalDurationSeconds &&
          other.totalVolume == this.totalVolume &&
          other.isFreeze == this.isFreeze);
}

class DailyActivitiesCompanion extends UpdateCompanion<DailyActivityRow> {
  final Value<int> dayKey;
  final Value<int> workoutCount;
  final Value<int> totalReps;
  final Value<int> totalDurationSeconds;
  final Value<double> totalVolume;
  final Value<bool> isFreeze;
  const DailyActivitiesCompanion({
    this.dayKey = const Value.absent(),
    this.workoutCount = const Value.absent(),
    this.totalReps = const Value.absent(),
    this.totalDurationSeconds = const Value.absent(),
    this.totalVolume = const Value.absent(),
    this.isFreeze = const Value.absent(),
  });
  DailyActivitiesCompanion.insert({
    this.dayKey = const Value.absent(),
    this.workoutCount = const Value.absent(),
    this.totalReps = const Value.absent(),
    this.totalDurationSeconds = const Value.absent(),
    this.totalVolume = const Value.absent(),
    this.isFreeze = const Value.absent(),
  });
  static Insertable<DailyActivityRow> custom({
    Expression<int>? dayKey,
    Expression<int>? workoutCount,
    Expression<int>? totalReps,
    Expression<int>? totalDurationSeconds,
    Expression<double>? totalVolume,
    Expression<bool>? isFreeze,
  }) {
    return RawValuesInsertable({
      if (dayKey != null) 'day_key': dayKey,
      if (workoutCount != null) 'workout_count': workoutCount,
      if (totalReps != null) 'total_reps': totalReps,
      if (totalDurationSeconds != null)
        'total_duration_seconds': totalDurationSeconds,
      if (totalVolume != null) 'total_volume': totalVolume,
      if (isFreeze != null) 'is_freeze': isFreeze,
    });
  }

  DailyActivitiesCompanion copyWith({
    Value<int>? dayKey,
    Value<int>? workoutCount,
    Value<int>? totalReps,
    Value<int>? totalDurationSeconds,
    Value<double>? totalVolume,
    Value<bool>? isFreeze,
  }) {
    return DailyActivitiesCompanion(
      dayKey: dayKey ?? this.dayKey,
      workoutCount: workoutCount ?? this.workoutCount,
      totalReps: totalReps ?? this.totalReps,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      totalVolume: totalVolume ?? this.totalVolume,
      isFreeze: isFreeze ?? this.isFreeze,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dayKey.present) {
      map['day_key'] = Variable<int>(dayKey.value);
    }
    if (workoutCount.present) {
      map['workout_count'] = Variable<int>(workoutCount.value);
    }
    if (totalReps.present) {
      map['total_reps'] = Variable<int>(totalReps.value);
    }
    if (totalDurationSeconds.present) {
      map['total_duration_seconds'] = Variable<int>(totalDurationSeconds.value);
    }
    if (totalVolume.present) {
      map['total_volume'] = Variable<double>(totalVolume.value);
    }
    if (isFreeze.present) {
      map['is_freeze'] = Variable<bool>(isFreeze.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivitiesCompanion(')
          ..write('dayKey: $dayKey, ')
          ..write('workoutCount: $workoutCount, ')
          ..write('totalReps: $totalReps, ')
          ..write('totalDurationSeconds: $totalDurationSeconds, ')
          ..write('totalVolume: $totalVolume, ')
          ..write('isFreeze: $isFreeze')
          ..write(')'))
        .toString();
  }
}

class $PersonalRecordsTable extends PersonalRecords
    with TableInfo<$PersonalRecordsTable, PersonalRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _metricMeta = const VerificationMeta('metric');
  @override
  late final GeneratedColumn<String> metric = GeneratedColumn<String>(
    'metric',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secondaryValueMeta = const VerificationMeta(
    'secondaryValue',
  );
  @override
  late final GeneratedColumn<double> secondaryValue = GeneratedColumn<double>(
    'secondary_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<int> dayKey = GeneratedColumn<int>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
    'workout_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _achievedAtMeta = const VerificationMeta(
    'achievedAt',
  );
  @override
  late final GeneratedColumn<DateTime> achievedAt = GeneratedColumn<DateTime>(
    'achieved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseId,
    metric,
    value,
    secondaryValue,
    dayKey,
    workoutId,
    achievedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('metric')) {
      context.handle(
        _metricMeta,
        metric.isAcceptableOrUnknown(data['metric']!, _metricMeta),
      );
    } else if (isInserting) {
      context.missing(_metricMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('secondary_value')) {
      context.handle(
        _secondaryValueMeta,
        secondaryValue.isAcceptableOrUnknown(
          data['secondary_value']!,
          _secondaryValueMeta,
        ),
      );
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
        _achievedAtMeta,
        achievedAt.isAcceptableOrUnknown(data['achieved_at']!, _achievedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {exerciseId, metric},
  ];
  @override
  PersonalRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalRecordRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      metric: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      secondaryValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}secondary_value'],
      )!,
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_key'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_id'],
      ),
      achievedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}achieved_at'],
      )!,
    );
  }

  @override
  $PersonalRecordsTable createAlias(String alias) {
    return $PersonalRecordsTable(attachedDatabase, alias);
  }
}

class PersonalRecordRow extends DataClass
    implements Insertable<PersonalRecordRow> {
  final int id;
  final int exerciseId;

  /// `bestSetReps` | `bestSetWeight` | `bestSetDuration` | `bestDayVolume`
  final String metric;
  final double value;

  /// Secondary figure for context, e.g. the weight at which a rep PR was set.
  final double secondaryValue;
  final int dayKey;
  final int? workoutId;
  final DateTime achievedAt;
  const PersonalRecordRow({
    required this.id,
    required this.exerciseId,
    required this.metric,
    required this.value,
    required this.secondaryValue,
    required this.dayKey,
    this.workoutId,
    required this.achievedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['metric'] = Variable<String>(metric);
    map['value'] = Variable<double>(value);
    map['secondary_value'] = Variable<double>(secondaryValue);
    map['day_key'] = Variable<int>(dayKey);
    if (!nullToAbsent || workoutId != null) {
      map['workout_id'] = Variable<int>(workoutId);
    }
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    return map;
  }

  PersonalRecordsCompanion toCompanion(bool nullToAbsent) {
    return PersonalRecordsCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      metric: Value(metric),
      value: Value(value),
      secondaryValue: Value(secondaryValue),
      dayKey: Value(dayKey),
      workoutId: workoutId == null && nullToAbsent
          ? const Value.absent()
          : Value(workoutId),
      achievedAt: Value(achievedAt),
    );
  }

  factory PersonalRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalRecordRow(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      metric: serializer.fromJson<String>(json['metric']),
      value: serializer.fromJson<double>(json['value']),
      secondaryValue: serializer.fromJson<double>(json['secondaryValue']),
      dayKey: serializer.fromJson<int>(json['dayKey']),
      workoutId: serializer.fromJson<int?>(json['workoutId']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'metric': serializer.toJson<String>(metric),
      'value': serializer.toJson<double>(value),
      'secondaryValue': serializer.toJson<double>(secondaryValue),
      'dayKey': serializer.toJson<int>(dayKey),
      'workoutId': serializer.toJson<int?>(workoutId),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
    };
  }

  PersonalRecordRow copyWith({
    int? id,
    int? exerciseId,
    String? metric,
    double? value,
    double? secondaryValue,
    int? dayKey,
    Value<int?> workoutId = const Value.absent(),
    DateTime? achievedAt,
  }) => PersonalRecordRow(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    metric: metric ?? this.metric,
    value: value ?? this.value,
    secondaryValue: secondaryValue ?? this.secondaryValue,
    dayKey: dayKey ?? this.dayKey,
    workoutId: workoutId.present ? workoutId.value : this.workoutId,
    achievedAt: achievedAt ?? this.achievedAt,
  );
  PersonalRecordRow copyWithCompanion(PersonalRecordsCompanion data) {
    return PersonalRecordRow(
      id: data.id.present ? data.id.value : this.id,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      metric: data.metric.present ? data.metric.value : this.metric,
      value: data.value.present ? data.value.value : this.value,
      secondaryValue: data.secondaryValue.present
          ? data.secondaryValue.value
          : this.secondaryValue,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      achievedAt: data.achievedAt.present
          ? data.achievedAt.value
          : this.achievedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordRow(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('metric: $metric, ')
          ..write('value: $value, ')
          ..write('secondaryValue: $secondaryValue, ')
          ..write('dayKey: $dayKey, ')
          ..write('workoutId: $workoutId, ')
          ..write('achievedAt: $achievedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    exerciseId,
    metric,
    value,
    secondaryValue,
    dayKey,
    workoutId,
    achievedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalRecordRow &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.metric == this.metric &&
          other.value == this.value &&
          other.secondaryValue == this.secondaryValue &&
          other.dayKey == this.dayKey &&
          other.workoutId == this.workoutId &&
          other.achievedAt == this.achievedAt);
}

class PersonalRecordsCompanion extends UpdateCompanion<PersonalRecordRow> {
  final Value<int> id;
  final Value<int> exerciseId;
  final Value<String> metric;
  final Value<double> value;
  final Value<double> secondaryValue;
  final Value<int> dayKey;
  final Value<int?> workoutId;
  final Value<DateTime> achievedAt;
  const PersonalRecordsCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.metric = const Value.absent(),
    this.value = const Value.absent(),
    this.secondaryValue = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.achievedAt = const Value.absent(),
  });
  PersonalRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int exerciseId,
    required String metric,
    required double value,
    this.secondaryValue = const Value.absent(),
    required int dayKey,
    this.workoutId = const Value.absent(),
    required DateTime achievedAt,
  }) : exerciseId = Value(exerciseId),
       metric = Value(metric),
       value = Value(value),
       dayKey = Value(dayKey),
       achievedAt = Value(achievedAt);
  static Insertable<PersonalRecordRow> custom({
    Expression<int>? id,
    Expression<int>? exerciseId,
    Expression<String>? metric,
    Expression<double>? value,
    Expression<double>? secondaryValue,
    Expression<int>? dayKey,
    Expression<int>? workoutId,
    Expression<DateTime>? achievedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (metric != null) 'metric': metric,
      if (value != null) 'value': value,
      if (secondaryValue != null) 'secondary_value': secondaryValue,
      if (dayKey != null) 'day_key': dayKey,
      if (workoutId != null) 'workout_id': workoutId,
      if (achievedAt != null) 'achieved_at': achievedAt,
    });
  }

  PersonalRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? exerciseId,
    Value<String>? metric,
    Value<double>? value,
    Value<double>? secondaryValue,
    Value<int>? dayKey,
    Value<int?>? workoutId,
    Value<DateTime>? achievedAt,
  }) {
    return PersonalRecordsCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      metric: metric ?? this.metric,
      value: value ?? this.value,
      secondaryValue: secondaryValue ?? this.secondaryValue,
      dayKey: dayKey ?? this.dayKey,
      workoutId: workoutId ?? this.workoutId,
      achievedAt: achievedAt ?? this.achievedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (metric.present) {
      map['metric'] = Variable<String>(metric.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (secondaryValue.present) {
      map['secondary_value'] = Variable<double>(secondaryValue.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<int>(dayKey.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('metric: $metric, ')
          ..write('value: $value, ')
          ..write('secondaryValue: $secondaryValue, ')
          ..write('dayKey: $dayKey, ')
          ..write('workoutId: $workoutId, ')
          ..write('achievedAt: $achievedAt')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, GoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<GoalType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GoalType>($GoalsTable.$convertertype);
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
    'target_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _achievedValueMeta = const VerificationMeta(
    'achievedValue',
  );
  @override
  late final GeneratedColumn<double> achievedValue = GeneratedColumn<double>(
    'achieved_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startDayKeyMeta = const VerificationMeta(
    'startDayKey',
  );
  @override
  late final GeneratedColumn<int> startDayKey = GeneratedColumn<int>(
    'start_day_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deadlineDayKeyMeta = const VerificationMeta(
    'deadlineDayKey',
  );
  @override
  late final GeneratedColumn<int> deadlineDayKey = GeneratedColumn<int>(
    'deadline_day_key',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedDayKeyMeta = const VerificationMeta(
    'completedDayKey',
  );
  @override
  late final GeneratedColumn<int> completedDayKey = GeneratedColumn<int>(
    'completed_day_key',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    type,
    exerciseId,
    targetValue,
    achievedValue,
    startDayKey,
    deadlineDayKey,
    isCompleted,
    completedDayKey,
    isArchived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('achieved_value')) {
      context.handle(
        _achievedValueMeta,
        achievedValue.isAcceptableOrUnknown(
          data['achieved_value']!,
          _achievedValueMeta,
        ),
      );
    }
    if (data.containsKey('start_day_key')) {
      context.handle(
        _startDayKeyMeta,
        startDayKey.isAcceptableOrUnknown(
          data['start_day_key']!,
          _startDayKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startDayKeyMeta);
    }
    if (data.containsKey('deadline_day_key')) {
      context.handle(
        _deadlineDayKeyMeta,
        deadlineDayKey.isAcceptableOrUnknown(
          data['deadline_day_key']!,
          _deadlineDayKeyMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_day_key')) {
      context.handle(
        _completedDayKeyMeta,
        completedDayKey.isAcceptableOrUnknown(
          data['completed_day_key']!,
          _completedDayKeyMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: $GoalsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      ),
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_value'],
      )!,
      achievedValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}achieved_value'],
      )!,
      startDayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_day_key'],
      )!,
      deadlineDayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deadline_day_key'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedDayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_day_key'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GoalType, String, String> $convertertype =
      const EnumNameConverter<GoalType>(GoalType.values);
}

class GoalRow extends DataClass implements Insertable<GoalRow> {
  final int id;
  final String title;
  final GoalType type;
  final int? exerciseId;
  final double targetValue;

  /// Snapshot of progress at completion time; live goals recompute on read.
  final double achievedValue;
  final int startDayKey;
  final int? deadlineDayKey;
  final bool isCompleted;
  final int? completedDayKey;
  final bool isArchived;
  final DateTime createdAt;
  const GoalRow({
    required this.id,
    required this.title,
    required this.type,
    this.exerciseId,
    required this.targetValue,
    required this.achievedValue,
    required this.startDayKey,
    this.deadlineDayKey,
    required this.isCompleted,
    this.completedDayKey,
    required this.isArchived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    {
      map['type'] = Variable<String>($GoalsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || exerciseId != null) {
      map['exercise_id'] = Variable<int>(exerciseId);
    }
    map['target_value'] = Variable<double>(targetValue);
    map['achieved_value'] = Variable<double>(achievedValue);
    map['start_day_key'] = Variable<int>(startDayKey);
    if (!nullToAbsent || deadlineDayKey != null) {
      map['deadline_day_key'] = Variable<int>(deadlineDayKey);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedDayKey != null) {
      map['completed_day_key'] = Variable<int>(completedDayKey);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      title: Value(title),
      type: Value(type),
      exerciseId: exerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseId),
      targetValue: Value(targetValue),
      achievedValue: Value(achievedValue),
      startDayKey: Value(startDayKey),
      deadlineDayKey: deadlineDayKey == null && nullToAbsent
          ? const Value.absent()
          : Value(deadlineDayKey),
      isCompleted: Value(isCompleted),
      completedDayKey: completedDayKey == null && nullToAbsent
          ? const Value.absent()
          : Value(completedDayKey),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
    );
  }

  factory GoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      type: $GoalsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      exerciseId: serializer.fromJson<int?>(json['exerciseId']),
      targetValue: serializer.fromJson<double>(json['targetValue']),
      achievedValue: serializer.fromJson<double>(json['achievedValue']),
      startDayKey: serializer.fromJson<int>(json['startDayKey']),
      deadlineDayKey: serializer.fromJson<int?>(json['deadlineDayKey']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedDayKey: serializer.fromJson<int?>(json['completedDayKey']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(
        $GoalsTable.$convertertype.toJson(type),
      ),
      'exerciseId': serializer.toJson<int?>(exerciseId),
      'targetValue': serializer.toJson<double>(targetValue),
      'achievedValue': serializer.toJson<double>(achievedValue),
      'startDayKey': serializer.toJson<int>(startDayKey),
      'deadlineDayKey': serializer.toJson<int?>(deadlineDayKey),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedDayKey': serializer.toJson<int?>(completedDayKey),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GoalRow copyWith({
    int? id,
    String? title,
    GoalType? type,
    Value<int?> exerciseId = const Value.absent(),
    double? targetValue,
    double? achievedValue,
    int? startDayKey,
    Value<int?> deadlineDayKey = const Value.absent(),
    bool? isCompleted,
    Value<int?> completedDayKey = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
  }) => GoalRow(
    id: id ?? this.id,
    title: title ?? this.title,
    type: type ?? this.type,
    exerciseId: exerciseId.present ? exerciseId.value : this.exerciseId,
    targetValue: targetValue ?? this.targetValue,
    achievedValue: achievedValue ?? this.achievedValue,
    startDayKey: startDayKey ?? this.startDayKey,
    deadlineDayKey: deadlineDayKey.present
        ? deadlineDayKey.value
        : this.deadlineDayKey,
    isCompleted: isCompleted ?? this.isCompleted,
    completedDayKey: completedDayKey.present
        ? completedDayKey.value
        : this.completedDayKey,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
  );
  GoalRow copyWithCompanion(GoalsCompanion data) {
    return GoalRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      achievedValue: data.achievedValue.present
          ? data.achievedValue.value
          : this.achievedValue,
      startDayKey: data.startDayKey.present
          ? data.startDayKey.value
          : this.startDayKey,
      deadlineDayKey: data.deadlineDayKey.present
          ? data.deadlineDayKey.value
          : this.deadlineDayKey,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedDayKey: data.completedDayKey.present
          ? data.completedDayKey.value
          : this.completedDayKey,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('targetValue: $targetValue, ')
          ..write('achievedValue: $achievedValue, ')
          ..write('startDayKey: $startDayKey, ')
          ..write('deadlineDayKey: $deadlineDayKey, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedDayKey: $completedDayKey, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    type,
    exerciseId,
    targetValue,
    achievedValue,
    startDayKey,
    deadlineDayKey,
    isCompleted,
    completedDayKey,
    isArchived,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.type == this.type &&
          other.exerciseId == this.exerciseId &&
          other.targetValue == this.targetValue &&
          other.achievedValue == this.achievedValue &&
          other.startDayKey == this.startDayKey &&
          other.deadlineDayKey == this.deadlineDayKey &&
          other.isCompleted == this.isCompleted &&
          other.completedDayKey == this.completedDayKey &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt);
}

class GoalsCompanion extends UpdateCompanion<GoalRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<GoalType> type;
  final Value<int?> exerciseId;
  final Value<double> targetValue;
  final Value<double> achievedValue;
  final Value<int> startDayKey;
  final Value<int?> deadlineDayKey;
  final Value<bool> isCompleted;
  final Value<int?> completedDayKey;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.achievedValue = const Value.absent(),
    this.startDayKey = const Value.absent(),
    this.deadlineDayKey = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedDayKey = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GoalsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required GoalType type,
    this.exerciseId = const Value.absent(),
    required double targetValue,
    this.achievedValue = const Value.absent(),
    required int startDayKey,
    this.deadlineDayKey = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedDayKey = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : title = Value(title),
       type = Value(type),
       targetValue = Value(targetValue),
       startDayKey = Value(startDayKey);
  static Insertable<GoalRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? type,
    Expression<int>? exerciseId,
    Expression<double>? targetValue,
    Expression<double>? achievedValue,
    Expression<int>? startDayKey,
    Expression<int>? deadlineDayKey,
    Expression<bool>? isCompleted,
    Expression<int>? completedDayKey,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (targetValue != null) 'target_value': targetValue,
      if (achievedValue != null) 'achieved_value': achievedValue,
      if (startDayKey != null) 'start_day_key': startDayKey,
      if (deadlineDayKey != null) 'deadline_day_key': deadlineDayKey,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedDayKey != null) 'completed_day_key': completedDayKey,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<GoalType>? type,
    Value<int?>? exerciseId,
    Value<double>? targetValue,
    Value<double>? achievedValue,
    Value<int>? startDayKey,
    Value<int?>? deadlineDayKey,
    Value<bool>? isCompleted,
    Value<int?>? completedDayKey,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      exerciseId: exerciseId ?? this.exerciseId,
      targetValue: targetValue ?? this.targetValue,
      achievedValue: achievedValue ?? this.achievedValue,
      startDayKey: startDayKey ?? this.startDayKey,
      deadlineDayKey: deadlineDayKey ?? this.deadlineDayKey,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDayKey: completedDayKey ?? this.completedDayKey,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $GoalsTable.$convertertype.toSql(type.value),
      );
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (achievedValue.present) {
      map['achieved_value'] = Variable<double>(achievedValue.value);
    }
    if (startDayKey.present) {
      map['start_day_key'] = Variable<int>(startDayKey.value);
    }
    if (deadlineDayKey.present) {
      map['deadline_day_key'] = Variable<int>(deadlineDayKey.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedDayKey.present) {
      map['completed_day_key'] = Variable<int>(completedDayKey.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('targetValue: $targetValue, ')
          ..write('achievedValue: $achievedValue, ')
          ..write('startDayKey: $startDayKey, ')
          ..write('deadlineDayKey: $deadlineDayKey, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedDayKey: $completedDayKey, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlanProgressesTable extends PlanProgresses
    with TableInfo<$PlanProgressesTable, PlanProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanProgressesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _currentDayMeta = const VerificationMeta(
    'currentDay',
  );
  @override
  late final GeneratedColumn<int> currentDay = GeneratedColumn<int>(
    'current_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _lastCompletedDayKeyMeta =
      const VerificationMeta('lastCompletedDayKey');
  @override
  late final GeneratedColumn<int> lastCompletedDayKey = GeneratedColumn<int>(
    'last_completed_day_key',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    planId,
    level,
    currentDay,
    lastCompletedDayKey,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_progresses';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('current_day')) {
      context.handle(
        _currentDayMeta,
        currentDay.isAcceptableOrUnknown(data['current_day']!, _currentDayMeta),
      );
    }
    if (data.containsKey('last_completed_day_key')) {
      context.handle(
        _lastCompletedDayKeyMeta,
        lastCompletedDayKey.isAcceptableOrUnknown(
          data['last_completed_day_key']!,
          _lastCompletedDayKeyMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {planId};
  @override
  PlanProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanProgressRow(
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      currentDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_day'],
      )!,
      lastCompletedDayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_completed_day_key'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlanProgressesTable createAlias(String alias) {
    return $PlanProgressesTable(attachedDatabase, alias);
  }
}

class PlanProgressRow extends DataClass implements Insertable<PlanProgressRow> {
  final String planId;
  final int level;
  final int currentDay;
  final int? lastCompletedDayKey;
  final DateTime updatedAt;
  const PlanProgressRow({
    required this.planId,
    required this.level,
    required this.currentDay,
    this.lastCompletedDayKey,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['plan_id'] = Variable<String>(planId);
    map['level'] = Variable<int>(level);
    map['current_day'] = Variable<int>(currentDay);
    if (!nullToAbsent || lastCompletedDayKey != null) {
      map['last_completed_day_key'] = Variable<int>(lastCompletedDayKey);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlanProgressesCompanion toCompanion(bool nullToAbsent) {
    return PlanProgressesCompanion(
      planId: Value(planId),
      level: Value(level),
      currentDay: Value(currentDay),
      lastCompletedDayKey: lastCompletedDayKey == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedDayKey),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlanProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanProgressRow(
      planId: serializer.fromJson<String>(json['planId']),
      level: serializer.fromJson<int>(json['level']),
      currentDay: serializer.fromJson<int>(json['currentDay']),
      lastCompletedDayKey: serializer.fromJson<int?>(
        json['lastCompletedDayKey'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'planId': serializer.toJson<String>(planId),
      'level': serializer.toJson<int>(level),
      'currentDay': serializer.toJson<int>(currentDay),
      'lastCompletedDayKey': serializer.toJson<int?>(lastCompletedDayKey),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlanProgressRow copyWith({
    String? planId,
    int? level,
    int? currentDay,
    Value<int?> lastCompletedDayKey = const Value.absent(),
    DateTime? updatedAt,
  }) => PlanProgressRow(
    planId: planId ?? this.planId,
    level: level ?? this.level,
    currentDay: currentDay ?? this.currentDay,
    lastCompletedDayKey: lastCompletedDayKey.present
        ? lastCompletedDayKey.value
        : this.lastCompletedDayKey,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlanProgressRow copyWithCompanion(PlanProgressesCompanion data) {
    return PlanProgressRow(
      planId: data.planId.present ? data.planId.value : this.planId,
      level: data.level.present ? data.level.value : this.level,
      currentDay: data.currentDay.present
          ? data.currentDay.value
          : this.currentDay,
      lastCompletedDayKey: data.lastCompletedDayKey.present
          ? data.lastCompletedDayKey.value
          : this.lastCompletedDayKey,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanProgressRow(')
          ..write('planId: $planId, ')
          ..write('level: $level, ')
          ..write('currentDay: $currentDay, ')
          ..write('lastCompletedDayKey: $lastCompletedDayKey, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(planId, level, currentDay, lastCompletedDayKey, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanProgressRow &&
          other.planId == this.planId &&
          other.level == this.level &&
          other.currentDay == this.currentDay &&
          other.lastCompletedDayKey == this.lastCompletedDayKey &&
          other.updatedAt == this.updatedAt);
}

class PlanProgressesCompanion extends UpdateCompanion<PlanProgressRow> {
  final Value<String> planId;
  final Value<int> level;
  final Value<int> currentDay;
  final Value<int?> lastCompletedDayKey;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlanProgressesCompanion({
    this.planId = const Value.absent(),
    this.level = const Value.absent(),
    this.currentDay = const Value.absent(),
    this.lastCompletedDayKey = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanProgressesCompanion.insert({
    required String planId,
    this.level = const Value.absent(),
    this.currentDay = const Value.absent(),
    this.lastCompletedDayKey = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : planId = Value(planId);
  static Insertable<PlanProgressRow> custom({
    Expression<String>? planId,
    Expression<int>? level,
    Expression<int>? currentDay,
    Expression<int>? lastCompletedDayKey,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (planId != null) 'plan_id': planId,
      if (level != null) 'level': level,
      if (currentDay != null) 'current_day': currentDay,
      if (lastCompletedDayKey != null)
        'last_completed_day_key': lastCompletedDayKey,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanProgressesCompanion copyWith({
    Value<String>? planId,
    Value<int>? level,
    Value<int>? currentDay,
    Value<int?>? lastCompletedDayKey,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlanProgressesCompanion(
      planId: planId ?? this.planId,
      level: level ?? this.level,
      currentDay: currentDay ?? this.currentDay,
      lastCompletedDayKey: lastCompletedDayKey ?? this.lastCompletedDayKey,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (currentDay.present) {
      map['current_day'] = Variable<int>(currentDay.value);
    }
    if (lastCompletedDayKey.present) {
      map['last_completed_day_key'] = Variable<int>(lastCompletedDayKey.value);
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
    return (StringBuffer('PlanProgressesCompanion(')
          ..write('planId: $planId, ')
          ..write('level: $level, ')
          ..write('currentDay: $currentDay, ')
          ..write('lastCompletedDayKey: $lastCompletedDayKey, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BadgesTable extends Badges with TableInfo<$BadgesTable, BadgeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BadgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedDayKeyMeta = const VerificationMeta(
    'earnedDayKey',
  );
  @override
  late final GeneratedColumn<int> earnedDayKey = GeneratedColumn<int>(
    'earned_day_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedAtMeta = const VerificationMeta(
    'earnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> earnedAt = GeneratedColumn<DateTime>(
    'earned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [code, earnedDayKey, earnedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'badges';
  @override
  VerificationContext validateIntegrity(
    Insertable<BadgeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('earned_day_key')) {
      context.handle(
        _earnedDayKeyMeta,
        earnedDayKey.isAcceptableOrUnknown(
          data['earned_day_key']!,
          _earnedDayKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_earnedDayKeyMeta);
    }
    if (data.containsKey('earned_at')) {
      context.handle(
        _earnedAtMeta,
        earnedAt.isAcceptableOrUnknown(data['earned_at']!, _earnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  BadgeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BadgeRow(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      earnedDayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}earned_day_key'],
      )!,
      earnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}earned_at'],
      )!,
    );
  }

  @override
  $BadgesTable createAlias(String alias) {
    return $BadgesTable(attachedDatabase, alias);
  }
}

class BadgeRow extends DataClass implements Insertable<BadgeRow> {
  final String code;
  final int earnedDayKey;
  final DateTime earnedAt;
  const BadgeRow({
    required this.code,
    required this.earnedDayKey,
    required this.earnedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['earned_day_key'] = Variable<int>(earnedDayKey);
    map['earned_at'] = Variable<DateTime>(earnedAt);
    return map;
  }

  BadgesCompanion toCompanion(bool nullToAbsent) {
    return BadgesCompanion(
      code: Value(code),
      earnedDayKey: Value(earnedDayKey),
      earnedAt: Value(earnedAt),
    );
  }

  factory BadgeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BadgeRow(
      code: serializer.fromJson<String>(json['code']),
      earnedDayKey: serializer.fromJson<int>(json['earnedDayKey']),
      earnedAt: serializer.fromJson<DateTime>(json['earnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'earnedDayKey': serializer.toJson<int>(earnedDayKey),
      'earnedAt': serializer.toJson<DateTime>(earnedAt),
    };
  }

  BadgeRow copyWith({String? code, int? earnedDayKey, DateTime? earnedAt}) =>
      BadgeRow(
        code: code ?? this.code,
        earnedDayKey: earnedDayKey ?? this.earnedDayKey,
        earnedAt: earnedAt ?? this.earnedAt,
      );
  BadgeRow copyWithCompanion(BadgesCompanion data) {
    return BadgeRow(
      code: data.code.present ? data.code.value : this.code,
      earnedDayKey: data.earnedDayKey.present
          ? data.earnedDayKey.value
          : this.earnedDayKey,
      earnedAt: data.earnedAt.present ? data.earnedAt.value : this.earnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BadgeRow(')
          ..write('code: $code, ')
          ..write('earnedDayKey: $earnedDayKey, ')
          ..write('earnedAt: $earnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, earnedDayKey, earnedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BadgeRow &&
          other.code == this.code &&
          other.earnedDayKey == this.earnedDayKey &&
          other.earnedAt == this.earnedAt);
}

class BadgesCompanion extends UpdateCompanion<BadgeRow> {
  final Value<String> code;
  final Value<int> earnedDayKey;
  final Value<DateTime> earnedAt;
  final Value<int> rowid;
  const BadgesCompanion({
    this.code = const Value.absent(),
    this.earnedDayKey = const Value.absent(),
    this.earnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BadgesCompanion.insert({
    required String code,
    required int earnedDayKey,
    required DateTime earnedAt,
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       earnedDayKey = Value(earnedDayKey),
       earnedAt = Value(earnedAt);
  static Insertable<BadgeRow> custom({
    Expression<String>? code,
    Expression<int>? earnedDayKey,
    Expression<DateTime>? earnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (earnedDayKey != null) 'earned_day_key': earnedDayKey,
      if (earnedAt != null) 'earned_at': earnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BadgesCompanion copyWith({
    Value<String>? code,
    Value<int>? earnedDayKey,
    Value<DateTime>? earnedAt,
    Value<int>? rowid,
  }) {
    return BadgesCompanion(
      code: code ?? this.code,
      earnedDayKey: earnedDayKey ?? this.earnedDayKey,
      earnedAt: earnedAt ?? this.earnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (earnedDayKey.present) {
      map['earned_day_key'] = Variable<int>(earnedDayKey.value);
    }
    if (earnedAt.present) {
      map['earned_at'] = Variable<DateTime>(earnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BadgesCompanion(')
          ..write('code: $code, ')
          ..write('earnedDayKey: $earnedDayKey, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $WorkoutExercisesTable workoutExercises = $WorkoutExercisesTable(
    this,
  );
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $DailyActivitiesTable dailyActivities = $DailyActivitiesTable(
    this,
  );
  late final $PersonalRecordsTable personalRecords = $PersonalRecordsTable(
    this,
  );
  late final $GoalsTable goals = $GoalsTable(this);
  late final $PlanProgressesTable planProgresses = $PlanProgressesTable(this);
  late final $BadgesTable badges = $BadgesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    exercises,
    workouts,
    workoutExercises,
    workoutSets,
    dailyActivities,
    personalRecords,
    goals,
    planProgresses,
    badges,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workouts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('personal_records', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('goals', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ExercisesTableCreateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      Value<String?> slug,
      required String name,
      required MuscleGroup muscleGroup,
      required Equipment equipment,
      required Difficulty difficulty,
      required TrackingType trackingType,
      Value<String> description,
      Value<String> instructions,
      Value<String> iconName,
      Value<bool> isBodyweight,
      Value<double> intensityFactor,
      Value<int> defaultRestSeconds,
      Value<bool> isCustom,
      Value<bool> isFavourite,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
    });
typedef $$ExercisesTableUpdateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      Value<String?> slug,
      Value<String> name,
      Value<MuscleGroup> muscleGroup,
      Value<Equipment> equipment,
      Value<Difficulty> difficulty,
      Value<TrackingType> trackingType,
      Value<String> description,
      Value<String> instructions,
      Value<String> iconName,
      Value<bool> isBodyweight,
      Value<double> intensityFactor,
      Value<int> defaultRestSeconds,
      Value<bool> isCustom,
      Value<bool> isFavourite,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
    });

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, ExerciseRow> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutExercisesTable, List<WorkoutExerciseRow>>
  _workoutExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutExercises,
    aliasName: 'exercises__id__workout_exercises__exercise_id',
  );

  $$WorkoutExercisesTableProcessedTableManager get workoutExercisesRefs {
    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PersonalRecordsTable, List<PersonalRecordRow>>
  _personalRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.personalRecords,
    aliasName: 'exercises__id__personal_records__exercise_id',
  );

  $$PersonalRecordsTableProcessedTableManager get personalRecordsRefs {
    final manager = $$PersonalRecordsTableTableManager(
      $_db,
      $_db.personalRecords,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _personalRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GoalsTable, List<GoalRow>> _goalsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.goals,
    aliasName: 'exercises__id__goals__exercise_id',
  );

  $$GoalsTableProcessedTableManager get goalsRefs {
    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MuscleGroup, MuscleGroup, String>
  get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Equipment, Equipment, String> get equipment =>
      $composableBuilder(
        column: $table.equipment,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Difficulty, Difficulty, String>
  get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TrackingType, TrackingType, String>
  get trackingType => $composableBuilder(
    column: $table.trackingType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBodyweight => $composableBuilder(
    column: $table.isBodyweight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get intensityFactor => $composableBuilder(
    column: $table.intensityFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavourite => $composableBuilder(
    column: $table.isFavourite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutExercisesRefs(
    Expression<bool> Function($$WorkoutExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> personalRecordsRefs(
    Expression<bool> Function($$PersonalRecordsTableFilterComposer f) f,
  ) {
    final $$PersonalRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalRecords,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalRecordsTableFilterComposer(
            $db: $db,
            $table: $db.personalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalsRefs(
    Expression<bool> Function($$GoalsTableFilterComposer f) f,
  ) {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackingType => $composableBuilder(
    column: $table.trackingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBodyweight => $composableBuilder(
    column: $table.isBodyweight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get intensityFactor => $composableBuilder(
    column: $table.intensityFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavourite => $composableBuilder(
    column: $table.isFavourite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MuscleGroup, String> get muscleGroup =>
      $composableBuilder(
        column: $table.muscleGroup,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Equipment, String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Difficulty, String> get difficulty =>
      $composableBuilder(
        column: $table.difficulty,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<TrackingType, String> get trackingType =>
      $composableBuilder(
        column: $table.trackingType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<bool> get isBodyweight => $composableBuilder(
    column: $table.isBodyweight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get intensityFactor => $composableBuilder(
    column: $table.intensityFactor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<bool> get isFavourite => $composableBuilder(
    column: $table.isFavourite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> workoutExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutExercisesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> personalRecordsRefs<T extends Object>(
    Expression<T> Function($$PersonalRecordsTableAnnotationComposer a) f,
  ) {
    final $$PersonalRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalRecords,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.personalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> goalsRefs<T extends Object>(
    Expression<T> Function($$GoalsTableAnnotationComposer a) f,
  ) {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          ExerciseRow,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (ExerciseRow, $$ExercisesTableReferences),
          ExerciseRow,
          PrefetchHooks Function({
            bool workoutExercisesRefs,
            bool personalRecordsRefs,
            bool goalsRefs,
          })
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> slug = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<MuscleGroup> muscleGroup = const Value.absent(),
                Value<Equipment> equipment = const Value.absent(),
                Value<Difficulty> difficulty = const Value.absent(),
                Value<TrackingType> trackingType = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> instructions = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<bool> isBodyweight = const Value.absent(),
                Value<double> intensityFactor = const Value.absent(),
                Value<int> defaultRestSeconds = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<bool> isFavourite = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                slug: slug,
                name: name,
                muscleGroup: muscleGroup,
                equipment: equipment,
                difficulty: difficulty,
                trackingType: trackingType,
                description: description,
                instructions: instructions,
                iconName: iconName,
                isBodyweight: isBodyweight,
                intensityFactor: intensityFactor,
                defaultRestSeconds: defaultRestSeconds,
                isCustom: isCustom,
                isFavourite: isFavourite,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> slug = const Value.absent(),
                required String name,
                required MuscleGroup muscleGroup,
                required Equipment equipment,
                required Difficulty difficulty,
                required TrackingType trackingType,
                Value<String> description = const Value.absent(),
                Value<String> instructions = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<bool> isBodyweight = const Value.absent(),
                Value<double> intensityFactor = const Value.absent(),
                Value<int> defaultRestSeconds = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<bool> isFavourite = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                slug: slug,
                name: name,
                muscleGroup: muscleGroup,
                equipment: equipment,
                difficulty: difficulty,
                trackingType: trackingType,
                description: description,
                instructions: instructions,
                iconName: iconName,
                isBodyweight: isBodyweight,
                intensityFactor: intensityFactor,
                defaultRestSeconds: defaultRestSeconds,
                isCustom: isCustom,
                isFavourite: isFavourite,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                workoutExercisesRefs = false,
                personalRecordsRefs = false,
                goalsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutExercisesRefs) db.workoutExercises,
                    if (personalRecordsRefs) db.personalRecords,
                    if (goalsRefs) db.goals,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutExercisesRefs)
                        await $_getPrefetchedData<
                          ExerciseRow,
                          $ExercisesTable,
                          WorkoutExerciseRow
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._workoutExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (personalRecordsRefs)
                        await $_getPrefetchedData<
                          ExerciseRow,
                          $ExercisesTable,
                          PersonalRecordRow
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._personalRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).personalRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalsRefs)
                        await $_getPrefetchedData<
                          ExerciseRow,
                          $ExercisesTable,
                          GoalRow
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._goalsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).goalsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
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

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      ExerciseRow,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (ExerciseRow, $$ExercisesTableReferences),
      ExerciseRow,
      PrefetchHooks Function({
        bool workoutExercisesRefs,
        bool personalRecordsRefs,
        bool goalsRefs,
      })
    >;
typedef $$WorkoutsTableCreateCompanionBuilder =
    WorkoutsCompanion Function({
      Value<int> id,
      required int dayKey,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      required WorkoutSource source,
      Value<String> title,
      Value<String?> planId,
      Value<int?> planLevel,
      Value<int?> planDay,
      Value<SessionFeedback?> feedback,
      Value<String> notes,
      Value<bool> isCompleted,
      Value<int> totalReps,
      Value<int> totalDurationSeconds,
      Value<double> totalVolume,
      Value<int> durationSeconds,
    });
typedef $$WorkoutsTableUpdateCompanionBuilder =
    WorkoutsCompanion Function({
      Value<int> id,
      Value<int> dayKey,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<WorkoutSource> source,
      Value<String> title,
      Value<String?> planId,
      Value<int?> planLevel,
      Value<int?> planDay,
      Value<SessionFeedback?> feedback,
      Value<String> notes,
      Value<bool> isCompleted,
      Value<int> totalReps,
      Value<int> totalDurationSeconds,
      Value<double> totalVolume,
      Value<int> durationSeconds,
    });

final class $$WorkoutsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutsTable, WorkoutRow> {
  $$WorkoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutExercisesTable, List<WorkoutExerciseRow>>
  _workoutExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutExercises,
    aliasName: 'workouts__id__workout_exercises__workout_id',
  );

  $$WorkoutExercisesTableProcessedTableManager get workoutExercisesRefs {
    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WorkoutSource, WorkoutSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get planLevel => $composableBuilder(
    column: $table.planLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get planDay => $composableBuilder(
    column: $table.planDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionFeedback?, SessionFeedback, String>
  get feedback => $composableBuilder(
    column: $table.feedback,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalReps => $composableBuilder(
    column: $table.totalReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDurationSeconds => $composableBuilder(
    column: $table.totalDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalVolume => $composableBuilder(
    column: $table.totalVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutExercisesRefs(
    Expression<bool> Function($$WorkoutExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get planLevel => $composableBuilder(
    column: $table.planLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get planDay => $composableBuilder(
    column: $table.planDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedback => $composableBuilder(
    column: $table.feedback,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalReps => $composableBuilder(
    column: $table.totalReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDurationSeconds => $composableBuilder(
    column: $table.totalDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalVolume => $composableBuilder(
    column: $table.totalVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<WorkoutSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<int> get planLevel =>
      $composableBuilder(column: $table.planLevel, builder: (column) => column);

  GeneratedColumn<int> get planDay =>
      $composableBuilder(column: $table.planDay, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SessionFeedback?, String> get feedback =>
      $composableBuilder(column: $table.feedback, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalReps =>
      $composableBuilder(column: $table.totalReps, builder: (column) => column);

  GeneratedColumn<int> get totalDurationSeconds => $composableBuilder(
    column: $table.totalDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalVolume => $composableBuilder(
    column: $table.totalVolume,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  Expression<T> workoutExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutExercisesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutsTable,
          WorkoutRow,
          $$WorkoutsTableFilterComposer,
          $$WorkoutsTableOrderingComposer,
          $$WorkoutsTableAnnotationComposer,
          $$WorkoutsTableCreateCompanionBuilder,
          $$WorkoutsTableUpdateCompanionBuilder,
          (WorkoutRow, $$WorkoutsTableReferences),
          WorkoutRow,
          PrefetchHooks Function({bool workoutExercisesRefs})
        > {
  $$WorkoutsTableTableManager(_$AppDatabase db, $WorkoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dayKey = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<WorkoutSource> source = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> planId = const Value.absent(),
                Value<int?> planLevel = const Value.absent(),
                Value<int?> planDay = const Value.absent(),
                Value<SessionFeedback?> feedback = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> totalReps = const Value.absent(),
                Value<int> totalDurationSeconds = const Value.absent(),
                Value<double> totalVolume = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
              }) => WorkoutsCompanion(
                id: id,
                dayKey: dayKey,
                startedAt: startedAt,
                completedAt: completedAt,
                source: source,
                title: title,
                planId: planId,
                planLevel: planLevel,
                planDay: planDay,
                feedback: feedback,
                notes: notes,
                isCompleted: isCompleted,
                totalReps: totalReps,
                totalDurationSeconds: totalDurationSeconds,
                totalVolume: totalVolume,
                durationSeconds: durationSeconds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int dayKey,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                required WorkoutSource source,
                Value<String> title = const Value.absent(),
                Value<String?> planId = const Value.absent(),
                Value<int?> planLevel = const Value.absent(),
                Value<int?> planDay = const Value.absent(),
                Value<SessionFeedback?> feedback = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> totalReps = const Value.absent(),
                Value<int> totalDurationSeconds = const Value.absent(),
                Value<double> totalVolume = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
              }) => WorkoutsCompanion.insert(
                id: id,
                dayKey: dayKey,
                startedAt: startedAt,
                completedAt: completedAt,
                source: source,
                title: title,
                planId: planId,
                planLevel: planLevel,
                planDay: planDay,
                feedback: feedback,
                notes: notes,
                isCompleted: isCompleted,
                totalReps: totalReps,
                totalDurationSeconds: totalDurationSeconds,
                totalVolume: totalVolume,
                durationSeconds: durationSeconds,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutExercisesRefs) db.workoutExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutExercisesRefs)
                    await $_getPrefetchedData<
                      WorkoutRow,
                      $WorkoutsTable,
                      WorkoutExerciseRow
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutsTableReferences
                          ._workoutExercisesRefsTable(db),
                      managerFromTypedResult: (p0) => $$WorkoutsTableReferences(
                        db,
                        table,
                        p0,
                      ).workoutExercisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.workoutId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutsTable,
      WorkoutRow,
      $$WorkoutsTableFilterComposer,
      $$WorkoutsTableOrderingComposer,
      $$WorkoutsTableAnnotationComposer,
      $$WorkoutsTableCreateCompanionBuilder,
      $$WorkoutsTableUpdateCompanionBuilder,
      (WorkoutRow, $$WorkoutsTableReferences),
      WorkoutRow,
      PrefetchHooks Function({bool workoutExercisesRefs})
    >;
typedef $$WorkoutExercisesTableCreateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<int> id,
      required int workoutId,
      required int exerciseId,
      required int position,
      required String exerciseName,
      required TrackingType trackingType,
      Value<bool> isSkipped,
    });
typedef $$WorkoutExercisesTableUpdateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<int> id,
      Value<int> workoutId,
      Value<int> exerciseId,
      Value<int> position,
      Value<String> exerciseName,
      Value<TrackingType> trackingType,
      Value<bool> isSkipped,
    });

final class $$WorkoutExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutExercisesTable,
          WorkoutExerciseRow
        > {
  $$WorkoutExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias('workout_exercises__workout_id__workouts__id');

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<int>('workout_id')!;

    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('workout_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetsTable, List<SetRow>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'workout_exercises__id__workout_sets__workout_exercise_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.workoutExerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TrackingType, TrackingType, String>
  get trackingType => $composableBuilder(
    column: $table.trackingType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isSkipped => $composableBuilder(
    column: $table.isSkipped,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.workoutExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackingType => $composableBuilder(
    column: $table.trackingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSkipped => $composableBuilder(
    column: $table.isSkipped,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TrackingType, String> get trackingType =>
      $composableBuilder(
        column: $table.trackingType,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isSkipped =>
      $composableBuilder(column: $table.isSkipped, builder: (column) => column);

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.workoutExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutExercisesTable,
          WorkoutExerciseRow,
          $$WorkoutExercisesTableFilterComposer,
          $$WorkoutExercisesTableOrderingComposer,
          $$WorkoutExercisesTableAnnotationComposer,
          $$WorkoutExercisesTableCreateCompanionBuilder,
          $$WorkoutExercisesTableUpdateCompanionBuilder,
          (WorkoutExerciseRow, $$WorkoutExercisesTableReferences),
          WorkoutExerciseRow,
          PrefetchHooks Function({
            bool workoutId,
            bool exerciseId,
            bool workoutSetsRefs,
          })
        > {
  $$WorkoutExercisesTableTableManager(
    _$AppDatabase db,
    $WorkoutExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workoutId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<TrackingType> trackingType = const Value.absent(),
                Value<bool> isSkipped = const Value.absent(),
              }) => WorkoutExercisesCompanion(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                position: position,
                exerciseName: exerciseName,
                trackingType: trackingType,
                isSkipped: isSkipped,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workoutId,
                required int exerciseId,
                required int position,
                required String exerciseName,
                required TrackingType trackingType,
                Value<bool> isSkipped = const Value.absent(),
              }) => WorkoutExercisesCompanion.insert(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                position: position,
                exerciseName: exerciseName,
                trackingType: trackingType,
                isSkipped: isSkipped,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                workoutId = false,
                exerciseId = false,
                workoutSetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsRefs) db.workoutSets,
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
                        if (workoutId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.workoutId,
                                    referencedTable:
                                        $$WorkoutExercisesTableReferences
                                            ._workoutIdTable(db),
                                    referencedColumn:
                                        $$WorkoutExercisesTableReferences
                                            ._workoutIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (exerciseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.exerciseId,
                                    referencedTable:
                                        $$WorkoutExercisesTableReferences
                                            ._exerciseIdTable(db),
                                    referencedColumn:
                                        $$WorkoutExercisesTableReferences
                                            ._exerciseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetsRefs)
                        await $_getPrefetchedData<
                          WorkoutExerciseRow,
                          $WorkoutExercisesTable,
                          SetRow
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutExercisesTableReferences
                              ._workoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutExerciseId == item.id,
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

typedef $$WorkoutExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutExercisesTable,
      WorkoutExerciseRow,
      $$WorkoutExercisesTableFilterComposer,
      $$WorkoutExercisesTableOrderingComposer,
      $$WorkoutExercisesTableAnnotationComposer,
      $$WorkoutExercisesTableCreateCompanionBuilder,
      $$WorkoutExercisesTableUpdateCompanionBuilder,
      (WorkoutExerciseRow, $$WorkoutExercisesTableReferences),
      WorkoutExerciseRow,
      PrefetchHooks Function({
        bool workoutId,
        bool exerciseId,
        bool workoutSetsRefs,
      })
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      required int workoutExerciseId,
      required int position,
      Value<int?> targetValue,
      Value<int> reps,
      Value<double> weightKg,
      Value<int> durationSeconds,
      Value<double> distanceMeters,
      Value<int> restSeconds,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      Value<int> workoutExerciseId,
      Value<int> position,
      Value<int?> targetValue,
      Value<int> reps,
      Value<double> weightKg,
      Value<int> durationSeconds,
      Value<double> distanceMeters,
      Value<int> restSeconds,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
    });

final class $$WorkoutSetsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSetsTable, SetRow> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutExercisesTable _workoutExerciseIdTable(_$AppDatabase db) => db
      .workoutExercises
      .createAlias('workout_sets__workout_exercise_id__workout_exercises__id');

  $$WorkoutExercisesTableProcessedTableManager get workoutExerciseId {
    final $_column = $_itemColumn<int>('workout_exercise_id')!;

    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutExercisesTableFilterComposer get workoutExerciseId {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutExercisesTableOrderingComposer get workoutExerciseId {
    final $$WorkoutExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$WorkoutExercisesTableAnnotationComposer get workoutExerciseId {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetsTable,
          SetRow,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (SetRow, $$WorkoutSetsTableReferences),
          SetRow,
          PrefetchHooks Function({bool workoutExerciseId})
        > {
  $$WorkoutSetsTableTableManager(_$AppDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workoutExerciseId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int?> targetValue = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                workoutExerciseId: workoutExerciseId,
                position: position,
                targetValue: targetValue,
                reps: reps,
                weightKg: weightKg,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                restSeconds: restSeconds,
                isCompleted: isCompleted,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workoutExerciseId,
                required int position,
                Value<int?> targetValue = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                id: id,
                workoutExerciseId: workoutExerciseId,
                position: position,
                targetValue: targetValue,
                reps: reps,
                weightKg: weightKg,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                restSeconds: restSeconds,
                isCompleted: isCompleted,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutExerciseId = false}) {
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
                    if (workoutExerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workoutExerciseId,
                                referencedTable: $$WorkoutSetsTableReferences
                                    ._workoutExerciseIdTable(db),
                                referencedColumn: $$WorkoutSetsTableReferences
                                    ._workoutExerciseIdTable(db)
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

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetsTable,
      SetRow,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (SetRow, $$WorkoutSetsTableReferences),
      SetRow,
      PrefetchHooks Function({bool workoutExerciseId})
    >;
typedef $$DailyActivitiesTableCreateCompanionBuilder =
    DailyActivitiesCompanion Function({
      Value<int> dayKey,
      Value<int> workoutCount,
      Value<int> totalReps,
      Value<int> totalDurationSeconds,
      Value<double> totalVolume,
      Value<bool> isFreeze,
    });
typedef $$DailyActivitiesTableUpdateCompanionBuilder =
    DailyActivitiesCompanion Function({
      Value<int> dayKey,
      Value<int> workoutCount,
      Value<int> totalReps,
      Value<int> totalDurationSeconds,
      Value<double> totalVolume,
      Value<bool> isFreeze,
    });

class $$DailyActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyActivitiesTable> {
  $$DailyActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workoutCount => $composableBuilder(
    column: $table.workoutCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalReps => $composableBuilder(
    column: $table.totalReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDurationSeconds => $composableBuilder(
    column: $table.totalDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalVolume => $composableBuilder(
    column: $table.totalVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFreeze => $composableBuilder(
    column: $table.isFreeze,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyActivitiesTable> {
  $$DailyActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workoutCount => $composableBuilder(
    column: $table.workoutCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalReps => $composableBuilder(
    column: $table.totalReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDurationSeconds => $composableBuilder(
    column: $table.totalDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalVolume => $composableBuilder(
    column: $table.totalVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFreeze => $composableBuilder(
    column: $table.isFreeze,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyActivitiesTable> {
  $$DailyActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<int> get workoutCount => $composableBuilder(
    column: $table.workoutCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalReps =>
      $composableBuilder(column: $table.totalReps, builder: (column) => column);

  GeneratedColumn<int> get totalDurationSeconds => $composableBuilder(
    column: $table.totalDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalVolume => $composableBuilder(
    column: $table.totalVolume,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFreeze =>
      $composableBuilder(column: $table.isFreeze, builder: (column) => column);
}

class $$DailyActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyActivitiesTable,
          DailyActivityRow,
          $$DailyActivitiesTableFilterComposer,
          $$DailyActivitiesTableOrderingComposer,
          $$DailyActivitiesTableAnnotationComposer,
          $$DailyActivitiesTableCreateCompanionBuilder,
          $$DailyActivitiesTableUpdateCompanionBuilder,
          (
            DailyActivityRow,
            BaseReferences<
              _$AppDatabase,
              $DailyActivitiesTable,
              DailyActivityRow
            >,
          ),
          DailyActivityRow,
          PrefetchHooks Function()
        > {
  $$DailyActivitiesTableTableManager(
    _$AppDatabase db,
    $DailyActivitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> dayKey = const Value.absent(),
                Value<int> workoutCount = const Value.absent(),
                Value<int> totalReps = const Value.absent(),
                Value<int> totalDurationSeconds = const Value.absent(),
                Value<double> totalVolume = const Value.absent(),
                Value<bool> isFreeze = const Value.absent(),
              }) => DailyActivitiesCompanion(
                dayKey: dayKey,
                workoutCount: workoutCount,
                totalReps: totalReps,
                totalDurationSeconds: totalDurationSeconds,
                totalVolume: totalVolume,
                isFreeze: isFreeze,
              ),
          createCompanionCallback:
              ({
                Value<int> dayKey = const Value.absent(),
                Value<int> workoutCount = const Value.absent(),
                Value<int> totalReps = const Value.absent(),
                Value<int> totalDurationSeconds = const Value.absent(),
                Value<double> totalVolume = const Value.absent(),
                Value<bool> isFreeze = const Value.absent(),
              }) => DailyActivitiesCompanion.insert(
                dayKey: dayKey,
                workoutCount: workoutCount,
                totalReps: totalReps,
                totalDurationSeconds: totalDurationSeconds,
                totalVolume: totalVolume,
                isFreeze: isFreeze,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyActivitiesTable,
      DailyActivityRow,
      $$DailyActivitiesTableFilterComposer,
      $$DailyActivitiesTableOrderingComposer,
      $$DailyActivitiesTableAnnotationComposer,
      $$DailyActivitiesTableCreateCompanionBuilder,
      $$DailyActivitiesTableUpdateCompanionBuilder,
      (
        DailyActivityRow,
        BaseReferences<_$AppDatabase, $DailyActivitiesTable, DailyActivityRow>,
      ),
      DailyActivityRow,
      PrefetchHooks Function()
    >;
typedef $$PersonalRecordsTableCreateCompanionBuilder =
    PersonalRecordsCompanion Function({
      Value<int> id,
      required int exerciseId,
      required String metric,
      required double value,
      Value<double> secondaryValue,
      required int dayKey,
      Value<int?> workoutId,
      required DateTime achievedAt,
    });
typedef $$PersonalRecordsTableUpdateCompanionBuilder =
    PersonalRecordsCompanion Function({
      Value<int> id,
      Value<int> exerciseId,
      Value<String> metric,
      Value<double> value,
      Value<double> secondaryValue,
      Value<int> dayKey,
      Value<int?> workoutId,
      Value<DateTime> achievedAt,
    });

final class $$PersonalRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PersonalRecordsTable,
          PersonalRecordRow
        > {
  $$PersonalRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('personal_records__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PersonalRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get secondaryValue => $composableBuilder(
    column: $table.secondaryValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonalRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get secondaryValue => $composableBuilder(
    column: $table.secondaryValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonalRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get metric =>
      $composableBuilder(column: $table.metric, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<double> get secondaryValue => $composableBuilder(
    column: $table.secondaryValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<int> get workoutId =>
      $composableBuilder(column: $table.workoutId, builder: (column) => column);

  GeneratedColumn<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => column,
  );

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonalRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonalRecordsTable,
          PersonalRecordRow,
          $$PersonalRecordsTableFilterComposer,
          $$PersonalRecordsTableOrderingComposer,
          $$PersonalRecordsTableAnnotationComposer,
          $$PersonalRecordsTableCreateCompanionBuilder,
          $$PersonalRecordsTableUpdateCompanionBuilder,
          (PersonalRecordRow, $$PersonalRecordsTableReferences),
          PersonalRecordRow,
          PrefetchHooks Function({bool exerciseId})
        > {
  $$PersonalRecordsTableTableManager(
    _$AppDatabase db,
    $PersonalRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<String> metric = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<double> secondaryValue = const Value.absent(),
                Value<int> dayKey = const Value.absent(),
                Value<int?> workoutId = const Value.absent(),
                Value<DateTime> achievedAt = const Value.absent(),
              }) => PersonalRecordsCompanion(
                id: id,
                exerciseId: exerciseId,
                metric: metric,
                value: value,
                secondaryValue: secondaryValue,
                dayKey: dayKey,
                workoutId: workoutId,
                achievedAt: achievedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int exerciseId,
                required String metric,
                required double value,
                Value<double> secondaryValue = const Value.absent(),
                required int dayKey,
                Value<int?> workoutId = const Value.absent(),
                required DateTime achievedAt,
              }) => PersonalRecordsCompanion.insert(
                id: id,
                exerciseId: exerciseId,
                metric: metric,
                value: value,
                secondaryValue: secondaryValue,
                dayKey: dayKey,
                workoutId: workoutId,
                achievedAt: achievedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PersonalRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseId = false}) {
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
                    if (exerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseId,
                                referencedTable:
                                    $$PersonalRecordsTableReferences
                                        ._exerciseIdTable(db),
                                referencedColumn:
                                    $$PersonalRecordsTableReferences
                                        ._exerciseIdTable(db)
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

typedef $$PersonalRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonalRecordsTable,
      PersonalRecordRow,
      $$PersonalRecordsTableFilterComposer,
      $$PersonalRecordsTableOrderingComposer,
      $$PersonalRecordsTableAnnotationComposer,
      $$PersonalRecordsTableCreateCompanionBuilder,
      $$PersonalRecordsTableUpdateCompanionBuilder,
      (PersonalRecordRow, $$PersonalRecordsTableReferences),
      PersonalRecordRow,
      PrefetchHooks Function({bool exerciseId})
    >;
typedef $$GoalsTableCreateCompanionBuilder =
    GoalsCompanion Function({
      Value<int> id,
      required String title,
      required GoalType type,
      Value<int?> exerciseId,
      required double targetValue,
      Value<double> achievedValue,
      required int startDayKey,
      Value<int?> deadlineDayKey,
      Value<bool> isCompleted,
      Value<int?> completedDayKey,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
    });
typedef $$GoalsTableUpdateCompanionBuilder =
    GoalsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<GoalType> type,
      Value<int?> exerciseId,
      Value<double> targetValue,
      Value<double> achievedValue,
      Value<int> startDayKey,
      Value<int?> deadlineDayKey,
      Value<bool> isCompleted,
      Value<int?> completedDayKey,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
    });

final class $$GoalsTableReferences
    extends BaseReferences<_$AppDatabase, $GoalsTable, GoalRow> {
  $$GoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('goals__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager? get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id');
    if ($_column == null) return null;
    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GoalType, GoalType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get achievedValue => $composableBuilder(
    column: $table.achievedValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startDayKey => $composableBuilder(
    column: $table.startDayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deadlineDayKey => $composableBuilder(
    column: $table.deadlineDayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedDayKey => $composableBuilder(
    column: $table.completedDayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get achievedValue => $composableBuilder(
    column: $table.achievedValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDayKey => $composableBuilder(
    column: $table.startDayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deadlineDayKey => $composableBuilder(
    column: $table.deadlineDayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedDayKey => $composableBuilder(
    column: $table.completedDayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GoalType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get achievedValue => $composableBuilder(
    column: $table.achievedValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startDayKey => $composableBuilder(
    column: $table.startDayKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deadlineDayKey => $composableBuilder(
    column: $table.deadlineDayKey,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedDayKey => $composableBuilder(
    column: $table.completedDayKey,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          GoalRow,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (GoalRow, $$GoalsTableReferences),
          GoalRow,
          PrefetchHooks Function({bool exerciseId})
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<GoalType> type = const Value.absent(),
                Value<int?> exerciseId = const Value.absent(),
                Value<double> targetValue = const Value.absent(),
                Value<double> achievedValue = const Value.absent(),
                Value<int> startDayKey = const Value.absent(),
                Value<int?> deadlineDayKey = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> completedDayKey = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                title: title,
                type: type,
                exerciseId: exerciseId,
                targetValue: targetValue,
                achievedValue: achievedValue,
                startDayKey: startDayKey,
                deadlineDayKey: deadlineDayKey,
                isCompleted: isCompleted,
                completedDayKey: completedDayKey,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required GoalType type,
                Value<int?> exerciseId = const Value.absent(),
                required double targetValue,
                Value<double> achievedValue = const Value.absent(),
                required int startDayKey,
                Value<int?> deadlineDayKey = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> completedDayKey = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                title: title,
                type: type,
                exerciseId: exerciseId,
                targetValue: targetValue,
                achievedValue: achievedValue,
                startDayKey: startDayKey,
                deadlineDayKey: deadlineDayKey,
                isCompleted: isCompleted,
                completedDayKey: completedDayKey,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GoalsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseId = false}) {
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
                    if (exerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseId,
                                referencedTable: $$GoalsTableReferences
                                    ._exerciseIdTable(db),
                                referencedColumn: $$GoalsTableReferences
                                    ._exerciseIdTable(db)
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

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      GoalRow,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (GoalRow, $$GoalsTableReferences),
      GoalRow,
      PrefetchHooks Function({bool exerciseId})
    >;
typedef $$PlanProgressesTableCreateCompanionBuilder =
    PlanProgressesCompanion Function({
      required String planId,
      Value<int> level,
      Value<int> currentDay,
      Value<int?> lastCompletedDayKey,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$PlanProgressesTableUpdateCompanionBuilder =
    PlanProgressesCompanion Function({
      Value<String> planId,
      Value<int> level,
      Value<int> currentDay,
      Value<int?> lastCompletedDayKey,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PlanProgressesTableFilterComposer
    extends Composer<_$AppDatabase, $PlanProgressesTable> {
  $$PlanProgressesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentDay => $composableBuilder(
    column: $table.currentDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastCompletedDayKey => $composableBuilder(
    column: $table.lastCompletedDayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlanProgressesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanProgressesTable> {
  $$PlanProgressesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentDay => $composableBuilder(
    column: $table.currentDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastCompletedDayKey => $composableBuilder(
    column: $table.lastCompletedDayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlanProgressesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanProgressesTable> {
  $$PlanProgressesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get currentDay => $composableBuilder(
    column: $table.currentDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastCompletedDayKey => $composableBuilder(
    column: $table.lastCompletedDayKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PlanProgressesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanProgressesTable,
          PlanProgressRow,
          $$PlanProgressesTableFilterComposer,
          $$PlanProgressesTableOrderingComposer,
          $$PlanProgressesTableAnnotationComposer,
          $$PlanProgressesTableCreateCompanionBuilder,
          $$PlanProgressesTableUpdateCompanionBuilder,
          (
            PlanProgressRow,
            BaseReferences<
              _$AppDatabase,
              $PlanProgressesTable,
              PlanProgressRow
            >,
          ),
          PlanProgressRow,
          PrefetchHooks Function()
        > {
  $$PlanProgressesTableTableManager(
    _$AppDatabase db,
    $PlanProgressesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanProgressesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanProgressesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanProgressesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> planId = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> currentDay = const Value.absent(),
                Value<int?> lastCompletedDayKey = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanProgressesCompanion(
                planId: planId,
                level: level,
                currentDay: currentDay,
                lastCompletedDayKey: lastCompletedDayKey,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String planId,
                Value<int> level = const Value.absent(),
                Value<int> currentDay = const Value.absent(),
                Value<int?> lastCompletedDayKey = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanProgressesCompanion.insert(
                planId: planId,
                level: level,
                currentDay: currentDay,
                lastCompletedDayKey: lastCompletedDayKey,
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

typedef $$PlanProgressesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanProgressesTable,
      PlanProgressRow,
      $$PlanProgressesTableFilterComposer,
      $$PlanProgressesTableOrderingComposer,
      $$PlanProgressesTableAnnotationComposer,
      $$PlanProgressesTableCreateCompanionBuilder,
      $$PlanProgressesTableUpdateCompanionBuilder,
      (
        PlanProgressRow,
        BaseReferences<_$AppDatabase, $PlanProgressesTable, PlanProgressRow>,
      ),
      PlanProgressRow,
      PrefetchHooks Function()
    >;
typedef $$BadgesTableCreateCompanionBuilder =
    BadgesCompanion Function({
      required String code,
      required int earnedDayKey,
      required DateTime earnedAt,
      Value<int> rowid,
    });
typedef $$BadgesTableUpdateCompanionBuilder =
    BadgesCompanion Function({
      Value<String> code,
      Value<int> earnedDayKey,
      Value<DateTime> earnedAt,
      Value<int> rowid,
    });

class $$BadgesTableFilterComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get earnedDayKey => $composableBuilder(
    column: $table.earnedDayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BadgesTableOrderingComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get earnedDayKey => $composableBuilder(
    column: $table.earnedDayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BadgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get earnedDayKey => $composableBuilder(
    column: $table.earnedDayKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get earnedAt =>
      $composableBuilder(column: $table.earnedAt, builder: (column) => column);
}

class $$BadgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BadgesTable,
          BadgeRow,
          $$BadgesTableFilterComposer,
          $$BadgesTableOrderingComposer,
          $$BadgesTableAnnotationComposer,
          $$BadgesTableCreateCompanionBuilder,
          $$BadgesTableUpdateCompanionBuilder,
          (BadgeRow, BaseReferences<_$AppDatabase, $BadgesTable, BadgeRow>),
          BadgeRow,
          PrefetchHooks Function()
        > {
  $$BadgesTableTableManager(_$AppDatabase db, $BadgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BadgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BadgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BadgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<int> earnedDayKey = const Value.absent(),
                Value<DateTime> earnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BadgesCompanion(
                code: code,
                earnedDayKey: earnedDayKey,
                earnedAt: earnedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required int earnedDayKey,
                required DateTime earnedAt,
                Value<int> rowid = const Value.absent(),
              }) => BadgesCompanion.insert(
                code: code,
                earnedDayKey: earnedDayKey,
                earnedAt: earnedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BadgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BadgesTable,
      BadgeRow,
      $$BadgesTableFilterComposer,
      $$BadgesTableOrderingComposer,
      $$BadgesTableAnnotationComposer,
      $$BadgesTableCreateCompanionBuilder,
      $$BadgesTableUpdateCompanionBuilder,
      (BadgeRow, BaseReferences<_$AppDatabase, $BadgesTable, BadgeRow>),
      BadgeRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$WorkoutExercisesTableTableManager get workoutExercises =>
      $$WorkoutExercisesTableTableManager(_db, _db.workoutExercises);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$DailyActivitiesTableTableManager get dailyActivities =>
      $$DailyActivitiesTableTableManager(_db, _db.dailyActivities);
  $$PersonalRecordsTableTableManager get personalRecords =>
      $$PersonalRecordsTableTableManager(_db, _db.personalRecords);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$PlanProgressesTableTableManager get planProgresses =>
      $$PlanProgressesTableTableManager(_db, _db.planProgresses);
  $$BadgesTableTableManager get badges =>
      $$BadgesTableTableManager(_db, _db.badges);
}
