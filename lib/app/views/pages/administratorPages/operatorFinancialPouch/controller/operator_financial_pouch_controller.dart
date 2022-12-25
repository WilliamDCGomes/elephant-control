import 'package:get/get.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../widget/pouch_card_widget.dart';

class OperatorPouchController extends GetxController {
  final bool withOperator;
  late RxBool loadingAnimation;
  late RxString userSelected;
  late RxList<String> usersName;
  late RxList<PouchCardWidget> pouchCardWidgetList;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  OperatorPouchController(this.withOperator){
    _initializeVariables();
    _initializeList();
  }

  _initializeVariables(){
    loadingAnimation = false.obs;
    userSelected = "".obs;
    usersName = <String>[].obs;
    pouchCardWidgetList = <PouchCardWidget>[].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
  }

  _initializeList(){
    if(withOperator){
      usersName.addAll([
        "João",
        "Marcos",
        "André",
        "Carlos",
      ]);
    }
    else{
      usersName.addAll([
        "Ana",
        "Paula",
        "Roberta",
        "Carol",
      ]);
    }
  }

  getPouchUser(String userName){
    pouchCardWidgetList.value = <PouchCardWidget>[
      PouchCardWidget(
        machineName: "Shopping Boulevard",
        responsibleUser: userName,
        lastChange: DateTime.now().add(Duration(days: -6)),
      ),
      PouchCardWidget(
        machineName: "Supermercado Central",
        responsibleUser: userName,
        lastChange: DateTime.now().add(Duration(days: -4)),
      ),
      PouchCardWidget(
        machineName: "Cinema Alameda",
        responsibleUser: userName,
        lastChange: DateTime.now(),
      ),
    ];
  }
}