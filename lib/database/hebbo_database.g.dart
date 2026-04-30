// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hebbo_database.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions
    with TableInfo<$SessionsTable, SessionTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('flanker'),
  );
  static const VerificationMeta _sessionNumMeta = const VerificationMeta(
    'sessionNum',
  );
  @override
  late final GeneratedColumn<int> sessionNum = GeneratedColumn<int>(
    'session_num',
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
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startingLevelMeta = const VerificationMeta(
    'startingLevel',
  );
  @override
  late final GeneratedColumn<int> startingLevel = GeneratedColumn<int>(
    'starting_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endingLevelMeta = const VerificationMeta(
    'endingLevel',
  );
  @override
  late final GeneratedColumn<int> endingLevel = GeneratedColumn<int>(
    'ending_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _environmentTierMeta = const VerificationMeta(
    'environmentTier',
  );
  @override
  late final GeneratedColumn<int> environmentTier = GeneratedColumn<int>(
    'environment_tier',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    sessionNum,
    startedAt,
    endedAt,
    startingLevel,
    endingLevel,
    environmentTier,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    }
    if (data.containsKey('session_num')) {
      context.handle(
        _sessionNumMeta,
        sessionNum.isAcceptableOrUnknown(data['session_num']!, _sessionNumMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionNumMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('starting_level')) {
      context.handle(
        _startingLevelMeta,
        startingLevel.isAcceptableOrUnknown(
          data['starting_level']!,
          _startingLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startingLevelMeta);
    }
    if (data.containsKey('ending_level')) {
      context.handle(
        _endingLevelMeta,
        endingLevel.isAcceptableOrUnknown(
          data['ending_level']!,
          _endingLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_endingLevelMeta);
    }
    if (data.containsKey('environment_tier')) {
      context.handle(
        _environmentTierMeta,
        environmentTier.isAcceptableOrUnknown(
          data['environment_tier']!,
          _environmentTierMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_environmentTierMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      sessionNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_num'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      startingLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}starting_level'],
      )!,
      endingLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ending_level'],
      )!,
      environmentTier: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}environment_tier'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class SessionTable extends DataClass implements Insertable<SessionTable> {
  final int id;
  final String gameId;
  final int sessionNum;
  final DateTime startedAt;
  final DateTime endedAt;
  final int startingLevel;
  final int endingLevel;
  final int environmentTier;
  const SessionTable({
    required this.id,
    required this.gameId,
    required this.sessionNum,
    required this.startedAt,
    required this.endedAt,
    required this.startingLevel,
    required this.endingLevel,
    required this.environmentTier,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<String>(gameId);
    map['session_num'] = Variable<int>(sessionNum);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['starting_level'] = Variable<int>(startingLevel);
    map['ending_level'] = Variable<int>(endingLevel);
    map['environment_tier'] = Variable<int>(environmentTier);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      sessionNum: Value(sessionNum),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      startingLevel: Value(startingLevel),
      endingLevel: Value(endingLevel),
      environmentTier: Value(environmentTier),
    );
  }

  factory SessionTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionTable(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      sessionNum: serializer.fromJson<int>(json['sessionNum']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      startingLevel: serializer.fromJson<int>(json['startingLevel']),
      endingLevel: serializer.fromJson<int>(json['endingLevel']),
      environmentTier: serializer.fromJson<int>(json['environmentTier']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<String>(gameId),
      'sessionNum': serializer.toJson<int>(sessionNum),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'startingLevel': serializer.toJson<int>(startingLevel),
      'endingLevel': serializer.toJson<int>(endingLevel),
      'environmentTier': serializer.toJson<int>(environmentTier),
    };
  }

  SessionTable copyWith({
    int? id,
    String? gameId,
    int? sessionNum,
    DateTime? startedAt,
    DateTime? endedAt,
    int? startingLevel,
    int? endingLevel,
    int? environmentTier,
  }) => SessionTable(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    sessionNum: sessionNum ?? this.sessionNum,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    startingLevel: startingLevel ?? this.startingLevel,
    endingLevel: endingLevel ?? this.endingLevel,
    environmentTier: environmentTier ?? this.environmentTier,
  );
  SessionTable copyWithCompanion(SessionsCompanion data) {
    return SessionTable(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      sessionNum: data.sessionNum.present
          ? data.sessionNum.value
          : this.sessionNum,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      startingLevel: data.startingLevel.present
          ? data.startingLevel.value
          : this.startingLevel,
      endingLevel: data.endingLevel.present
          ? data.endingLevel.value
          : this.endingLevel,
      environmentTier: data.environmentTier.present
          ? data.environmentTier.value
          : this.environmentTier,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionTable(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('sessionNum: $sessionNum, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('startingLevel: $startingLevel, ')
          ..write('endingLevel: $endingLevel, ')
          ..write('environmentTier: $environmentTier')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameId,
    sessionNum,
    startedAt,
    endedAt,
    startingLevel,
    endingLevel,
    environmentTier,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionTable &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.sessionNum == this.sessionNum &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.startingLevel == this.startingLevel &&
          other.endingLevel == this.endingLevel &&
          other.environmentTier == this.environmentTier);
}

class SessionsCompanion extends UpdateCompanion<SessionTable> {
  final Value<int> id;
  final Value<String> gameId;
  final Value<int> sessionNum;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> startingLevel;
  final Value<int> endingLevel;
  final Value<int> environmentTier;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.sessionNum = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.startingLevel = const Value.absent(),
    this.endingLevel = const Value.absent(),
    this.environmentTier = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    required int sessionNum,
    required DateTime startedAt,
    required DateTime endedAt,
    required int startingLevel,
    required int endingLevel,
    required int environmentTier,
  }) : sessionNum = Value(sessionNum),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       startingLevel = Value(startingLevel),
       endingLevel = Value(endingLevel),
       environmentTier = Value(environmentTier);
  static Insertable<SessionTable> custom({
    Expression<int>? id,
    Expression<String>? gameId,
    Expression<int>? sessionNum,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? startingLevel,
    Expression<int>? endingLevel,
    Expression<int>? environmentTier,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (sessionNum != null) 'session_num': sessionNum,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (startingLevel != null) 'starting_level': startingLevel,
      if (endingLevel != null) 'ending_level': endingLevel,
      if (environmentTier != null) 'environment_tier': environmentTier,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? gameId,
    Value<int>? sessionNum,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? startingLevel,
    Value<int>? endingLevel,
    Value<int>? environmentTier,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      sessionNum: sessionNum ?? this.sessionNum,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      startingLevel: startingLevel ?? this.startingLevel,
      endingLevel: endingLevel ?? this.endingLevel,
      environmentTier: environmentTier ?? this.environmentTier,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (sessionNum.present) {
      map['session_num'] = Variable<int>(sessionNum.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (startingLevel.present) {
      map['starting_level'] = Variable<int>(startingLevel.value);
    }
    if (endingLevel.present) {
      map['ending_level'] = Variable<int>(endingLevel.value);
    }
    if (environmentTier.present) {
      map['environment_tier'] = Variable<int>(environmentTier.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('sessionNum: $sessionNum, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('startingLevel: $startingLevel, ')
          ..write('endingLevel: $endingLevel, ')
          ..write('environmentTier: $environmentTier')
          ..write(')'))
        .toString();
  }
}

class $TrialsTable extends Trials with TableInfo<$TrialsTable, TrialTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrialsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _trialNumMeta = const VerificationMeta(
    'trialNum',
  );
  @override
  late final GeneratedColumn<int> trialNum = GeneratedColumn<int>(
    'trial_num',
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
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _reactionMsMeta = const VerificationMeta(
    'reactionMs',
  );
  @override
  late final GeneratedColumn<int> reactionMs = GeneratedColumn<int>(
    'reaction_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    trialNum,
    type,
    correct,
    reactionMs,
    difficulty,
    timestamp,
    metadata,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trials';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrialTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('trial_num')) {
      context.handle(
        _trialNumMeta,
        trialNum.isAcceptableOrUnknown(data['trial_num']!, _trialNumMeta),
      );
    } else if (isInserting) {
      context.missing(_trialNumMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('reaction_ms')) {
      context.handle(
        _reactionMsMeta,
        reactionMs.isAcceptableOrUnknown(data['reaction_ms']!, _reactionMsMeta),
      );
    } else if (isInserting) {
      context.missing(_reactionMsMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrialTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrialTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      trialNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trial_num'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correct'],
      )!,
      reactionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reaction_ms'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
    );
  }

  @override
  $TrialsTable createAlias(String alias) {
    return $TrialsTable(attachedDatabase, alias);
  }
}

class TrialTable extends DataClass implements Insertable<TrialTable> {
  final int id;
  final int sessionId;
  final int trialNum;
  final String type;
  final bool correct;
  final int reactionMs;
  final int difficulty;
  final DateTime timestamp;
  final String? metadata;
  const TrialTable({
    required this.id,
    required this.sessionId,
    required this.trialNum,
    required this.type,
    required this.correct,
    required this.reactionMs,
    required this.difficulty,
    required this.timestamp,
    this.metadata,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['trial_num'] = Variable<int>(trialNum);
    map['type'] = Variable<String>(type);
    map['correct'] = Variable<bool>(correct);
    map['reaction_ms'] = Variable<int>(reactionMs);
    map['difficulty'] = Variable<int>(difficulty);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    return map;
  }

  TrialsCompanion toCompanion(bool nullToAbsent) {
    return TrialsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      trialNum: Value(trialNum),
      type: Value(type),
      correct: Value(correct),
      reactionMs: Value(reactionMs),
      difficulty: Value(difficulty),
      timestamp: Value(timestamp),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory TrialTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrialTable(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      trialNum: serializer.fromJson<int>(json['trialNum']),
      type: serializer.fromJson<String>(json['type']),
      correct: serializer.fromJson<bool>(json['correct']),
      reactionMs: serializer.fromJson<int>(json['reactionMs']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      metadata: serializer.fromJson<String?>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'trialNum': serializer.toJson<int>(trialNum),
      'type': serializer.toJson<String>(type),
      'correct': serializer.toJson<bool>(correct),
      'reactionMs': serializer.toJson<int>(reactionMs),
      'difficulty': serializer.toJson<int>(difficulty),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'metadata': serializer.toJson<String?>(metadata),
    };
  }

  TrialTable copyWith({
    int? id,
    int? sessionId,
    int? trialNum,
    String? type,
    bool? correct,
    int? reactionMs,
    int? difficulty,
    DateTime? timestamp,
    Value<String?> metadata = const Value.absent(),
  }) => TrialTable(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    trialNum: trialNum ?? this.trialNum,
    type: type ?? this.type,
    correct: correct ?? this.correct,
    reactionMs: reactionMs ?? this.reactionMs,
    difficulty: difficulty ?? this.difficulty,
    timestamp: timestamp ?? this.timestamp,
    metadata: metadata.present ? metadata.value : this.metadata,
  );
  TrialTable copyWithCompanion(TrialsCompanion data) {
    return TrialTable(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      trialNum: data.trialNum.present ? data.trialNum.value : this.trialNum,
      type: data.type.present ? data.type.value : this.type,
      correct: data.correct.present ? data.correct.value : this.correct,
      reactionMs: data.reactionMs.present
          ? data.reactionMs.value
          : this.reactionMs,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrialTable(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('trialNum: $trialNum, ')
          ..write('type: $type, ')
          ..write('correct: $correct, ')
          ..write('reactionMs: $reactionMs, ')
          ..write('difficulty: $difficulty, ')
          ..write('timestamp: $timestamp, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    trialNum,
    type,
    correct,
    reactionMs,
    difficulty,
    timestamp,
    metadata,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrialTable &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.trialNum == this.trialNum &&
          other.type == this.type &&
          other.correct == this.correct &&
          other.reactionMs == this.reactionMs &&
          other.difficulty == this.difficulty &&
          other.timestamp == this.timestamp &&
          other.metadata == this.metadata);
}

class TrialsCompanion extends UpdateCompanion<TrialTable> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> trialNum;
  final Value<String> type;
  final Value<bool> correct;
  final Value<int> reactionMs;
  final Value<int> difficulty;
  final Value<DateTime> timestamp;
  final Value<String?> metadata;
  const TrialsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.trialNum = const Value.absent(),
    this.type = const Value.absent(),
    this.correct = const Value.absent(),
    this.reactionMs = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.metadata = const Value.absent(),
  });
  TrialsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int trialNum,
    required String type,
    required bool correct,
    required int reactionMs,
    required int difficulty,
    required DateTime timestamp,
    this.metadata = const Value.absent(),
  }) : sessionId = Value(sessionId),
       trialNum = Value(trialNum),
       type = Value(type),
       correct = Value(correct),
       reactionMs = Value(reactionMs),
       difficulty = Value(difficulty),
       timestamp = Value(timestamp);
  static Insertable<TrialTable> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? trialNum,
    Expression<String>? type,
    Expression<bool>? correct,
    Expression<int>? reactionMs,
    Expression<int>? difficulty,
    Expression<DateTime>? timestamp,
    Expression<String>? metadata,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (trialNum != null) 'trial_num': trialNum,
      if (type != null) 'type': type,
      if (correct != null) 'correct': correct,
      if (reactionMs != null) 'reaction_ms': reactionMs,
      if (difficulty != null) 'difficulty': difficulty,
      if (timestamp != null) 'timestamp': timestamp,
      if (metadata != null) 'metadata': metadata,
    });
  }

  TrialsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? trialNum,
    Value<String>? type,
    Value<bool>? correct,
    Value<int>? reactionMs,
    Value<int>? difficulty,
    Value<DateTime>? timestamp,
    Value<String?>? metadata,
  }) {
    return TrialsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      trialNum: trialNum ?? this.trialNum,
      type: type ?? this.type,
      correct: correct ?? this.correct,
      reactionMs: reactionMs ?? this.reactionMs,
      difficulty: difficulty ?? this.difficulty,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (trialNum.present) {
      map['trial_num'] = Variable<int>(trialNum.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (reactionMs.present) {
      map['reaction_ms'] = Variable<int>(reactionMs.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrialsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('trialNum: $trialNum, ')
          ..write('type: $type, ')
          ..write('correct: $correct, ')
          ..write('reactionMs: $reactionMs, ')
          ..write('difficulty: $difficulty, ')
          ..write('timestamp: $timestamp, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }
}

class $DifficultyStatesTable extends DifficultyStates
    with TableInfo<$DifficultyStatesTable, DifficultyTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DifficultyStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentLevelMeta = const VerificationMeta(
    'currentLevel',
  );
  @override
  late final GeneratedColumn<int> currentLevel = GeneratedColumn<int>(
    'current_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [gameId, currentLevel, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'difficulty_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<DifficultyTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('current_level')) {
      context.handle(
        _currentLevelMeta,
        currentLevel.isAcceptableOrUnknown(
          data['current_level']!,
          _currentLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentLevelMeta);
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
  Set<GeneratedColumn> get $primaryKey => {gameId};
  @override
  DifficultyTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DifficultyTable(
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      currentLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_level'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DifficultyStatesTable createAlias(String alias) {
    return $DifficultyStatesTable(attachedDatabase, alias);
  }
}

class DifficultyTable extends DataClass implements Insertable<DifficultyTable> {
  final String gameId;
  final int currentLevel;
  final DateTime updatedAt;
  const DifficultyTable({
    required this.gameId,
    required this.currentLevel,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game_id'] = Variable<String>(gameId);
    map['current_level'] = Variable<int>(currentLevel);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DifficultyStatesCompanion toCompanion(bool nullToAbsent) {
    return DifficultyStatesCompanion(
      gameId: Value(gameId),
      currentLevel: Value(currentLevel),
      updatedAt: Value(updatedAt),
    );
  }

  factory DifficultyTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DifficultyTable(
      gameId: serializer.fromJson<String>(json['gameId']),
      currentLevel: serializer.fromJson<int>(json['currentLevel']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gameId': serializer.toJson<String>(gameId),
      'currentLevel': serializer.toJson<int>(currentLevel),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DifficultyTable copyWith({
    String? gameId,
    int? currentLevel,
    DateTime? updatedAt,
  }) => DifficultyTable(
    gameId: gameId ?? this.gameId,
    currentLevel: currentLevel ?? this.currentLevel,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DifficultyTable copyWithCompanion(DifficultyStatesCompanion data) {
    return DifficultyTable(
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      currentLevel: data.currentLevel.present
          ? data.currentLevel.value
          : this.currentLevel,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DifficultyTable(')
          ..write('gameId: $gameId, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gameId, currentLevel, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DifficultyTable &&
          other.gameId == this.gameId &&
          other.currentLevel == this.currentLevel &&
          other.updatedAt == this.updatedAt);
}

class DifficultyStatesCompanion extends UpdateCompanion<DifficultyTable> {
  final Value<String> gameId;
  final Value<int> currentLevel;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DifficultyStatesCompanion({
    this.gameId = const Value.absent(),
    this.currentLevel = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DifficultyStatesCompanion.insert({
    required String gameId,
    required int currentLevel,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : gameId = Value(gameId),
       currentLevel = Value(currentLevel),
       updatedAt = Value(updatedAt);
  static Insertable<DifficultyTable> custom({
    Expression<String>? gameId,
    Expression<int>? currentLevel,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gameId != null) 'game_id': gameId,
      if (currentLevel != null) 'current_level': currentLevel,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DifficultyStatesCompanion copyWith({
    Value<String>? gameId,
    Value<int>? currentLevel,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DifficultyStatesCompanion(
      gameId: gameId ?? this.gameId,
      currentLevel: currentLevel ?? this.currentLevel,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (currentLevel.present) {
      map['current_level'] = Variable<int>(currentLevel.value);
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
    return (StringBuffer('DifficultyStatesCompanion(')
          ..write('gameId: $gameId, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpatialSpanProgressTableTable extends SpatialSpanProgressTable
    with TableInfo<$SpatialSpanProgressTableTable, SpatialSpanProgress> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpatialSpanProgressTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<int> trackId = GeneratedColumn<int>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxSpanReachedMeta = const VerificationMeta(
    'maxSpanReached',
  );
  @override
  late final GeneratedColumn<int> maxSpanReached = GeneratedColumn<int>(
    'max_span_reached',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _lastPlayedAtMeta = const VerificationMeta(
    'lastPlayedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPlayedAt = GeneratedColumn<DateTime>(
    'last_played_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackId,
    maxSpanReached,
    lastPlayedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spatial_span_progress_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpatialSpanProgress> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('max_span_reached')) {
      context.handle(
        _maxSpanReachedMeta,
        maxSpanReached.isAcceptableOrUnknown(
          data['max_span_reached']!,
          _maxSpanReachedMeta,
        ),
      );
    }
    if (data.containsKey('last_played_at')) {
      context.handle(
        _lastPlayedAtMeta,
        lastPlayedAt.isAcceptableOrUnknown(
          data['last_played_at']!,
          _lastPlayedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpatialSpanProgress map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpatialSpanProgress(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_id'],
      )!,
      maxSpanReached: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_span_reached'],
      )!,
      lastPlayedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_played_at'],
      ),
    );
  }

  @override
  $SpatialSpanProgressTableTable createAlias(String alias) {
    return $SpatialSpanProgressTableTable(attachedDatabase, alias);
  }
}

class SpatialSpanProgress extends DataClass
    implements Insertable<SpatialSpanProgress> {
  final int id;
  final int trackId;
  final int maxSpanReached;
  final DateTime? lastPlayedAt;
  const SpatialSpanProgress({
    required this.id,
    required this.trackId,
    required this.maxSpanReached,
    this.lastPlayedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['track_id'] = Variable<int>(trackId);
    map['max_span_reached'] = Variable<int>(maxSpanReached);
    if (!nullToAbsent || lastPlayedAt != null) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt);
    }
    return map;
  }

  SpatialSpanProgressTableCompanion toCompanion(bool nullToAbsent) {
    return SpatialSpanProgressTableCompanion(
      id: Value(id),
      trackId: Value(trackId),
      maxSpanReached: Value(maxSpanReached),
      lastPlayedAt: lastPlayedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayedAt),
    );
  }

  factory SpatialSpanProgress.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpatialSpanProgress(
      id: serializer.fromJson<int>(json['id']),
      trackId: serializer.fromJson<int>(json['trackId']),
      maxSpanReached: serializer.fromJson<int>(json['maxSpanReached']),
      lastPlayedAt: serializer.fromJson<DateTime?>(json['lastPlayedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackId': serializer.toJson<int>(trackId),
      'maxSpanReached': serializer.toJson<int>(maxSpanReached),
      'lastPlayedAt': serializer.toJson<DateTime?>(lastPlayedAt),
    };
  }

  SpatialSpanProgress copyWith({
    int? id,
    int? trackId,
    int? maxSpanReached,
    Value<DateTime?> lastPlayedAt = const Value.absent(),
  }) => SpatialSpanProgress(
    id: id ?? this.id,
    trackId: trackId ?? this.trackId,
    maxSpanReached: maxSpanReached ?? this.maxSpanReached,
    lastPlayedAt: lastPlayedAt.present ? lastPlayedAt.value : this.lastPlayedAt,
  );
  SpatialSpanProgress copyWithCompanion(
    SpatialSpanProgressTableCompanion data,
  ) {
    return SpatialSpanProgress(
      id: data.id.present ? data.id.value : this.id,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      maxSpanReached: data.maxSpanReached.present
          ? data.maxSpanReached.value
          : this.maxSpanReached,
      lastPlayedAt: data.lastPlayedAt.present
          ? data.lastPlayedAt.value
          : this.lastPlayedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpatialSpanProgress(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('maxSpanReached: $maxSpanReached, ')
          ..write('lastPlayedAt: $lastPlayedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackId, maxSpanReached, lastPlayedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpatialSpanProgress &&
          other.id == this.id &&
          other.trackId == this.trackId &&
          other.maxSpanReached == this.maxSpanReached &&
          other.lastPlayedAt == this.lastPlayedAt);
}

class SpatialSpanProgressTableCompanion
    extends UpdateCompanion<SpatialSpanProgress> {
  final Value<int> id;
  final Value<int> trackId;
  final Value<int> maxSpanReached;
  final Value<DateTime?> lastPlayedAt;
  const SpatialSpanProgressTableCompanion({
    this.id = const Value.absent(),
    this.trackId = const Value.absent(),
    this.maxSpanReached = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
  });
  SpatialSpanProgressTableCompanion.insert({
    this.id = const Value.absent(),
    required int trackId,
    this.maxSpanReached = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
  }) : trackId = Value(trackId);
  static Insertable<SpatialSpanProgress> custom({
    Expression<int>? id,
    Expression<int>? trackId,
    Expression<int>? maxSpanReached,
    Expression<DateTime>? lastPlayedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackId != null) 'track_id': trackId,
      if (maxSpanReached != null) 'max_span_reached': maxSpanReached,
      if (lastPlayedAt != null) 'last_played_at': lastPlayedAt,
    });
  }

  SpatialSpanProgressTableCompanion copyWith({
    Value<int>? id,
    Value<int>? trackId,
    Value<int>? maxSpanReached,
    Value<DateTime?>? lastPlayedAt,
  }) {
    return SpatialSpanProgressTableCompanion(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      maxSpanReached: maxSpanReached ?? this.maxSpanReached,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<int>(trackId.value);
    }
    if (maxSpanReached.present) {
      map['max_span_reached'] = Variable<int>(maxSpanReached.value);
    }
    if (lastPlayedAt.present) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpatialSpanProgressTableCompanion(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('maxSpanReached: $maxSpanReached, ')
          ..write('lastPlayedAt: $lastPlayedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$HebboDatabase extends GeneratedDatabase {
  _$HebboDatabase(QueryExecutor e) : super(e);
  $HebboDatabaseManager get managers => $HebboDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $TrialsTable trials = $TrialsTable(this);
  late final $DifficultyStatesTable difficultyStates = $DifficultyStatesTable(
    this,
  );
  late final $SpatialSpanProgressTableTable spatialSpanProgressTable =
      $SpatialSpanProgressTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sessions,
    trials,
    difficultyStates,
    spatialSpanProgressTable,
  ];
}

typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<String> gameId,
      required int sessionNum,
      required DateTime startedAt,
      required DateTime endedAt,
      required int startingLevel,
      required int endingLevel,
      required int environmentTier,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<String> gameId,
      Value<int> sessionNum,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> startingLevel,
      Value<int> endingLevel,
      Value<int> environmentTier,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$HebboDatabase, $SessionsTable, SessionTable> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TrialsTable, List<TrialTable>> _trialsRefsTable(
    _$HebboDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.trials,
    aliasName: $_aliasNameGenerator(db.sessions.id, db.trials.sessionId),
  );

  $$TrialsTableProcessedTableManager get trialsRefs {
    final manager = $$TrialsTableTableManager(
      $_db,
      $_db.trials,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_trialsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$HebboDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
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

  ColumnFilters<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionNum => $composableBuilder(
    column: $table.sessionNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startingLevel => $composableBuilder(
    column: $table.startingLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endingLevel => $composableBuilder(
    column: $table.endingLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get environmentTier => $composableBuilder(
    column: $table.environmentTier,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> trialsRefs(
    Expression<bool> Function($$TrialsTableFilterComposer f) f,
  ) {
    final $$TrialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trials,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrialsTableFilterComposer(
            $db: $db,
            $table: $db.trials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$HebboDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
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

  ColumnOrderings<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionNum => $composableBuilder(
    column: $table.sessionNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startingLevel => $composableBuilder(
    column: $table.startingLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endingLevel => $composableBuilder(
    column: $table.endingLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get environmentTier => $composableBuilder(
    column: $table.environmentTier,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$HebboDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<int> get sessionNum => $composableBuilder(
    column: $table.sessionNum,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get startingLevel => $composableBuilder(
    column: $table.startingLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endingLevel => $composableBuilder(
    column: $table.endingLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get environmentTier => $composableBuilder(
    column: $table.environmentTier,
    builder: (column) => column,
  );

  Expression<T> trialsRefs<T extends Object>(
    Expression<T> Function($$TrialsTableAnnotationComposer a) f,
  ) {
    final $$TrialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trials,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrialsTableAnnotationComposer(
            $db: $db,
            $table: $db.trials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$HebboDatabase,
          $SessionsTable,
          SessionTable,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (SessionTable, $$SessionsTableReferences),
          SessionTable,
          PrefetchHooks Function({bool trialsRefs})
        > {
  $$SessionsTableTableManager(_$HebboDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<int> sessionNum = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> startingLevel = const Value.absent(),
                Value<int> endingLevel = const Value.absent(),
                Value<int> environmentTier = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                gameId: gameId,
                sessionNum: sessionNum,
                startedAt: startedAt,
                endedAt: endedAt,
                startingLevel: startingLevel,
                endingLevel: endingLevel,
                environmentTier: environmentTier,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                required int sessionNum,
                required DateTime startedAt,
                required DateTime endedAt,
                required int startingLevel,
                required int endingLevel,
                required int environmentTier,
              }) => SessionsCompanion.insert(
                id: id,
                gameId: gameId,
                sessionNum: sessionNum,
                startedAt: startedAt,
                endedAt: endedAt,
                startingLevel: startingLevel,
                endingLevel: endingLevel,
                environmentTier: environmentTier,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trialsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (trialsRefs) db.trials],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (trialsRefs)
                    await $_getPrefetchedData<
                      SessionTable,
                      $SessionsTable,
                      TrialTable
                    >(
                      currentTable: table,
                      referencedTable: $$SessionsTableReferences
                          ._trialsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SessionsTableReferences(db, table, p0).trialsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$HebboDatabase,
      $SessionsTable,
      SessionTable,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (SessionTable, $$SessionsTableReferences),
      SessionTable,
      PrefetchHooks Function({bool trialsRefs})
    >;
typedef $$TrialsTableCreateCompanionBuilder =
    TrialsCompanion Function({
      Value<int> id,
      required int sessionId,
      required int trialNum,
      required String type,
      required bool correct,
      required int reactionMs,
      required int difficulty,
      required DateTime timestamp,
      Value<String?> metadata,
    });
typedef $$TrialsTableUpdateCompanionBuilder =
    TrialsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> trialNum,
      Value<String> type,
      Value<bool> correct,
      Value<int> reactionMs,
      Value<int> difficulty,
      Value<DateTime> timestamp,
      Value<String?> metadata,
    });

final class $$TrialsTableReferences
    extends BaseReferences<_$HebboDatabase, $TrialsTable, TrialTable> {
  $$TrialsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$HebboDatabase db) => db.sessions
      .createAlias($_aliasNameGenerator(db.trials.sessionId, db.sessions.id));

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrialsTableFilterComposer
    extends Composer<_$HebboDatabase, $TrialsTable> {
  $$TrialsTableFilterComposer({
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

  ColumnFilters<int> get trialNum => $composableBuilder(
    column: $table.trialNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reactionMs => $composableBuilder(
    column: $table.reactionMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrialsTableOrderingComposer
    extends Composer<_$HebboDatabase, $TrialsTable> {
  $$TrialsTableOrderingComposer({
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

  ColumnOrderings<int> get trialNum => $composableBuilder(
    column: $table.trialNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reactionMs => $composableBuilder(
    column: $table.reactionMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrialsTableAnnotationComposer
    extends Composer<_$HebboDatabase, $TrialsTable> {
  $$TrialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get trialNum =>
      $composableBuilder(column: $table.trialNum, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get reactionMs => $composableBuilder(
    column: $table.reactionMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrialsTableTableManager
    extends
        RootTableManager<
          _$HebboDatabase,
          $TrialsTable,
          TrialTable,
          $$TrialsTableFilterComposer,
          $$TrialsTableOrderingComposer,
          $$TrialsTableAnnotationComposer,
          $$TrialsTableCreateCompanionBuilder,
          $$TrialsTableUpdateCompanionBuilder,
          (TrialTable, $$TrialsTableReferences),
          TrialTable,
          PrefetchHooks Function({bool sessionId})
        > {
  $$TrialsTableTableManager(_$HebboDatabase db, $TrialsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> trialNum = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> correct = const Value.absent(),
                Value<int> reactionMs = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
              }) => TrialsCompanion(
                id: id,
                sessionId: sessionId,
                trialNum: trialNum,
                type: type,
                correct: correct,
                reactionMs: reactionMs,
                difficulty: difficulty,
                timestamp: timestamp,
                metadata: metadata,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int trialNum,
                required String type,
                required bool correct,
                required int reactionMs,
                required int difficulty,
                required DateTime timestamp,
                Value<String?> metadata = const Value.absent(),
              }) => TrialsCompanion.insert(
                id: id,
                sessionId: sessionId,
                trialNum: trialNum,
                type: type,
                correct: correct,
                reactionMs: reactionMs,
                difficulty: difficulty,
                timestamp: timestamp,
                metadata: metadata,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TrialsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
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
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$TrialsTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$TrialsTableReferences
                                    ._sessionIdTable(db)
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

typedef $$TrialsTableProcessedTableManager =
    ProcessedTableManager<
      _$HebboDatabase,
      $TrialsTable,
      TrialTable,
      $$TrialsTableFilterComposer,
      $$TrialsTableOrderingComposer,
      $$TrialsTableAnnotationComposer,
      $$TrialsTableCreateCompanionBuilder,
      $$TrialsTableUpdateCompanionBuilder,
      (TrialTable, $$TrialsTableReferences),
      TrialTable,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$DifficultyStatesTableCreateCompanionBuilder =
    DifficultyStatesCompanion Function({
      required String gameId,
      required int currentLevel,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DifficultyStatesTableUpdateCompanionBuilder =
    DifficultyStatesCompanion Function({
      Value<String> gameId,
      Value<int> currentLevel,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DifficultyStatesTableFilterComposer
    extends Composer<_$HebboDatabase, $DifficultyStatesTable> {
  $$DifficultyStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentLevel => $composableBuilder(
    column: $table.currentLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DifficultyStatesTableOrderingComposer
    extends Composer<_$HebboDatabase, $DifficultyStatesTable> {
  $$DifficultyStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentLevel => $composableBuilder(
    column: $table.currentLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DifficultyStatesTableAnnotationComposer
    extends Composer<_$HebboDatabase, $DifficultyStatesTable> {
  $$DifficultyStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<int> get currentLevel => $composableBuilder(
    column: $table.currentLevel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DifficultyStatesTableTableManager
    extends
        RootTableManager<
          _$HebboDatabase,
          $DifficultyStatesTable,
          DifficultyTable,
          $$DifficultyStatesTableFilterComposer,
          $$DifficultyStatesTableOrderingComposer,
          $$DifficultyStatesTableAnnotationComposer,
          $$DifficultyStatesTableCreateCompanionBuilder,
          $$DifficultyStatesTableUpdateCompanionBuilder,
          (
            DifficultyTable,
            BaseReferences<
              _$HebboDatabase,
              $DifficultyStatesTable,
              DifficultyTable
            >,
          ),
          DifficultyTable,
          PrefetchHooks Function()
        > {
  $$DifficultyStatesTableTableManager(
    _$HebboDatabase db,
    $DifficultyStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DifficultyStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DifficultyStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DifficultyStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gameId = const Value.absent(),
                Value<int> currentLevel = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DifficultyStatesCompanion(
                gameId: gameId,
                currentLevel: currentLevel,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gameId,
                required int currentLevel,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DifficultyStatesCompanion.insert(
                gameId: gameId,
                currentLevel: currentLevel,
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

typedef $$DifficultyStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$HebboDatabase,
      $DifficultyStatesTable,
      DifficultyTable,
      $$DifficultyStatesTableFilterComposer,
      $$DifficultyStatesTableOrderingComposer,
      $$DifficultyStatesTableAnnotationComposer,
      $$DifficultyStatesTableCreateCompanionBuilder,
      $$DifficultyStatesTableUpdateCompanionBuilder,
      (
        DifficultyTable,
        BaseReferences<
          _$HebboDatabase,
          $DifficultyStatesTable,
          DifficultyTable
        >,
      ),
      DifficultyTable,
      PrefetchHooks Function()
    >;
typedef $$SpatialSpanProgressTableTableCreateCompanionBuilder =
    SpatialSpanProgressTableCompanion Function({
      Value<int> id,
      required int trackId,
      Value<int> maxSpanReached,
      Value<DateTime?> lastPlayedAt,
    });
typedef $$SpatialSpanProgressTableTableUpdateCompanionBuilder =
    SpatialSpanProgressTableCompanion Function({
      Value<int> id,
      Value<int> trackId,
      Value<int> maxSpanReached,
      Value<DateTime?> lastPlayedAt,
    });

class $$SpatialSpanProgressTableTableFilterComposer
    extends Composer<_$HebboDatabase, $SpatialSpanProgressTableTable> {
  $$SpatialSpanProgressTableTableFilterComposer({
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

  ColumnFilters<int> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxSpanReached => $composableBuilder(
    column: $table.maxSpanReached,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SpatialSpanProgressTableTableOrderingComposer
    extends Composer<_$HebboDatabase, $SpatialSpanProgressTableTable> {
  $$SpatialSpanProgressTableTableOrderingComposer({
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

  ColumnOrderings<int> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxSpanReached => $composableBuilder(
    column: $table.maxSpanReached,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpatialSpanProgressTableTableAnnotationComposer
    extends Composer<_$HebboDatabase, $SpatialSpanProgressTableTable> {
  $$SpatialSpanProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => column);

  GeneratedColumn<int> get maxSpanReached => $composableBuilder(
    column: $table.maxSpanReached,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => column,
  );
}

class $$SpatialSpanProgressTableTableTableManager
    extends
        RootTableManager<
          _$HebboDatabase,
          $SpatialSpanProgressTableTable,
          SpatialSpanProgress,
          $$SpatialSpanProgressTableTableFilterComposer,
          $$SpatialSpanProgressTableTableOrderingComposer,
          $$SpatialSpanProgressTableTableAnnotationComposer,
          $$SpatialSpanProgressTableTableCreateCompanionBuilder,
          $$SpatialSpanProgressTableTableUpdateCompanionBuilder,
          (
            SpatialSpanProgress,
            BaseReferences<
              _$HebboDatabase,
              $SpatialSpanProgressTableTable,
              SpatialSpanProgress
            >,
          ),
          SpatialSpanProgress,
          PrefetchHooks Function()
        > {
  $$SpatialSpanProgressTableTableTableManager(
    _$HebboDatabase db,
    $SpatialSpanProgressTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpatialSpanProgressTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SpatialSpanProgressTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SpatialSpanProgressTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> trackId = const Value.absent(),
                Value<int> maxSpanReached = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
              }) => SpatialSpanProgressTableCompanion(
                id: id,
                trackId: trackId,
                maxSpanReached: maxSpanReached,
                lastPlayedAt: lastPlayedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int trackId,
                Value<int> maxSpanReached = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
              }) => SpatialSpanProgressTableCompanion.insert(
                id: id,
                trackId: trackId,
                maxSpanReached: maxSpanReached,
                lastPlayedAt: lastPlayedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SpatialSpanProgressTableTableProcessedTableManager =
    ProcessedTableManager<
      _$HebboDatabase,
      $SpatialSpanProgressTableTable,
      SpatialSpanProgress,
      $$SpatialSpanProgressTableTableFilterComposer,
      $$SpatialSpanProgressTableTableOrderingComposer,
      $$SpatialSpanProgressTableTableAnnotationComposer,
      $$SpatialSpanProgressTableTableCreateCompanionBuilder,
      $$SpatialSpanProgressTableTableUpdateCompanionBuilder,
      (
        SpatialSpanProgress,
        BaseReferences<
          _$HebboDatabase,
          $SpatialSpanProgressTableTable,
          SpatialSpanProgress
        >,
      ),
      SpatialSpanProgress,
      PrefetchHooks Function()
    >;

class $HebboDatabaseManager {
  final _$HebboDatabase _db;
  $HebboDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$TrialsTableTableManager get trials =>
      $$TrialsTableTableManager(_db, _db.trials);
  $$DifficultyStatesTableTableManager get difficultyStates =>
      $$DifficultyStatesTableTableManager(_db, _db.difficultyStates);
  $$SpatialSpanProgressTableTableTableManager get spatialSpanProgressTable =>
      $$SpatialSpanProgressTableTableTableManager(
        _db,
        _db.spatialSpanProgressTable,
      );
}
