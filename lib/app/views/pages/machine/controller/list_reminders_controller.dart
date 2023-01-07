import 'package:elephant_control/app/utils/text_field_validators.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/button_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/confirmation_popup.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/snackbar_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_field_widget.dart';
import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:elephant_control/base/services/machine_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../base/models/reminderMachine/reminder_machine.dart';
import '../../widgetsShared/popups/default_popup_widget.dart';

class ListReminderController extends GetxController {
  late final RxList<ReminderMachine> _reminders;
  late final MachineService _machineService;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final TextEditingController _searchReminders;
  late final String _machineId;

  ListReminderController(List<ReminderMachine> reminders, this._machineId) {
    _reminders = RxList<ReminderMachine>(reminders);
    _machineService = MachineService();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _searchReminders = TextEditingController();
    // getReminders();
  }

  List<ReminderMachine> get reminders => searchReminders.text.toLowerCase().trim().isEmpty ? _reminders.where((p0) => p0.active == true).toList() : _reminders.where((p0) => p0.description.toLowerCase().trim().contains(searchReminders.text.toLowerCase().trim()) && p0.active == true).toList();
  TextEditingController get searchReminders => _searchReminders;

  void updateList() => _reminders.refresh();

  Future<void> deleteReminder(ReminderMachine reminder) async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      bool? exclude;
      await showDialog(
          context: Get.context!,
          builder: (context) => StatefulBuilder(builder: (context, setState) {
                return ConfirmationPopup(
                  subTitle: "Deseja excluir o lembrete:\n${reminder.description}?",
                  title: "Excluir lembrete",
                  firstButton: () {
                    exclude = false;
                  },
                  secondButton: () {
                    exclude = true;
                  },
                );
              }));
      if (exclude != true) throw Exception();
      reminder.description = "";
      reminder.active = false;
      await _machineService.createOrEditReminder(reminder);
    } catch (_) {
    } finally {
      loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      updateList();
    }
  }

  Future<void> createOrEditReminder(ReminderMachine? reminder, {bool delet = false}) async {
    final bool edition = reminder != null;
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      TextEditingController description = TextEditingController(text: reminder?.description);
      bool realized = reminder?.realized ?? false;
      final form = GlobalKey<FormState>();
      await showDialog(
          context: Get.context!,
          builder: (context) => StatefulBuilder(builder: (context, setState) {
                return DefaultPopupWidget(
                  title: !edition
                      ? "Criar lembrete"
                      : delet
                          ? "Deletar lembrete"
                          : "Editar lembrete",
                  children: [
                    SizedBox(height: 1.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Form(
                          key: form,
                          child: TextFieldWidget(
                              width: 100.w,
                              height: 9.h,
                              controller: description,
                              hintText: "Lembrete",
                              validator: (value) => TextFieldValidators.defaultValidator(
                                    value,
                                    errorMessage: "Preencha o lembrete",
                                  ))),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: CheckboxListTile(
                        title: const Text("Realizado"),
                        value: realized,
                        onChanged: (value) => setState(() => realized = value ?? false),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ButtonWidget(
                      hintText: !edition
                          ? "Criar"
                          : delet
                              ? "Deletar"
                              : "Editar",
                      onPressed: () {
                        if (!form.currentState!.validate()) return;
                        if (description.text.trim().isNotEmpty) {
                          Get.back();
                        }
                      },
                    ),
                    SizedBox(height: 1.h),
                  ],
                );
              }));
      if (description.text.trim().isEmpty) return;
      if (reminder == null) {
        reminder = ReminderMachine(description: description.text.trim(), realized: realized, machineId: _machineId);
      } else {
        reminder.description = description.text.trim();
        reminder.realized = realized;
      }
      final bool success = await _machineService.createOrEditReminder(reminder);
      if (success) {
        if (edition) {
          reminder = _reminders.firstWhere((element) => element.id == reminder?.id);
          reminder.description = description.text.trim();
          reminder.realized = realized;
        } else {
          _reminders.add(reminder);
        }
      }
    } catch (_) {
      SnackbarWidget(
        warningText: "Não foi possível ${!edition ? "criar" : delet ? "deletar" : "editar"} o lembrete",
        informationText: "",
        backgrondColor: AppColors.defaultColor.withOpacity(0.75),
      );
    } finally {
      loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      updateList();
    }
  }
}
