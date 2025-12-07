import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_check_token/app_check_token.dart';
import 'package:flyaway/config/app_config/app_shapes/border_radius.dart';
import 'package:flyaway/config/app_config/app_shapes/media_query.dart';
import 'package:flyaway/config/app_config/app_shared_prefences/app_secure_storage.dart';
import 'package:flyaway/features/profile_features/controller/profile_controller.dart';
import 'package:get/get.dart';

import '../../../config/app_config/app_font_styles/app_font_styles.dart';
import '../../../config/app_config/app_price_format/app_price_format.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LocalStorage? localStorage;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  bool isLoading = true;
  bool _isEditing = false;
  final ProfileController profileController = Get.put(ProfileController());

  // Edit form controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AppCheckToken appCheckToken = AppCheckToken();
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      localStorage = await LocalStorage.getInstance();
      final loadedFirstName = await localStorage!.get('name');
      final loadedLastName = await localStorage!.get('lastName');
      final loadedEmail = await localStorage!.get('email');
      final loadedPhone = await localStorage!.get('phone');

      setState(() {
        firstName = loadedFirstName;
        lastName = loadedLastName;
        email = loadedEmail;
        phoneNumber = loadedPhone;

        // Update controllers
        _firstNameController.text = firstName ?? '';
        _lastNameController.text = lastName ?? '';
        _emailController.text = email ?? '';
        _phoneController.text = phoneNumber ?? '';

        isLoading = false;
      });
      await profileController.getWalletCount(phoneNumber ?? '');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading user data: $e');
    }
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade700, Colors.blueAccent.shade400],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Avatar with animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              color: Colors.white.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.person, size: 60, color: Colors.white),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _isEditing
                        ? _showImagePickerOptions
                        : () => setState(() {
                            _isEditing = true;
                          }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _isEditing ? Colors.white : Colors.blue.shade800,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isEditing ? Icons.camera_alt : Icons.edit,
                        size: 18,
                        color: _isEditing ? Colors.blue.shade800 : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Name with edit mode
          _isEditing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'First Name',
                          hintStyle: AppFontStyles().FirstFontStyleWidget(
                            12.sp,
                            Colors.white,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          hintStyle: AppFontStyles().FirstFontStyleWidget(
                            12.sp,
                            Colors.white,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                )
              : Text(
                  '${firstName ?? 'First'} ${lastName ?? 'Last'}',
                  style: AppFontStyles().FirstFontStyleWidget(
                    20.sp,
                    Colors.white,
                  ),
                ),

          const SizedBox(height: 8),

          // Email with edit mode
          // Email with edit mode
          _isEditing
              ? SizedBox(
                  width: 250,
                  child: TextFormField(
                    controller: _emailController,
                    style: AppFontStyles().FirstFontStyleWidget(
                      12.sp,
                      Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: AppFontStyles().FirstFontStyleWidget(
                        12.sp,
                        Colors.white,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                )
              : (email != null && email!.isNotEmpty)
              ? Text(
                  email!,
                  style: AppFontStyles().FirstFontStyleWidget(
                    12.sp,
                    Colors.black,
                  ),
                )
              : Container(), // Or SizedBox.shrink()
          // Edit mode action buttons
          if (_isEditing) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
                  ),
                  child: Text('saveChanges'.tr),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                      // Reset controllers to original values
                      _firstNameController.text = firstName ?? '';
                      _lastNameController.text = lastName ?? '';
                      _emailController.text = email ?? '';
                      _phoneController.text = phoneNumber ?? '';
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                  ),
                  child: Text('cancel'.tr),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String title,
    String? value,
    String? fieldKey,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.blue.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade50,
                    Colors.blue.shade100.withOpacity(0.5),
                  ],
                ),
              ),
              child: Icon(icon, color: Colors.blue.shade800, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFontStyles().FirstFontStyleWidget(
                      11.sp,
                      Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _isEditing && fieldKey != null
                      ? _buildEditableField(fieldKey, value ?? '')
                      : Text(
                          value ?? 'notSet'.tr,
                          style: AppFontStyles().FirstFontStyleWidget(
                            12.sp,
                            Colors.blue,
                          ),
                        ),
                ],
              ),
            ),
            if (!_isEditing)
              Icon(Icons.chevron_right, color: Colors.blue.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String fieldKey, String currentValue) {
    TextEditingController controller;
    TextInputType keyboardType;
    String hintText;

    switch (fieldKey) {
      case 'email':
        controller = _emailController;
        keyboardType = TextInputType.emailAddress;
        hintText = 'enterEmail';
        break;
      case 'phone':
        controller = _phoneController;
        keyboardType = TextInputType.phone;
        hintText = 'enterPhoneNumber';
        break;
      default:
        controller = TextEditingController(text: currentValue);
        keyboardType = TextInputType.text;
        hintText = 'Enter value';
    }

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintStyle: AppFontStyles().FirstFontStyleWidget(12.sp, Colors.white),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade500, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        isDense: true,
      ),
      validator: (value) {
        if (fieldKey == 'email' && value != null && value.isNotEmpty) {
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email';
          }
        }
        if (fieldKey == 'phone' && value != null && value.isNotEmpty) {
          if (!RegExp(r'^[0-9+\-\s]{10,}$').hasMatch(value)) {
            return 'Please enter a valid phone number';
          }
        }
        return null;
      },
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    bool isLogout = false,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isLogout
                  ? [Colors.red.shade50, Colors.red.shade100.withOpacity(0.5)]
                  : [
                      Colors.blue.shade50,
                      Colors.blue.shade100.withOpacity(0.5),
                    ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isLogout
                ? Colors.red.shade700
                : color ?? Colors.blue.shade700,
            size: 22,
          ),
        ),
        title: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red.shade700 : color ?? Colors.black,
            fontSize: 15,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isLogout ? Colors.red.shade700 : Colors.grey.shade500,
          size: 24,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.transparent,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading your profile...',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Column(
      children: [
        _buildProfileHeader(),
        const SizedBox(height: 24),

        // Personal Information Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.person_outline, color: Colors.blue.shade700, size: 22),
              const SizedBox(width: 10),
              Text(
                'personalInformation'.tr,
                style: AppFontStyles().FirstFontStyleWidget(
                  14.sp,
                  Colors.black,
                ),
              ),
              const Spacer(),
              if (!_isEditing)
                InkWell(
                  onTap: () => setState(() {
                    _isEditing = true;
                  }),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16, color: Colors.blue.shade700),
                        const SizedBox(width: 6),
                        Text(
                          'edit'.tr,
                          style: AppFontStyles().FirstFontStyleWidget(
                            12.sp,
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _buildInfoCard(
          Icons.person,
          'fullName'.tr,
          '$firstName $lastName',
          null,
        ),
        _buildInfoCard(Icons.email, 'emailAddress'.tr, email, 'email'),
        _buildInfoCard(Icons.phone, 'phoneNumber'.tr, phoneNumber, 'phone'),
        GestureDetector(
          onTap: () => Get.toNamed('/add_wallet_count'),
          child: Obx(() => _buildInfoCard(
            Icons.wallet,
            'walletCount'.tr,
            formatNumber(profileController.walletCount.value),
            null,
          )),
        ),


        const SizedBox(height: 24),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: getBorderRadiusFunc(10)),
            fixedSize: Size(
              getWidth(context, 0.8.sp),
              getHeight(context, 0.05.sp),
            ),
          ),
          onPressed: () async{
            localStorage = await LocalStorage.getInstance();
            await localStorage!.clear();
            await appCheckToken.checkToken();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.exit_to_app  , color: Colors.white, size: 18.sp,),
              Text(
                'exitToApp'.tr,
                style: AppFontStyles().FirstFontStyleWidget(
                  14.sp,
                  Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // Implement camera functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // Implement gallery functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Remove Photo',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                // Implement remove photo
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? true) {
      try {
        setState(() {
          isLoading = true;
        });

        // Save to local storage
        await localStorage!.set('name', _firstNameController.text);
        await localStorage!.set('lastName', _lastNameController.text);
        await localStorage!.set('email', _emailController.text);
        await localStorage!.set('phone', _phoneController.text);

        // Update state
        setState(() {
          firstName = _firstNameController.text;
          lastName = _lastNameController.text;
          email = _emailController.text;
          phoneNumber = _phoneController.text;
          _isEditing = false;
          isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _changePassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => _buildChangePasswordSheet(),
    );
  }

  Widget _buildChangePasswordSheet() {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Change Password',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Current Password',
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'New Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              prefixIcon: const Icon(Icons.lock_reset),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Update Password',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _privacySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Privacy Settings')),
          body: ListView(
            children: const [
              ListTile(
                title: Text('Profile Visibility'),
                subtitle: Text('Control who can see your profile'),
                trailing: Icon(Icons.chevron_right),
              ),
              ListTile(
                title: Text('Data Sharing'),
                subtitle: Text('Manage data sharing preferences'),
                trailing: Icon(Icons.chevron_right),
              ),
              ListTile(
                title: Text('Delete Account'),
                subtitle: Text('Permanently delete your account'),
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _notificationSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Notification Settings')),
          body: ListView(
            children: const [
              SwitchListTile(
                title: Text('Push Notifications'),
                subtitle: Text('Receive push notifications'),
                value: true,
                onChanged: null,
              ),
              SwitchListTile(
                title: Text('Email Notifications'),
                subtitle: Text('Receive email updates'),
                value: true,
                onChanged: null,
              ),
              SwitchListTile(
                title: Text('SMS Notifications'),
                subtitle: Text('Receive SMS updates'),
                value: false,
                onChanged: null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform logout logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshProfile() async {
    setState(() {
      isLoading = true;
    });
    await _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    profileController.onInit();
    return RefreshIndicator(
      onRefresh: () async => profileController.onInit(),
      child: Scaffold(
        body: SafeArea(
          child: isLoading
              ? _buildLoadingState()
              : RefreshIndicator(
                  onRefresh: _refreshProfile,
                  color: Colors.blue.shade700,
                  backgroundColor: Colors.white,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [SliverToBoxAdapter(child: _buildProfileContent())],
                  ),
                ),
        ),
        // Floating Action Button with conditional visibility
        // floatingActionButton: _isEditing
        //     ? null
        //     : FloatingActionButton.extended(
        //         onPressed: () => setState(() {
        //           _isEditing = true;
        //         }),
        //         backgroundColor: Colors.blue.shade700,
        //         foregroundColor: Colors.white,
        //         elevation: 4,
        //         icon: const Icon(Icons.edit),
        //         label: Text(
        //           'editProfile'.tr,
        //           style: AppFontStyles().FirstFontStyleWidget(
        //             13.sp,
        //             Colors.white,
        //           ),
        //         ),
        //       ),
      ),
    );
  }
}
