import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../models/room_model.dart';

class CsvService {
  List<List<dynamic>>? _data; // Cache local des données chargées

  Future<List<Room>> loadRooms() async {
    if (_data == null) {
      final rawData = await rootBundle.loadString('assets/All_enspd_location_room.csv');
      _data = CsvToListConverter().convert(rawData, eol: '\n');
    }

    List<List<dynamic>> listData = _data!;
    List<String> headers = listData.first.map((e) => e.toString()).toList();
    List<Map<String, String>> data = listData.skip(1).map((row) {
      return Map.fromIterables(headers, row.map((e) => e.toString()));
    }).toList();

    return data.map((row) => Room.fromCsv(row)).toList();
  }

  /// Charge les itinéraires sous forme de texte (steps à suivre) entre deux salles
  Future<String> getItinerary(String start, String destination) async {
    // Chargement des données si elles ne sont pas encore disponibles
    if (_data == null) {
      await loadRooms();
    }

    Room? startRoom = await _findRoomByName(start);
    Room? destinationRoom = await _findRoomByName(destination);

    if (startRoom == null || destinationRoom == null) {
      return "L'une des salles n'a pas été trouvée.";
    }

    // Si la salle de départ et la salle de destination sont identiques
    if (start == destination) {
      return "Vous êtes déjà à la destination.";
    }

    // Logique de comparaison des propriétés des salles
    List<String> itinerarySteps = [];

    // Comparer le Bloc
    if (startRoom.block != destinationRoom.block) {
      itinerarySteps.add("Étape 1: Dirigez-vous vers le ${destinationRoom.block}.");
    }else{ itinerarySteps.add("Étape 1: Votre destination est dans le meme bloc que vous : ${startRoom.block}"); }
    
    // Comparer l'Étage
    if (startRoom.floor != destinationRoom.floor) {
      itinerarySteps.add("Étape 2: Montez ou descendez à/au ${destinationRoom.floor}.");
    }else{ itinerarySteps.add("Étape 2: Votre destination est au meme Etage que vous : ${startRoom.floor} "); }

    // Comparer la Porte (Gate)
    if (startRoom.gate != destinationRoom.gate) {
      itinerarySteps.add("Étape 3: Allez vers le  ${destinationRoom.gate}.");
    }else{ itinerarySteps.add("Étape 3: Votre destination est au meme GATE que vous : ${startRoom.gate}"); }

    // Comparer le nom de la salle (Room Name)
    itinerarySteps.add("Étape finale: Arrivez à la salle ${destinationRoom.roomName}.");

    // Retourner l'itinéraire
    return itinerarySteps.join("\n");
  }

  // Méthode pour rechercher une salle par son nom
  Future<Room?> _findRoomByName(String roomName) async {
    if (_data == null) {
      await loadRooms();
    }

    // Recherche de la salle dans les données
    List<Room> rooms = await loadRooms();

    // Retourner une salle ou null si non trouvée
    return rooms.firstWhere(
      (room) => room.roomName == roomName,
      
    );
  }
}
