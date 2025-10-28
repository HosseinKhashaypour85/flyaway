import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_config/app_localization_config/language_service.dart';

class LanguageBottomSheet {
  final LanguageService languageService = LanguageService();

  void showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(
            top: 16,
            left: 20,
            right: 20,
            bottom: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                children: [
                  Icon(
                    Icons.language_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "change_language".tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "select_preferred_language".tr,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // Language options - Using GetX to get current locale
              _buildLanguageOption(
                languageCode: 'fa',
                languageName: "فارسی",
                nativeName: "Persian",
                flag: "🇮🇷",
                context: context,
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                languageCode: 'en',
                languageName: "English",
                nativeName: "English",
                flag: "🇺🇸",
                context: context,
              ),

              // Close button
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    "cancel".tr,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required String languageCode,
    required String languageName,
    required String nativeName,
    required String flag,
    required BuildContext context,
  }) {
    // Use Get.locale instead of Localizations.localeOf(context)
    final currentLocale = Get.locale;
    final isSelected = currentLocale?.languageCode == languageCode;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Get.theme.primaryColor.withOpacity(0.1)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Get.theme.primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: Text(flag, style: const TextStyle(fontSize: 20)),
          ),
        ),
        title: Text(
          languageName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Get.theme.primaryColor : Colors.black87,
          ),
        ),
        subtitle: Text(
          nativeName,
          style: TextStyle(
            fontSize: 14,
            color: isSelected
                ? Get.theme.primaryColor.withOpacity(0.8)
                : Colors.grey[600],
          ),
        ),
        trailing: isSelected
            ? Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 16),
              )
            : null,
        onTap: () {
          languageService.setLanguage(languageCode);
          Navigator.pop(context);
        },
      ),
    );
  }
}
