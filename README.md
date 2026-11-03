6.30 - BARRIL E CAIXAS DE PREGOS
Base: 6.28 enviada. Detalhes: ALTERACOES_6_30.txt.

6.28 - KITS REAPARECEM APÓS A MORTE
Detalhes: CORRECAO_KITS_6_28.txt.

6.27 — COLISÕES E CORREDOR
Corpo dos inimigos bloqueado pelas paredes; escada ascendente no nível 2;
corredor redesenhado no estilo da fase 1. Detalhes: ALTERACOES_6_27.txt.
Validação estática e simulada; execução no GameMaker ainda não realizada.

6.24 — BRILHOS E DICAS
Kits e duto destacados, pensamento ao sair sem usar o duto e fala no buraco final.
Detalhes: CORRECOES_6_24.txt.

6.23 — INVESTIDA E ARMA NA FASE 2
Corrigido o alcance de dano da investida da cobra. Pistola na sala do pé de cabra,
com uma caixa de 14 pregos. Removidas as caixas da fase 1.
Detalhes: CORRECOES_6_23.txt.

6.22 — SAÍDA E INTERAÇÃO
Fundo preto correto na escadaria final. E mais consistente; diálogos com E ou Espaço.
Detalhes e roteiro de verificação: CORRECOES_6_22.txt.

6.20 — KITS DE VIDA
E: guardar kit. Q: usar e curar 20% da vida máxima. Vida cheia não gasta kit.
Cinco kits: 2 no boss 1 e 3 no boss final. Três caixas extras de 14 pregos na fase 2.
Detalhes: KITS_E_MUNICAO_6_20.txt.

6.19 — PENSAMENTO SOBRE MUNIÇÃO E SAÍDA
Ao obter a pistola, o personagem explica os controles e pensa em guardar pregos
para ameaças maiores. Botão direito: atacar/atirar; esquerdo: recarregar;
1: cano; 2: pistola. O cano não pode mais ser arremessado.
O cientista orienta procurar uma porta de emergência com escadaria para fora.
Detalhes e validação: MUNICAO_E_SAIDA_6_19.txt.

6.09 — CENA DE SURGIMENTO
Após derrotar o caracol, a câmera aproxima o buraco.
A cobra emerge em oito quadros. O jogador fica parado durante a cena.
A câmera retorna e libera o combate com a barra de vida.
A cena respeita pausa e mantém a proporção da câmera durante o zoom.
Validação estática; teste de execução no GameMaker pendente.

HISTÓRICO
6.08 — HOMEM-COBRA
O laboratório começa com um caracol. Ao derrotá-lo, o homem-cobra sai do buraco.
Boss com 240 de vida, quatro direções, perseguição e golpe próximo com preparação.
Barra de vida no topo no padrão do homem-formiga. Cano e pregos causam dano.
Durante a luta, as saídas ficam bloqueadas. Após vencer, o buraco leva à escadaria.
Validação estática; compilação e teste no GameMaker pendentes.

HISTÓRICO
6.07 — LABORATÓRIO AMPLIADO
Sala ampliada de 640 x 427 para 960 x 640.
Nova arte com experimentos mais afastados e buraco integrado à parede esquerda.
Colisões, leituras das cápsulas, terminal, inimigos e entrada reposicionados.
Passagem pelo buraco preservada até a escadaria final.
Recursos e percurso verificados estaticamente; execução no GameMaker pendente.

HISTÓRICO

Versão 6.06 — limpeza de sprites sem uso. Veja LIMPEZA_6_06.txt.

6.05 — CÂMERA DA SAÍDA CORRIGIDA
A sala final usa escala uniforme e fica centralizada, com margens laterais.
A câmera mostra todo o corredor e mantém a proporção durante os créditos.
Arte, colisões e progressão mantidas da versão 6.04.
Validação estática concluída. Execução no GameMaker pendente.

HISTÓRICO

6.04 — ESCADARIA
Arte atualizada com a escada de saída ampliada e a escada de descida quebrada.
O jogador entra pelo buraco à direita, segue para baixo e sobe a escada à esquerda.
O trajeto de subida acompanha os degraus até a saída e inicia os créditos.
As antigas colisões horizontais da escada foram removidas.
A porta vermelha permanece bloqueada por pedras.

Validação estática dos arquivos e percurso. Execução no GameMaker pendente.

HISTÓRICO

6.03 — CORREDOR DE SAÍDA
Buraco de entrada na parede direita, parte superior.
Escada quebrada no alto à esquerda, bloqueada por colisão.
Porta vermelha à direita, parte inferior, obstruída por pedras.
Escada de emergência à esquerda, parte inferior, encerra o jogo.
O jogador chega perto do buraco e segue pelo corredor até a escada.

Verificação estática dos recursos concluída. Teste no GameMaker pendente.

DOCUMENTAÇÃO ANTERIOR

# Escape the Bunker — 6.02

VERSÃO 6.02 — SAÍDA FINAL

