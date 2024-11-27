import 'package:flutter/material.dart'; 
import '../services/csv_service.dart';
import '../models/room_model.dart';
 // Importez la page de détails

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<List<Room>> roomsFuture;
  List<Room> rooms = [];
  String selectedCategory = "All";
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    roomsFuture = loadRooms();
  }

  Future<List<Room>> loadRooms() async {
    try {
      List<Room> rooms = await CsvService().loadRooms();
      return rooms;
    } catch (e) {
      print('Erreur lors du chargement des données: $e');
      throw Exception('Erreur de chargement des données');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF565BDB),
      ),
      body: Column(
        children: [
          // Conteneur pour la barre de recherche
          Container(
            color: Color(0xFF565BDB),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: [
                // Alignement du texte à gauche
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Let’s Find Your ENSPD room!",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  onSubmitted: (_) {
                    setState(() {
                      searchQuery = searchController.text.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Color(0xFF848484)),
                    hintText: "Search Classroom, offices, teachers",
                    hintStyle: TextStyle(color: Color(0xFF848484)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Barre des catégories (qui reste fixe)
         Container(
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0), // Padding autour de la liste
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, // Alignement à gauche
                children: [
                  _categoryButton("All", isSelected: selectedCategory == "All"),
                  SizedBox(width: 12), // Espacement entre les boutons
                  _categoryButton("Classroom", isSelected: selectedCategory == "Classroom"),
                  SizedBox(width: 12), // Espacement entre les boutons
                  _categoryButton("Offices", isSelected: selectedCategory == "Offices"),
                  SizedBox(width: 12), // Espacement entre les boutons
                  _categoryButton("Laboratory", isSelected: selectedCategory == "Laboratory"),
                ],
              ),
            ),
          ),
          // Affichage des salles avec filtre
          Expanded(
            child: FutureBuilder<List<Room>>(
              future: roomsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }

                if (snapshot.hasData) {
                  rooms = snapshot.data!;
                  List<Room> filteredRooms = rooms.where((room) {
                    return (selectedCategory == "All" || room.roomType == selectedCategory) &&
                           (room.roomName.toLowerCase().contains(searchQuery) ||
                            room.roomType.toLowerCase().contains(searchQuery) ||
                            room.roomAttribution.toLowerCase().contains(searchQuery));
                  }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: filteredRooms.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigation vers la page de détails avec les informations de la salle
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: filteredRooms[index],  // Passe la room comme argument
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Color.fromRGBO(245, 241, 241, 1), width: 1.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${filteredRooms[index].roomName} - ${filteredRooms[index].roomType} - ${filteredRooms[index].roomAttribution}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF565BDB),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                filteredRooms[index].textDescriptor,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return Center(child: Text('Aucune donnée disponible'));
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _categoryButton(String text, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = isSelected ? "All" : text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Padding ajusté
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromRGBO(86, 91, 219, 1) : const Color.fromRGBO(203, 203, 203, 0.3),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Poppins-Medium',
            color: isSelected ? Colors.white : const Color.fromRGBO(124, 124, 124, 1),
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
