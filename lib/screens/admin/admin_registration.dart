// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../model/hive_voters_info.dart';

class AdminRegistration extends StatefulWidget {
  const AdminRegistration({super.key});

  @override
  _AdminRegistrationState createState() => _AdminRegistrationState();
}

class _AdminRegistrationState extends State<AdminRegistration> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _birthdateController = TextEditingController();

  String? _selectedSex; // State variable for dropdown selection

  final _voterData = HiveVotersInfo(
    firstName: '',
    middleName: '',
    lastName: '',
    sex: '',
    birthdate: '',
    address: '',
    contactNumber: '',
    emailAddress: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voter Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildTextField(
                  'First Name', (value) => _voterData.firstName = value),
              _buildTextField(
                  'Middle Name', (value) => _voterData.middleName = value),
              _buildTextField(
                  'Last Name', (value) => _voterData.lastName = value),
              _buildDropdownField('Sex', ['Male', 'Female', 'Other'],
                  (value) => _voterData.sex = value!),
              _buildDateField(
                  'Birthdate', (value) => _voterData.birthdate = value),
              _buildTextField('Address', (value) => _voterData.address = value),
              _buildTextField(
                  'Contact Number', (value) => _voterData.contactNumber = value,
                  keyboardType: TextInputType.phone),
              _buildTextField(
                  'Email Address', (value) => _voterData.emailAddress = value,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerVoter,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onSaved,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onSaved: (value) => onSaved(value!),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: _selectedSex, // Bind to state variable
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedSex = newValue; // Update state variable
          });
          onChanged(newValue);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField(String label, Function(String) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _birthdateController, // Use the persistent controller
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            String formattedDate = "${pickedDate.toLocal()}".split(' ')[0];
            setState(() {
              _birthdateController.text =
                  formattedDate; // Update controller text
              onSaved(formattedDate); // Save the selected date
            });
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  void _registerVoter() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final box = Hive.box<HiveVotersInfo>('votersBox');
      await box.add(_voterData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voter registered successfully!')),
      );

      // Clear the form
      _formKey.currentState!.reset();
      setState(() {
        _selectedSex = null; // Reset dropdown
        _birthdateController.clear(); // Reset date field
      });
    }
  }
}
