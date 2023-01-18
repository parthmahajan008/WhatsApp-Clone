import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import material package
import 'package:flutter/material.dart';
import '../repository/select_contact_repository.dart';

final getContactProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return SelectContactController(
      ref: ref, selectContactRepository: selectContactRepository);
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController({
    required this.ref,
    required this.selectContactRepository,
  });
  void selectContact(Contact selectedcontact, BuildContext context) {
    selectContactRepository.selectContact(selectedcontact, context);
  }
}