Na última sala (laboratório), examine o buraco na parede esquerda com E.
Após a fala, pressione Espaço para atravessar até o corredor de saída.
Caminhe até a escadaria central para subir e encerrar o jogo com os créditos.
A porta vermelha e as pedras compõem o cenário da saída.
O encerramento provisório na fase 1 está desativado.

COMO ABRIR
Extraia o ZIP completo e abra tcc.yyp no GameMaker.
IDE de referência registrada no projeto: 2024.14.4.222.
Execute em Build > Run. A compatibilidade do runtime precisa ser conferida no IDE.

VERIFICAÇÃO
Recursos, referências e arquivos de projeto conferidos estaticamente.
Compilação e teste de execução no GameMaker ainda pendentes.


---

## Documentação anterior

Versão 5.58 — Caracol
Base: 5.56. Novo visual e animações do caracol nas quatro direções.

# Escape The Bunker

Jogo 2D de exploração, investigação e sobrevivência, com visão de cima e arte em pixels. Desenvolvido em GameMaker/GML como projeto acadêmico de PDS.

**Versão documentada:** 5.56, baseada na 5.55.  
**Situação:** protótipo jogável em desenvolvimento; a história completa ainda não está concluída.

## História e objetivo

O jogador assume o papel de um inspetor ambiental que visita o Complexo Nereida. Após passar pela recepção e chegar à sala de espera, uma explosão provoca sua queda em um bunker. Para encontrar uma saída, ele precisa explorar as salas, registrar irregularidades, conversar com sobreviventes, coletar equipamentos e enfrentar criaturas ligadas aos experimentos da empresa.

## Requisitos e versão do GameMaker

- Computador com Windows para executar o alvo desktop do projeto.
- Teclado e mouse.
- GameMaker instalado, com os componentes necessários para executar projetos no alvo Windows.
- **IDE de referência: GameMaker 2024.14.4.222**, registrada em `MetaData.IDEVersion` no arquivo `tcc.yyp`. Use essa versão como referência para abrir o projeto.
- Runtime compatível com a IDE. A versão exata ainda precisa ser registrada.

Requisitos mínimos de hardware e compatibilidade com outras versões da IDE ainda não foram testados.

## Como abrir e executar

1. Baixe o ZIP completo do projeto.
2. Extraia **todo o conteúdo** para uma pasta local, por exemplo `C:\Projetos\EscapeTheBunker`. Não abra o projeto dentro do ZIP.
3. Mantenha `tcc.yyp` junto das pastas `objects`, `scripts`, `rooms`, `sprites`, `sounds`, `fonts` e `options`. Copiar somente o `.yyp` não é suficiente.
4. Abra o GameMaker e selecione **File > Open Project** (Arquivo > Abrir projeto).
5. Localize a pasta extraída e abra **`tcc.yyp`**.
6. Aguarde o carregamento dos recursos. Se necessário, conclua a instalação do runtime compatível antes de executar.
7. Selecione **Windows** como plataforma de destino. Para o teste inicial, use a opção **VM**, quando disponível na seleção de destino.
8. Use **Build > Run** ou o botão de executar da IDE.
9. Após a compilação, escolha a opção de iniciar no menu do jogo.

O ZIP contém o **projeto-fonte**, não um executável pronto. Para jogar sem a IDE, é necessário gerar e distribuir uma compilação do jogo.

### Se houver erro

- **Recurso não encontrado:** extraia novamente o ZIP completo e confira se as pastas permaneceram juntas.
- **Erro ao carregar o projeto:** confira a versão da IDE e registre a mensagem completa. Não apague recursos nem edite a versão no `.yyp` para forçar a abertura.
- **Erro após trocar de versão do projeto:** use **Build > Clean** e execute novamente para descartar o cache antigo.
- **Erro de compilação ou execução:** informe o objeto, evento, linha e mensagem exibidos pelo GameMaker, além da versão da IDE e do runtime.

## Controles

| Comando | Ação |
|---|---|
| **W, A, S, D** | Movimentar o personagem. |
| **Mouse** | Mirar e selecionar opções dos menus. |
| **E** | Interagir, abrir portas, examinar e coletar itens próximos. |
| **Segurar E** | Forçar a porta da câmara fria por 3 segundos, quando estiver com o pé de cabra. |
| **J** | Abrir ou fechar o diário de evidências. |
| **Shift** | Andar de forma furtiva, com menos ruído. |
| **1** | Equipar o cano, depois de coletá-lo. |
| **2** | Equipar a arma de pregos, depois de coletá-la. |
| **Botão direito do mouse** | Atacar com o cano ou disparar a arma equipada. Também executa a finalização furtiva quando disponível. |
| **Botão esquerdo do mouse** | Recarregar a arma de pregos; nos menus, selecionar opções. |
| **Espaço** | Completar ou avançar diálogos. O cano não pode ser arremessado. |
| **Esc** | Abrir/fechar a pausa ou voltar de uma tela de menu. |
| **F11** | Alternar o modo de tela. |
| **Setas ou WASD** | Navegar nos menus. No diário, esquerda/direita ou A/D mudam a página. |
| **Enter ou Espaço** | Confirmar opções dos menus. |

