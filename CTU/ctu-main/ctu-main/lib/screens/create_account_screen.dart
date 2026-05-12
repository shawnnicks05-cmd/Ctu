import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/auth_provider.dart';
import '../services/autofill_service.dart';
import '../utils/app_theme.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _fullName = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _department = TextEditingController();
  final _yearLevel = TextEditingController();
  final _section = TextEditingController();

  bool _obscure = true;
  String? _selectedUserType;
  final AutofillService _autofillService = AutofillService();
  
  // List of colleges for dropdown
  final List<String> _departments = [
    'College of Engineering',
    'College of Arts and Sciences',
    'College of Education',
    'College of Technology',
    'College of Agriculture and Forestry',
    'College of Maritime Education',
    'College of Nursing',
    'College of Business and Management',
  ];
  
  String? _selectedDepartment;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _fullName.dispose();
    _phoneNumber.dispose();
    _department.dispose();
    _yearLevel.dispose();
    _section.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    await authProvider.signUpWithEmailAndDetails(
      email: _email.text.trim(),
      password: _password.text,
      fullName: _fullName.text.trim(),
      phoneNumber: _phoneNumber.text.trim(),
      department: _selectedDepartment ?? '',
      yearLevel: _yearLevel.text.trim(),
      section: _section.text.trim(),
      userType: _selectedUserType ?? '',
    );

    if (!mounted) return;

    if (authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage!,
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Save credentials for auto-fill on login screen
      await _autofillService.saveUserInfo(
        email: _email.text.trim(),
        password: _password.text,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created successfully!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      
      // Navigate back to login screen after successful signup
      Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: AppColors.primary,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 420,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.school,
                              size: 60,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Email Field
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration(
                      label: 'Email',
                      hint: 'name@ctu.edu.ph',
                      icon: Icons.email_outlined,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Enter your email';
                      }

                      if (!v.contains('@')) {
                        return 'Enter valid email';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Password Field
                  TextFormField(
                    controller: _password,
                    obscureText: _obscure,
                    decoration: _inputDecoration(
                      label: 'Password',
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.length < 6) {
                        return 'Minimum 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Full Name Field
                  TextFormField(
                    controller: _fullName,
                    decoration: _inputDecoration(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      icon: Icons.person_outline,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Phone Number Field
                  TextFormField(
                    controller: _phoneNumber,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration(
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      icon: Icons.phone_outlined,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // User Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedUserType,
                    decoration: _inputDecoration(
                      label: 'User Type',
                      hint: 'Select user type',
                      icon: Icons.person_outline,
                    ),
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'Student',
                        child: Text('Student'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Professor',
                        child: Text('Professor'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedUserType = newValue;
                      });
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please select your user type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // College Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    decoration: _inputDecoration(
                      label: 'College',
                      hint: 'Select college',
                      icon: Icons.school_outlined,
                    ).copyWith(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    isExpanded: true,
                    menuMaxHeight: 200,
                    items: _departments.map((String department) {
                      return DropdownMenuItem<String>(
                        value: department,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 300),
                          child: Text(
                            department,
                            style: GoogleFonts.poppins(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDepartment = newValue;
                      });
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please select your college';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Year Level Field
                  TextFormField(
                    controller: _yearLevel,
                    decoration: _inputDecoration(
                      label: 'Year Level',
                      hint: 'e.g., 1st Year, 2nd Year',
                      icon: Icons.trending_up_outlined,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Enter your year level';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Section Field
                  TextFormField(
                    controller: _section,
                    decoration: _inputDecoration(
                      label: 'Section',
                      hint: 'e.g., A, B, C',
                      icon: Icons.group_outlined,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Enter your section';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return ElevatedButton(
                          onPressed: authProvider.isLoading ? null : _createAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Create Account',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        );
                      },
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
}
