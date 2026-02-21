import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/features/achievements/models/notification_settings_model.dart';
import 'package:quitease/shared/services/notification/notification_scheduler.dart';
import 'package:quitease/shared/utils/enums.dart';
import 'package:quitease/core/theme/app_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final NotificationScheduler _scheduler = Get.find();

  // Settings state
  late NotificationSettingsModel _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      _settings = await NotificationSettingsModel.load();
      _scheduler.updateSettings(_settings);
    } catch (e) {
      _settings = NotificationSettingsModel(); // Default settings
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveSettings() async {
    try {
      await _settings.save();
      _scheduler.updateSettings(_settings);
      Get.snackbar(
        'Success',
        'Preferences saved successfully',
        backgroundColor: SereneAscentTheme.getColor(
          SereneAscentPaletteColor.successGreen,
        ),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save settings',
        backgroundColor: SereneAscentTheme.getColor(
          SereneAscentPaletteColor.errorRed,
        ),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Notification Settings',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Motivation Section
            _buildSectionHeader('Motivation'),
            const SizedBox(height: 12),
            _buildToggleCard(
              title: 'Daily Check-ins',
              subtitle: 'Get a gentle nudge to log your mood.',
              icon: Icons.wb_sunny_outlined,
              value: _settings.dailyCheckInsEnabled,
              onChanged: (val) =>
                  setState(() => _settings.dailyCheckInsEnabled = val),
            ),
            const SizedBox(height: 16),
            _buildToggleCard(
              title: 'Streak Celebrations',
              subtitle: 'Celebrate your consistency and wins.',
              icon: Icons.celebration_outlined,
              value: _settings.milestonesEnabled,
              onChanged: (val) =>
                  setState(() => _settings.milestonesEnabled = val),
            ),
            const SizedBox(height: 16),
            _buildToggleCard(
              title: 'Wellness Tips',
              subtitle: 'Weekly insights for your journey.',
              icon: Icons.lightbulb_outline,
              value: _settings.cravingTipsEnabled,
              onChanged: (val) =>
                  setState(() => _settings.cravingTipsEnabled = val),
            ),

            const SizedBox(height: 32),

            // Frequency Section
            _buildSectionHeader('Frequency'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildFrequencyCard(
                    title: 'Low',
                    detail: 'Once a day',
                    icon: Icons.eco_outlined,
                    iconColor: Colors.green,
                    isSelected:
                        _settings.frequency == NotificationFrequency.low,
                    onTap: () => setState(
                      () => _settings.frequency = NotificationFrequency.low,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFrequencyCard(
                    title: 'Medium',
                    detail: '3 times/day',
                    icon: Icons.waves,
                    iconColor: Colors.blue,
                    isSelected:
                        _settings.frequency == NotificationFrequency.medium,
                    onTap: () => setState(
                      () => _settings.frequency = NotificationFrequency.medium,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFrequencyCard(
                    title: 'High',
                    detail: 'Hourly',
                    icon: Icons.whatshot,
                    iconColor: Colors.orange,
                    isSelected:
                        _settings.frequency == NotificationFrequency.high,
                    onTap: () => setState(
                      () => _settings.frequency = NotificationFrequency.high,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Quiet Hours Section
            _buildSectionHeader('Quiet Hours'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFECF5FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.nightlight_round,
                          color: Color(0xFF1D7EDC),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Sleep Mode',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              'Mute notifications during sleep.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildCustomSwitch(
                        value: _settings.quietHoursEnabled,
                        onChanged: (val) {
                          setState(() => _settings.quietHoursEnabled = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _settings.quietHoursEnabled ? 1.0 : 0.5,
                          child: IgnorePointer(
                            ignoring: !_settings.quietHoursEnabled,
                            child: _buildTimePickerField(
                              label: 'Start',
                              time: _formatTime(_settings.quietHoursStart),
                              onTap: () => _selectTime(true),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _settings.quietHoursEnabled ? 1.0 : 0.5,
                          child: IgnorePointer(
                            ignoring: !_settings.quietHoursEnabled,
                            child: _buildTimePickerField(
                              label: 'End',
                              time: _formatTime(_settings.quietHoursEnd),
                              onTap: () => _selectTime(false),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Save Preferences',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.check, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1D7EDC), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCustomSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildFrequencyCard({
    required String title,
    required String detail,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1D7EDC) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            else
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              detail,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerField({
    required String label,
    required String time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF94A3B8),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value ? const Color(0xFF1D7EDC) : const Color(0xFFE2E8F0),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int hour) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${h.toString().padLeft(2, '0')}:00 $period';
  }

  Future<void> _selectTime(bool isStart) async {
    final currentHour = isStart
        ? _settings.quietHoursStart
        : _settings.quietHoursEnd;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentHour, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _settings.quietHoursStart = picked.hour;
        } else {
          _settings.quietHoursEnd = picked.hour;
        }
      });
    }
  }
}
