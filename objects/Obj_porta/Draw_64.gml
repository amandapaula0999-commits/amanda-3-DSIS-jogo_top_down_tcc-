// Reutiliza a mesma caixa de diálogo da secretária.
if (!orientacao_falando) exit;
if (global.interface.pause_aberto || global.interface.diario_aberto || global.interface.config_aberta) exit;
bunker_aviso_gui(orientacao_texto, "ESPAÇO / E: CONTINUAR");
