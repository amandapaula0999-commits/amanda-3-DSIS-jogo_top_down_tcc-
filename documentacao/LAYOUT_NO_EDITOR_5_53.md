> Histórico da 5.53: na 5.54, apenas o efeito de explosão/queda da sala de espera voltou ao Draw original. Veja CORRECOES_5_54.md.

# Layout no editor — versão 5.53

## O que mudou

As 14 rooms de gameplay agora contêm seu `Obj_mapa` e os elementos fixos do
cenário. O menu é a 15ª room. Paredes, portas, itens, inimigos e bloqueios não
são mais construídos a partir de tabelas de coordenadas em scripts.

Os 70 marcadores `Obj_ponto_mapa` guardam as chegadas, interações e pontos de
cena. Eles aparecem no editor e ficam invisíveis durante o jogo. As 24 portas
referenciam os marcadores pelo identificador, mantendo seus requisitos de
chaves e progressão. Os indícios conservam seus textos e códigos do diário.

A fachada, o buraco da queda e os escombros antes desenhados por código foram
convertidos em sprites estáticos e posicionados nas rooms. Os 514 arquivos
de imagem/áudio existentes foram preservados byte a byte; não houve redesenho.

## Como mudar uma sala

- **Parede ou caixa com colisão:** mova/redimensione a instância `Obj_parede`
  na camada de colisões. A dimensão do sprite determina a dimensão física.
- **Porta:** mova `Obj_porta` na camada `Portas`. Sua área de interação e o
  texto acompanham a posição. Nas propriedades da instância, `destino` é a
  room de destino e `ponto_destino` é o identificador da chegada nessa room.
- **Chegada:** abra a room de destino e mova o `Obj_ponto_mapa` correspondente.
  Mantenha seu identificador. Não é necessário alterar coordenadas no GML.
- **Interação/indício:** mova seu marcador na camada `Pontos_do_mapa`. Os campos
  de texto/índice pertencem à instância. Preserve índices e códigos para não
  mudar a associação das evidências ao diário.
- **Boss:** mova a instância do boss e os marcadores `boss_foco_porta`,
  `boss_fuga_preparo`, `boss_fuga_impacto` e `boss_fuga_saida`. O bloqueio da
  saída é a instância `Obj_bloqueio_arena`, inicialmente sem colisão.
- **Câmara fria:** seu bloqueio é `Obj_bloqueio_camara`; a interação com o
  homem usa o ponto `homem_camara`.
- **Checkpoint/atalho P:** nas propriedades de `Obj_mapa`, configure
  `ponto_checkpoint`, `proxima_sala_debug` e `ponto_debug`.

As propriedades de texto são expressões: mantenha as aspas, por exemplo
`"inicio"`. Não duplique um identificador de ponto dentro da mesma room.

O cenário continua usando as artes completas existentes. Ao mover a posição
de uma parede ilustrada no fundo, ajuste também a arte correspondente; mover
o colisor não modifica os pixels da imagem.

## Ordem de criação

A ordem configurada nas rooms é: `Obj_mapa`, marcadores/colisores, demais
objetos e jogador. Preserve essa ordem ao adicionar instâncias. `Room Start`
reúne os indícios e inicia os encontros depois que todos os objetos existem.

Projéteis, ácido derramado e itens equipados continuam sendo criados durante
o jogo: são efeitos da jogabilidade, sem posições fixas de layout. Dimensões
da interface, velocidades, durações e distâncias relativas não foram removidas.

## Verificações e limite

Foram conferidos recursos, eventos, imagens, propriedades, ordem de criação,
portas e marcadores. As posições de origem, chegadas e colisões migradas foram
comparadas com a versão 5.52. Nove simulações de funções GML com substitutos
da engine verificaram transições, boss em diferentes taxas de quadros,
checkpoints, indícios, P durante a pausa e retorno ao laboratório. Os oito
testes de estado/inventário também passaram.

Não houve compilação nem execução nativa no GameMaker. Antes de distribuir,
confira no jogo: nova partida, transições, queda, coleta da chave do boss,
fechamento/abertura da arena, morte/checkpoint, câmara fria, retorno ao
laboratório, pausa e atalho P. Os testes JavaScript não substituem essa etapa.
