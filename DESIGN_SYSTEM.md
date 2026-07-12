# EventPro — Design System

## 1. Introdução

Este documento define o padrão visual oficial do EventPro. Ele serve como referência para manter consistência, legibilidade e identidade profissional em todas as telas do sistema.

O EventPro utiliza o conceito **Premium Dark**, com uma paleta baseada em **preto, dourado e branco**. A interface é construída sobre **Material 3**, com tokens centralizados em `lib/core/theme/` e componentes reutilizáveis em `lib/core/widgets/`.

### Princípios visuais

- **Sofisticado e profissional** — visual limpo, escuro e elegante.
- **Consistente** — mesmas cores, tipografia e componentes em todo o app.
- **Legível** — contraste adequado entre texto e fundo.
- **Centralizado** — features nunca definem estilos próprios; sempre consomem tokens oficiais.

### Regra principal

> Sempre usar tokens de `core/theme/` e componentes de `core/widgets/`. Nunca aplicar cores, tamanhos ou estilos hardcoded dentro das features.

---

## 2. Paleta de cores

Todas as cores oficiais estão definidas em `lib/core/theme/app_colors.dart`.

| Token | Hex | Uso |
|---|---|---|
| `background` | `#121212` | Fundo principal da aplicação (scaffold) |
| `surface` | `#1E1E1E` | Cards, painéis e containers elevados |
| `surfaceVariant` | `#242424` | Inputs, áreas secundárias e preenchimentos |
| `primary` | `#D4AF37` | Ações principais, destaques e foco (dourado) |
| `white` | `#FFFFFF` | Texto principal e ícones ativos |
| `mutedWhite` | `#EAEAEA` | Corpo de texto em destaque |
| `secondaryText` | `#BEBEBE` | Texto secundário, labels e hints |
| `border` | `#2A2A2A` | Bordas, divisores e contornos |
| `success` | `#2E8B57` | Feedback positivo e confirmações |
| `warning` | `#FFC107` | Alertas e avisos |
| `error` | `#CF6679` | Erros e validações |

### Regras de uso

- **Fundo da tela:** sempre `background`.
- **Cards e painéis:** sempre `surface` com borda `border`.
- **Ações primárias:** botões e elementos interativos principais usam `primary` (dourado).
- **Texto:** `white` para títulos e labels; `mutedWhite` para corpo; `secondaryText` para informações auxiliares.
- **Feedback:** usar `success`, `warning` ou `error` conforme o contexto — nunca inventar novas cores de status.
- **Contraste:** texto claro sobre fundos escuros; texto escuro (`background`) sobre botões dourados (`primary`).

---

## 3. Tipografia

Todos os estilos oficiais estão definidos em `lib/core/theme/app_text_styles.dart` e mapeados no `TextTheme` de `app_theme.dart`.

| Estilo | Tamanho | Peso | Cor | Uso |
|---|---|---|---|---|
| `displayLarge` | 34px | Bold (700) | `white` | Títulos de destaque, branding |
| `headlineMedium` | 24px | SemiBold (600) | `white` | Títulos de seção e páginas |
| `titleMedium` | 18px | SemiBold (600) | `white` | Subtítulos e cabeçalhos de card |
| `titleSmall` | 14px | Medium (500) | `white` | Labels de card e itens de lista |
| `bodyLarge` | 16px | Regular (400) | `mutedWhite` | Texto principal, parágrafos |
| `bodyMedium` | 14px | Regular (400) | `secondaryText` | Texto secundário, descrições |
| `labelLarge` | 15px | SemiBold (600) | `white` | Labels de botões e ações |
| `caption` | 12px | Regular (400) | `secondaryText` | Metadados, timestamps, hints |

### Regras de uso

- Preferir `Theme.of(context).textTheme` nas telas.
- Usar `AppTextStyles` diretamente apenas quando o contexto do tema não estiver disponível.
- Nunca criar `TextStyle` inline com tamanhos ou cores customizados.
- `displayLarge` possui `letterSpacing: 1.2` — reservado para títulos de impacto visual.
- `bodyLarge` e `bodyMedium` possuem `height` (line-height) definido — manter para legibilidade.

---

## 4. Espaçamento e layout

A escala de espaçamento segue múltiplos de **4px**, com valores padrão já adotados no tema.

| Token | Valor | Uso |
|---|---|---|
| `xs` | 4px | Espaçamento mínimo entre elementos inline |
| `sm` | 8px | Gap entre ícones e texto |
| `md` | 16px | Padding interno de inputs, margens internas |
| `lg` | 24px | Padding de cards, padding horizontal de botões |
| `xl` | 32px | Margens entre seções |
| `xxl` | 48px | Altura mínima de botões |

### Valores já aplicados no tema

- **Card padding:** `24px` (todos os lados)
- **Input padding:** `16px` horizontal, `14px` vertical
- **Botão padding:** `24px` horizontal, `14px` vertical
- **Altura mínima de botão:** `48px`

### Regras de uso

- Manter respiro visual — evitar elementos colados nas bordas.
- Usar a escala definida; não inventar valores arbitrários (ex.: 13px, 27px).
- Conteúdo de formulários e listas deve respeitar padding lateral consistente.

---

