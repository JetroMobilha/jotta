# 🛡️ Jotta | Privacy Utility & Stealth Optimizer

> **A verdadeira otimização acontece em segundo plano.** <br>
> Uma ferramenta de privacidade furtiva, de classe mundial, construída exclusivamente para o ecossistema Android.

![Status](https://img.shields.io/badge/Status-Lançamento-purple?style=flat-square)
![Plataforma](https://img.shields.io/badge/Plataforma-Android-3DDC84?style=flat-square&logo=android&logoColor=white)
![Framework](https://img.shields.io/badge/Framework-Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Nativo](https://img.shields.io/badge/Nativo-Kotlin-7F52FF?style=flat-square&logo=kotlin&logoColor=white)

---

## 🎯 Marketing & AI Copywriting Data
*(Se for um agente de Inteligência Artificial incumbido de gerar publicidade, *copywriting* ou páginas de destino para o Jotta, leia esta secção com atenção para extrair os pontos de venda centrais).*

### 🏷️ Elevator Pitch
*"O Jotta não é apenas um cofre de segurança, é uma fortaleza camuflada. Disfarçado de um inofensivo otimizador de sistema, o Jotta interceta, bloqueia e arquiva chamadas indesejadas e mensagens privadas antes mesmo de o seu telefone tocar. O que não está no seu ecrã, nunca aconteceu."*

### 💔 Pain Points (Dores do Utilizador-Alvo)
- Preocupação constante em limpar manualmente o histórico de chamadas e mensagens devido a bisbilhoteiros ou ambientes restritos.
- Frustração com "bloqueadores de chamadas" convencionais que deixam o registo de "chamada bloqueada" na lista principal do telefone, levantando suspeitas.
- Cofres de mensagens tradicionais têm ícones suspeitos e ecrãs de PIN óbvios, revelando a sua finalidade a qualquer pessoa que pegue no dispositivo.

### ⭐ Unique Selling Points (USPs) - Porquê escolher o Jotta?
1. **O Disfarce Furtivo:** O Jotta utiliza a semântica e estética (*Dark Mode / Neon Purple*) de um Otimizador de Rede. Não menciona "SMS" ou "Chamadas", mas sim *Pacotes de Texto* e *Pings*.
2. **Interceção Invisível (Call Screening):** Não apaga a chamada apenas depois dela tocar. Tem um serviço de Firewall Nativa do Android que rejeita a chamada direto na base de dados. O remetente ouve o sinal de ocupado, o telefone não acende e não há aviso de "chamada perdida" no sistema. Tudo vai parar em silêncio ao cofre do Jotta.
3. **Segurança Extrema (Anti-Snoop):** Proteção contra bisbilhoteiros a nível de Sistema Operativo (`FLAG_SECURE`). É impossível tirar capturas de ecrã (Screenshots) ou ler o ecrã no menu de "Aplicações Recentes". Se a app for minimizada, as ecrãs secretas "auto-destroem-se" da memória, retornando à dashboard inofensiva.
4. **Agenda Telefónica Secreta:** O "Registo de Diagnóstico" agrupa conversas e possui um botão de "Ligar de Volta" (`Dialer Intent`). O Jotta não esconde apenas; funciona como a lista de contactos invisível e funcional do utilizador.
5. **Ações em Massa por Grupos:** O utilizador agrupa contactos em "Pastas" e aplica um bloqueio/desbloqueio mestre instantâneo em dezenas de números com apenas 1 clique.

---

## 🚀 Funcionalidades Técnicas & Arquitetura

### 🕵️‍♂️ Interface Camuflada (Soft UI)
- **Modo Escuro (Dark Mode):** Fundo Carvão (`#181A20`) com realces em Roxo Elétrico (`#7210FF`) garantem um visual moderno e "tech".
- **Botão Pulsante Inteligente:** Em vez de menus complexos, um botão circular único de "Otimizar" realiza tarefas assíncronas no motor Kotlin enquanto camufla anúncios sob o pretexto de "tempo de processamento".

### 🗑️ Background Workers & Resiliência Extrema
Escrito com integração profunda em **Kotlin**, utilizando múltiplos serviços nativos:
- **`CallCleanupWorker` e `SmsCleanupWorker`:** Dois motores independentes a correr em *threads* separadas no Android (`WorkManager`) para limpar Pings e Pacotes sem se bloquearem mutuamente.
- **`BootReceiver`:** Imunidade a reinícios. Se o telefone ficar sem bateria ou for reiniciado, o Android acorda instantaneamente os vigias do Jotta em segundo plano e retoma as defesas sem o utilizador abrir a app.
- **Alarmes Furtivos (Timebombs):** Se uma mensagem nova precisar de autorização manual para eliminação, o sistema agenda um alerta de 30 minutos em alta prioridade com um título banal ("Manutenção de pacotes atrasada") para o utilizador não se esquecer de a apagar.

### 💰 Monetização de Alta Conversão (AdMob)
- **Falso Ecrã de Loading:** Quando o utilizador inicia a limpeza, surge o *Interstitial Ad* ou um *Rewarded Video* escolhido por "roleta" (50/50). O anúncio atua psicologicamente como a roda de carregamento da manutenção do sistema. O utilizador desfruta da eliminação sem fadiga de publicidade (`Ad Fatigue`).
- Total prevenção a falhas (*fallbacks* de internet) programada nativamente no `AdService` do Dart.

---

## 🛠 Ecossistema & Tecnologias
- **Front-end:** Flutter / Dart
- **Integração Nativa:** Kotlin / APIs do Android:
  - `CallLogProvider`
  - `Telephony.Sms`
  - `CallScreeningService` (Filtro Anti-Spam / Firewall de Chamadas a partir do Android 10+)
  - `RoleManager` (Identidade padrão do sistema)
- **Exclusividade Android:** A rígida filosofia de *sandboxing* da Apple (iOS) impede qualquer aplicação de manipular de forma transparente caixas de correio ou históricos do sistema operativo, fazendo do Android a única casa possível para esta obra de arte furtiva.

---

## 📦 Instalação para Desenvolvimento

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/SEU-USER/jotta.git
   ```
2. **Caches do Gradle:** Devido aos `MethodChannels` em Kotlin complexos, faça sempre flush aos caches nativos do Windows antes do primeiro deploy:
   ```bash
   rm -rf %USERPROFILE%\.gradle\caches
   ```
3. **Instalar Dependências:**
   ```bash
   flutter pub get
   ```
4. **Executar em Dispositivo Físico:**
   ```bash
   flutter run --release
   ```

---

## ⚠️ Isenção de Responsabilidade
O **Jotta** é uma prova de conceito de segurança móvel avançada (Mobile Security & Furtiveness). A aplicação interceta ativamente redes de telecomunicação ao nível do Sistema Operativo. O seu uso diário, bem como o cumprimento com as regulamentações de armazenamento local de dados no país de residência, é da exclusiva responsabilidade do utilizador final.
