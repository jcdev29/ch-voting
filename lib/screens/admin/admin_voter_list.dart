// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../model/hive_voters_info.dart';

class AdminVotersList extends StatefulWidget {
  const AdminVotersList({super.key});

  @override
  _AdminVotersListState createState() => _AdminVotersListState();
}

class _AdminVotersListState extends State<AdminVotersList> {
  late Box<HiveVotersInfo> _votersBox;
  int? _expandedIndex; // Keeps track of the expanded voter

  @override
  void initState() {
    super.initState();
    _votersBox = Hive.box<HiveVotersInfo>('votersBox'); // Open the Hive box
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voters List'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _votersBox.listenable(),
        builder: (context, Box<HiveVotersInfo> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people, size: 100, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'No voters registered yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final voter = box.getAt(index);
              final isExpanded = _expandedIndex == index;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: isExpanded ? Colors.deepPurple[50] : null,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        '${voter?.firstName} ${voter?.lastName}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more),
                      onTap: () {
                        setState(() {
                          _expandedIndex = isExpanded ? null : index;
                        });
                      },
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${voter?.emailAddress ?? ""}'),
                            Text('Sex: ${voter?.sex ?? ""}'),
                            Text('Birthdate: ${voter?.birthdate ?? ""}'),
                            Text('Address: ${voter?.address ?? ""}'),
                            Text('Contact: ${voter?.contactNumber ?? ""}'),
                            Text(
                                'Chosen President: ${voter?.chosenPresident ?? ""}'),
                            Text(
                                'Chosen Vice President: ${voter?.chosenVicePresident ?? ""}'),
                            Text(
                                'Chosen Senators: ${voter?.chosenSenators ?? ""}'),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateVoterScreen(
                                        voter: voter!,
                                        index: index,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Update Voter'),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UpdateVoterScreen extends StatefulWidget {
  final HiveVotersInfo voter;
  final int index;

  const UpdateVoterScreen({
    super.key,
    required this.voter,
    required this.index,
  });

  @override
  _UpdateVoterScreenState createState() => _UpdateVoterScreenState();
}

class _UpdateVoterScreenState extends State<UpdateVoterScreen> {
  final _formKey = GlobalKey<FormState>();
  late HiveVotersInfo _updatedVoter;

  @override
  void initState() {
    super.initState();
    _updatedVoter = widget.voter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Voter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                label: 'First Name',
                initialValue: _updatedVoter.firstName,
                onChanged: (value) => _updatedVoter.firstName = value,
              ),
              CustomTextField(
                label: 'Middle Name',
                initialValue: _updatedVoter.middleName,
                onChanged: (value) => _updatedVoter.middleName = value,
              ),
              CustomTextField(
                label: 'Last Name',
                initialValue: _updatedVoter.lastName,
                onChanged: (value) => _updatedVoter.lastName = value,
              ),
              CustomTextField(
                label: 'Address',
                initialValue: _updatedVoter.address,
                onChanged: (value) => _updatedVoter.address = value,
              ),
              CustomTextField(
                label: 'Contact Number',
                initialValue: _updatedVoter.contactNumber,
                onChanged: (value) => _updatedVoter.contactNumber = value,
                keyboardType: TextInputType.phone,
              ),
              CustomTextField(
                label: 'Email Address',
                initialValue: _updatedVoter.emailAddress,
                onChanged: (value) => _updatedVoter.emailAddress = value,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateVoter,
                child: const Text('Update Voter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateVoter() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final box = Hive.box<HiveVotersInfo>('votersBox');
      await box.putAt(widget.index, _updatedVoter);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Voter information updated successfully!')),
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Voter details have been updated.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      ).then((_) => Navigator.pop(context));
    }
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final Function(String) onChanged;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
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
        onChanged: (value) => onChanged(value),
      ),
    );
  }
}
