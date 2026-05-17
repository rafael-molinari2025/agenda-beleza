# Belle·Agenda v2.0

Sistema de agendamento para salões de beleza e profissionais de saúde.

## Funcionalidades

- Login / cadastro com Firebase Authentication
- Dados na nuvem via Firestore (multi-dispositivo)
- Painel com métricas do dia, semana e mês
- Agenda com calendário visual
- Cadastro de clientes e serviços
- **WhatsApp automático** — ao criar um agendamento, a mensagem de confirmação é aberta automaticamente
- **QR Code PIX** — gerado automaticamente após cada agendamento (sem API externa)
- Relatórios e gráfico mensal
- Backup em JSON

## Configuração

### 1. Firebase

1. Acesse [console.firebase.google.com](https://console.firebase.google.com) e crie um projeto
2. Em **Authentication** → Sign-in method → habilite **E-mail/Senha**
3. Em **Firestore Database** → Criar banco de dados (modo produção)
4. Em **Project Settings** → Your apps → adicione um app Web → copie o `firebaseConfig`
5. Edite `firebase-config.js` com seus dados reais

### 2. Regras do Firestore

No console do Firebase, em Firestore → Regras, cole:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 3. PIX

Após criar sua conta no sistema, vá em **Configurações** e informe:
- Sua chave PIX
- Nome do recebedor (aparece no app do pagador)
- Cidade

### 4. Hospedagem (Firebase Hosting — opcional)

```bash
npm install -g firebase-tools
firebase login
firebase init hosting
firebase deploy
```

## Arquivos

| Arquivo | Descrição |
|---|---|
| `login.html` | Tela de login e cadastro |
| `app.html` | Sistema principal |
| `firebase-config.js` | Configuração do Firebase (não commitar com dados reais) |
