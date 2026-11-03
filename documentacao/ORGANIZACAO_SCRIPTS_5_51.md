# Organização dos scripts — versão 5.51

Base: versão 5.50 PAUSA_VISIVEL_COMPLETO. Esta versão reorganiza os arquivos por responsabilidade.
O antigo nome `Scr_fluxo_v5` já havia sido substituído por `Scr_progressao` na base atual.
Os tamanhos encontrados na base foram 653 linhas em `Scr_bunker` e 755 em `Scr_progressao`.

## Onde encontrar cada sistema

No Asset Browser, use a pasta **Scripts**, dividida em Sistemas, Interface, Cenario, Jogabilidade, Progressao e Salas.

| Script | Pasta | Linhas | Responsabilidade |
| --- | --- | ---: | --- |
| `Scr_camera` | Sistemas | 96 | Configuração da tela, enquadramento e câmera cinemática. |
| `Scr_audio` | Sistemas | 91 | Trilhas, efeitos, volumes e transições de áudio. |
| `Scr_configuracoes` | Interface | 57 | Opções de áudio e apresentação da tela de configurações. |
| `Scr_menu_cartoes` | Interface | 144 | Geometria compartilhada e apresentação dos cartões dos menus. |
| `Scr_personagens_visual` | Cenario | 48 | Proporções dos personagens e encaixe visual das armas. |
| `Scr_combate` | Jogabilidade | 109 | Impactos do cano e do boss, queda dos barris e liberação do ácido. |
| `Scr_coletas` | Jogabilidade | 28 | Registro de munição e evidências, com prevenção de coletas duplicadas. |
| `Scr_percepcao` | Jogabilidade | 18 | Ruído e visibilidade usados pela percepção dos inimigos. |
| `Scr_vitoria` | Progressao | 35 | Encerramento da fase e avanço temporal da cena de vitória/créditos. |
| `Scr_cenario_dinamico` | Cenario | 81 | Desenho dinâmico dos escombros e ajuste de qualidade do cenário. |
| `Scr_debug` | Sistemas | 114 | Navegação de teste entre salas pela tecla P. |
| `Scr_checkpoints` | Progressao | 26 | Gravação de checkpoints e reinício a partir do ponto salvo. |
| `Scr_passagens` | Progressao | 83 | Alcance, requisitos e uso de portas, escadas e dutos. |
| `Scr_passagens_visual` | Cenario | 90 | Apresentação das passagens e nomes acima das portas. |
| `Scr_progressao` | Progressao | 97 | Liberação dos arquivos, chave da escadaria e sequência de entrada/saída da arena. |
| `Scr_interface_mensagens` | Interface | 163 | Avisos, textos contextuais da fase 2 e mensagens dos escombros. |
| `Scr_ferramentas` | Salas | 58 | Interações e feedback da sala de ferramentas. |
| `Scr_boss_movimento` | Jogabilidade | 100 | Navegação, deslocamento, animação e verificação de trajetos do boss. |

Os cinco módulos existentes de estado, colisões, visual do bunker, depósito e laboratório também aparecem nessas pastas. Seus códigos GML permaneceram idênticos.

## Preservação do comportamento

As 67 funções extraídas mantêm literalmente seus nomes, parâmetros e corpos. Não há wrappers adicionais nem cópias duplicadas. As chamadas feitas pelos objetos continuam iguais. Os novos recursos .yy, o projeto .yyp e a ordenação do Asset Browser foram atualizados juntos.

`Scr_progressao` contém apenas progressão: arquivos, chave da escadaria e sequência da arena. `Scr_bunker` foi removido do registro e substituído pelos módulos específicos.

A pausa continua em `Obj_pause`, com a profundidade corrigida na versão 5.50. Todos os eventos dos objetos, rooms, sprites, sons, fontes e opções são idênticos à base.

A separação facilita encontrar e manter cada sistema; não representa uma otimização de FPS. O desenho existente foi organizado por assunto, sem redesenho nesta versão.

## Validação

- Igualdade literal das 67 funções movidas e dos nomes das 106 funções nomeadas do projeto.
- Sem novas funções duplicadas, recursos de script sem registro ou referências ausentes.
- 190 recursos registrados, 199 arquivos de metadados e 97 eventos verificados.
- Oito testes de estado, inventário, requisitos de portas e checkpoints passaram em simulação JavaScript usando trechos dos scripts GML. O teste incluído foi atualizado para os novos caminhos.
- Dois arquivos já não registrados na base (`Font_de_fala.old.yy` e `Spr_checkpoint.yy`) foram preservados; esta versão não é uma limpeza de assets.
- Compilação e execução no GameMaker pendentes. A comparação estrutural e as simulações não substituem o teste na engine.

