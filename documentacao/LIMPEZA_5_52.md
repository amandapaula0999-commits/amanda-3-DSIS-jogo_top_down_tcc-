# Limpeza de arquivos e nomes — 5.52

Base: projeto completo 5.51.

## Nomes corrigidos

| Anterior | Atual |
| --- | --- |
| `Obj_area_boos` | `Obj_area_boss` |
| `Spr_boos_caido` | `Spr_boss_caido` |
| `Spr_sala_boos` | `Spr_sala_boss` |
| `Obj_canoAremesado` | `Obj_cano_arremessado` |
| `Spr_inimigo_andando_esqueda` | `Spr_inimigo_andando_esquerda` |
| `Spr_inimigo_parado_esqueda` | `Spr_inimigo_parado_esquerda` |

As mudanças abrangem pastas, arquivos .yy, nomes internos, caminhos de frames, cadastro em tcc.yyp, metadados e referências GML. Nenhuma imagem foi redesenhada.

## Arquivos removidos

- `fonts/Font_de_fala/Font_de_fala.old.png`
- `fonts/Font_de_fala/Font_de_fala.old.yy`
- `sprites/Spr_checkpoint/530bfdf2-8a7d-47a4-968c-ded6a1ca9ea5.png`
- `sprites/Spr_checkpoint/Spr_checkpoint.yy`
- `sprites/Spr_checkpoint/layers/530bfdf2-8a7d-47a4-968c-ded6a1ca9ea5/a7063918-faa6-4c13-b3b0-8c26b0c74540.png`

As duas cópias antigas da fonte não eram referenciadas. A fonte ativa `Font_de_fala.yy` e sua imagem `Font_de_fala.png` foram preservadas.
A pasta `Spr_checkpoint` não estava no cadastro de recursos e tinha apenas referências internas a si mesma. `Obj_checkpoint` usa `Spr_checkpoint_acido`, que foi mantido. Nenhum recurso registrado foi removido.

## Validação

- 190 recursos, 15 rooms, 97 eventos e 231 frames de sprites verificados.
- Nenhum caminho ausente, nome de recurso duplicado ou asset .yy sem cadastro nas pastas de recursos.
- Comparação de todos os arquivos com a base: somente exclusões listadas e substituições dos seis identificadores, além da documentação/versão.
- Os 120 arquivos GML conservaram exatamente a lógica anterior após normalizar os nomes. Imagens e sons restantes conservaram seus bytes.
- Não houve compilação ou execução no GameMaker. A validação foi estática.

## Conferência na engine

Abra tcc.yyp e compile. Confira a arena e o sprite do boss caído, arremesse o cano, observe o caracol parado/andando à esquerda e confirme a fonte e o checkpoint. Os nomes de rooms, posições e regras de progressão foram preservados.

A documentação de versões anteriores foi mantida como histórico; o quadro acima registra os nomes vigentes.
