// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
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
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relativeDurationMinutesMeta =
      const VerificationMeta('relativeDurationMinutes');
  @override
  late final GeneratedColumn<int> relativeDurationMinutes =
      GeneratedColumn<int>(
        'relative_duration_minutes',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _voicePersonalityMeta = const VerificationMeta(
    'voicePersonality',
  );
  @override
  late final GeneratedColumn<String> voicePersonality = GeneratedColumn<String>(
    'voice_personality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('nova'),
  );
  static const VerificationMeta _ttsVoiceNameMeta = const VerificationMeta(
    'ttsVoiceName',
  );
  @override
  late final GeneratedColumn<String> ttsVoiceName = GeneratedColumn<String>(
    'tts_voice_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speechRateMeta = const VerificationMeta(
    'speechRate',
  );
  @override
  late final GeneratedColumn<double> speechRate = GeneratedColumn<double>(
    'speech_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.5),
  );
  static const VerificationMeta _speechPitchMeta = const VerificationMeta(
    'speechPitch',
  );
  @override
  late final GeneratedColumn<double> speechPitch = GeneratedColumn<double>(
    'speech_pitch',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _repeatFrequencyMeta = const VerificationMeta(
    'repeatFrequency',
  );
  @override
  late final GeneratedColumn<String> repeatFrequency = GeneratedColumn<String>(
    'repeat_frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _customSpokenMessageMeta =
      const VerificationMeta('customSpokenMessage');
  @override
  late final GeneratedColumn<String> customSpokenMessage =
      GeneratedColumn<String>(
        'custom_spoken_message',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isSpokenEnabledMeta = const VerificationMeta(
    'isSpokenEnabled',
  );
  @override
  late final GeneratedColumn<bool> isSpokenEnabled = GeneratedColumn<bool>(
    'is_spoken_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_spoken_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    id,
    title,
    description,
    scheduledAt,
    relativeDurationMinutes,
    voicePersonality,
    ttsVoiceName,
    speechRate,
    speechPitch,
    repeatFrequency,
    customSpokenMessage,
    isEnabled,
    isSpokenEnabled,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('relative_duration_minutes')) {
      context.handle(
        _relativeDurationMinutesMeta,
        relativeDurationMinutes.isAcceptableOrUnknown(
          data['relative_duration_minutes']!,
          _relativeDurationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('voice_personality')) {
      context.handle(
        _voicePersonalityMeta,
        voicePersonality.isAcceptableOrUnknown(
          data['voice_personality']!,
          _voicePersonalityMeta,
        ),
      );
    }
    if (data.containsKey('tts_voice_name')) {
      context.handle(
        _ttsVoiceNameMeta,
        ttsVoiceName.isAcceptableOrUnknown(
          data['tts_voice_name']!,
          _ttsVoiceNameMeta,
        ),
      );
    }
    if (data.containsKey('speech_rate')) {
      context.handle(
        _speechRateMeta,
        speechRate.isAcceptableOrUnknown(data['speech_rate']!, _speechRateMeta),
      );
    }
    if (data.containsKey('speech_pitch')) {
      context.handle(
        _speechPitchMeta,
        speechPitch.isAcceptableOrUnknown(
          data['speech_pitch']!,
          _speechPitchMeta,
        ),
      );
    }
    if (data.containsKey('repeat_frequency')) {
      context.handle(
        _repeatFrequencyMeta,
        repeatFrequency.isAcceptableOrUnknown(
          data['repeat_frequency']!,
          _repeatFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('custom_spoken_message')) {
      context.handle(
        _customSpokenMessageMeta,
        customSpokenMessage.isAcceptableOrUnknown(
          data['custom_spoken_message']!,
          _customSpokenMessageMeta,
        ),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('is_spoken_enabled')) {
      context.handle(
        _isSpokenEnabledMeta,
        isSpokenEnabled.isAcceptableOrUnknown(
          data['is_spoken_enabled']!,
          _isSpokenEnabledMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      relativeDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}relative_duration_minutes'],
      ),
      voicePersonality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voice_personality'],
      )!,
      ttsVoiceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tts_voice_name'],
      ),
      speechRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speech_rate'],
      )!,
      speechPitch: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speech_pitch'],
      )!,
      repeatFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_frequency'],
      )!,
      customSpokenMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_spoken_message'],
      ),
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      isSpokenEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_spoken_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final String title;
  final String? description;
  final DateTime scheduledAt;
  final int? relativeDurationMinutes;
  final String voicePersonality;
  final String? ttsVoiceName;
  final double speechRate;
  final double speechPitch;
  final String repeatFrequency;
  final String? customSpokenMessage;
  final bool isEnabled;
  final bool isSpokenEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Reminder({
    required this.id,
    required this.title,
    this.description,
    required this.scheduledAt,
    this.relativeDurationMinutes,
    required this.voicePersonality,
    this.ttsVoiceName,
    required this.speechRate,
    required this.speechPitch,
    required this.repeatFrequency,
    this.customSpokenMessage,
    required this.isEnabled,
    required this.isSpokenEnabled,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || relativeDurationMinutes != null) {
      map['relative_duration_minutes'] = Variable<int>(relativeDurationMinutes);
    }
    map['voice_personality'] = Variable<String>(voicePersonality);
    if (!nullToAbsent || ttsVoiceName != null) {
      map['tts_voice_name'] = Variable<String>(ttsVoiceName);
    }
    map['speech_rate'] = Variable<double>(speechRate);
    map['speech_pitch'] = Variable<double>(speechPitch);
    map['repeat_frequency'] = Variable<String>(repeatFrequency);
    if (!nullToAbsent || customSpokenMessage != null) {
      map['custom_spoken_message'] = Variable<String>(customSpokenMessage);
    }
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['is_spoken_enabled'] = Variable<bool>(isSpokenEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      scheduledAt: Value(scheduledAt),
      relativeDurationMinutes: relativeDurationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(relativeDurationMinutes),
      voicePersonality: Value(voicePersonality),
      ttsVoiceName: ttsVoiceName == null && nullToAbsent
          ? const Value.absent()
          : Value(ttsVoiceName),
      speechRate: Value(speechRate),
      speechPitch: Value(speechPitch),
      repeatFrequency: Value(repeatFrequency),
      customSpokenMessage: customSpokenMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(customSpokenMessage),
      isEnabled: Value(isEnabled),
      isSpokenEnabled: Value(isSpokenEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      relativeDurationMinutes: serializer.fromJson<int?>(
        json['relativeDurationMinutes'],
      ),
      voicePersonality: serializer.fromJson<String>(json['voicePersonality']),
      ttsVoiceName: serializer.fromJson<String?>(json['ttsVoiceName']),
      speechRate: serializer.fromJson<double>(json['speechRate']),
      speechPitch: serializer.fromJson<double>(json['speechPitch']),
      repeatFrequency: serializer.fromJson<String>(json['repeatFrequency']),
      customSpokenMessage: serializer.fromJson<String?>(
        json['customSpokenMessage'],
      ),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      isSpokenEnabled: serializer.fromJson<bool>(json['isSpokenEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'relativeDurationMinutes': serializer.toJson<int?>(
        relativeDurationMinutes,
      ),
      'voicePersonality': serializer.toJson<String>(voicePersonality),
      'ttsVoiceName': serializer.toJson<String?>(ttsVoiceName),
      'speechRate': serializer.toJson<double>(speechRate),
      'speechPitch': serializer.toJson<double>(speechPitch),
      'repeatFrequency': serializer.toJson<String>(repeatFrequency),
      'customSpokenMessage': serializer.toJson<String?>(customSpokenMessage),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'isSpokenEnabled': serializer.toJson<bool>(isSpokenEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Reminder copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    DateTime? scheduledAt,
    Value<int?> relativeDurationMinutes = const Value.absent(),
    String? voicePersonality,
    Value<String?> ttsVoiceName = const Value.absent(),
    double? speechRate,
    double? speechPitch,
    String? repeatFrequency,
    Value<String?> customSpokenMessage = const Value.absent(),
    bool? isEnabled,
    bool? isSpokenEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Reminder(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    relativeDurationMinutes: relativeDurationMinutes.present
        ? relativeDurationMinutes.value
        : this.relativeDurationMinutes,
    voicePersonality: voicePersonality ?? this.voicePersonality,
    ttsVoiceName: ttsVoiceName.present ? ttsVoiceName.value : this.ttsVoiceName,
    speechRate: speechRate ?? this.speechRate,
    speechPitch: speechPitch ?? this.speechPitch,
    repeatFrequency: repeatFrequency ?? this.repeatFrequency,
    customSpokenMessage: customSpokenMessage.present
        ? customSpokenMessage.value
        : this.customSpokenMessage,
    isEnabled: isEnabled ?? this.isEnabled,
    isSpokenEnabled: isSpokenEnabled ?? this.isSpokenEnabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      relativeDurationMinutes: data.relativeDurationMinutes.present
          ? data.relativeDurationMinutes.value
          : this.relativeDurationMinutes,
      voicePersonality: data.voicePersonality.present
          ? data.voicePersonality.value
          : this.voicePersonality,
      ttsVoiceName: data.ttsVoiceName.present
          ? data.ttsVoiceName.value
          : this.ttsVoiceName,
      speechRate: data.speechRate.present
          ? data.speechRate.value
          : this.speechRate,
      speechPitch: data.speechPitch.present
          ? data.speechPitch.value
          : this.speechPitch,
      repeatFrequency: data.repeatFrequency.present
          ? data.repeatFrequency.value
          : this.repeatFrequency,
      customSpokenMessage: data.customSpokenMessage.present
          ? data.customSpokenMessage.value
          : this.customSpokenMessage,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      isSpokenEnabled: data.isSpokenEnabled.present
          ? data.isSpokenEnabled.value
          : this.isSpokenEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('relativeDurationMinutes: $relativeDurationMinutes, ')
          ..write('voicePersonality: $voicePersonality, ')
          ..write('ttsVoiceName: $ttsVoiceName, ')
          ..write('speechRate: $speechRate, ')
          ..write('speechPitch: $speechPitch, ')
          ..write('repeatFrequency: $repeatFrequency, ')
          ..write('customSpokenMessage: $customSpokenMessage, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isSpokenEnabled: $isSpokenEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    scheduledAt,
    relativeDurationMinutes,
    voicePersonality,
    ttsVoiceName,
    speechRate,
    speechPitch,
    repeatFrequency,
    customSpokenMessage,
    isEnabled,
    isSpokenEnabled,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.scheduledAt == this.scheduledAt &&
          other.relativeDurationMinutes == this.relativeDurationMinutes &&
          other.voicePersonality == this.voicePersonality &&
          other.ttsVoiceName == this.ttsVoiceName &&
          other.speechRate == this.speechRate &&
          other.speechPitch == this.speechPitch &&
          other.repeatFrequency == this.repeatFrequency &&
          other.customSpokenMessage == this.customSpokenMessage &&
          other.isEnabled == this.isEnabled &&
          other.isSpokenEnabled == this.isSpokenEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> scheduledAt;
  final Value<int?> relativeDurationMinutes;
  final Value<String> voicePersonality;
  final Value<String?> ttsVoiceName;
  final Value<double> speechRate;
  final Value<double> speechPitch;
  final Value<String> repeatFrequency;
  final Value<String?> customSpokenMessage;
  final Value<bool> isEnabled;
  final Value<bool> isSpokenEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.relativeDurationMinutes = const Value.absent(),
    this.voicePersonality = const Value.absent(),
    this.ttsVoiceName = const Value.absent(),
    this.speechRate = const Value.absent(),
    this.speechPitch = const Value.absent(),
    this.repeatFrequency = const Value.absent(),
    this.customSpokenMessage = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isSpokenEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required DateTime scheduledAt,
    this.relativeDurationMinutes = const Value.absent(),
    this.voicePersonality = const Value.absent(),
    this.ttsVoiceName = const Value.absent(),
    this.speechRate = const Value.absent(),
    this.speechPitch = const Value.absent(),
    this.repeatFrequency = const Value.absent(),
    this.customSpokenMessage = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isSpokenEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       scheduledAt = Value(scheduledAt);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? scheduledAt,
    Expression<int>? relativeDurationMinutes,
    Expression<String>? voicePersonality,
    Expression<String>? ttsVoiceName,
    Expression<double>? speechRate,
    Expression<double>? speechPitch,
    Expression<String>? repeatFrequency,
    Expression<String>? customSpokenMessage,
    Expression<bool>? isEnabled,
    Expression<bool>? isSpokenEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (relativeDurationMinutes != null)
        'relative_duration_minutes': relativeDurationMinutes,
      if (voicePersonality != null) 'voice_personality': voicePersonality,
      if (ttsVoiceName != null) 'tts_voice_name': ttsVoiceName,
      if (speechRate != null) 'speech_rate': speechRate,
      if (speechPitch != null) 'speech_pitch': speechPitch,
      if (repeatFrequency != null) 'repeat_frequency': repeatFrequency,
      if (customSpokenMessage != null)
        'custom_spoken_message': customSpokenMessage,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (isSpokenEnabled != null) 'is_spoken_enabled': isSpokenEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime>? scheduledAt,
    Value<int?>? relativeDurationMinutes,
    Value<String>? voicePersonality,
    Value<String?>? ttsVoiceName,
    Value<double>? speechRate,
    Value<double>? speechPitch,
    Value<String>? repeatFrequency,
    Value<String?>? customSpokenMessage,
    Value<bool>? isEnabled,
    Value<bool>? isSpokenEnabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      relativeDurationMinutes:
          relativeDurationMinutes ?? this.relativeDurationMinutes,
      voicePersonality: voicePersonality ?? this.voicePersonality,
      ttsVoiceName: ttsVoiceName ?? this.ttsVoiceName,
      speechRate: speechRate ?? this.speechRate,
      speechPitch: speechPitch ?? this.speechPitch,
      repeatFrequency: repeatFrequency ?? this.repeatFrequency,
      customSpokenMessage: customSpokenMessage ?? this.customSpokenMessage,
      isEnabled: isEnabled ?? this.isEnabled,
      isSpokenEnabled: isSpokenEnabled ?? this.isSpokenEnabled,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (relativeDurationMinutes.present) {
      map['relative_duration_minutes'] = Variable<int>(
        relativeDurationMinutes.value,
      );
    }
    if (voicePersonality.present) {
      map['voice_personality'] = Variable<String>(voicePersonality.value);
    }
    if (ttsVoiceName.present) {
      map['tts_voice_name'] = Variable<String>(ttsVoiceName.value);
    }
    if (speechRate.present) {
      map['speech_rate'] = Variable<double>(speechRate.value);
    }
    if (speechPitch.present) {
      map['speech_pitch'] = Variable<double>(speechPitch.value);
    }
    if (repeatFrequency.present) {
      map['repeat_frequency'] = Variable<String>(repeatFrequency.value);
    }
    if (customSpokenMessage.present) {
      map['custom_spoken_message'] = Variable<String>(
        customSpokenMessage.value,
      );
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (isSpokenEnabled.present) {
      map['is_spoken_enabled'] = Variable<bool>(isSpokenEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('relativeDurationMinutes: $relativeDurationMinutes, ')
          ..write('voicePersonality: $voicePersonality, ')
          ..write('ttsVoiceName: $ttsVoiceName, ')
          ..write('speechRate: $speechRate, ')
          ..write('speechPitch: $speechPitch, ')
          ..write('repeatFrequency: $repeatFrequency, ')
          ..write('customSpokenMessage: $customSpokenMessage, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isSpokenEnabled: $isSpokenEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('personal'),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueTimeMeta = const VerificationMeta(
    'dueTime',
  );
  @override
  late final GeneratedColumn<String> dueTime = GeneratedColumn<String>(
    'due_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  static const VerificationMeta _reminderIdMeta = const VerificationMeta(
    'reminderId',
  );
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
    'reminder_id',
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
    id,
    title,
    description,
    category,
    priority,
    dueDate,
    dueTime,
    isCompleted,
    reminderId,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('due_time')) {
      context.handle(
        _dueTimeMeta,
        dueTime.isAcceptableOrUnknown(data['due_time']!, _dueTimeMeta),
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
    if (data.containsKey('reminder_id')) {
      context.handle(
        _reminderIdMeta,
        reminderId.isAcceptableOrUnknown(data['reminder_id']!, _reminderIdMeta),
      );
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      dueTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_time'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      reminderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String title;
  final String? description;
  final String category;
  final String priority;
  final DateTime? dueDate;
  final String? dueTime;
  final bool isCompleted;
  final String? reminderId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.priority,
    this.dueDate,
    this.dueTime,
    required this.isCompleted,
    this.reminderId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['category'] = Variable<String>(category);
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || dueTime != null) {
      map['due_time'] = Variable<String>(dueTime);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || reminderId != null) {
      map['reminder_id'] = Variable<String>(reminderId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: Value(category),
      priority: Value(priority),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueTime: dueTime == null && nullToAbsent
          ? const Value.absent()
          : Value(dueTime),
      isCompleted: Value(isCompleted),
      reminderId: reminderId == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      priority: serializer.fromJson<String>(json['priority']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      dueTime: serializer.fromJson<String?>(json['dueTime']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      reminderId: serializer.fromJson<String?>(json['reminderId']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String>(category),
      'priority': serializer.toJson<String>(priority),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'dueTime': serializer.toJson<String?>(dueTime),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'reminderId': serializer.toJson<String?>(reminderId),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Task copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    String? category,
    String? priority,
    Value<DateTime?> dueDate = const Value.absent(),
    Value<String?> dueTime = const Value.absent(),
    bool? isCompleted,
    Value<String?> reminderId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    category: category ?? this.category,
    priority: priority ?? this.priority,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    dueTime: dueTime.present ? dueTime.value : this.dueTime,
    isCompleted: isCompleted ?? this.isCompleted,
    reminderId: reminderId.present ? reminderId.value : this.reminderId,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      priority: data.priority.present ? data.priority.value : this.priority,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueTime: data.dueTime.present ? data.dueTime.value : this.dueTime,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      reminderId: data.reminderId.present
          ? data.reminderId.value
          : this.reminderId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('reminderId: $reminderId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    category,
    priority,
    dueDate,
    dueTime,
    isCompleted,
    reminderId,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.priority == this.priority &&
          other.dueDate == this.dueDate &&
          other.dueTime == this.dueTime &&
          other.isCompleted == this.isCompleted &&
          other.reminderId == this.reminderId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> category;
  final Value<String> priority;
  final Value<DateTime?> dueDate;
  final Value<String?> dueTime;
  final Value<bool> isCompleted;
  final Value<String?> reminderId;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? priority,
    Expression<DateTime>? dueDate,
    Expression<String>? dueTime,
    Expression<bool>? isCompleted,
    Expression<String>? reminderId,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (priority != null) 'priority': priority,
      if (dueDate != null) 'due_date': dueDate,
      if (dueTime != null) 'due_time': dueTime,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (reminderId != null) 'reminder_id': reminderId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? category,
    Value<String>? priority,
    Value<DateTime?>? dueDate,
    Value<String?>? dueTime,
    Value<bool>? isCompleted,
    Value<String?>? reminderId,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderId: reminderId ?? this.reminderId,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (dueTime.present) {
      map['due_time'] = Variable<String>(dueTime.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('reminderId: $reminderId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalendarEventsTable extends CalendarEvents
    with TableInfo<$CalendarEventsTable, CalendarEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarEventsTable(this.attachedDatabase, [this._alias]);
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
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
  static const VerificationMeta _eventDateMeta = const VerificationMeta(
    'eventDate',
  );
  @override
  late final GeneratedColumn<DateTime> eventDate = GeneratedColumn<DateTime>(
    'event_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
  static const VerificationMeta _categoryColorMeta = const VerificationMeta(
    'categoryColor',
  );
  @override
  late final GeneratedColumn<int> categoryColor = GeneratedColumn<int>(
    'category_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF6366F1),
  );
  static const VerificationMeta _isImportantDateMeta = const VerificationMeta(
    'isImportantDate',
  );
  @override
  late final GeneratedColumn<bool> isImportantDate = GeneratedColumn<bool>(
    'is_important_date',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_important_date" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasAlarmMeta = const VerificationMeta(
    'hasAlarm',
  );
  @override
  late final GeneratedColumn<bool> hasAlarm = GeneratedColumn<bool>(
    'has_alarm',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_alarm" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderIdMeta = const VerificationMeta(
    'reminderId',
  );
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
    'reminder_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    description,
    eventDate,
    startTime,
    endTime,
    categoryColor,
    isImportantDate,
    hasAlarm,
    reminderId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarEvent> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('event_date')) {
      context.handle(
        _eventDateMeta,
        eventDate.isAcceptableOrUnknown(data['event_date']!, _eventDateMeta),
      );
    } else if (isInserting) {
      context.missing(_eventDateMeta);
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
    if (data.containsKey('category_color')) {
      context.handle(
        _categoryColorMeta,
        categoryColor.isAcceptableOrUnknown(
          data['category_color']!,
          _categoryColorMeta,
        ),
      );
    }
    if (data.containsKey('is_important_date')) {
      context.handle(
        _isImportantDateMeta,
        isImportantDate.isAcceptableOrUnknown(
          data['is_important_date']!,
          _isImportantDateMeta,
        ),
      );
    }
    if (data.containsKey('has_alarm')) {
      context.handle(
        _hasAlarmMeta,
        hasAlarm.isAcceptableOrUnknown(data['has_alarm']!, _hasAlarmMeta),
      );
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
        _reminderIdMeta,
        reminderId.isAcceptableOrUnknown(data['reminder_id']!, _reminderIdMeta),
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
  CalendarEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      eventDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}event_date'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      ),
      categoryColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_color'],
      )!,
      isImportantDate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_important_date'],
      )!,
      hasAlarm: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_alarm'],
      )!,
      reminderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CalendarEventsTable createAlias(String alias) {
    return $CalendarEventsTable(attachedDatabase, alias);
  }
}

class CalendarEvent extends DataClass implements Insertable<CalendarEvent> {
  final String id;
  final String title;
  final String? description;
  final DateTime eventDate;
  final String? startTime;
  final String? endTime;
  final int categoryColor;
  final bool isImportantDate;
  final bool hasAlarm;
  final String? reminderId;
  final DateTime createdAt;
  const CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.eventDate,
    this.startTime,
    this.endTime,
    required this.categoryColor,
    required this.isImportantDate,
    required this.hasAlarm,
    this.reminderId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['event_date'] = Variable<DateTime>(eventDate);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<String>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    map['category_color'] = Variable<int>(categoryColor);
    map['is_important_date'] = Variable<bool>(isImportantDate);
    map['has_alarm'] = Variable<bool>(hasAlarm);
    if (!nullToAbsent || reminderId != null) {
      map['reminder_id'] = Variable<String>(reminderId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CalendarEventsCompanion toCompanion(bool nullToAbsent) {
    return CalendarEventsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      eventDate: Value(eventDate),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      categoryColor: Value(categoryColor),
      isImportantDate: Value(isImportantDate),
      hasAlarm: Value(hasAlarm),
      reminderId: reminderId == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderId),
      createdAt: Value(createdAt),
    );
  }

  factory CalendarEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarEvent(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      eventDate: serializer.fromJson<DateTime>(json['eventDate']),
      startTime: serializer.fromJson<String?>(json['startTime']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      categoryColor: serializer.fromJson<int>(json['categoryColor']),
      isImportantDate: serializer.fromJson<bool>(json['isImportantDate']),
      hasAlarm: serializer.fromJson<bool>(json['hasAlarm']),
      reminderId: serializer.fromJson<String?>(json['reminderId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'eventDate': serializer.toJson<DateTime>(eventDate),
      'startTime': serializer.toJson<String?>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'categoryColor': serializer.toJson<int>(categoryColor),
      'isImportantDate': serializer.toJson<bool>(isImportantDate),
      'hasAlarm': serializer.toJson<bool>(hasAlarm),
      'reminderId': serializer.toJson<String?>(reminderId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CalendarEvent copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    DateTime? eventDate,
    Value<String?> startTime = const Value.absent(),
    Value<String?> endTime = const Value.absent(),
    int? categoryColor,
    bool? isImportantDate,
    bool? hasAlarm,
    Value<String?> reminderId = const Value.absent(),
    DateTime? createdAt,
  }) => CalendarEvent(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    eventDate: eventDate ?? this.eventDate,
    startTime: startTime.present ? startTime.value : this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    categoryColor: categoryColor ?? this.categoryColor,
    isImportantDate: isImportantDate ?? this.isImportantDate,
    hasAlarm: hasAlarm ?? this.hasAlarm,
    reminderId: reminderId.present ? reminderId.value : this.reminderId,
    createdAt: createdAt ?? this.createdAt,
  );
  CalendarEvent copyWithCompanion(CalendarEventsCompanion data) {
    return CalendarEvent(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      eventDate: data.eventDate.present ? data.eventDate.value : this.eventDate,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      categoryColor: data.categoryColor.present
          ? data.categoryColor.value
          : this.categoryColor,
      isImportantDate: data.isImportantDate.present
          ? data.isImportantDate.value
          : this.isImportantDate,
      hasAlarm: data.hasAlarm.present ? data.hasAlarm.value : this.hasAlarm,
      reminderId: data.reminderId.present
          ? data.reminderId.value
          : this.reminderId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEvent(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('eventDate: $eventDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('categoryColor: $categoryColor, ')
          ..write('isImportantDate: $isImportantDate, ')
          ..write('hasAlarm: $hasAlarm, ')
          ..write('reminderId: $reminderId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    eventDate,
    startTime,
    endTime,
    categoryColor,
    isImportantDate,
    hasAlarm,
    reminderId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarEvent &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.eventDate == this.eventDate &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.categoryColor == this.categoryColor &&
          other.isImportantDate == this.isImportantDate &&
          other.hasAlarm == this.hasAlarm &&
          other.reminderId == this.reminderId &&
          other.createdAt == this.createdAt);
}

class CalendarEventsCompanion extends UpdateCompanion<CalendarEvent> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> eventDate;
  final Value<String?> startTime;
  final Value<String?> endTime;
  final Value<int> categoryColor;
  final Value<bool> isImportantDate;
  final Value<bool> hasAlarm;
  final Value<String?> reminderId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CalendarEventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.categoryColor = const Value.absent(),
    this.isImportantDate = const Value.absent(),
    this.hasAlarm = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalendarEventsCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required DateTime eventDate,
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.categoryColor = const Value.absent(),
    this.isImportantDate = const Value.absent(),
    this.hasAlarm = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       eventDate = Value(eventDate);
  static Insertable<CalendarEvent> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? eventDate,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<int>? categoryColor,
    Expression<bool>? isImportantDate,
    Expression<bool>? hasAlarm,
    Expression<String>? reminderId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (eventDate != null) 'event_date': eventDate,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (categoryColor != null) 'category_color': categoryColor,
      if (isImportantDate != null) 'is_important_date': isImportantDate,
      if (hasAlarm != null) 'has_alarm': hasAlarm,
      if (reminderId != null) 'reminder_id': reminderId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalendarEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime>? eventDate,
    Value<String?>? startTime,
    Value<String?>? endTime,
    Value<int>? categoryColor,
    Value<bool>? isImportantDate,
    Value<bool>? hasAlarm,
    Value<String?>? reminderId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CalendarEventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      categoryColor: categoryColor ?? this.categoryColor,
      isImportantDate: isImportantDate ?? this.isImportantDate,
      hasAlarm: hasAlarm ?? this.hasAlarm,
      reminderId: reminderId ?? this.reminderId,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<DateTime>(eventDate.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (categoryColor.present) {
      map['category_color'] = Variable<int>(categoryColor.value);
    }
    if (isImportantDate.present) {
      map['is_important_date'] = Variable<bool>(isImportantDate.value);
    }
    if (hasAlarm.present) {
      map['has_alarm'] = Variable<bool>(hasAlarm.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
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
    return (StringBuffer('CalendarEventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('eventDate: $eventDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('categoryColor: $categoryColor, ')
          ..write('isImportantDate: $isImportantDate, ')
          ..write('hasAlarm: $hasAlarm, ')
          ..write('reminderId: $reminderId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WishlistItemsTable extends WishlistItems
    with TableInfo<$WishlistItemsTable, WishlistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WishlistItemsTable(this.attachedDatabase, [this._alias]);
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('goal'),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    description,
    category,
    priority,
    targetDate,
    isCompleted,
    imagePath,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wishlist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WishlistItem> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
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
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
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
  WishlistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WishlistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WishlistItemsTable createAlias(String alias) {
    return $WishlistItemsTable(attachedDatabase, alias);
  }
}

class WishlistItem extends DataClass implements Insertable<WishlistItem> {
  final String id;
  final String title;
  final String? description;
  final String category;
  final String priority;
  final DateTime? targetDate;
  final bool isCompleted;
  final String? imagePath;
  final DateTime createdAt;
  const WishlistItem({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.priority,
    this.targetDate,
    required this.isCompleted,
    this.imagePath,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['category'] = Variable<String>(category);
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WishlistItemsCompanion toCompanion(bool nullToAbsent) {
    return WishlistItemsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: Value(category),
      priority: Value(priority),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      isCompleted: Value(isCompleted),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      createdAt: Value(createdAt),
    );
  }

  factory WishlistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WishlistItem(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      priority: serializer.fromJson<String>(json['priority']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String>(category),
      'priority': serializer.toJson<String>(priority),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'imagePath': serializer.toJson<String?>(imagePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WishlistItem copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    String? category,
    String? priority,
    Value<DateTime?> targetDate = const Value.absent(),
    bool? isCompleted,
    Value<String?> imagePath = const Value.absent(),
    DateTime? createdAt,
  }) => WishlistItem(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    category: category ?? this.category,
    priority: priority ?? this.priority,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    isCompleted: isCompleted ?? this.isCompleted,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    createdAt: createdAt ?? this.createdAt,
  );
  WishlistItem copyWithCompanion(WishlistItemsCompanion data) {
    return WishlistItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      priority: data.priority.present ? data.priority.value : this.priority,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WishlistItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('targetDate: $targetDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    category,
    priority,
    targetDate,
    isCompleted,
    imagePath,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WishlistItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.priority == this.priority &&
          other.targetDate == this.targetDate &&
          other.isCompleted == this.isCompleted &&
          other.imagePath == this.imagePath &&
          other.createdAt == this.createdAt);
}

class WishlistItemsCompanion extends UpdateCompanion<WishlistItem> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> category;
  final Value<String> priority;
  final Value<DateTime?> targetDate;
  final Value<bool> isCompleted;
  final Value<String?> imagePath;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WishlistItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WishlistItemsCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<WishlistItem> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? priority,
    Expression<DateTime>? targetDate,
    Expression<bool>? isCompleted,
    Expression<String>? imagePath,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (priority != null) 'priority': priority,
      if (targetDate != null) 'target_date': targetDate,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (imagePath != null) 'image_path': imagePath,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WishlistItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? category,
    Value<String>? priority,
    Value<DateTime?>? targetDate,
    Value<bool>? isCompleted,
    Value<String?>? imagePath,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return WishlistItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      targetDate: targetDate ?? this.targetDate,
      isCompleted: isCompleted ?? this.isCompleted,
      imagePath: imagePath ?? this.imagePath,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
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
    return (StringBuffer('WishlistItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('targetDate: $targetDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlarmHistoryTable extends AlarmHistory
    with TableInfo<$AlarmHistoryTable, AlarmHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlarmHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderIdMeta = const VerificationMeta(
    'reminderId',
  );
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
    'reminder_id',
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triggeredAtMeta = const VerificationMeta(
    'triggeredAt',
  );
  @override
  late final GeneratedColumn<DateTime> triggeredAt = GeneratedColumn<DateTime>(
    'triggered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionTakenMeta = const VerificationMeta(
    'actionTaken',
  );
  @override
  late final GeneratedColumn<String> actionTaken = GeneratedColumn<String>(
    'action_taken',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spokenMessageMeta = const VerificationMeta(
    'spokenMessage',
  );
  @override
  late final GeneratedColumn<String> spokenMessage = GeneratedColumn<String>(
    'spoken_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reminderId,
    title,
    triggeredAt,
    actionTaken,
    spokenMessage,
    loggedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alarm_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlarmHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
        _reminderIdMeta,
        reminderId.isAcceptableOrUnknown(data['reminder_id']!, _reminderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reminderIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('triggered_at')) {
      context.handle(
        _triggeredAtMeta,
        triggeredAt.isAcceptableOrUnknown(
          data['triggered_at']!,
          _triggeredAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_triggeredAtMeta);
    }
    if (data.containsKey('action_taken')) {
      context.handle(
        _actionTakenMeta,
        actionTaken.isAcceptableOrUnknown(
          data['action_taken']!,
          _actionTakenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actionTakenMeta);
    }
    if (data.containsKey('spoken_message')) {
      context.handle(
        _spokenMessageMeta,
        spokenMessage.isAcceptableOrUnknown(
          data['spoken_message']!,
          _spokenMessageMeta,
        ),
      );
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlarmHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlarmHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      reminderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      triggeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}triggered_at'],
      )!,
      actionTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_taken'],
      )!,
      spokenMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spoken_message'],
      ),
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
    );
  }

  @override
  $AlarmHistoryTable createAlias(String alias) {
    return $AlarmHistoryTable(attachedDatabase, alias);
  }
}

class AlarmHistoryData extends DataClass
    implements Insertable<AlarmHistoryData> {
  final String id;
  final String reminderId;
  final String title;
  final DateTime triggeredAt;
  final String actionTaken;
  final String? spokenMessage;
  final DateTime loggedAt;
  const AlarmHistoryData({
    required this.id,
    required this.reminderId,
    required this.title,
    required this.triggeredAt,
    required this.actionTaken,
    this.spokenMessage,
    required this.loggedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['reminder_id'] = Variable<String>(reminderId);
    map['title'] = Variable<String>(title);
    map['triggered_at'] = Variable<DateTime>(triggeredAt);
    map['action_taken'] = Variable<String>(actionTaken);
    if (!nullToAbsent || spokenMessage != null) {
      map['spoken_message'] = Variable<String>(spokenMessage);
    }
    map['logged_at'] = Variable<DateTime>(loggedAt);
    return map;
  }

  AlarmHistoryCompanion toCompanion(bool nullToAbsent) {
    return AlarmHistoryCompanion(
      id: Value(id),
      reminderId: Value(reminderId),
      title: Value(title),
      triggeredAt: Value(triggeredAt),
      actionTaken: Value(actionTaken),
      spokenMessage: spokenMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(spokenMessage),
      loggedAt: Value(loggedAt),
    );
  }

  factory AlarmHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlarmHistoryData(
      id: serializer.fromJson<String>(json['id']),
      reminderId: serializer.fromJson<String>(json['reminderId']),
      title: serializer.fromJson<String>(json['title']),
      triggeredAt: serializer.fromJson<DateTime>(json['triggeredAt']),
      actionTaken: serializer.fromJson<String>(json['actionTaken']),
      spokenMessage: serializer.fromJson<String?>(json['spokenMessage']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reminderId': serializer.toJson<String>(reminderId),
      'title': serializer.toJson<String>(title),
      'triggeredAt': serializer.toJson<DateTime>(triggeredAt),
      'actionTaken': serializer.toJson<String>(actionTaken),
      'spokenMessage': serializer.toJson<String?>(spokenMessage),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
    };
  }

  AlarmHistoryData copyWith({
    String? id,
    String? reminderId,
    String? title,
    DateTime? triggeredAt,
    String? actionTaken,
    Value<String?> spokenMessage = const Value.absent(),
    DateTime? loggedAt,
  }) => AlarmHistoryData(
    id: id ?? this.id,
    reminderId: reminderId ?? this.reminderId,
    title: title ?? this.title,
    triggeredAt: triggeredAt ?? this.triggeredAt,
    actionTaken: actionTaken ?? this.actionTaken,
    spokenMessage: spokenMessage.present
        ? spokenMessage.value
        : this.spokenMessage,
    loggedAt: loggedAt ?? this.loggedAt,
  );
  AlarmHistoryData copyWithCompanion(AlarmHistoryCompanion data) {
    return AlarmHistoryData(
      id: data.id.present ? data.id.value : this.id,
      reminderId: data.reminderId.present
          ? data.reminderId.value
          : this.reminderId,
      title: data.title.present ? data.title.value : this.title,
      triggeredAt: data.triggeredAt.present
          ? data.triggeredAt.value
          : this.triggeredAt,
      actionTaken: data.actionTaken.present
          ? data.actionTaken.value
          : this.actionTaken,
      spokenMessage: data.spokenMessage.present
          ? data.spokenMessage.value
          : this.spokenMessage,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlarmHistoryData(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('title: $title, ')
          ..write('triggeredAt: $triggeredAt, ')
          ..write('actionTaken: $actionTaken, ')
          ..write('spokenMessage: $spokenMessage, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reminderId,
    title,
    triggeredAt,
    actionTaken,
    spokenMessage,
    loggedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlarmHistoryData &&
          other.id == this.id &&
          other.reminderId == this.reminderId &&
          other.title == this.title &&
          other.triggeredAt == this.triggeredAt &&
          other.actionTaken == this.actionTaken &&
          other.spokenMessage == this.spokenMessage &&
          other.loggedAt == this.loggedAt);
}

class AlarmHistoryCompanion extends UpdateCompanion<AlarmHistoryData> {
  final Value<String> id;
  final Value<String> reminderId;
  final Value<String> title;
  final Value<DateTime> triggeredAt;
  final Value<String> actionTaken;
  final Value<String?> spokenMessage;
  final Value<DateTime> loggedAt;
  final Value<int> rowid;
  const AlarmHistoryCompanion({
    this.id = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.title = const Value.absent(),
    this.triggeredAt = const Value.absent(),
    this.actionTaken = const Value.absent(),
    this.spokenMessage = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlarmHistoryCompanion.insert({
    required String id,
    required String reminderId,
    required String title,
    required DateTime triggeredAt,
    required String actionTaken,
    this.spokenMessage = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       reminderId = Value(reminderId),
       title = Value(title),
       triggeredAt = Value(triggeredAt),
       actionTaken = Value(actionTaken);
  static Insertable<AlarmHistoryData> custom({
    Expression<String>? id,
    Expression<String>? reminderId,
    Expression<String>? title,
    Expression<DateTime>? triggeredAt,
    Expression<String>? actionTaken,
    Expression<String>? spokenMessage,
    Expression<DateTime>? loggedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reminderId != null) 'reminder_id': reminderId,
      if (title != null) 'title': title,
      if (triggeredAt != null) 'triggered_at': triggeredAt,
      if (actionTaken != null) 'action_taken': actionTaken,
      if (spokenMessage != null) 'spoken_message': spokenMessage,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlarmHistoryCompanion copyWith({
    Value<String>? id,
    Value<String>? reminderId,
    Value<String>? title,
    Value<DateTime>? triggeredAt,
    Value<String>? actionTaken,
    Value<String?>? spokenMessage,
    Value<DateTime>? loggedAt,
    Value<int>? rowid,
  }) {
    return AlarmHistoryCompanion(
      id: id ?? this.id,
      reminderId: reminderId ?? this.reminderId,
      title: title ?? this.title,
      triggeredAt: triggeredAt ?? this.triggeredAt,
      actionTaken: actionTaken ?? this.actionTaken,
      spokenMessage: spokenMessage ?? this.spokenMessage,
      loggedAt: loggedAt ?? this.loggedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (triggeredAt.present) {
      map['triggered_at'] = Variable<DateTime>(triggeredAt.value);
    }
    if (actionTaken.present) {
      map['action_taken'] = Variable<String>(actionTaken.value);
    }
    if (spokenMessage.present) {
      map['spoken_message'] = Variable<String>(spokenMessage.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlarmHistoryCompanion(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('title: $title, ')
          ..write('triggeredAt: $triggeredAt, ')
          ..write('actionTaken: $actionTaken, ')
          ..write('spokenMessage: $spokenMessage, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    durationMinutes,
    completedAt,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
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
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }
}

class FocusSession extends DataClass implements Insertable<FocusSession> {
  final String id;
  final String? taskId;
  final int durationMinutes;
  final DateTime completedAt;
  final String? notes;
  const FocusSession({
    required this.id,
    this.taskId,
    required this.durationMinutes,
    required this.completedAt,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['completed_at'] = Variable<DateTime>(completedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      durationMinutes: Value(durationMinutes),
      completedAt: Value(completedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory FocusSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSession(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String?>(taskId),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  FocusSession copyWith({
    String? id,
    Value<String?> taskId = const Value.absent(),
    int? durationMinutes,
    DateTime? completedAt,
    Value<String?> notes = const Value.absent(),
  }) => FocusSession(
    id: id ?? this.id,
    taskId: taskId.present ? taskId.value : this.taskId,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    completedAt: completedAt ?? this.completedAt,
    notes: notes.present ? notes.value : this.notes,
  );
  FocusSession copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSession(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSession(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, durationMinutes, completedAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSession &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.durationMinutes == this.durationMinutes &&
          other.completedAt == this.completedAt &&
          other.notes == this.notes);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSession> {
  final Value<String> id;
  final Value<String?> taskId;
  final Value<int> durationMinutes;
  final Value<DateTime> completedAt;
  final Value<String?> notes;
  final Value<int> rowid;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    required String id,
    this.taskId = const Value.absent(),
    required int durationMinutes,
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       durationMinutes = Value(durationMinutes);
  static Insertable<FocusSession> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<int>? durationMinutes,
    Expression<DateTime>? completedAt,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (completedAt != null) 'completed_at': completedAt,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusSessionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? taskId,
    Value<int>? durationMinutes,
    Value<DateTime>? completedAt,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      completedAt: completedAt ?? this.completedAt,
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
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
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
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $CalendarEventsTable calendarEvents = $CalendarEventsTable(this);
  late final $WishlistItemsTable wishlistItems = $WishlistItemsTable(this);
  late final $AlarmHistoryTable alarmHistory = $AlarmHistoryTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    reminders,
    tasks,
    calendarEvents,
    wishlistItems,
    alarmHistory,
    focusSessions,
    appSettings,
  ];
}

typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  required String id,
  required String title,
  Value<String?> description,
  required DateTime scheduledAt,
  Value<int?> relativeDurationMinutes,
  Value<String> voicePersonality,
  Value<String?> ttsVoiceName,
  Value<double> speechRate,
  Value<double> speechPitch,
  Value<String> repeatFrequency,
  Value<String?> customSpokenMessage,
  Value<bool> isEnabled,
  Value<bool> isSpokenEnabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<DateTime> scheduledAt,
  Value<int?> relativeDurationMinutes,
  Value<String> voicePersonality,
  Value<String?> ttsVoiceName,
  Value<double> speechRate,
  Value<double> speechPitch,
  Value<String> repeatFrequency,
  Value<String?> customSpokenMessage,
  Value<bool> isEnabled,
  Value<bool> isSpokenEnabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get relativeDurationMinutes => $composableBuilder(
    column: $table.relativeDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voicePersonality => $composableBuilder(
    column: $table.voicePersonality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ttsVoiceName => $composableBuilder(
    column: $table.ttsVoiceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speechRate => $composableBuilder(
    column: $table.speechRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speechPitch => $composableBuilder(
    column: $table.speechPitch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatFrequency => $composableBuilder(
    column: $table.repeatFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customSpokenMessage => $composableBuilder(
    column: $table.customSpokenMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSpokenEnabled => $composableBuilder(
    column: $table.isSpokenEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get relativeDurationMinutes => $composableBuilder(
    column: $table.relativeDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voicePersonality => $composableBuilder(
    column: $table.voicePersonality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ttsVoiceName => $composableBuilder(
    column: $table.ttsVoiceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speechRate => $composableBuilder(
    column: $table.speechRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speechPitch => $composableBuilder(
    column: $table.speechPitch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatFrequency => $composableBuilder(
    column: $table.repeatFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customSpokenMessage => $composableBuilder(
    column: $table.customSpokenMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSpokenEnabled => $composableBuilder(
    column: $table.isSpokenEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get relativeDurationMinutes => $composableBuilder(
    column: $table.relativeDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get voicePersonality => $composableBuilder(
    column: $table.voicePersonality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ttsVoiceName => $composableBuilder(
    column: $table.ttsVoiceName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speechRate => $composableBuilder(
    column: $table.speechRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speechPitch => $composableBuilder(
    column: $table.speechPitch,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatFrequency => $composableBuilder(
    column: $table.repeatFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customSpokenMessage => $composableBuilder(
    column: $table.customSpokenMessage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<bool> get isSpokenEnabled => $composableBuilder(
    column: $table.isSpokenEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<int?> relativeDurationMinutes = const Value.absent(),
                Value<String> voicePersonality = const Value.absent(),
                Value<String?> ttsVoiceName = const Value.absent(),
                Value<double> speechRate = const Value.absent(),
                Value<double> speechPitch = const Value.absent(),
                Value<String> repeatFrequency = const Value.absent(),
                Value<String?> customSpokenMessage = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> isSpokenEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                title: title,
                description: description,
                scheduledAt: scheduledAt,
                relativeDurationMinutes: relativeDurationMinutes,
                voicePersonality: voicePersonality,
                ttsVoiceName: ttsVoiceName,
                speechRate: speechRate,
                speechPitch: speechPitch,
                repeatFrequency: repeatFrequency,
                customSpokenMessage: customSpokenMessage,
                isEnabled: isEnabled,
                isSpokenEnabled: isSpokenEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                required DateTime scheduledAt,
                Value<int?> relativeDurationMinutes = const Value.absent(),
                Value<String> voicePersonality = const Value.absent(),
                Value<String?> ttsVoiceName = const Value.absent(),
                Value<double> speechRate = const Value.absent(),
                Value<double> speechPitch = const Value.absent(),
                Value<String> repeatFrequency = const Value.absent(),
                Value<String?> customSpokenMessage = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> isSpokenEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                title: title,
                description: description,
                scheduledAt: scheduledAt,
                relativeDurationMinutes: relativeDurationMinutes,
                voicePersonality: voicePersonality,
                ttsVoiceName: ttsVoiceName,
                speechRate: speechRate,
                speechPitch: speechPitch,
                repeatFrequency: repeatFrequency,
                customSpokenMessage: customSpokenMessage,
                isEnabled: isEnabled,
                isSpokenEnabled: isSpokenEnabled,
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

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  required String title,
  Value<String?> description,
  Value<String> category,
  Value<String> priority,
  Value<DateTime?> dueDate,
  Value<String?> dueTime,
  Value<bool> isCompleted,
  Value<String?> reminderId,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<String> category,
  Value<String> priority,
  Value<DateTime?> dueDate,
  Value<String?> dueTime,
  Value<bool> isCompleted,
  Value<String?> reminderId,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get dueTime =>
      $composableBuilder(column: $table.dueTime, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> dueTime = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> reminderId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                description: description,
                category: category,
                priority: priority,
                dueDate: dueDate,
                dueTime: dueTime,
                isCompleted: isCompleted,
                reminderId: reminderId,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> dueTime = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> reminderId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                description: description,
                category: category,
                priority: priority,
                dueDate: dueDate,
                dueTime: dueTime,
                isCompleted: isCompleted,
                reminderId: reminderId,
                notes: notes,
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

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
      Task,
      PrefetchHooks Function()
    >;
typedef $$CalendarEventsTableCreateCompanionBuilder =
    CalendarEventsCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      required DateTime eventDate,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<int> categoryColor,
      Value<bool> isImportantDate,
      Value<bool> hasAlarm,
      Value<String?> reminderId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$CalendarEventsTableUpdateCompanionBuilder =
    CalendarEventsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<DateTime> eventDate,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<int> categoryColor,
      Value<bool> isImportantDate,
      Value<bool> hasAlarm,
      Value<String?> reminderId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CalendarEventsTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarEventsTable> {
  $$CalendarEventsTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eventDate => $composableBuilder(
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

  ColumnFilters<int> get categoryColor => $composableBuilder(
    column: $table.categoryColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isImportantDate => $composableBuilder(
    column: $table.isImportantDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasAlarm => $composableBuilder(
    column: $table.hasAlarm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarEventsTable> {
  $$CalendarEventsTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eventDate => $composableBuilder(
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

  ColumnOrderings<int> get categoryColor => $composableBuilder(
    column: $table.categoryColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isImportantDate => $composableBuilder(
    column: $table.isImportantDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasAlarm => $composableBuilder(
    column: $table.hasAlarm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarEventsTable> {
  $$CalendarEventsTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get eventDate =>
      $composableBuilder(column: $table.eventDate, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get categoryColor => $composableBuilder(
    column: $table.categoryColor,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isImportantDate => $composableBuilder(
    column: $table.isImportantDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasAlarm =>
      $composableBuilder(column: $table.hasAlarm, builder: (column) => column);

  GeneratedColumn<String> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CalendarEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarEventsTable,
          CalendarEvent,
          $$CalendarEventsTableFilterComposer,
          $$CalendarEventsTableOrderingComposer,
          $$CalendarEventsTableAnnotationComposer,
          $$CalendarEventsTableCreateCompanionBuilder,
          $$CalendarEventsTableUpdateCompanionBuilder,
          (
            CalendarEvent,
            BaseReferences<_$AppDatabase, $CalendarEventsTable, CalendarEvent>,
          ),
          CalendarEvent,
          PrefetchHooks Function()
        > {
  $$CalendarEventsTableTableManager(
    _$AppDatabase db,
    $CalendarEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> eventDate = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<int> categoryColor = const Value.absent(),
                Value<bool> isImportantDate = const Value.absent(),
                Value<bool> hasAlarm = const Value.absent(),
                Value<String?> reminderId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalendarEventsCompanion(
                id: id,
                title: title,
                description: description,
                eventDate: eventDate,
                startTime: startTime,
                endTime: endTime,
                categoryColor: categoryColor,
                isImportantDate: isImportantDate,
                hasAlarm: hasAlarm,
                reminderId: reminderId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                required DateTime eventDate,
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<int> categoryColor = const Value.absent(),
                Value<bool> isImportantDate = const Value.absent(),
                Value<bool> hasAlarm = const Value.absent(),
                Value<String?> reminderId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalendarEventsCompanion.insert(
                id: id,
                title: title,
                description: description,
                eventDate: eventDate,
                startTime: startTime,
                endTime: endTime,
                categoryColor: categoryColor,
                isImportantDate: isImportantDate,
                hasAlarm: hasAlarm,
                reminderId: reminderId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarEventsTable,
      CalendarEvent,
      $$CalendarEventsTableFilterComposer,
      $$CalendarEventsTableOrderingComposer,
      $$CalendarEventsTableAnnotationComposer,
      $$CalendarEventsTableCreateCompanionBuilder,
      $$CalendarEventsTableUpdateCompanionBuilder,
      (
        CalendarEvent,
        BaseReferences<_$AppDatabase, $CalendarEventsTable, CalendarEvent>,
      ),
      CalendarEvent,
      PrefetchHooks Function()
    >;
typedef $$WishlistItemsTableCreateCompanionBuilder =
    WishlistItemsCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      Value<String> category,
      Value<String> priority,
      Value<DateTime?> targetDate,
      Value<bool> isCompleted,
      Value<String?> imagePath,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$WishlistItemsTableUpdateCompanionBuilder =
    WishlistItemsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<String> category,
      Value<String> priority,
      Value<DateTime?> targetDate,
      Value<bool> isCompleted,
      Value<String?> imagePath,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$WishlistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WishlistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WishlistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WishlistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WishlistItemsTable,
          WishlistItem,
          $$WishlistItemsTableFilterComposer,
          $$WishlistItemsTableOrderingComposer,
          $$WishlistItemsTableAnnotationComposer,
          $$WishlistItemsTableCreateCompanionBuilder,
          $$WishlistItemsTableUpdateCompanionBuilder,
          (
            WishlistItem,
            BaseReferences<_$AppDatabase, $WishlistItemsTable, WishlistItem>,
          ),
          WishlistItem,
          PrefetchHooks Function()
        > {
  $$WishlistItemsTableTableManager(_$AppDatabase db, $WishlistItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WishlistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WishlistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WishlistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WishlistItemsCompanion(
                id: id,
                title: title,
                description: description,
                category: category,
                priority: priority,
                targetDate: targetDate,
                isCompleted: isCompleted,
                imagePath: imagePath,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WishlistItemsCompanion.insert(
                id: id,
                title: title,
                description: description,
                category: category,
                priority: priority,
                targetDate: targetDate,
                isCompleted: isCompleted,
                imagePath: imagePath,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WishlistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WishlistItemsTable,
      WishlistItem,
      $$WishlistItemsTableFilterComposer,
      $$WishlistItemsTableOrderingComposer,
      $$WishlistItemsTableAnnotationComposer,
      $$WishlistItemsTableCreateCompanionBuilder,
      $$WishlistItemsTableUpdateCompanionBuilder,
      (
        WishlistItem,
        BaseReferences<_$AppDatabase, $WishlistItemsTable, WishlistItem>,
      ),
      WishlistItem,
      PrefetchHooks Function()
    >;
typedef $$AlarmHistoryTableCreateCompanionBuilder =
    AlarmHistoryCompanion Function({
      required String id,
      required String reminderId,
      required String title,
      required DateTime triggeredAt,
      required String actionTaken,
      Value<String?> spokenMessage,
      Value<DateTime> loggedAt,
      Value<int> rowid,
    });
typedef $$AlarmHistoryTableUpdateCompanionBuilder =
    AlarmHistoryCompanion Function({
      Value<String> id,
      Value<String> reminderId,
      Value<String> title,
      Value<DateTime> triggeredAt,
      Value<String> actionTaken,
      Value<String?> spokenMessage,
      Value<DateTime> loggedAt,
      Value<int> rowid,
    });

class $$AlarmHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $AlarmHistoryTable> {
  $$AlarmHistoryTableFilterComposer({
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

  ColumnFilters<String> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionTaken => $composableBuilder(
    column: $table.actionTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spokenMessage => $composableBuilder(
    column: $table.spokenMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlarmHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $AlarmHistoryTable> {
  $$AlarmHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionTaken => $composableBuilder(
    column: $table.actionTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spokenMessage => $composableBuilder(
    column: $table.spokenMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlarmHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlarmHistoryTable> {
  $$AlarmHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionTaken => $composableBuilder(
    column: $table.actionTaken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get spokenMessage => $composableBuilder(
    column: $table.spokenMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);
}

class $$AlarmHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlarmHistoryTable,
          AlarmHistoryData,
          $$AlarmHistoryTableFilterComposer,
          $$AlarmHistoryTableOrderingComposer,
          $$AlarmHistoryTableAnnotationComposer,
          $$AlarmHistoryTableCreateCompanionBuilder,
          $$AlarmHistoryTableUpdateCompanionBuilder,
          (
            AlarmHistoryData,
            BaseReferences<_$AppDatabase, $AlarmHistoryTable, AlarmHistoryData>,
          ),
          AlarmHistoryData,
          PrefetchHooks Function()
        > {
  $$AlarmHistoryTableTableManager(_$AppDatabase db, $AlarmHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlarmHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlarmHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlarmHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> reminderId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> triggeredAt = const Value.absent(),
                Value<String> actionTaken = const Value.absent(),
                Value<String?> spokenMessage = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlarmHistoryCompanion(
                id: id,
                reminderId: reminderId,
                title: title,
                triggeredAt: triggeredAt,
                actionTaken: actionTaken,
                spokenMessage: spokenMessage,
                loggedAt: loggedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String reminderId,
                required String title,
                required DateTime triggeredAt,
                required String actionTaken,
                Value<String?> spokenMessage = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlarmHistoryCompanion.insert(
                id: id,
                reminderId: reminderId,
                title: title,
                triggeredAt: triggeredAt,
                actionTaken: actionTaken,
                spokenMessage: spokenMessage,
                loggedAt: loggedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlarmHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlarmHistoryTable,
      AlarmHistoryData,
      $$AlarmHistoryTableFilterComposer,
      $$AlarmHistoryTableOrderingComposer,
      $$AlarmHistoryTableAnnotationComposer,
      $$AlarmHistoryTableCreateCompanionBuilder,
      $$AlarmHistoryTableUpdateCompanionBuilder,
      (
        AlarmHistoryData,
        BaseReferences<_$AppDatabase, $AlarmHistoryTable, AlarmHistoryData>,
      ),
      AlarmHistoryData,
      PrefetchHooks Function()
    >;
typedef $$FocusSessionsTableCreateCompanionBuilder =
    FocusSessionsCompanion Function({
      required String id,
      Value<String?> taskId,
      required int durationMinutes,
      Value<DateTime> completedAt,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$FocusSessionsTableUpdateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<String> id,
      Value<String?> taskId,
      Value<int> durationMinutes,
      Value<DateTime> completedAt,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$FocusSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
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

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FocusSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
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

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FocusSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$FocusSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusSessionsTable,
          FocusSession,
          $$FocusSessionsTableFilterComposer,
          $$FocusSessionsTableOrderingComposer,
          $$FocusSessionsTableAnnotationComposer,
          $$FocusSessionsTableCreateCompanionBuilder,
          $$FocusSessionsTableUpdateCompanionBuilder,
          (
            FocusSession,
            BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSession>,
          ),
          FocusSession,
          PrefetchHooks Function()
        > {
  $$FocusSessionsTableTableManager(_$AppDatabase db, $FocusSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion(
                id: id,
                taskId: taskId,
                durationMinutes: durationMinutes,
                completedAt: completedAt,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> taskId = const Value.absent(),
                required int durationMinutes,
                Value<DateTime> completedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion.insert(
                id: id,
                taskId: taskId,
                durationMinutes: durationMinutes,
                completedAt: completedAt,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FocusSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusSessionsTable,
      FocusSession,
      $$FocusSessionsTableFilterComposer,
      $$FocusSessionsTableOrderingComposer,
      $$FocusSessionsTableAnnotationComposer,
      $$FocusSessionsTableCreateCompanionBuilder,
      $$FocusSessionsTableUpdateCompanionBuilder,
      (
        FocusSession,
        BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSession>,
      ),
      FocusSession,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$CalendarEventsTableTableManager get calendarEvents =>
      $$CalendarEventsTableTableManager(_db, _db.calendarEvents);
  $$WishlistItemsTableTableManager get wishlistItems =>
      $$WishlistItemsTableTableManager(_db, _db.wishlistItems);
  $$AlarmHistoryTableTableManager get alarmHistory =>
      $$AlarmHistoryTableTableManager(_db, _db.alarmHistory);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
