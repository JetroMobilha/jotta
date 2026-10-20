# 🛡️ Jota | Otimizador de Sistema (Stealth UI)

> **A verdadeira otimização acontece em segundo plano.** <br>
> Uma ferramenta de privacidade e utilidade furtiva construída exclusivamente para o ecossistema Android.

![Status](https://img.shields.io/badge/Status-Desenvolvimento-purple?style=flat-square)
![Plataforma](https://img.shields.io/badge/Plataforma-Android-3DDC84?style=flat-square&logo=android&logoColor=white)
![Framework](https://img.shields.io/badge/Framework-Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Nativo](https://img.shields.io/badge/Nativo-Kotlin-7F52FF?style=flat-square&logo=kotlin&logoColor=white)

---

## 🕵️‍♂️ O que é o Jota?

Apresentando-se externamente como uma aplicação genérica de **"Otimização de Sistema"** (limpeza de RAM/Rede), o verdadeiro propósito do Jota é a **proteção da privacidade das telecomunicações**.

O Jota deteta, elimina e arquiva num cofre seguro as chamadas telefónicas (*Pings*) e mensagens de texto (*Pacotes*) de uma lista configurada de contactos (*Entidades*). Tudo isto debaixo de uma interface de Modo Escuro e Neon Purple.

---

## 🚀 Funcionalidades Principais

### 🎨 Interface Camuflada (Soft UI / Dark Mode)
Adoção de uma linguagem visual inofensiva e profissional:
- **Design Furtivo:** Tons de Preto Carvão e Roxo Elétrico com animações subtis.
- **Vocabulário Criptografado:**
   - Chamadas = `Pings de Rede`
   - SMS = `Pacotes de Texto`
   - Contactos Secretos = `Entidades`
   - Cofre Seguro = `Registo de Diagnóstico`

### 🗑️ Interceção Automática (Background Workers)
Escrito com integração profunda em **Kotlin**, utilizando o `WorkManager`:
- Elimina silenciosamente as chamadas da lista de filtros em intervalos de tempo definidos.
- Monitoriza SMS e alerta o utilizador de forma encriptada (*"Nova otimização de texto"*).
- Manipula permissões inteligentemente, assumindo-se como *Default SMS App* temporariamente e devolvendo o controlo de imediato.

### 🗄️ Registo de Diagnóstico (O Cofre Seguro)
Os registos apagados não são perdidos, são encriptados e movidos para o Cofre.
- **PIN de Acesso:** Proteção por PIN de 4 dígitos.
- **Anti-Espionagem (Android OS):** Bloqueio de capturas de ecrã e visualização nas apps recentes (`FLAG_SECURE`).
- **Autodestruição de Memória:** Os ecrãs com conteúdo sensível fecham-se instantaneamente se a app for minimizada.
- **Ação Direta:** Permite ligar de volta ou eliminar definitivamente o histórico diretamente do cofre.

### 💰 Monetização Dinâmica de UX (AdMob)
- **Ecrãs de "Falso" Carregamento:** Exibição de anúncios intersticiais ou vídeos premiados durante a "Otimização de Sistema", aproveitando o tempo de espera percebido pelo utilizador enquanto o Kotlin atua em segundo plano.

---

## 🛠 Arquitetura & Tecnologias

- **Front-end:** Flutter / Dart
- **Integração Nativa Android:** Kotlin / Android APIs (`CallLogProvider`, `Telephony.Sms`, `MethodChannels`, `Intents`)
- **Tarefas em Segundo Plano:** `WorkManager` (CoroutineWorker) com Alarmes Intrusivos de Alta Prioridade.
- **Armazenamento Local:** `SharedPreferences`
- **Ecossistema:** Exclusivo para **Android** (Devido às restrições de sandboxing do iOS, que impedem o acesso nativo a registos de chamadas e SMS).

---

## 📦 Instalação para Desenvolvimento

1. **Clone o repositório:**
   ```bash
   git clone [https://github.com/JetroMobilha/jotta.git](https://github.com/JetroMobilha/jotta.git)