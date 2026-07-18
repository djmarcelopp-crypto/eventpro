import '../models/assistant_confidence.dart';
import '../models/assistant_entity.dart';
import '../models/assistant_entity_type.dart';
import '../models/assistant_provenance.dart';
import '../utils/assistant_text_normalizer.dart';

/// Keyword spotting for equipment / services / team / logistics.
///
/// Does **not** map keywords to inventory IDs or quantities.
abstract class KeywordExtractor {
  static const equipment = <String>[
    'palco',
    'som',
    'iluminacao',
    'painel de led',
    'led',
    'box truss',
    'gerador',
    'microfone',
    'telao',
    'projetor',
    'estrutura',
    'praticavel',
    'grid',
    'moving head',
    'maquina de fumaca',
  ];

  static const services = <String>[
    'dj',
    'banda',
    'transmissao',
    'filmagem',
    'iluminacao',
    'som',
  ];

  static const team = <String>[
    'dj',
    'banda',
    'sonoplasta',
    'tecnico',
    'operador',
  ];

  static const logistics = <String>[
    'transporte',
    'van',
    'caminhao',
    'logistica',
  ];

  static List<AssistantEntity> extract(String text) {
    final folded = AssistantTextNormalizer.fold(text);
    final entities = <AssistantEntity>[];

    void collect(
      List<String> catalog,
      AssistantEntityType type,
    ) {
      final ordered = [...catalog]..sort((a, b) => b.length.compareTo(a.length));
      final seen = <String>{};
      for (final key in ordered) {
        if (!folded.contains(key)) continue;
        if (!seen.add(key)) continue;
        entities.add(
          AssistantEntity(
            type: type,
            rawValue: key,
            normalizedValue: key,
            provenance: AssistantProvenance.extracted,
            confidence: AssistantConfidence.fromScore(
              0.75,
              evidences: ['keyword:$key'],
            ),
          ),
        );
      }
    }

    collect(equipment, AssistantEntityType.equipment);
    collect(services, AssistantEntityType.service);
    collect(team, AssistantEntityType.teamRequirement);
    collect(logistics, AssistantEntityType.vehicleRequirement);
    return entities;
  }
}
