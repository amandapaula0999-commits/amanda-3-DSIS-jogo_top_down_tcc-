#region Inicialização

// Menu principal - inicialização
jogo_estado_iniciar(true);
gpu_set_texfilter(false);
display_set_gui_size(1366, 768);
window_set_fullscreen(true);
selecionado = 0;
quantidade_opcoes = 4;
animacao_cartao = [0, 0, 0, 0];
// Geometria compartilhada entre desenho e interação.
cartao_x = [950, 950, 950, 615];
cartao_y = [311, 363, 428, 366];
cartao_limite = [352, 405, 470, 427];
cartao_largura = [320, 320, 320, 224];
cartao_altura = [110, 110, 110, 104];
cartao_escala = [0.9, 0.9, 0.9, 0.92];
hover_altura = 18;
input_mouse = false;
mouse_anterior_x = device_mouse_x_to_gui(0);
mouse_anterior_y = device_mouse_y_to_gui(0);
pad_anterior = -1;
pad_eixo_x = 0;
pad_eixo_y = 0;
saindo_jogo = false;
saida_tempo = 0;
saida_y_inicial = cartao_y[3];
saida_extrair_duracao = 0.50;
saida_zoom_duracao = 0.80;
saida_coberta_desenhada = false;
saida_coberta_tempo = 0;
saida_encerrada = false;
mostrar_controles = false;
bloqueio_input = 10;
pulso = 0;
iniciando_jogo = false;
tempo_transicao = 0;

// Para os sons anteriores ao abrir o menu.
audio_stop_all();
bunker_audio_forcar("NORMAL");

#endregion
