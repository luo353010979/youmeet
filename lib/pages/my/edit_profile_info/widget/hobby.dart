import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youmeet/common/index.dart';

class HobbyWidget extends StatefulWidget {
  const HobbyWidget({
    super.key,
    this.initialSelected = const [],
    this.onComplet,
  });

  final List<String> initialSelected;
  final ValueChanged<List<String>>? onComplet;

  static const List<String> hobbies = [
    '培训',
    '管理',
    '运营',
    '数据分析',
    '设计',
    'SOP管理',
    '应用开发',
    '风险控制',
    'HRBP',
  ];

  @override
  State<HobbyWidget> createState() => _HobbyWidgetState();
}

class _HobbyWidgetState extends State<HobbyWidget> {
  static const List<Color> _tagColors = [
    Color(0xFFFFE3E3),
    Color(0xFFFFF1D6),
    Color(0xFFE8F6E8),
    Color(0xFFE5F3FF),
    Color(0xFFEEE9FF),
    Color(0xFFFFE9F4),
    Color(0xFFE6FFF5),
    Color(0xFFFFF7CC),
  ];

  final Set<String> _selected = <String>{};
  final Map<String, Color> _hobbyColorMap = <String, Color>{};

  @override
  void initState() {
    super.initState();
    _selected.addAll(
      widget.initialSelected.where(HobbyWidget.hobbies.contains),
    );
    _assignRandomColors();
  }

  void _assignRandomColors() {
    final List<Color> shuffledColors = List<Color>.from(_tagColors)..shuffle();
    for (int i = 0; i < HobbyWidget.hobbies.length; i++) {
      final Color color = shuffledColors[i % shuffledColors.length];
      _hobbyColorMap[HobbyWidget.hobbies[i]] = color;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: Get.height * 0.72,
      padding: EdgeInsets.all(16.w),
      child: Column(children: [_buildTitle(), _buildHobbyGrid(context)]),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ButtonWidget.text(
          LocaleKeys.commonBottomCancel.tr,
          onTap: () => Get.back(),
          textColor: Color(0xFF666666),
          fontSize: 16,
        ),
        TextWidget.h4(LocaleKeys.personalityTags.tr),

        ButtonWidget.text(
          LocaleKeys.commonBottomSave.tr,
          onTap: () {
            widget.onComplet?.call(_selected.toList());
            Get.back();
          },
          fontSize: 16,
        ),
      ],
    ).marginOnly(bottom: 16.h);
  }

  Widget _buildHobbyGrid(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: HobbyWidget.hobbies.map((String hobby) {
        final bool selected = _selected.contains(hobby);
        final Color bgColor = _hobbyColorMap[hobby] ?? _tagColors.first;

        return FilterChip(
          label: Text(hobby),
          selected: selected,
          showCheckmark: false,
          selectedColor: colorScheme.primary.withValues(alpha: 0.18),
          backgroundColor: bgColor,
          side: BorderSide(
            color: selected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: .18),
          ),
          labelStyle: TextStyle(
            color: selected ? colorScheme.primary : const Color(0xFF4A4A4A),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _selected.add(hobby);
              } else {
                _selected.remove(hobby);
              }
            });
          },
        );
      }).toList(),
    );
  }
}
