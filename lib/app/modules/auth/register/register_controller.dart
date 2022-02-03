import 'dart:developer';

import 'package:get/get.dart';
import 'package:vakinha_burger_mobile/app/core/mixins/loader_mixin.dart';
import 'package:vakinha_burger_mobile/app/core/mixins/messages_mixin.dart';
import 'package:vakinha_burger_mobile/app/core/rest_client/rest_client.dart';
import 'package:vakinha_burger_mobile/app/repositories/auth/auth_repository.dart';

class RegisterController extends GetxController
    with LoaderMixin, MessagesMixin {
  final AuthRepository _authRepository;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  RegisterController({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  @override
  void onInit() {
    loaderListener(_loading);
    messageListerner(_message);
    super.onInit();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _loading.toggle();

      await _authRepository.register(name, email, password);
      _loading.toggle();
      // TODO: Voltar quando fizer o login
      Get.back();
      _message(
        MessageModel(
            'Sucesso', 'Cadastro realizado com sucesso', MessageType.info),
      );
    } on RestClientException catch (e, s) {
      _loading.toggle();
      log('Erro ao registrar login', error: e, stackTrace: s);
      MessageModel('Erro', e.message, MessageType.error);
    } catch (e, s) {
      _loading.toggle();
      log('Erro ao registrar usuário', error: e, stackTrace: s);
      MessageModel('Erro', 'Erro ao registrar usuário', MessageType.error);
    }
  }
}
