import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../Models/Repair.dart';
import '../Methods/fetchRepairs.dart';
import 'addRepair.dart';

class RepairDetailsPage extends StatefulWidget {
  @override
  _RepairDetailsPageState createState() => _RepairDetailsPageState();
}

class _RepairDetailsPageState extends State<RepairDetailsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Repair Details',
          textAlign: TextAlign.center,
        ),
      ),
      body: FutureBuilder<List<Repair>>(
        future: fetchRepairs(),
        builder: (BuildContext context, AsyncSnapshot<List<Repair>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.data);
            print(snapshot.error);
            return Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            List<Repair> repairs = snapshot.data!;

            return ListView.builder(
              itemCount: repairs.length,
              itemBuilder: (BuildContext context, int index) {
                Repair repair = repairs[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /*Text(
                      DateFormat('dd-MM-yyyy    ').format(repair.dateReceive),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),*/
                    Container(
                      margin: EdgeInsets.all(10.0),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(0),
                        border: Border.all(
                          color: const Color.fromARGB(
                              255, 0, 0, 0), // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                      height: 80,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.grey,
                              child: Center(
                                child: Image.asset(
                                  'assets/watchPhoto.jpg',
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              color: Colors.blue.withOpacity(0.3),
                              child: Center(
                                child: Text(
                                  repair?.watchBrand ?? 'N/A',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.blue.withOpacity(0.2),
                              child: Center(
                                child: Text(
                                  repair?.code ?? 'N/A',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: Colors.blue.withOpacity(0.3),
                              child: Center(
                                child: _buildStatusIcon(repair?.lastStatus),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          DateFormat('dd-MM-yyyy    ')
                                              .format(repair.dateReceive),
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9, // Set the width as needed (80% of the screen width in this example)
                                          child: Card(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  height:
                                                      200, // Set the height as needed
                                                  width: double.infinity,
                                                  child: Image.asset(
                                                    'assets/watchPhoto.jpg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                ListTile(
                                                  title: Text(
                                                      'Saat: ${repair?.watchBrand ?? 'N/A'}'),
                                                ),
                                                ListTile(
                                                  title: Text(
                                                      'Kod: ${repair?.code ?? 'N/A'}'),
                                                ),
                                                ListTile(
                                                  title: Text(
                                                      'Sahibi: ${repair?.nameCustomer ?? 'N/A'}'),
                                                ),
                                                ListTile(
                                                  title: Text(
                                                      'Teslim Alan: ${repair?.nameReceiver ?? 'N/A'}'),
                                                ),
                                                ListTile(
                                                  title: Text(
                                                      'İşlem: ${repair?.operation ?? 'N/A'}'),
                                                ),
                                                // Add more ListTile widgets with relevant details
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          // Perform actions based on the selected index if needed
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4.0,
        shape: CircleBorder(),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddRepairPage()), // Replace 'AddRepairPage' with your actual page name
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget _buildStatusIcon(String? status) {
  IconData iconData;
  Color iconColor;

  switch (status) {
    case 'Completed':
      iconData = Icons.check_circle;
      iconColor = const Color.fromARGB(255, 75, 146, 77);
      break;
    case 'Pending':
      iconData = Icons.access_time;
      iconColor = Colors.grey;
      break;
    case 'In Progress':
      iconData = Icons.hourglass_empty;
      iconColor = Colors.grey;
      break;
    default:
      iconData = Icons.remove_circle; // Default icon for 'N/A'
      iconColor = Colors.grey;
  }

  return Icon(
    iconData,
    size: 32, // Adjust the size of the icon as needed
    color: iconColor,
  );
}
