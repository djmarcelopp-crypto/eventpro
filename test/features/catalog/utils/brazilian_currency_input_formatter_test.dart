import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/utils/brazilian_currency_input_formatter.dart';

void main() {
  group('BrazilianCurrencyInputFormatter', () {
    final formatter = BrazilianCurrencyInputFormatter();

    TextEditingValue apply(
      TextEditingValue oldValue,
      TextEditingValue newValue,
    ) {
      return formatter.formatEditUpdate(oldValue, newValue);
    }

    TextEditingValue typeChar(TextEditingValue current, String char) {
      final newText = '${current.text}$char';
      return apply(
        current,
        TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        ),
      );
    }

    void expectValue(TextEditingValue value, String text, int cursor) {
      expect(value.text, text);
      expect(value.selection.baseOffset, cursor);
      expect(value.selection.extentOffset, cursor);
    }

    test('mantém cursor ao digitar 10,50 incrementalmente', () {
      var value = apply(
        const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0)),
        const TextEditingValue(text: '1', selection: TextSelection.collapsed(offset: 1)),
      );
      expectValue(value, '1', 1);

      value = typeChar(value, '0');
      expectValue(value, '10', 2);

      value = typeChar(value, ',');
      expectValue(value, '10,', 3);

      value = typeChar(value, '5');
      expectValue(value, '10,5', 4);

      value = typeChar(value, '0');
      expectValue(value, '10,50', 5);
    });

    test('permite digitação incremental de inteiros', () {
      var value = apply(
        const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0)),
        const TextEditingValue(text: '1', selection: TextSelection.collapsed(offset: 1)),
      );
      expectValue(value, '1', 1);

      value = typeChar(value, '5');
      expectValue(value, '15', 2);

      value = typeChar(value, '0');
      expectValue(value, '150', 3);

      value = typeChar(value, '0');
      expectValue(value, '1.500', 5);
    });

    test('permite digitar vírgula e centavos manualmente', () {
      var value = apply(
        const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0)),
        const TextEditingValue(text: '1', selection: TextSelection.collapsed(offset: 1)),
      );
      value = typeChar(value, '0');
      value = typeChar(value, ',');
      expectValue(value, '10,', 3);

      value = typeChar(value, '5');
      expectValue(value, '10,5', 4);

      value = typeChar(value, '0');
      expectValue(value, '10,50', 5);
    });

    test('aceita 200,00', () {
      final value = apply(
        const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0)),
        const TextEditingValue(
          text: '200,00',
          selection: TextSelection.collapsed(offset: 6),
        ),
      );
      expectValue(value, '200,00', 6);
    });

    test('aceita 1.500,75', () {
      final value = apply(
        const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0)),
        const TextEditingValue(
          text: '1.500,75',
          selection: TextSelection.collapsed(offset: 8),
        ),
      );
      expectValue(value, '1.500,75', 8);
    });

    test('converte ponto decimal do teclado numérico em vírgula', () {
      expectValue(
        apply(
          const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0)),
          const TextEditingValue(text: '10.5', selection: TextSelection.collapsed(offset: 4)),
        ),
        '10,5',
        4,
      );
      expectValue(
        apply(
          const TextEditingValue(text: '10', selection: TextSelection.collapsed(offset: 2)),
          const TextEditingValue(text: '10.', selection: TextSelection.collapsed(offset: 3)),
        ),
        '10,',
        3,
      );
    });

    test('reformata valor colado', () {
      expectValue(
        apply(
          const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0)),
          const TextEditingValue(
            text: 'R\$ 2.500,50',
            selection: TextSelection.collapsed(offset: 12),
          ),
        ),
        '2.500,50',
        8,
      );
      expectValue(
        apply(
          const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0)),
          const TextEditingValue(
            text: '1500',
            selection: TextSelection.collapsed(offset: 4),
          ),
        ),
        '1.500',
        5,
      );
    });

    test('permite backspace durante digitação', () {
      expectValue(
        apply(
          const TextEditingValue(text: '1.500', selection: TextSelection.collapsed(offset: 5)),
          const TextEditingValue(text: '150', selection: TextSelection.collapsed(offset: 3)),
        ),
        '150',
        3,
      );
      expectValue(
        apply(
          const TextEditingValue(text: '10,50', selection: TextSelection.collapsed(offset: 5)),
          const TextEditingValue(text: '10,5', selection: TextSelection.collapsed(offset: 4)),
        ),
        '10,5',
        4,
      );
    });

    test('preserva edição no meio do texto', () {
      final value = apply(
        const TextEditingValue(text: '10,50', selection: TextSelection.collapsed(offset: 1)),
        const TextEditingValue(text: '15,50', selection: TextSelection.collapsed(offset: 2)),
      );
      expectValue(value, '15,50', 2);
    });

    test('bloqueia duas vírgulas', () {
      final value = apply(
        const TextEditingValue(text: '10,5', selection: TextSelection.collapsed(offset: 4)),
        const TextEditingValue(text: '10,5,0', selection: TextSelection.collapsed(offset: 6)),
      );
      expect(value.text, '10,5');
      expect(value.selection.baseOffset, 4);
    });

    test('bloqueia mais de duas casas decimais', () {
      final value = apply(
        const TextEditingValue(text: '10,50', selection: TextSelection.collapsed(offset: 5)),
        const TextEditingValue(text: '10,505', selection: TextSelection.collapsed(offset: 6)),
      );
      expect(value.text, '10,50');
      expect(value.selection.baseOffset, 5);
    });

    test('remove letras e sinais negativos', () {
      expectValue(
        apply(
          const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0)),
          const TextEditingValue(text: 'R\$abc1500', selection: TextSelection.collapsed(offset: 10)),
        ),
        '1.500',
        5,
      );
      expectValue(
        apply(
          const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0)),
          const TextEditingValue(text: '-10,50', selection: TextSelection.collapsed(offset: 6)),
        ),
        '10,50',
        5,
      );
    });

    test('rejeita mais de 9 dígitos inteiros', () {
      final value = apply(
        const TextEditingValue(
          text: '999.999.999',
          selection: TextSelection.collapsed(offset: 11),
        ),
        const TextEditingValue(
          text: '9999999999',
          selection: TextSelection.collapsed(offset: 10),
        ),
      );
      expect(value.text, '999.999.999');
      expect(value.selection.baseOffset, 11);
    });
  });
}
