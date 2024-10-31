import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? '';
      _ageController.text = prefs.getInt('user_age')?.toString() ?? '';
      _heightController.text = prefs.getDouble('user_height')?.toString() ?? '';
      _weightController.text = prefs.getDouble('user_weight')?.toString() ?? '';
    });
  }

  Future<void> _saveProfileData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', _nameController.text);
        await prefs.setInt('user_age', int.parse(_ageController.text));
        await prefs.setDouble('user_height', double.parse(_heightController.text));
        await prefs.setDouble('user_weight', double.parse(_weightController.text));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating profile: $e')),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveProfileData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(Icons.person, size: 50, color: Colors.blue.shade900),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter your age' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _heightController,
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.height),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter your height' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.line_weight),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter your weight' : null,
                   ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfileData,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(_isLoading ? 'Saving...' : 'Save Profile'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}