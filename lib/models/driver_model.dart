class DriverModel { 
  
  final int id; 
  final int companyId; 
  
  final String driverName; 
  final String kontak; 
  final String status; 
  
  DriverModel({ 
    required this.id, 
    required this.companyId, 
    required this.driverName, 
    required this.kontak, 
    required this.status, 
  }); 
  
  factory DriverModel.fromJson( 
    Map<String, dynamic> json, 
  ) { 
    
    return DriverModel( 
      id: json["id"], 
      companyId: json["company_id"], 
      driverName: json["driver_name"] ?? "",
      kontak: json["kontak"] ?? "", 
      status: json["status"] ?? "", 
    ); 
  } 
}