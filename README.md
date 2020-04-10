# bate_ponto_web

IDE: VS Code

## Instalar Flutter (Ubuntu)

Clone o repositório do Flutter:
```
git clone https://github.com/flutter/flutter.git -b stable
```

Adicione essa linha no final do seu arquivo ~/.bashrc
```
export PATH="$PATH:CAMINHO_DA_PASTA_QUE_VC_CLONOU_O_FLUTTER/flutter/bin"
```

Execute:
```
flutter precache
flutter channel beta
flutter upgrade
flutter config --enable-web

```

## Instalar dependências
```
flutter pub get
```

## Executar aplicação
```
flutter run -d chrome
```

# Tarefas

- [X] Cadastro empresa (Aleph)
- [X] Login admin (Aleph)
- [X] Listar abonos (Daniel)
- [X] Avaliar abono (Gabriel)
- [X] Cadastrar empregado (Aleph)
- [X] Listar empregados (Aleph)
- [ ] Atrasos
- [ ] Relatório de pontos
- [ ] Configurações: Enviar relatório automático
- [ ] Indicadores