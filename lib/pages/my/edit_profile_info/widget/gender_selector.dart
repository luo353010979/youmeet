import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class GenderPickerWidget extends StatelessWidget {
  const GenderPickerWidget({super.key, this.currentGender});

  final int? currentGender;

  Widget _buildOption({
    required BuildContext context,
    required String title,
    required int value,
    required bool selected,
  }) {
    return InkWell(
      onTap: () => Get.back(result: value),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEEF8FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF16C4FF) : const Color(0xFFECECEC),
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: selected
                    ? const Color(0xFF1293BF)
                    : const Color(0xFF333333),
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF16C4FF),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedGender = currentGender ?? UserService.to.profile.sex ?? 1;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFDADADA),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Text(
            LocaleKeys.gender.tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 12),
          _buildOption(
            context: context,
            title: LocaleKeys.man.tr,
            value: 1,
            selected: selectedGender == 1,
          ),
          const SizedBox(height: 10),
          _buildOption(
            context: context,
            title: LocaleKeys.woman.tr,
            value: 2,
            selected: selectedGender == 2,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              LocaleKeys.commonBottomCancel.tr,
              style: const TextStyle(fontSize: 15, color: Color(0xFF666666)),
            ),
          ),
        ],
      ),
    );
  }
}
