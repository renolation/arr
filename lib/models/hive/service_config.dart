import 'package:hive/hive.dart';

part 'service_config.g.dart';

@HiveType(typeId: 0)
class ServiceConfig extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  String url;
  
  @HiveField(3)
  String apiKey;
  
  @HiveField(4)
  ServiceType serviceType;
  
  @HiveField(5)
  bool isEnabled;
  
  @HiveField(6)
  DateTime? lastSync;
  
  @HiveField(7)
  bool isDefault;

  ServiceConfig({
    required this.id,
    required this.name,
    required this.url,
    required this.apiKey,
    required this.serviceType,
    this.isEnabled = true,
    this.lastSync,
    this.isDefault = false,
  });
}

@HiveType(typeId: 1)
enum ServiceType {
  @HiveField(0)
  sonarr,
  
  @HiveField(1)
  radarr,
  
  @HiveField(2)
  lidarr,
  
  @HiveField(3)
  readarr,
}