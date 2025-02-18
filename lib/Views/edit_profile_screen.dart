
import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150', // Replace with actual profile picture URL
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: MediaQuery.of(context).size.width / 2 - 30,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.edit, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Edit Profile Title
                  Center(
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // First Name Field
                  buildTextField("First Name", "Sabrina"),

                  // Last Name Field
                  buildTextField("Last Name", "Aryan"),

                  // Username Field
                  buildTextField("Username", "@Sabrina"),

                  // Email Field
                  buildTextField("Email", "SabrinaAry208@gmail.com"),

                  // Phone Number Field
                  buildTextField("Phone Number", "+234 904 6470"),

                  // Birth Field
                  buildDropdownField("Birth"),

                  // Gender Field
                  buildDropdownField("Gender"),

                  SizedBox(height: 20),

                  // Change Password Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Add Change Password functionality
                      },
                      icon: Icon(Icons.lock),
                      label: Text("Change Password"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField(String labelText) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: [
              DropdownMenuItem(value: "Option 1", child: Text("Option 1")),
              DropdownMenuItem(value: "Option 2", child: Text("Option 2")),
            ],
            onChanged: (value) {
              // Handle dropdown value change
            },
            ),
     );
    }
}
