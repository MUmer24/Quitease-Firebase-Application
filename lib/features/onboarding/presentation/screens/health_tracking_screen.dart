import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/features/onboarding/presentation/controllers/health_tracking_controller.dart';
import 'package:quitease/core/constants/app_constants.dart';

class HealthTrackingScreen extends StatelessWidget {
  final HealthTrackingController controller = Get.put(
    HealthTrackingController(),
  );

  HealthTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.healthTrackingScreenAppbarTitle),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField(
                controller: controller.cigsPerDayController,
                label: AppConstants.cigsPerDayLbl,
                icon: AppConstants.calendarIcon,
                validator: controller.validateNumber,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.cigsPerPackController,
                label: AppConstants.cigsPerPackLbl,
                icon: AppConstants.fireIcon,
                validator: controller.validateNumber,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.pricePerPackController,
                label: AppConstants.pricePerPackLbl,
                icon: AppConstants.moneyIcon,
                validator: controller.validateNumber,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: controller.navigateToSummary,
                child: Text(AppConstants.nextBtn),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: validator,
    );
  }
}