Os comandos dependem do contexto: diálogos, pausas e cenas bloqueiam ações de combate e movimento. A recepcionista também aceita **E** para avançar a conversa.

**Atalho de desenvolvimento:** a tecla **P** percorre o roteiro de salas de teste. Ela pode pular etapas e não deve ser usada para avaliar a progressão normal da história.

## Conteúdo e encerramento atual

| Parte | Situação nesta versão |
|---|---|
| Prólogo | Fachada, recepção, sala de espera, explosão e queda no bunker. |
| Fase 1 | Exploração, evidências, equipamentos, inimigos, passagens e checkpoints. |
| Boss da fase 1 | Encontro com o Homem-Formiga, com cena de início e liberação da saída. |
| Encerramento da demonstração | A escadaria da fase 1 aciona a sequência de encerramento e os créditos. |
| Fase 2 | Há salas e interações no projeto, acessíveis pelo roteiro de testes ou pela configuração de desenvolvimento. |
| Boss final humano-cobra | **Não implementado.** |
| Desfecho completo da história | **Pendente.** Os créditos atuais encerram a demonstração, não a história completa. |

No arquivo `scripts/Scr_estado_jogo/Scr_estado_jogo.gml`, a configuração atual inclui:

```gml
portas_livres: true,
encerrar_na_escadaria: true
```

`portas_livres` permite ignorar parte das travas de progressão para testes; algumas portas mantêm seus requisitos específicos. `encerrar_na_escadaria` ativa o encerramento provisório da fase 1. Desabilitar essa opção **não implementa o Boss cobra nem o final da história**.

Para testar a progressão normal, desative `portas_livres` e percorra a campanha desde o início.

### Pendências para concluir o jogo

- Implementar e testar o encontro com o Boss final humano-cobra.
- Concluir a progressão até esse encontro e o desfecho da história.
- Substituir o encerramento provisório pelo encerramento definitivo.
- Testar a campanha com os atalhos e liberações de desenvolvimento desativados.

## Checkpoints

Os checkpoints permitem retornar a um ponto da partida após morrer. O projeto grava informações de checkpoint em `checkpoint_v5.ini`, mas a leitura desse arquivo ainda não foi implementada. Continuar a campanha após fechar o jogo é uma funcionalidade pendente.

## Equipe

| Integrante | Responsabilidade |
|---|---|
| Amanda | Programação. |
| Luiz de Matos | Programação. |
| Luis Augusto | História, concepção do jogo e ideias de design. |
| Isa | Artes. |

## Git e histórico de desenvolvimento

O histórico inicial ficou concentrado em poucos commits de um único autor. Grande parte do projeto foi adicionada de uma vez, sem registros separados das etapas de desenvolvimento.

Os ZIPs numerados e o `VERSAO.txt` identificam as versões, mas não substituem o histórico do Git.

### Próximos passos no Git

- Registrar cada correção ou funcionalidade em um commit separado.
- Usar mensagens que expliquem a mudança, como `Corrige colisão da porta da recepção`.
- Cada integrante registrar suas próprias alterações, incluindo artes e documentação.
- Organizar tarefas e erros em issues e revisar as mudanças em equipe.
- Criar uma tag para cada versão testada.
- Documentar as etapas anteriores com os registros disponíveis, sem alterar datas ou autorias.

## Organização do projeto

- `tcc.yyp`: arquivo usado para abrir o projeto no GameMaker.
- `rooms/`: salas, instâncias e configuração do layout.
- `objects/`: objetos e seus eventos GML.
- `scripts/`: funções compartilhadas, organizadas por assunto.
- `sprites/`, `sounds/` e `fonts/`: recursos visuais, sonoros e fontes.
- `options/`: configurações do projeto e das plataformas.
- `documentacao/`: notas e registros das versões anteriores.
- `VERSAO.txt`: identificação da entrega.

## Verificação da versão 5.56

Revisão de documentação e comentários. As instruções dos 127 arquivos GML continuam iguais às da versão 5.55. Salas, sprites e mecânicas permanecem iguais.

Verificação estática: comparação do código, fechamento das regiões e integridade do pacote. Compilação e execução no GameMaker pendentes.

### Testes pendentes

Registrar a IDE e o runtime usados e testar: abertura do projeto, prólogo, movimentação, colisões, coleta, diálogos, checkpoints, Boss da fase 1 e créditos da demonstração.

## Referências para abrir e executar

- [Manual oficial — File Menu / Open Project](https://manual.gamemaker.io/monthly/en/IDE_Navigation/Menus/The_File_Menu.htm)
- [Manual oficial — Build Menu / Run / Clean](https://manual.gamemaker.io/monthly/en/IDE_Navigation/Menus/The_Build_Menu.htm)

IDE registrada em `tcc.yyp`. Controles e configurações correspondem ao código da versão 5.56.
