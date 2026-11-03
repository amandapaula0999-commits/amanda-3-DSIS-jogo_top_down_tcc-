# Correções da versão 5.54

## Sala de espera

O sprite da queda da 5.53 estava na profundidade 10000, atrás do cenário em
1100. Foi removido e substituído pelo trecho original de `Obj_mapa/Draw_0`
da 5.52. O controlador está na profundidade 1000, acima
do fundo. A sequência conserva som, flash, textos e transição para o andar
inferior. O destino continua sendo um marcador da room.

## Porta externa

A migração havia trocado o padrão de `visual_estatico` para verdadeiro. Isso
ocultava a porta externa, cuja imagem não faz parte do fundo. O padrão voltou
a falso, como na 5.52. As portas explicitamente incorporadas ao cenário
conservam suas propriedades. A fachada usa o sprite existente, sem redesenho.

## Colisões

As áreas de algumas plantas cobriam somente seus vasos; estantes começavam
abaixo do tampo. As 20 áreas ajustadas agora incluem as superfícies indicadas
nas imagens. Há também um colisor na posição da secretária, ligado ao balcão,
para impedir sobreposição com o jogador. As mudanças estão nas instâncias de
`Obj_parede` nas rooms, mantendo a edição visual do layout. As imagens dos
cenários, o jogador e suas proporções não foram alterados.

## Verificações realizadas

- 198 recursos, 15 rooms, 24 portas, 70 marcadores e 234 frames: referências
  estruturais e arquivos válidos. Os 514 arquivos de arte/áudio da 5.52 foram
  preservados byte a byte.
- Geometria com a máscara dos pés: caminhos da recepção até as duas portas e
  a posição de conversa; caminhos até as portas da biblioteca.
- Simulação do GML selecionado: explosão desenhada, som uma vez e queda
  concluída a 20, 30, 60 e 144 FPS; emissão do desenho da porta externa.
- As nove simulações do layout/transições e os oito testes do estado passaram.

**Limite:** estas são verificações estáticas e simulações com substitutos das
funções da engine. O projeto não foi compilado nem executado no GameMaker.
Ao abrir, confira a fachada, a recepção, a explosão e as estantes da biblioteca.