## 5. Bordas e cantos arredondados

| Elemento | Border radius | Borda |
|---|---|---|
| Cards (`AppCard`) | `20px` | `1px solid border` |
| Botões (`PrimaryButton`) | `12px` | nenhuma |
| Inputs (`InputDecorationTheme`) | `12px` | `1px solid border` |
| Divisores | — | cor `border` |

### Regras de uso

- Cantos arredondados suaves — nunca usar `BorderRadius.zero` em componentes interativos.
- Borda de foco em inputs: cor `primary` (dourado).
- Borda padrão em inputs e cards: cor `border`.

---

## 6. Componentes base

Componentes oficiais ficam em `lib/core/widgets/`. Features devem reutilizá-los — nunca recriar variações locais.

### PrimaryButton

**Arquivo:** `lib/core/widgets/primary_button.dart`

| Propriedade | Valor |
|---|---|
| Largura | Total (`double.infinity`) |
| Altura mínima | `48px` |
| Fundo | `primary` (dourado) |
| Texto | `background` (preto), estilo `labelLarge` |
| Border radius | `12px` |

**Quando usar:** ação principal de uma tela ou formulário (salvar, confirmar, criar).

**Quando não usar:** ações secundárias, links ou ações destrutivas — esses terão componentes próprios quando necessário.

---

### AppCard

**Arquivo:** `lib/core/widgets/app_card.dart`

| Propriedade | Valor |
|---|---|
| Fundo | `surface` |
| Padding | `24px` |
| Border radius | `20px` |
| Borda | `1px solid border` |

**Quando usar:** agrupar conteúdo relacionado — formulários, resumos, listas, painéis informativos.

**Quando não usar:** como wrapper genérico de tela inteira — o scaffold já provê o fundo `background`.

---

### AppTextField (previsto)

**Arquivo:** `lib/core/widgets/app_text_field.dart` *(ainda não implementado)*

O padrão visual já está definido em `app_theme.dart` via `InputDecorationTheme`:

| Propriedade | Valor |
|---|---|
| Preenchimento | `filled: true`, cor `surfaceVariant` |
| Padding | `16px` horizontal, `14px` vertical |
| Border radius | `12px` |
| Borda padrão | `1px solid border` |
| Borda focada | `1px solid primary` |
| Label e hint | estilo `bodyMedium`, cor `secondaryText` |

**Quando implementado:** todo campo de texto do MVP deve usar `AppTextField`, nunca `TextField` com decoração customizada.

---

## 7. Tema global

O tema da aplicação é montado em `lib/core/theme/app_theme.dart` via `AppTheme.darkTheme`.

Configurações principais:

- **Material 3** ativado (`useMaterial3: true`)
- **Brightness:** dark
- **ColorScheme:** mapeado a partir de `AppColors`
- **TextTheme:** mapeado a partir de `AppTextStyles`
- **ElevatedButtonTheme:** estilo do `PrimaryButton`
- **InputDecorationTheme:** estilo base dos campos de texto

Todas as telas devem usar `AppTheme.darkTheme` como tema da aplicação. Não criar temas alternativos sem aprovação.

---

## 8. Estados de interface

Estados de carregamento, erro, vazio e sucesso devem ser tratados de forma consistente em todas as features.

### Loading (carregamento)

- Exibir indicador visual durante operações assíncronas.
- Preferir `CircularProgressIndicator` com cor `primary`.
- Desabilitar ações enquanto carrega.

### Erro

- Cor de destaque: `error`.
- Mensagem amigável ao usuário — nunca expor detalhes técnicos.
- Oferecer ação de retry quando aplicável.

### Vazio

- Texto informativo com estilo `bodyMedium`.
- Ícone ou ilustração discreta, se necessário.
- Call-to-action quando fizer sentido (ex.: "Nenhum cliente cadastrado — Adicionar cliente").

### Sucesso

- Cor de destaque: `success`.
- Feedback breve (snackbar ou mensagem inline).
- Retornar ao fluxo normal após confirmação.

---

## 9. Regras de uso

### O que fazer

- Usar `AppColors`, `AppTextStyles` e `AppTheme` como fonte única de estilos.
- Reutilizar componentes de `core/widgets/` em todas as features.
- Criar novos componentes visuais em `core/widgets/` quando houver repetição.
- Atualizar este documento ao adicionar novos tokens ou componentes.
- Manter textos da interface em **português**; nomes de código em **inglês**.

### O que não fazer

- Definir cores, tamanhos ou `TextStyle` inline dentro de features.
- Criar botões, cards ou inputs customizados localmente.
- Usar cores fora da paleta oficial.
- Introduzir temas claros ou variações visuais sem aprovação.
- Duplicar componentes que já existem em `core/`.

---

## 10. Referência de implementação

```
lib/core/theme/
  app_colors.dart       → paleta de cores
  app_text_styles.dart  → estilos tipográficos
  app_theme.dart        → tema Material 3 global

lib/core/widgets/
  primary_button.dart   → botão de ação principal
  app_card.dart         → container padrão
  app_text_field.dart   → campo de texto (previsto)
```

Este documento e os arquivos acima são a fonte oficial do padrão visual do EventPro. Qualquer alteração visual deve ser refletida em ambos.
