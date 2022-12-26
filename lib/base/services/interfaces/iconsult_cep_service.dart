import '../../models/addressInformation/model/address_information.dart';

abstract class IConsultCepService {
  Future<AddressInformation?> searchCep(String cep);
}