Para repetir o teste de lógica com Node.js: `node documentacao/testes/testar_estado.js`.

Na engine, compile e verifique início da partida, ESC/configurações/J, áudio, portas, morte/checkpoint e boss.

## Índice das funções movidas

| Função | Arquivo atual | Origem |
| --- | --- | --- |
| `arquivo_liberado` | `scripts/Scr_progressao/Scr_progressao.gml` | `Scr_progressao` |
| `boss_animar` | `scripts/Scr_boss_movimento/Scr_boss_movimento.gml` | `Scr_progressao` |
| `boss_bloqueio_desenhar` | `scripts/Scr_cenario_dinamico/Scr_cenario_dinamico.gml` | `Scr_progressao` |
| `boss_concluir` | `scripts/Scr_progressao/Scr_progressao.gml` | `Scr_progressao` |
| `boss_deslocar` | `scripts/Scr_boss_movimento/Scr_boss_movimento.gml` | `Scr_progressao` |
| `boss_iniciar` | `scripts/Scr_progressao/Scr_progressao.gml` | `Scr_progressao` |
| `boss_mover` | `scripts/Scr_boss_movimento/Scr_boss_movimento.gml` | `Scr_progressao` |
| `boss_trecho_livre` | `scripts/Scr_boss_movimento/Scr_boss_movimento.gml` | `Scr_progressao` |
| `bunker_audio_aplicar_configuracao` | `scripts/Scr_audio/Scr_audio.gml` | `Scr_bunker` |
| `bunker_audio_atualizar` | `scripts/Scr_audio/Scr_audio.gml` | `Scr_bunker` |
| `bunker_audio_contexto` | `scripts/Scr_audio/Scr_audio.gml` | `Scr_bunker` |
| `bunker_audio_forcar` | `scripts/Scr_audio/Scr_audio.gml` | `Scr_bunker` |
| `bunker_audio_parar` | `scripts/Scr_audio/Scr_audio.gml` | `Scr_bunker` |
| `bunker_audio_recurso` | `scripts/Scr_audio/Scr_audio.gml` | `Scr_bunker` |
| `bunker_audio_tocar_efeito` | `scripts/Scr_audio/Scr_audio.gml` | `Scr_bunker` |
| `bunker_aviso_gui` | `scripts/Scr_interface_mensagens/Scr_interface_mensagens.gml` | `Scr_progressao` |
| `bunker_barril_derramar` | `scripts/Scr_combate/Scr_combate.gml` | `Scr_bunker` |
| `bunker_camera_atualizar` | `scripts/Scr_camera/Scr_camera.gml` | `Scr_bunker` |
| `bunker_camera_cinematica` | `scripts/Scr_camera/Scr_camera.gml` | `Scr_bunker` |
| `bunker_cano_impacto` | `scripts/Scr_combate/Scr_combate.gml` | `Scr_bunker` |
| `bunker_cano_pixels` | `scripts/Scr_combate/Scr_combate.gml` | `Scr_bunker` |
| `bunker_cartao_bloco` | `scripts/Scr_menu_cartoes/Scr_menu_cartoes.gml` | `Scr_bunker` |
| `bunker_cartao_desenhar` | `scripts/Scr_menu_cartoes/Scr_menu_cartoes.gml` | `Scr_bunker` |
| `bunker_cartao_letras` | `scripts/Scr_menu_cartoes/Scr_menu_cartoes.gml` | `Scr_bunker` |
| `bunker_coletar_municao` | `scripts/Scr_coletas/Scr_coletas.gml` | `Scr_bunker` |
| `bunker_configuracao_alternar` | `scripts/Scr_configuracoes/Scr_configuracoes.gml` | `Scr_bunker` |
| `bunker_configuracoes_desenhar` | `scripts/Scr_configuracoes/Scr_configuracoes.gml` | `Scr_bunker` |
| `bunker_configurar_tela` | `scripts/Scr_camera/Scr_camera.gml` | `Scr_bunker` |
| `bunker_derrubar_barril` | `scripts/Scr_combate/Scr_combate.gml` | `Scr_bunker` |
| `bunker_desempenho_tick` | `scripts/Scr_cenario_dinamico/Scr_cenario_dinamico.gml` | `Scr_bunker` |
| `bunker_emitir_ruido` | `scripts/Scr_percepcao/Scr_percepcao.gml` | `Scr_bunker` |
| `bunker_escala_inimigo` | `scripts/Scr_personagens_visual/Scr_personagens_visual.gml` | `Scr_bunker` |
| `bunker_escala_protagonista` | `scripts/Scr_personagens_visual/Scr_personagens_visual.gml` | `Scr_bunker` |
| `bunker_evidencia_indice` | `scripts/Scr_coletas/Scr_coletas.gml` | `Scr_bunker` |
| `bunker_fase2_conteudo` | `scripts/Scr_interface_mensagens/Scr_interface_mensagens.gml` | `Scr_progressao` |
| `bunker_fase2_ferramentas_texto` | `scripts/Scr_interface_mensagens/Scr_interface_mensagens.gml` | `Scr_progressao` |
| `bunker_fase2_gui` | `scripts/Scr_interface_mensagens/Scr_interface_mensagens.gml` | `Scr_progressao` |
| `bunker_fase2_mensagem` | `scripts/Scr_interface_mensagens/Scr_interface_mensagens.gml` | `Scr_progressao` |
| `bunker_impacto` | `scripts/Scr_combate/Scr_combate.gml` | `Scr_bunker` |
| `bunker_interface_fase2` | `scripts/Scr_interface_mensagens/Scr_interface_mensagens.gml` | `Scr_progressao` |
| `bunker_pause_cartoes` | `scripts/Scr_menu_cartoes/Scr_menu_cartoes.gml` | `Scr_bunker` |
| `bunker_pause_couro` | `scripts/Scr_menu_cartoes/Scr_menu_cartoes.gml` | `Scr_bunker` |
| `bunker_pause_layout` | `scripts/Scr_menu_cartoes/Scr_menu_cartoes.gml` | `Scr_bunker` |
| `bunker_pause_recorte` | `scripts/Scr_menu_cartoes/Scr_menu_cartoes.gml` | `Scr_bunker` |
| `bunker_porta_em_alcance` | `scripts/Scr_passagens/Scr_passagens.gml` | `Scr_bunker` |
| `bunker_porta_rotulo_desenhar` | `scripts/Scr_passagens_visual/Scr_passagens_visual.gml` | `Scr_progressao` |
| `bunker_pose_bracos` | `scripts/Scr_personagens_visual/Scr_personagens_visual.gml` | `Scr_bunker` |
| `bunker_registrar` | `scripts/Scr_coletas/Scr_coletas.gml` | `Scr_bunker` |
| `bunker_tem_id` | `scripts/Scr_coletas/Scr_coletas.gml` | `Scr_bunker` |
| `bunker_visivel` | `scripts/Scr_percepcao/Scr_percepcao.gml` | `Scr_bunker` |
| `bunker_vitoria_atualizar` | `scripts/Scr_vitoria/Scr_vitoria.gml` | `Scr_bunker` |
| `bunker_vitoria_iniciar` | `scripts/Scr_vitoria/Scr_vitoria.gml` | `Scr_bunker` |
| `cenario_dinamico_desenhar` | `scripts/Scr_cenario_dinamico/Scr_cenario_dinamico.gml` | `Scr_progressao` |
| `checkpoint_gravar` | `scripts/Scr_checkpoints/Scr_checkpoints.gml` | `Scr_progressao` |
| `checkpoint_reiniciar` | `scripts/Scr_checkpoints/Scr_checkpoints.gml` | `Scr_progressao` |
| `corredor_entulho_desenhar` | `scripts/Scr_cenario_dinamico/Scr_cenario_dinamico.gml` | `Scr_progressao` |
| `debug_avancar_sala` | `scripts/Scr_debug/Scr_debug.gml` | `Scr_progressao` |
| `entulho_interface_desenhar` | `scripts/Scr_interface_mensagens/Scr_interface_mensagens.gml` | `Scr_progressao` |
| `entulho_pilha_desenhar` | `scripts/Scr_cenario_dinamico/Scr_cenario_dinamico.gml` | `Scr_progressao` |
| `escadaria_criar_chave` | `scripts/Scr_progressao/Scr_progressao.gml` | `Scr_progressao` |
| `passagem_atualizar` | `scripts/Scr_passagens/Scr_passagens.gml` | `Scr_progressao` |
| `passagem_desenhar` | `scripts/Scr_passagens_visual/Scr_passagens_visual.gml` | `Scr_progressao` |
| `passagem_liberada` | `scripts/Scr_passagens/Scr_passagens.gml` | `Scr_progressao` |
| `progressao_atualizar` | `scripts/Scr_progressao/Scr_progressao.gml` | `Scr_progressao` |
| `sala10_entrar` | `scripts/Scr_ferramentas/Scr_ferramentas.gml` | `Scr_progressao` |
| `sala10_sprites_atualizar` | `scripts/Scr_ferramentas/Scr_ferramentas.gml` | `Scr_progressao` |
| `sala10_step` | `scripts/Scr_ferramentas/Scr_ferramentas.gml` | `Scr_progressao` |
