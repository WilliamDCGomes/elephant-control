import '../../models/addressInformation/address_information.dart';

abstract class IConsultCepService {
  Future<AddressInformation?> searchCep(String cep);
}