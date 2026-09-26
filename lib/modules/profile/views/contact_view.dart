import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../../../data/models/misc_models.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});
  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  final name = TextEditingController();
  final email = TextEditingController();
  final subject = TextEditingController();
  final message = TextEditingController();
  bool submitting = false;

  @override
  void dispose() { name.dispose(); email.dispose(); subject.dispose(); message.dispose(); super.dispose(); }

  Future<void> submit() async {
    if (name.text.trim().isEmpty || !GetUtils.isEmail(email.text.trim()) || subject.text.trim().isEmpty || message.text.trim().isEmpty) {
      Get.snackbar('Check your details', 'Please complete Name, valid Email, Subject and Message.');
      return;
    }
    setState(() => submitting = true);
    try {
      final inquiry = InquiryModel(
        id: const Uuid().v4(),
        name: name.text.trim(),
        email: email.text.trim(),
        subject: subject.text.trim(),
        message: message.text.trim(),
        createdAt: DateTime.now(),
      );
      await Get.find<LocalStorageService>().saveInquiry(inquiry.toMap());
      if (!mounted) return;
      name.clear(); email.clear(); subject.clear(); message.clear();
      Get.snackbar('Submitted', 'Your inquiry has been submitted successfully.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Contact Us')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Get in touch', style: AppTypography.headingLarge),
        const SizedBox(height: 6),
        Text('Project contact details are not configured in this build. Use the inquiry form to save a support request locally.', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.lg),
        Text('Organization contact', style: AppTypography.headingSmall),
        const SizedBox(height: 6),
        Text('Email, phone, support hours and office address are not configured in the supplied project.', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.md),
        Text('Office location', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.sm),
        Container(
          height: 190, width: double.infinity, clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.border)),
          child: AppConstants.officeLatitude != null && AppConstants.officeLongitude != null && AppConstants.googleMapsApiKey != 'YOUR_GOOGLE_MAPS_API_KEY'
              ? GoogleMap(
                  initialCameraPosition: CameraPosition(target: LatLng(AppConstants.officeLatitude!, AppConstants.officeLongitude!), zoom: 14),
                  markers: {Marker(markerId: const MarkerId('office'), position: LatLng(AppConstants.officeLatitude!, AppConstants.officeLongitude!), infoWindow: const InfoWindow(title: 'Fandom Verse Office'))},
                )
              : Center(child: Text(
                  'Add the real office coordinates and Google Maps key in AppConstants to enable the live map.\n\n${AppConstants.officeAddress}',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall,
                )),
        ),
        if (AppConstants.officeLatitude != null && AppConstants.officeLongitude != null)
          TextButton.icon(onPressed: () => launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${AppConstants.officeLatitude},${AppConstants.officeLongitude}'), mode: LaunchMode.externalApplication), icon: const FVIcon(Icons.directions), label: const Text('Directions')),
        const SizedBox(height: AppSpacing.lg),
        FVTextField(label: 'Name', controller: name),
        const SizedBox(height: 16),
        FVTextField(label: 'Email', controller: email, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        FVTextField(label: 'Subject', controller: subject),
        const SizedBox(height: 16),
        FVTextField(label: 'Message', controller: message, maxLines: 6),
        const SizedBox(height: 20),
        FVButton(text: 'Submit Inquiry', onPressed: submit, isLoading: submitting),
      ]),
    ),
  );
}
