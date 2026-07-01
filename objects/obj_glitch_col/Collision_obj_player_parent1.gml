if !activated {
    activated = true;
    global.glitch_state = 1; // Activa el glitch

    // Opcional: destruir el objeto para que no vuelva a activarse
    instance_destroy();
}