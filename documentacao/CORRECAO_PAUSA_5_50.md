# Correção da interface invisível — 5.50

O erro foi introduzido na refatoração 5.49. Obj_pause era criado com depth
-100000. O intervalo de desenho documentado da engine é -16000 a 16000;
fora dele, a instância pode continuar processando eventos sem ser desenhada.

Alteração funcional única: Obj_jogador/Create_0.gml cria Obj_pause com depth
-10000. O controlador permanece separado do jogador e usa a mesma arte.
Os Draw GUI de pausa, configurações e diário não foram redesenhados.

Verificação estática confirmou a falha do valor anterior e a validade do novo,
visible=true, registro do Draw GUI e presença dos sprites e recursos.
Todos os outros arquivos de gameplay, rooms, sprites e sons foram comparados
byte a byte com o ZIP 5.49 e permaneceram idênticos.

Os 13 testes simulados da entrega anterior verificavam entradas e transições;
não simulavam o limite de desenho da engine. Seus resultados históricos não
constituem teste visual da correção atual. GameMaker/Igor não está disponível,
portanto esta versão não foi compilada nem executada na engine.

Teste visual na engine: abrir ESC, verificar carteira/cartões, entrar e sair
das configurações, continuar, abrir/fechar J e repetir depois de mudar de room.

Referência oficial:
https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Instances/instance_create_depth.htm
