# Separação da pausa — versão 5.49

Base: Escape_The_Bunker_v5_48_ESTADO_ORGANIZADO_COMPLETO.zip.
Escopo: separar a interface de pausa do jogador.

## Responsabilidades

| Arquivo | Responsabilidade |
| --- | --- |
| Obj_pause/Create_0.gml | Estado local dos cartões e funções de congelamento/limpeza da interface. |
| Obj_pause/Step_1.gml | Begin Step: atalhos, abertura, navegação, configurações, diário e retomada. |
| Obj_pause/Step_2.gml | End Step: reiniciar, retornar ao menu ou avançar pelo atalho de teste. |
| Obj_pause/Draw_64.gml | A mesma carteira, cartões, configurações e diário da versão 5.48. |
| Obj_jogador/Create_0.gml | Cria uma instância de Obj_pause quando ainda não existe. |
| Obj_jogador/Step_0.gml | Finalização furtiva, movimento, colisão, inventário e morte. |
| Obj_jogador/Draw_64.gml | HUD de condição, equipamento e contador do diário. |

O Step do jogador passou de 440 para 228 linhas. Seu Draw GUI passou de 173
para 33 linhas. O antigo Step de Obj_pause, que implementava outro menu, foi
substituído pelos eventos Begin Step e End Step, registrados no arquivo .yy.
As configurações do menu principal continuam em Obj_menu.

## Congelamento e retomada

Obj_pause é não persistente: cada sala com jogador recebe seu controlador.
Criá-lo não pausa o jogo. Quando ESC ou J abre um menu, o controlador registra
vida/munição atuais e desativa as demais instâncias, inclusive o jogador.
A abertura ocorre no Begin Step, antes dos Steps de movimento e combate.
Cenas, diálogos e finalizações furtivas continuam bloqueando novos menus.

Continuar agenda a reativação para o próximo Begin Step. Assim a confirmação
por Enter, Espaço ou clique não chega ao combate no mesmo quadro. Reinício,
retorno ao menu e atalho P são concluídos no End Step com o mundo congelado.
P conserva os valores registrados antes da desativação. F11 continua ativo.

Os campos globais de interface existentes foram mantidos para compatibilidade
com os outros objetos. Não foram introduzidos novos campos globais.
As áreas clicáveis das configurações agora seguem a escala usada no desenho.

## Verificação realizada

- 13 cenários de interface executados a partir dos eventos GML traduzidos para
  JavaScript, com funções da engine simuladas; resultado em VALIDACAO_PAUSA_5_49.json.
- Teclado, mouse em 1366×768 e 1920×1080, D-pad, analógico e reconexão de controle.
- Configurações, diário vazio/com páginas, bloqueios de abertura, retomada,
  reinício, retorno ao menu e atalhos P/F11.
- 174 recursos do projeto, 15 rooms, 97 eventos e 232 frames de sprites verificados.
- Os blocos de gameplay do Step e o desenho dos menus foram comparados com a
  versão 5.48 e preservados literalmente. As 15 rooms e 618 arquivos de arte/áudio
  permaneceram idênticos.

## Limite da validação e teste na engine

Os testes simulados não substituem a compilação
GML, o comportamento real dos dispositivos ou a execução visual na engine.

Ao abrir tcc.yyp, compilar e verificar:

1. Abrir ESC durante movimento/combate: jogador, inimigos e projéteis devem parar.
2. Testar quatro cartões com teclado, mouse e gamepad; continuar sem ação extra.
3. Alternar música/efeitos, voltar à carteira e continuar a partida.
4. Abrir J sem registros e com registros, trocar páginas e fechar.
5. Reiniciar no checkpoint, voltar ao menu e começar outra partida.
6. Usar P/F11 com pausa/diário/configurações abertos e confirmar que a sala seguinte
   inicia normalmente, sem duplicar o controlador nem deixar áudio congelado.
