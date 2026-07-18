import '../models/agenda_block.dart';

class AgendaBlockValidationResult {
  const AgendaBlockValidationResult({required this.errors});

  final List<String> errors;

  bool get isValid => errors.isEmpty;
}

abstract class AgendaBlockValidator {
  static const titleRequiredError = 'Informe um título para o bloqueio';
  static const startRequiredError = 'Informe o início do bloqueio';
  static const endRequiredError = 'Informe o fim do bloqueio';
  static const endAfterStartError = 'O fim deve ser posterior ao início';

  static AgendaBlockValidationResult validateFields({
    String? title,
    DateTime? start,
    DateTime? end,
  }) {
    final errors = <String>[];

    if (title == null || title.trim().isEmpty) {
      errors.add(titleRequiredError);
    }
    if (start == null) {
      errors.add(startRequiredError);
    }
    if (end == null) {
      errors.add(endRequiredError);
    }
    if (start != null && end != null && !end.isAfter(start)) {
      errors.add(endAfterStartError);
    }

    return AgendaBlockValidationResult(errors: List.unmodifiable(errors));
  }

  static AgendaBlockValidationResult validate(AgendaBlock block) {
    return validateFields(
      title: block.title,
      start: block.start,
      end: block.end,
    );
  }
}
