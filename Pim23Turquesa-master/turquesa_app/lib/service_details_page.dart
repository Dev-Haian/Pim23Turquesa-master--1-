//service_details_page.dart

import 'package:flutter/material.dart';
import 'franquias_screen.dart'; // Importe a tela de Franquias

class ServiceDetailsPage extends StatelessWidget {
  final String categoryName;
  final List<dynamic> subcategories;

  ServiceDetailsPage({required this.categoryName, required this.subcategories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Serviços de $categoryName:', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),),
        backgroundColor: const Color.fromARGB(255, 125, 177, 171), // Cor de fundo
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: subcategories.length,
          itemBuilder: (context, index) {
            final service = subcategories[index];
            return GestureDetector(
              onTap: () {
                // Navega para a tela de Franquias passando o serviço selecionado
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FranquiasScreen(selectedService: service),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (service['image'] != null && service['image'].isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            service['image'],
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Preço: \$${service['price']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 67, 65, 65),
                              ),
                            ),
                            if (service['description'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  service['description'],
                                  style: TextStyle(color: Color.fromARGB(255, 67, 65, 65)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
