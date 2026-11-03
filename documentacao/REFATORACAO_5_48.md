# Refatoração 5.48

Base: Escape_The_Bunker_v5_47_COLISOES_TEMPO_COMPLETO.

## O que mudou

As 84 variáveis globais avulsas passaram a ser 84 campos distribuídos por 13 estruturas. A quantidade de informações necessárias ao jogo não foi escondida nem eliminada; cada campo agora tem um domínio e um local de criação explícitos. Nenhum alias dos nomes antigos foi mantido.

Exemplos:

```gml
global.inventario.chave_escadaria
global.progresso.boss_derrotado
global.checkpoint.sala
global.config.musica_muda
checkpoint_gravar(room, x, y);
boss_iniciar();
```

`Scr_fluxo_v5` foi renomeado para `Scr_progressao`, incluindo o registro no projeto. As funções com prefixos v5_, v53_, v54_, v536_, s8_ e s34_, os campos v535_ e as variáveis locais s10_ também receberam nomes descritivos. O mapeamento completo está em MAPEAMENTO_5_48.md.

## Único ponto de criação

`Scr_estado_jogo` declara todos os campos em `jogo_estado_iniciar(_nova)`. A chamada no corpo do script prepara o estado no início do programa, antes dos eventos das instâncias. Assim, a criação do jogador ou de outro objeto não precisa declarar variáveis globais de emergência.

- `jogo_estado_iniciar(false)`: cria o estado se necessário; chamadas seguintes não alteram dados.
- `jogo_estado_iniciar(true)`: inicia uma partida limpa, reiniciando progresso, inventário, vida, checkpoints e estados temporários. É chamado no Create do menu, como ocorria na base.
- `jogo_preparar_sala()`: encerra diálogos, pausas, câmera de cena, ruídos e referências temporárias da sala anterior. Mantém inventário, vida, evidências, checkpoint e destino de entrada. É chamado no Create de Obj_mapa.

As preferências de áudio e os parâmetros de configuração permanecem entre partidas. A qualidade visual automática volta a zero no reset, conforme a base. A geometria estática do cano fica em `global.recursos` e é criada uma única vez. Não há mais inicialização dispersa no menu, no jogador, na chave ou no laboratório.

Há apenas uma chamada a `variable_global_exists`, dentro do inicializador, para detectar a primeira execução. Verificações `variable_instance_exists` foram conservadas: elas tratam atributos opcionais de tipos diferentes de objetos, não o estado global.

## Responsabilidades

| Estrutura | Conteúdo |
|---|---|
| progresso | Eventos concluídos, evidências e coletas |
| inventario | Armas, munição, chaves e cartão |
| jogador | Vida persistente |
| checkpoint | Sala, coordenadas e flags de retorno |
| transicao | Próxima entrada, queda e duto |
| config | Áudio mudo, qualidade e modos de execução |
| interface | Diálogos, diário, pausa, configurações e créditos |
| cena | Cinemáticas, Boss, bloqueio e mensagens de escombros |
| camera | Zoom, foco e dimensões |
| audio | Reprodução atual e transições da trilha |
| ruido | Eventos ouvidos pelos inimigos |
| renderizacao | Contadores de desempenho e reconstrução do cenário |
| recursos | Geometria estática reutilizável |

As estruturas ainda são compartilhadas; esta alteração organiza o estado sem tentar substituir toda a arquitetura do jogo. Novos campos devem ser declarados no inicializador, antes de serem usados por eventos.

## Compatibilidade e escopo

Os 637 arquivos de sprites, rooms, sons, fontes e demais recursos visuais verificados são idênticos aos da base. Não foram alterados tamanho das salas, posições de objetos, comportamento de combate ou regras de coleta.

O modo de portas livres e o encerramento na escadaria continuam habilitados por padrão, como na 5.47. A Sala de Ferramentas e o laboratório conservam suas exigências especiais. Não foi ativada uma nova mecânica de Boss.

O nome `checkpoint_v5.ini` foi preservado por compatibilidade de arquivo. Ele não é um identificador de variável ou função. A base grava o checkpoint nesse arquivo, mas não implementa sua leitura ao abrir o jogo; a refatoração não adiciona um sistema de save/load.

## Verificação realizada

- Todos os campos lidos no código têm declaração no estado central.
- Ausência dos prefixos históricos no código executável.
- Ausência de definições de função duplicadas ou referências antigas às funções renomeadas.
- Delimitadores dos 103 arquivos GML e JSON dos recursos verificados (aceitando a sintaxe de vírgula final do GameMaker).
- Recursos do projeto apontam para arquivos existentes; script novo registrado.
- Comparação byte a byte dos 637 arquivos de conteúdo com a base.
- Oito cenários de lógica passaram: inicialização, idempotência, troca de sala, morte em outra sala, morte na mesma sala, chaves especiais, escadaria e reset da partida.

Os testes de lógica usam um ambiente simulado JS para o subconjunto compatível do GML real, com funções da engine substituídas por simulações. Não validam renderização, física ou compilação GML. Compilação e execução no GameMaker pendentes.

## Roteiro de verificação no GameMaker

1. Extraia o ZIP em uma pasta nova, abra tcc.yyp, limpe o cache de compilação e execute.
2. Inicie uma partida e confira menu, áudio e transição da recepção até o bunker.
3. Colete arma, munição e evidência; entre e saia de uma sala, verificando a conservação dos itens e da vida.
4. Grave checkpoint, sofra dano até morrer e verifique posição de retorno, vida e inventário.
5. Teste chave de ferramentas, pé de cabra, câmara fria e cartão do laboratório.
6. Para testar a progressão normal, ajuste `global.config.portas_livres` no inicializador para false. Confira que a escadaria exige chave e Boss derrotado.
7. Inicie a luta existente, morra/reentre e conclua-a; confira câmera, porta e créditos.
8. Desative música/efeitos, retorne ao menu e inicie nova partida. As preferências devem persistir, enquanto progresso e itens são reiniciados.
