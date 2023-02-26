import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../base/viewControllers/report_viewcontroller.dart';
import 'date_format_to_brazil.dart';
import 'format_numbers.dart';

class GenerateReportPdf {
  static double get height => 29.7 * PdfPageFormat.cm;
  static double get width => 21.0 * PdfPageFormat.cm;
  static List<List<String>> saveList = <List<String>>[];
  static List<Widget> widgets = <Widget>[];

  static Future<File?> generateGeneralPdf(List<String>? machines, ReportViewController reportViewController, String reportPeriod, {bool closing = false}) async {
    try {
      saveList.clear();
      final doc = Document(pageMode: PdfPageMode.outlines);
      if(machines != null && machines.length > 50){
        List<String> tempList = <String>[];
        for(int i = 0; i < 50; i++){
          tempList.add(machines[i]);
        }
        List<String> secondTempList = <String>[];
        secondTempList.addAll(tempList);
        saveList.add(secondTempList);
        tempList.clear();
        int index = 50;
        int limitIndex = 99;
        while(index < machines.length){
          tempList.add(machines[index]);
          index++;
          if(index == limitIndex){
            limitIndex += 50;
            List<String> thirdTempList = <String>[];
            thirdTempList.addAll(tempList);
            saveList.add(thirdTempList);
            tempList.clear();
          }
          else if(index == machines.length){
            List<String> thirdTempList = <String>[];
            thirdTempList.addAll(tempList);
            saveList.add(thirdTempList);
            break;
          }
        }
      }
      else if(machines != null && machines.isNotEmpty){
        saveList.add(machines);
      }
      generateManyLists("Máquinas Visitadas");

      doc.addPage(
        MultiPage(
          maxPages: 1000,
          pageTheme: const PageTheme(
            pageFormat: PdfPageFormat.a4,
            margin: EdgeInsets.zero,
            orientation: PageOrientation.portrait,
          ),
          build: (context) {
            return [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.025, horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Column(
                          children: [
                            TitlePdf(
                              title: closing ? "RELATÓRIO DE FECHAMENTO" : "RELATÓRIO GERAL",
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            TitlePdf(
                              title: "Data do relatório: " + DateFormatToBrazil.formatDateAndHour(DateTime.now()),
                              fontSize: 10,
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            TitlePdf(
                              title: (closing ? "Mês de fechamento do relatório: " : "Período do relatório: ") + reportPeriod,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    TitleDescriptionWidget(
                      title: "Total de pelúcias adicionadas nas máquinas",
                      description: FormatNumbers.scoreIntNumber(reportViewController.plushAdded),
                    ),
                    TitleDescriptionWidget(
                      title: "Total de pelúcias que saíram das máquinas",
                      description: FormatNumbers.scoreIntNumber(reportViewController.plushRemoved),
                    ),
                    TitleDescriptionWidget(
                      title: "Total de pelúcias estimado nas máquinas",
                      description: FormatNumbers.scoreIntNumber(reportViewController.plushInTheMachine),
                    ),
                    TitleDescriptionWidget(
                      title: "Valor das máquinas",
                      description: FormatNumbers.intToMoney(reportViewController.machineValue),
                    ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: TitleDescriptionWidget(
                          title: "Valor Dinheiro",
                          description: FormatNumbers.numbersToMoney(reportViewController.totalPouchValue),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: TitleDescriptionWidget(
                          title: "Valor PIX",
                          description: FormatNumbers.numbersToMoney(reportViewController.pixValue!),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: TitleDescriptionWidget(
                          title: "Valor Cartão de Crédito",
                          description: FormatNumbers.numbersToMoney(reportViewController.creditValue),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: TitleDescriptionWidget(
                          title: "Valor Cartão de Débito",
                          description: FormatNumbers.numbersToMoney(reportViewController.debitValue),
                        ),
                      ),
                    TitleDescriptionWidget(
                      title: "Quantidade de visitas nas máquinas",
                      description: FormatNumbers.scoreIntNumber(reportViewController.numbersOfVisits),
                    ),
                    TitleDescriptionWidget(
                      title: "Quantidade de vezes que os malotes foram coletados",
                      description: FormatNumbers.scoreIntNumber(reportViewController.numbersOfPouchRemoved),
                    ),
                    TitleDescriptionWidget(
                      title: "Valor total cartão de crédito dos malotes",
                      description: FormatNumbers.numbersToMoney(reportViewController.creditValue),
                    ),
                    TitleDescriptionWidget(
                      title: "Valor total cartão de débito dos malotes",
                      description: FormatNumbers.numbersToMoney(reportViewController.debitValue),
                    ),
                    TitleDescriptionWidget(
                      title: "Valor total PIX dos malotes",
                      description: FormatNumbers.numbersToMoney(reportViewController.pixValue),),
                    TitleDescriptionWidget(
                      title: "Valor total dos malotes",
                      description: FormatNumbers.numbersToMoney(reportViewController.totalPouchValue),
                    ),
                    TitleDescriptionWidget(
                      title: "Quantidade de vezes em que as máquinas estiveram fora da média",
                      description: FormatNumbers.scoreIntNumber(reportViewController.numbersOfTimesOutOffAverage),
                    ),
                    if(saveList.isNotEmpty && saveList.length == 1)
                      TitleListWidget(
                        title: "Máquinas Visitadas",
                        listInformations: saveList[0],
                      ),
                    if(saveList.isNotEmpty && saveList.length > 1)
                      for(var widget in widgets)
                        widget,
                  ],
                ),
              ),
            ];
          },
        ),
      );

      final documentoPdfGerado = await doc.save();
      final diretorioTemporario = await getTemporaryDirectory();
      File file = await File('${diretorioTemporario.path}/RELATORIO_${closing ? "DE_FECHAMENTO" : "GERAL"}_${DateFormatToBrazil.formatDateAndTimePdf(DateTime.now())}.pdf').create();
      file.writeAsBytesSync(documentoPdfGerado);
      return file;
    } catch (e) {
      return null;
    }
  }

  static void generateManyLists(String title){
    widgets.clear();
    List<Widget> allWidgets = [
      TitleListWidget(
        title: title,
        listInformations: saveList[0],
      ),
    ];

    for(int i = 1; i < saveList.length; i++){
      allWidgets.add(
        Wrap(
          children: List<Widget>.generate(saveList[i].length, (int index) {
            return Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  saveList[i][index],
                  style: TextStyle(
                    fontSize: 12,
                    color: PdfColors.black,
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }

    widgets = allWidgets;
  }

  static Future<File?> generateSpecificPdf(String machines, ReportViewController reportViewController, String reportPeriod, {bool closing = false}) async {
    try {
      final doc = Document(pageMode: PdfPageMode.outlines);

      doc.addPage(
        MultiPage(
          pageTheme: const PageTheme(
            pageFormat: PdfPageFormat.a4,
            margin: EdgeInsets.zero,
            orientation: PageOrientation.portrait,
          ),
          build: (context) {
            return [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.025, horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Column(
                          children: [
                            TitlePdf(
                              title: (closing ? "RELATÓRIO DE FECHAMENTO DA MÁQUINA " : "RELATÓRIO GERAL DA MÁQUINA ") + machines.toUpperCase(),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            TitlePdf(
                              title: "Data do relatório: " + DateFormatToBrazil.formatDateAndHour(DateTime.now()),
                              fontSize: 10,
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            TitlePdf(
                              title: (closing ? "Mês de fechamento do relatório: " : "Período do relatório: ") + reportPeriod,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    TitleDescriptionWidget(
                      title: "Total de pelúcias adicionadas nas máquinas",
                      description: FormatNumbers.scoreIntNumber(reportViewController.plushAdded),
                    ),
                    TitleDescriptionWidget(
                      title: "Total de pelúcias que saíram das máquinas",
                      description: FormatNumbers.scoreIntNumber(reportViewController.plushRemoved),
                    ),
                    TitleDescriptionWidget(
                      title: "Total de pelúcias estimado nas máquinas",
                      description: FormatNumbers.scoreIntNumber(reportViewController.plushInTheMachine),
                    ),
                    TitleDescriptionWidget(
                      title: "Valor das máquinas",
                      description: FormatNumbers.intToMoney(reportViewController.machineValue),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: TitleDescriptionWidget(
                        title: "Valor Dinheiro",
                        description: FormatNumbers.numbersToMoney(reportViewController.totalPouchValue),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: TitleDescriptionWidget(
                        title: "Valor PIX",
                        description: FormatNumbers.numbersToMoney(reportViewController.pixValue!),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: TitleDescriptionWidget(
                        title: "Valor Cartão de Crédito",
                        description: FormatNumbers.numbersToMoney(reportViewController.creditValue),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: TitleDescriptionWidget(
                        title: "Valor Cartão de Débito",
                        description: FormatNumbers.numbersToMoney(reportViewController.debitValue),
                      ),
                    ),
                    TitleAndDescriptionWidget(
                      title: "Médias programada para a máquina",
                      reportViewController: reportViewController,
                    ),
                    TitleDescriptionWidget(
                      title: "Média geral da máquina",
                      description: FormatNumbers.numbersToString(reportViewController.averageValue),
                    ),
                    TitleDescriptionWidget(
                      title: "Quantidade de visitas na máquina: ",
                      description: FormatNumbers.scoreIntNumber(reportViewController.numbersOfVisits),
                    ),
                    if (reportViewController.visitDays != null &&
                        reportViewController.visitDays!.isNotEmpty &&
                        reportViewController.operatorsWhoVisitMachines != null &&
                        reportViewController.visitDays!.length == reportViewController.operatorsWhoVisitMachines!.length)
                      TitleDateTimeListWidget(
                        title: "Datas em que a máquina foi visitada",
                        listInformations: reportViewController.visitDays!,
                        reportViewController: reportViewController,
                      ),
                    TitleDescriptionWidget(
                      title: "Quantidade de vezes que os malotes foram coletados",
                      description: FormatNumbers.scoreIntNumber(reportViewController.numbersOfPouchRemoved),
                    ),
                    if (reportViewController.pouchCollectedDates != null &&
                        reportViewController.pouchCollectedDates!.isNotEmpty &&
                        reportViewController.operatorsWhoCollectedPouchsList != null &&
                        reportViewController.operatorsWhoCollectedPouchsList!.length ==
                            reportViewController.pouchCollectedDates!.length)
                      TitlePouchCollectedListWidget(
                        title: "Datas de coletas dos malotes",
                        listInformations: reportViewController.pouchCollectedDates!,
                        reportViewController: reportViewController,
                      ),
                    TitleDescriptionWidget(
                      title: "Quantidade de vezes em que as máquinas estiveram fora da média",
                      description: FormatNumbers.scoreIntNumber(reportViewController.numbersOfTimesOutOffAverage),
                    ),
                    if (reportViewController.outOffAverageDates != null &&
                        reportViewController.outOffAverageDates!.isNotEmpty &&
                        reportViewController.outOffAverageValues != null &&
                        reportViewController.outOffAverageValues!.length == reportViewController.outOffAverageDates!.length)
                      TitleMachineOutsideAverageListWidget(
                        title: "Datas e valor da máquina fora da média",
                        listInformations: reportViewController.outOffAverageDates!,
                        reportViewController: reportViewController,
                      ),
                  ],
                ),
              ),
            ];
          },
        ),
      );

      final documentoPdfGerado = await doc.save();
      final diretorioTemporario = await getTemporaryDirectory();
      File file = await File('${diretorioTemporario.path}/RELATORIO_${closing ? "DE_FECHAMENTO" : "GERAL"}_ESPECIFICO_${DateFormatToBrazil.formatDateAndTimePdf(DateTime.now())}.pdf').create();
      file.writeAsBytesSync(documentoPdfGerado);
      return file;
    } catch (e) {
      return null;
    }
  }
}

class TitlePdf extends StatelessWidget {
  final String title;
  final double? fontSize;
  final TextDecoration? decoration;

  TitlePdf({
    required this.title,
    this.fontSize,
    this.decoration,
  });
  @override
  Widget build(Context context) {
    return Text(
      title,
      style: TextStyle(
        decoration: decoration,
        fontSize: fontSize ?? 14,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 2
    );
  }
}

class TitleDescriptionWidget extends StatelessWidget {
  final String title;
  final String? description;
  final bool showTwoDots;
  final bool defaultSession;
  final bool boldBoth;

  TitleDescriptionWidget({
    required this.title,
    required this.description,
    this.showTwoDots = true,
    this.defaultSession = false,
    this.boldBoth = false,
  });
  @override
  Widget build(Context context) {
    return description != null && description != 'null' && description!.isNotEmpty
        ? Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title + (showTwoDots ? ": " : " "),
                    style: TextStyle(
                      color: PdfColors.black,
                      fontSize: 14,
                      fontWeight: !defaultSession || boldBoth ? FontWeight.bold : null,
                    ),
                  ),
                  TextSpan(
                    text: description,
                    style: TextStyle(
                      color: PdfColors.black,
                      fontSize: 14,
                      fontWeight: defaultSession || boldBoth ? FontWeight.bold : null,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ) : SizedBox();
  }
}

class TitleAndDescriptionWidget extends StatelessWidget {
  final String title;
  final ReportViewController? reportViewController;

  TitleAndDescriptionWidget({
    required this.title,
    required this.reportViewController,
  });

  @override
  Widget build(Context context) {
    return reportViewController != null ? Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 1.5.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: .5.h, bottom: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Mínima: ",
                      style: TextStyle(
                        color: PdfColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: FormatNumbers.numbersToString(reportViewController!.minimumAverageValue),
                      style: TextStyle(
                        color: PdfColors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Máxima: ",
                      style: TextStyle(
                        color: PdfColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: FormatNumbers.numbersToString(reportViewController!.maximumAverageValue),
                      style: TextStyle(
                        color: PdfColors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    ) : SizedBox();
  }
}

class TitleListWidget extends StatelessWidget {
  final String title;
  final List<String> listInformations;
  final bool showTwoDots;
  final bool defaultSession;
  final bool boldBoth;

  TitleListWidget({
    required this.title,
    required this.listInformations,
    this.showTwoDots = true,
    this.defaultSession = false,
    this.boldBoth = false,
  });
  @override
  Widget build(Context context) {
    return listInformations.isNotEmpty ? Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title + (showTwoDots ? ": " : " "),
              style: TextStyle(
                fontSize: 14,
                color: PdfColors.black,
                fontWeight: !defaultSession || boldBoth ? FontWeight.bold : null,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 2.h
            ),
            GenerateList(
              listInformations: listInformations,
            ),
          ],
        ),
      ),
    ) : SizedBox();
  }
}

class TitleDateTimeListWidget extends StatelessWidget {
  final String title;
  final List<DateTime> listInformations;
  final ReportViewController reportViewController;
  final bool showTwoDots;
  final bool defaultSession;
  final bool boldBoth;

  TitleDateTimeListWidget({
    required this.title,
    required this.listInformations,
    required this.reportViewController,
    this.showTwoDots = true,
    this.defaultSession = false,
    this.boldBoth = false,
  });
  @override
  Widget build(Context context) {
    return listInformations.isNotEmpty ? Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title + (showTwoDots ? ": " : " "),
              style: TextStyle(
                fontSize: 14,
                color: PdfColors.black,
                fontWeight: !defaultSession || boldBoth ? FontWeight.bold : null,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 2.h
            ),
            Wrap(
              children: List<Widget>.generate(listInformations.length, (int index) {
                return Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Container(
                    width: 100.w,
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      children: [
                        Container(
                          height: 2.h,
                          width: 2.h,
                          margin: EdgeInsets.only(right: 2.w),
                          decoration: BoxDecoration(
                            color: PdfColors.black,
                            borderRadius: BorderRadius.circular(
                              1.h,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            DateFormatToBrazil.formatDateAndHour(
                              reportViewController.visitDays![index],
                            ) +
                                " - Operador: " +
                                reportViewController.operatorsWhoVisitMachines![index],
                            style: TextStyle(
                              fontSize: 14,
                              color: PdfColors.black,
                              fontWeight: !defaultSession || boldBoth ? FontWeight.bold : null,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    ) : SizedBox();
  }
}

class TitlePouchCollectedListWidget extends StatelessWidget {
  final String title;
  final List<DateTime> listInformations;
  final ReportViewController reportViewController;
  final bool showTwoDots;
  final bool defaultSession;
  final bool boldBoth;

  TitlePouchCollectedListWidget({
    required this.title,
    required this.listInformations,
    required this.reportViewController,
    this.showTwoDots = true,
    this.defaultSession = false,
    this.boldBoth = false,
  });
  @override
  Widget build(Context context) {
    return listInformations.isNotEmpty ? Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title + (showTwoDots ? ": " : " "),
              style: TextStyle(
                fontSize: 14,
                color: PdfColors.black,
                fontWeight: !defaultSession || boldBoth ? FontWeight.bold : null,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 2.h
            ),
            Wrap(
              children: List<Widget>.generate(listInformations.length, (int index) {
                return Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Container(
                    width: 100.w,
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      children: [
                        Container(
                          height: 2.h,
                          width: 2.h,
                          margin: EdgeInsets.only(right: 2.w),
                          decoration: BoxDecoration(
                            color: PdfColors.black,
                            borderRadius: BorderRadius.circular(
                              1.h,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            DateFormatToBrazil.formatDateAndHour(
                              reportViewController.pouchCollectedDates![index],
                            ) +
                            " - Operador: " +
                            reportViewController.operatorsWhoCollectedPouchsList![index],
                            style: TextStyle(
                              fontSize: 14,
                              color: PdfColors.black,
                              fontWeight: !defaultSession || boldBoth ? FontWeight.bold : null,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    ) : SizedBox();
  }
}

class TitleMachineOutsideAverageListWidget extends StatelessWidget {
  final String title;
  final List<DateTime> listInformations;
  final ReportViewController reportViewController;
  final bool showTwoDots;
  final bool defaultSession;
  final bool boldBoth;

  TitleMachineOutsideAverageListWidget({
    required this.title,
    required this.listInformations,
    required this.reportViewController,
    this.showTwoDots = true,
    this.defaultSession = false,
    this.boldBoth = false,
  });
  @override
  Widget build(Context context) {
    return listInformations.isNotEmpty ? Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title + (showTwoDots ? ": " : " "),
              style: TextStyle(
                fontSize: 14,
                color: PdfColors.black,
                fontWeight: !defaultSession || boldBoth ? FontWeight.bold : null,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 2.h
            ),
            Wrap(
              children: List<Widget>.generate(listInformations.length, (int index) {
                return Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Container(
                    width: 100.w,
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      children: [
                        Container(
                          height: 2.h,
                          width: 2.h,
                          margin: EdgeInsets.only(right: 2.w),
                          decoration: BoxDecoration(
                            color: PdfColors.black,
                            borderRadius: BorderRadius.circular(
                              1.h,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            DateFormatToBrazil.formatDateAndHour(
                              reportViewController.outOffAverageDates![index],
                            ) +
                            " - Valor: " +
                            FormatNumbers.numbersToString(
                              reportViewController.outOffAverageValues![index],
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: PdfColors.black,
                              fontWeight: !defaultSession || boldBoth ? FontWeight.bold : null,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    ) : SizedBox();
  }
}

class GenerateList extends StatelessWidget {
  final List<String> listInformations;

  GenerateList({
    required this.listInformations,
  });

  @override
  Widget build(context) {
    return Wrap(
      children: List<Widget>.generate(listInformations.length, (int index) {
        return Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              listInformations[index],
              style: TextStyle(
                fontSize: 12,
                color: PdfColors.black,
              ),
            ),
          ),
        );
      }),
    );
  }
}