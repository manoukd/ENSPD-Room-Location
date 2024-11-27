class Room {
  final String roomName;
  final String roomType;
  final String roomAttribution;
  final String textDescriptor;
  final String block;  // Nouveau champ pour le bloc
  final String floor;  // Nouveau champ pour l'étage
  final String gate;   // Nouveau champ pour la porte

  Room({
    required this.roomName,
    required this.roomType,
    required this.roomAttribution,
    this.textDescriptor = '',  // Valeur par défaut vide pour textDescriptor
    required this.block,        // Le bloc
    required this.floor,        // L'étage
    required this.gate,         // Le gate
  });

  factory Room.fromCsv(Map<String, String> row) {
    return Room(
      roomName: row['Room_Name'] ?? '',  // Si 'Room_Name' n'existe pas, une chaîne vide
      roomType: row['Room_Type'] ?? '',  // Si 'Room_Type' n'existe pas, une chaîne vide
      roomAttribution: row['Room_Attribution'] ?? '',  // Si 'Room_Attribution' n'existe pas, une chaîne vide
      textDescriptor: row['Text_Descriptor'] ?? '',  // Si 'Text_Descriptor' n'existe pas, une chaîne vide
      block: row['Bloc'] ?? '',  // Ajout du bloc
      floor: row['Etage'] ?? '',  // Ajout de l'étage
      gate: row['Gate'] ?? '',    // Ajout de la porte (Gate) 
    );
  }
}
