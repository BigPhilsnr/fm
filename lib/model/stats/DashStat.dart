class DashStat {
  DashStat({
      this.stats,});

  DashStat.fromJson(dynamic json) {
    stats = json['stats'] != null ? Stats.fromJson(json['stats']) : null;
  }
  Stats? stats;
DashStat copyWith({  Stats? stats,
}) => DashStat(  stats: stats ?? this.stats,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (stats != null) {
      map['stats'] = stats?.toJson();
    }
    return map;
  }

}

class Stats {
  Stats({
      this.invoices, 
      this.payments, 
      this.patients, 
      this.patientEncounters,});

  Stats.fromJson(dynamic json) {
    invoices = json['invoices'];
    payments = json['payments'];
    patients = json['patients'];
    patientEncounters = json['patient_encounters'];
  }
  num? invoices;
  num? payments;
  num? patients;
  num? patientEncounters;
Stats copyWith({  num? invoices,
  num? payments,
  num? patients,
  num? patientEncounters,
}) => Stats(  invoices: invoices ?? this.invoices,
  payments: payments ?? this.payments,
  patients: patients ?? this.patients,
  patientEncounters: patientEncounters ?? this.patientEncounters,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['invoices'] = invoices;
    map['payments'] = payments;
    map['patients'] = patients;
    map['patient_encounters'] = patientEncounters;
    return map;
  }

}