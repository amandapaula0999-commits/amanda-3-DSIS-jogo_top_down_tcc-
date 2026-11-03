#region Inicialização

// Secretária da recepção
sprite_index = Spr_recepcionista;
image_index = 0;
image_speed = 1; // Dez quadros a 4 FPS, preservando os 250 ms do GIF.
image_xscale = 1;
image_yscale = 1;
// Conversa pela frente do balcão; o NPC permanece atrás da mesa.
interacao_x = x;
interacao_y = y + 66;
raio_interacao = 26;
fala_1 = "SECRETÁRIA: Bom dia. O inspetor ambiental, correto? Seu protocolo já estava separado.";
fala_2 = "SECRETÁRIA: A gerência deixou os registros na sala de espera. Siga pelo corredor à direita.";
fala_3 = "SECRETÁRIA: No corredor, entre pela porta da esquerda. A outra sala está trancada.";
fala_4 = "SECRETÁRIA: ...e, se notar algum odor, anote como manutenção pendente. É o procedimento.";
fala_atual_num = 1;
total_falas = 4;
exibir_dialogo = false;
texto_atual = "";
texto_completo = "";
char_index = 0;
velocidade_texto = 0.70;

#endregion
