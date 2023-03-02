import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateFormatToBrazil {
  static String formatDate(DateTime? date) {
    if(date != null)
      return DateFormat('dd-MM-yyyy').format(date).replaceAll('-', '/');
    return "";
  }

  static String formatHour(TimeOfDay? time) {
    if(time != null){
      String hour = (time.hour < 10 ? "0" : "") + time.hour.toString();
      String minute = (time.minute < 10 ? "0" : "") + time.minute.toString();
      return  hour + ":" + minute;
    }
    return "";
  }

  static String formatDateAmerican(DateTime? date) {
    if(date != null)
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    return "";
  }

  static DateTime? formatDateFromTextField(String? date) {
    if(date != null) {
      var dates = date.split('/');
      DateTime newDate = DateTime(
        int.parse(dates[2]),
        int.parse(dates[1]),
        int.parse(dates[0]),
      );
      return newDate;
    }
    return null;
  }

  static String formatDateFromReport(String? date) {
    try{
      if(date != null) {
        var dates = date.split(' ');
        var justdate = dates[0].split('/');
        var justHour = dates[1].split(':');
        DateTime newDate = DateTime(
          int.parse(justdate[2]),
          int.parse(justdate[1]),
          int.parse(justdate[0]),
          int.parse(justHour[0]),
          int.parse(justHour[1]),
        );

        return "${DateFormat('dd-MM-yyyy').format(newDate).replaceAll('-', '/')} às ${DateFormat('HH:mm').format(newDate)}";
      }
      return "";
    }
    catch(_){
      return "";
    }
  }

  static String formatDateAndHour(DateTime? date) {
    if(date != null)
      return "${DateFormat('dd-MM-yyyy').format(date).replaceAll('-', '/')} às ${DateFormat('HH:mm').format(date)}";
    return "";
  }

  static String formatDateAndTimePdf(DateTime? date) {
    if(date != null)
      return "${DateFormat('dd-MM-yyyy').format(date)}_AS_${DateFormat('HH:mm:ss:SS').format(date)}";
    return "";
  }

  static String formatDateFull(DateTime? date) {
    if(date != null) {
      initializeDateFormatting('pt_BR', null);
      Intl.defaultLocale = 'pt_BR';
      return DateFormat('yMMMd').format(date);
    }
    return "";
  }

  static String dayAndMounth(DateTime? date) {
    if(date != null) {
      initializeDateFormatting('pt_BR', null);
      Intl.defaultLocale = 'pt_BR';
      return DateFormat('dd-MM').format(date).replaceAll('-', '/').toUpperCase();
    }
    return "";
  }

  static String mounthAndYearReduced(DateTime? date) {
    if(date != null) {
      initializeDateFormatting('pt_BR', null);
      Intl.defaultLocale = 'pt_BR';
      return DateFormat('MM-yyyy').format(date).replaceAll('-', '/').toUpperCase();
    }
    return "";
  }

  static String mounthAndYear(DateTime? date) {
    if(date != null) {
      initializeDateFormatting('pt_BR', null);
      Intl.defaultLocale = 'pt_BR';
      return DateFormat('MMMM-yyyy').format(date).replaceAll('-', ' ').toUpperCase();
    }
    return "";
  }

  static String mounth(DateTime? date) {
    if(date != null) {
      initializeDateFormatting('pt_BR', null);
      Intl.defaultLocale = 'pt_BR';
      return DateFormat('MMMM').format(date).replaceAll('-', ' ');
    }
    return "";
  }

  static DateTime firstDateOfMonth() {
    DateTime _todayDate = DateTime.now();
    return DateTime(_todayDate.year, _todayDate.month, 1);
  }

  static DateTime lastDateOfMonth() {
    DateTime _todayDate = DateTime.now();
    return DateTime(_todayDate.year, _todayDate.month + 1, 0);
  }

  static String weekDay(DateTime? date) {
    if(date != null) {
      switch(date.weekday){
        case 7:
          return "Domingo";
        case 1:
          return "Segunda";
        case 2:
          return "Terça";
        case 3:
          return "Quarta";
        case 4:
          return "Quinta";
        case 5:
          return "Sexta";
        case 6:
          return "Sábado";
      }
    }
    return "";
  }

  static String getMonthName(DateTime? date) {
    if(date != null) {
      switch(date.month){
        case 1:
          return "Janeiro";
        case 2:
          return "Fevereiro";
        case 3:
          return "Março";
        case 4:
          return "Abril";
        case 5:
          return "Maio";
        case 6:
          return "Junho";
        case 7:
          return "Julho";
        case 8:
          return "Agosto";
        case 9:
          return "Setembro";
        case 10:
          return "Outubro";
        case 11:
          return "Novembro";
        case 12:
          return "Dezembro";
      }
    }
    return "";
  }
}