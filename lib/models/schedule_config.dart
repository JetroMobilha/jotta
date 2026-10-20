class ScheduleConfig {
  final bool callLogEnabled;
  final int callLogIntervalMinutes;
  final bool smsEnabled;
  final int smsIntervalMinutes;
  final bool smsReminderEnabled;
  final DateTime? lastExecution;
  final int vaultRetentionDays;

  ScheduleConfig({
    this.callLogEnabled = false,
    this.callLogIntervalMinutes = 15,
    this.smsEnabled = false,
    this.smsIntervalMinutes = 1440, // 24 hours
    this.smsReminderEnabled = false,
    this.lastExecution,
    this.vaultRetentionDays = 7,
  });

  factory ScheduleConfig.fromJson(Map<String, dynamic> json) {
    return ScheduleConfig(
      callLogEnabled: json['callLogEnabled'] as bool? ?? false,
      callLogIntervalMinutes: json['callLogIntervalMinutes'] as int? ?? 15,
      smsEnabled: json['smsEnabled'] as bool? ?? false,
      smsIntervalMinutes: json['smsIntervalMinutes'] as int? ?? 1440,
      smsReminderEnabled: json['smsReminderEnabled'] as bool? ?? false,
      lastExecution: json['lastExecution'] != null
          ? DateTime.parse(json['lastExecution'] as String)
          : null,
      vaultRetentionDays: json['vaultRetentionDays'] as int? ?? 7,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callLogEnabled': callLogEnabled,
      'callLogIntervalMinutes': callLogIntervalMinutes,
      'smsEnabled': smsEnabled,
      'smsIntervalMinutes': smsIntervalMinutes,
      'smsReminderEnabled': smsReminderEnabled,
      'lastExecution': lastExecution?.toIso8601String(),
      'vaultRetentionDays': vaultRetentionDays,
    };
  }

  ScheduleConfig copyWith({
    bool? callLogEnabled,
    int? callLogIntervalMinutes,
    bool? smsEnabled,
    int? smsIntervalMinutes,
    bool? smsReminderEnabled,
    DateTime? lastExecution,
    int? vaultRetentionDays,
  }) {
    return ScheduleConfig(
      callLogEnabled: callLogEnabled ?? this.callLogEnabled,
      callLogIntervalMinutes: callLogIntervalMinutes ?? this.callLogIntervalMinutes,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      smsIntervalMinutes: smsIntervalMinutes ?? this.smsIntervalMinutes,
      smsReminderEnabled: smsReminderEnabled ?? this.smsReminderEnabled,
      lastExecution: lastExecution ?? this.lastExecution,
      vaultRetentionDays: vaultRetentionDays ?? this.vaultRetentionDays,
    );
  }
}
