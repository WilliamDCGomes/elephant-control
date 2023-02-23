import 'dart:convert';
import 'dart:io';
import 'package:elephant_control/app/utils/format_numbers.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '../../base/viewControllers/report_viewcontroller.dart';

class GenerateReportPdf {
  static double get height => 29.7 * PdfPageFormat.cm;
  static double get width => 21.0 * PdfPageFormat.cm;

  static Future<File?> generateGeneralPdf(List<String>? machines, ReportViewController reportViewController) async {
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
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Center(
                      child: TitlePdf(title: "RELATÓRIO GERAL", decoration: TextDecoration.underline),
                    ),
                    TitleDescriptionWidget(
                        title: "Total de pelúcias adicionadas nas máquinas",
                        description: FormatNumbers.scoreIntNumber(reportViewController.plushAdded)),
                    TitleDescriptionWidget(
                        title: "Total de pelúcias que saíram das máquinas",
                        description: FormatNumbers.scoreIntNumber(reportViewController.plushRemoved)),
                    TitleDescriptionWidget(
                        title: "Total de pelúcias estimado nas máquinas",
                        description: FormatNumbers.scoreIntNumber(reportViewController.plushInTheMachine)),
                    TitleDescriptionWidget(
                        title: "Valor das máquinas",
                        description: FormatNumbers.intToMoney(reportViewController.machineValue)),
                    TitleDescriptionWidget(
                        title: "Quantidade de visitas nas máquinas",
                        description: FormatNumbers.scoreIntNumber(reportViewController.numbersOfVisits)),
                    TitleDescriptionWidget(
                        title: "Quantidade de vezes que os malotes foram coletados",
                        description: FormatNumbers.scoreIntNumber(reportViewController.numbersOfPouchRemoved)),
                    TitleDescriptionWidget(
                        title: "Valor total cartão de crédito dos malotes",
                        description: FormatNumbers.numbersToMoney(reportViewController.creditValue)),
                    TitleDescriptionWidget(
                        title: "Valor total cartão de débito dos malotes",
                        description: FormatNumbers.numbersToMoney(reportViewController.debitValue)),
                    TitleDescriptionWidget(
                        title: "Valor total PIX dos malotes",
                        description: FormatNumbers.numbersToMoney(reportViewController.pixValue)),
                    TitleDescriptionWidget(
                        title: "Valor total dos malotes",
                        description: FormatNumbers.numbersToMoney(reportViewController.totalPouchValue)),
                    TitleDescriptionWidget(
                        title: "Quantidade de vezes em que as máquinas estiveram fora da média",
                        description: FormatNumbers.scoreIntNumber(reportViewController.numbersOfTimesOutOffAverage)),
                  ]))
            ];
          },
        ),
      );

      final documentoPdfGerado = await doc.save();
      final diretorioTemporario = await getTemporaryDirectory();
      File file = await File(
              '${diretorioTemporario.path}/Proposta_Intencao_Compra_ZIncorporacoes_${DateTime.now().millisecondsSinceEpoch}.pdf')
          .create();
      file.writeAsBytesSync(documentoPdfGerado);
      return file;
    } catch (e) {
      return null;
    }
  }
}

class TitlePdf extends StatelessWidget {
  final String title;
  final TextDecoration? decoration;

  TitlePdf({
    required this.title,
    this.decoration,
  });
  @override
  Widget build(Context context) {
    return Text(title,
        style: TextStyle(
          decoration: decoration,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ));
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
        ? Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title + (showTwoDots ? ": " : " "),
                    style: TextStyle(
                        color: PdfColors.black,
                        fontSize: 14,
                        fontWeight: !defaultSession || boldBoth ? FontWeight.bold : null),
                  ),
                  TextSpan(
                    text: description,
                    style: TextStyle(
                        color: PdfColors.black,
                        fontSize: 14,
                        fontWeight: defaultSession || boldBoth ? FontWeight.bold : null),
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          )
        : SizedBox();
  }
}
