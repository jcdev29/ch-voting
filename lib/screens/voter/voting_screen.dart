// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../model/hive_voters_info.dart';

class VotingScreen extends StatefulWidget {
  final HiveVotersInfo voter;

  const VotingScreen({super.key, required this.voter});

  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  final List<String> _presidents = [
    'President A',
    'President B',
    'President C',
    'President D'
  ];
  final List<String> _vicePresidents = ['Vice A', 'Vice B', 'Vice C', 'Vice D'];
  final List<String> _senators = [
    'Senator A',
    'Senator B',
    'Senator C',
    'Senator D',
    'Senator E',
    'Senator F',
    'Senator G',
    'Senator H'
  ];

  String? _selectedPresident;
  String? _selectedVicePresident;
  final List<String> _selectedSenators = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vote for Your Leaders'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('President (Choose 1)'),
                  ..._buildRadioList(_presidents, _selectedPresident, (value) {
                    setState(() {
                      _selectedPresident = value;
                    });
                  }),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Vice President (Choose 1)'),
                  ..._buildRadioList(_vicePresidents, _selectedVicePresident,
                      (value) {
                    setState(() {
                      _selectedVicePresident = value;
                    });
                  }),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Senators (Choose up to 4)'),
                  ..._buildCheckboxList(_senators, _selectedSenators, 4),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _selectedPresident != null &&
                              _selectedVicePresident != null &&
                              _selectedSenators.length == 4
                          ? _showSummaryDialog
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'Submit Vote',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  List<Widget> _buildRadioList(List<String> options, String? selectedValue,
      Function(String?) onChanged) {
    return options
        .map(
          (option) => RadioListTile<String>(
            title: Text(option, style: const TextStyle(fontSize: 16)),
            value: option,
            groupValue: selectedValue,
            activeColor: Colors.deepPurple,
            onChanged: onChanged,
          ),
        )
        .toList();
  }

  List<Widget> _buildCheckboxList(
      List<String> options, List<String> selectedValues, int maxSelection) {
    return options
        .map(
          (option) => CheckboxListTile(
            title: Text(option, style: const TextStyle(fontSize: 16)),
            value: selectedValues.contains(option),
            activeColor: Colors.deepPurple,
            onChanged: (bool? checked) {
              if (checked == true && selectedValues.length < maxSelection) {
                setState(() {
                  selectedValues.add(option);
                });
              } else if (checked == false) {
                setState(() {
                  selectedValues.remove(option);
                });
              }
            },
          ),
        )
        .toList();
  }

  void _showSummaryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Your Vote'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('President: $_selectedPresident'),
              Text('Vice President: $_selectedVicePresident'),
              Text('Senators: ${_selectedSenators.join(', ')}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                _saveVote();
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _saveVote() async {
    final box =
        await Hive.openBox<HiveVotersInfo>('votersBox'); // Open the Hive box

    final currentLoggedVoter = widget.voter;

    if (currentLoggedVoter != null) {
      final currentVoter = currentLoggedVoter; // Get the current voter

      // Update the voter's choices
      currentVoter.chosenPresident = _selectedPresident;
      currentVoter.chosenVicePresident = _selectedVicePresident;
      currentVoter.chosenSenators = _selectedSenators;

      // Save the updated voter back to Hive
      final voterKey =
          box.keys.firstWhere((key) => box.get(key) == currentVoter);
      await box.put(voterKey, currentVoter);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vote saved successfully!')),
      );

      _goToDashboard(); // Navigate to the dashboard
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No current voter found.')),
      );
    }
  }

  void _goToDashboard() {
    // Navigate back to the dashboard
    Navigator.pop(context);
  }
}
