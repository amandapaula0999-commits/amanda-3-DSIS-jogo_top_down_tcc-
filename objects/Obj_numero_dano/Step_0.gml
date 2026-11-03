if (bunker_jogo_bloqueado()) exit;
var dt = bunker_dt();
tempo += dt;
y -= 18 * dt;
if (tempo >= duracao) instance_destroy();
