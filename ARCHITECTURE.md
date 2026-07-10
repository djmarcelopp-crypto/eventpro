# Arquitetura Oficial Inicial do EventPro

## 1. Propósito da arquitetura

A arquitetura inicial do EventPro foi definida para apoiar o desenvolvimento de um MVP sólido, com organização clara, manutenção simples e evolução futura. O foco é priorizar a entrega rápida da versão inicial, mantendo uma base técnica limpa e preparada para crescer sem introduzir complexidade desnecessária.

O projeto será desenvolvido com Flutter e Dart, usando Material 3 como base visual, com uma estrutura organizada por funcionalidades em um modelo feature-first, simples e prático para o MVP.

## 2. Princípios gerais

A arquitetura inicial seguirá estes princípios:

- Flutter e Dart como stack principal.
- Material 3 como sistema de interface padrão.
- Organização por funcionalidades, em vez de organização por tipo de arquivo.
- Uso de Riverpod para estado e injeção de dependências.
- Uso de GoRouter para navegação.
- Simplicidade para o MVP, evitando camadas desnecessárias.
- Preparação para crescimento futuro sem tornar o projeto pesado ou difícil de manter.
- Estrutura enxuta, com criação de pastas somente quando uma funcionalidade estiver em desenvolvimento.

## 3. Escopo inicial do MVP

O MVP inicial será focado em uma versão para Windows, com a Web como segunda prioridade. As plataformas macOS e iPhone serão trabalhadas posteriormente.

O MVP terá inicialmente apenas o perfil Administrador. O sistema será online-first, com sincronização e funcionamento offline deixados para uma versão futura.

A Inteligência Artificial não faz parte do MVP inicial.

As funcionalidades do MVP serão:

- dashboard;
- clientes;
- serviços e equipamentos;
- orçamentos;
- geração de PDF;
- compartilhamento do orçamento;
- configurações da empresa.

## 4. Abordagem arquitetural recomendada

A arquitetura proposta é uma versão pragmática de Clean Architecture, adaptada ao contexto de um MVP simples e objetivo. A ideia é manter separação de responsabilidades quando ela realmente fizer sentido, evitando abstrações sem uso.

## 5. Estrutura inicial de pastas dentro de lib

A estrutura inicial recomendada é a seguinte:

```text
lib/
  app/
  core/
  features/
    dashboard/
    clients/
    catalog/
    budgets/
    settings/
  main.dart
```

### 5.1 app

Responsável por montar a aplicação, configurar a navegação principal, os provedores globais e a composição inicial da interface.

### 5.2 core

Contém recursos compartilhados entre todas as funcionalidades, como temas, constantes, utilidades, widgets reutilizáveis e regras comuns.

A estrutura inicial esperada dentro de core é:

```text
lib/core/
  theme/
    app_theme.dart
    app_colors.dart
    app_text_styles.dart
  widgets/
    primary_button.dart
    app_text_field.dart
    app_card.dart
```

### 5.3 features

Cada funcionalidade do MVP terá sua própria pasta, criada somente quando a implementação começar. Não serão criadas pastas vazias para módulos futuros.

As features iniciais são:

- dashboard
- clients
- catalog
- budgets
- settings

## 6. Organização interna das features

Dentro de cada feature, a estrutura deve ser simples e opcional. As pastas presentation, domain e data serão usadas somente quando essas camadas forem realmente necessárias.

A regra principal é:

- se a feature for pequena e simples, pode ser implementada com poucos arquivos diretamente na pasta da feature;
- se a complexidade crescer, então se adiciona uma organização mais explícita com presentation, domain e data.

Essa abordagem evita arquivos e abstrações sem uso no início.

## 7. Padrões de nomenclatura

Para manter o código consistente, os padrões abaixo serão adotados:

- arquivos em snake_case;
- classes em PascalCase;
- variáveis, funções e parâmetros em camelCase;
- constantes em SCREAMING_SNAKE_CASE;
- widgets em PascalCase, com nomes claros e específicos.

## 8. Uso de Riverpod

Riverpod será usado para:

- gerenciamento de estado da interface;
- controle de carregamento e erro;
- injeção de dependências quando houver necessidade real;
- compartilhamento de estado entre telas e widgets.

O uso deve permanecer simples no MVP. A recomendação é evitar uma arquitetura excessiva de providers e usar apenas o necessário para manter o código legível e fácil de manter.

## 9. Uso de GoRouter

A navegação será organizada com GoRouter, usando rotas nomeadas e centralizadas.

As regras básicas são:

- cada fluxo principal deve ter uma rota clara e nomeada;
- a configuração de rotas deve ficar em um local dedicado;
- a navegação deve permanecer simples no MVP;
- novas rotas devem ser adicionadas conforme as telas forem surgindo.

## 10. Integração com Firebase

A integração com Firebase será adicionada depois da interface e da estrutura inicial do MVP.

Isso significa que a arquitetura inicial não deve depender diretamente de Firebase nas primeiras etapas. A estrutura deve permitir essa integração futura sem exigir grandes refatorações.

## 11. Regras para tratamento de erros, carregamento e validação

### 11.1 Tratamento de erros

- erros devem ser tratados de forma explícita;
- mensagens amigáveis devem ser exibidas ao usuário;
- falhas de carregamento, validação ou ação devem ser representadas de forma consistente.

### 11.2 Carregamento

- estados de carregamento devem ser visíveis quando houver operações assíncronas;
- telas ou componentes devem exibir estados de loading, sucesso, erro e vazio quando apropriado.

### 11.3 Validação de formulários

- validação deve ocorrer antes de salvar ou enviar dados;
- mensagens de erro devem ser claras e consistentes;
- regras de validação devem ser simples e alinhadas ao MVP.

## 12. Tema Premium Dark

O tema visual do EventPro seguirá o conceito Premium Dark com uma paleta baseada em preto, dourado e branco.

A organização do tema deve acontecer em um local centralizado dentro de core, com separação clara para:

- tema principal da aplicação;
- esquema de cores;
- tipografia;
- espaçamento;
- estilos de componentes reutilizáveis.

O objetivo é manter a identidade visual consistente, sofisticada e profissional em todas as telas do MVP.

## 13. Estratégia básica de testes

A estratégia inicial de testes será simples e suficiente para apoiar o MVP.

Os principais tipos de testes serão:

- testes unitários para regras de negócio e validações simples;
- testes de widget para telas e componentes principais;
- testes básicos de integração somente onde houver maior risco ou complexidade.

A prioridade é garantir confiabilidade para os fluxos críticos do MVP sem exagerar na quantidade de testes no início.

## 14. Diretrizes de evolução

A arquitetura inicial deve permitir crescimento futuro sem introduzir complexidade prematura.

- novas funcionalidades devem entrar como novas features;
- novas integrações devem ser encapsuladas sem impactar demais as telas existentes;
- a estrutura deve permanecer previsível para novos integrantes do projeto;
- mudanças no backend ou na interface devem ter impacto limitado no restante do sistema.

## 15. Resumo da decisão arquitetural

A arquitetura oficial inicial do EventPro será:

- Flutter + Dart;
- Material 3;
- arquitetura feature-first e simples;
- Riverpod para estado e dependências quando necessário;
- GoRouter para navegação;
- MVP focado em Windows;
- perfil de administrador inicial;
- abordagem online-first;
- integração com Firebase postergada para depois da estrutura inicial;
- escopo inicial limitado a dashboard, clientes, catalog, orçamentos, PDF, compartilhamento e configurações.
