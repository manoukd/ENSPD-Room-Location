import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../services/csv_service.dart';

class DetailsPage extends StatefulWidget {
  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  String? selectedRoom; // Salle de départ choisie
  String itinerary = ""; // Texte de l'itinéraire
  Room? destinationRoom; // Salle de destination (nullable)
  List<Room> rooms = []; // Liste des salles pour le dropdown
  bool isLoading = true; // Indicateur de chargement

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialisation de la salle de destination depuis les arguments de la route
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Room) {
      destinationRoom = args;
    }
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      List<Room> loadedRooms = await CsvService().loadRooms();
      setState(() {
        rooms = loadedRooms;
        isLoading = false; // Fin du chargement
      });
    } catch (e) {
      print('Erreur lors du chargement des salles: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _generateItinerary() async {
    if (selectedRoom == null || destinationRoom == null) return;
    try {
      String result = await CsvService().getItinerary(selectedRoom!, destinationRoom!.roomName);
      setState(() {
        itinerary = result;
      });
    } catch (e) {
      print('Erreur lors de la génération de l\'itinéraire: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || destinationRoom == null) {
      // Affiche un écran de chargement si les données ne sont pas encore disponibles
      return Scaffold(
        appBar: AppBar(
          title: const Text("Chargement..."),
          backgroundColor: const Color(0xFF565BDB),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(destinationRoom!.roomName),
        backgroundColor: const Color(0xFF565BDB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
  width: double.infinity,  // Prend toute la largeur de l'écran
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),  // Padding left and right de 16px, top and bottom de 8px
  margin: const EdgeInsets.only(bottom: 32),  // Marge en bas de 32px
  decoration: BoxDecoration(
    color: Color(0xFF565BDB),  // Couleur de fond
    borderRadius: BorderRadius.circular(12),  // Bords arrondis de 12px
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,  // Aligner les textes au centre
    children: [
      // Informations de la salle de destination
      Text(
        '${destinationRoom!.roomName} est Votre destination',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      const SizedBox(height: 8),  // Espace entre les textes
      
      Text(
        'Cette salle est attribuée à: ${destinationRoom!.roomAttribution}',
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      const SizedBox(height: 8),

      // Conteneur pour Bloc, Etage et Gate
      Container(
        padding: const EdgeInsets.only(top: 16),  // Padding top de 4px
        margin: const EdgeInsets.only(top: 16), 
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white, width: 1)),  // Bordure supérieure blanche de 1px
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,  // Aligner au centre
          children: [
            Text(
              '${destinationRoom!.block} ------ ${destinationRoom!.floor} ------ ${destinationRoom!.gate}',
              style: const TextStyle(fontSize: 16, color: Colors.white), 
            ),
            const SizedBox(height: 32),
            
          ],
        ),
      ),
    ],
  ),
),

        Text(
          'Quelle est votre position actuelle?',
          style: const TextStyle(fontSize: 18),
        ),
        SizedBox(height: 24),
        // Conteneur avec Row pour aligner les éléments horizontalement
        Row(
          
          mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Pour espacer les éléments de manière égale
          children: [
            // Dropdown pour sélectionner la salle de départ
            Expanded(  // Utilisé pour faire en sorte que le Dropdown prenne plus d'espace
              child: DropdownButtonFormField<String>(
                value: selectedRoom,
                items: rooms.map((room) {
                  return DropdownMenuItem<String>(
                    value: room.roomName,
                    child: Text(room.roomName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRoom = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Choisissez votre position de départ',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),  // Espace de 16px entre le dropdown et le bouton

            // Bouton pour générer l'itinéraire avec la couleur RGBA spécifiée et texte en blanc
            ElevatedButton(
              onPressed: _generateItinerary,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(86, 91, 219, 1),  // Applique la couleur de fond
                foregroundColor: Colors.white,  // Applique la couleur blanche au texte
              ),
              child: const Text("Trouver l'itinéraire"),
              
            ), 
            
          ],
        ),
        SizedBox(height: 48),

            // Affichage de l'itinéraire
            const Text(
              " Votre Itinéraire:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ),
            ),
            const SizedBox(height: 12),
            Text(
              itinerary.isNotEmpty ? itinerary : "Aucun itinéraire généré. Désolé",
              style: const TextStyle(fontSize: 16),
            ), 
          ],
        ),
      ),
    );
  }
}
