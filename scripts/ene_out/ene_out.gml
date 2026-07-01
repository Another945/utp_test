function ene_out() {
    if (!variable_instance_exists(id, "has_been_seen")) {
        has_been_seen = false;
    }
    if (inside_view) {
        has_been_seen = true;
    }
    if (!inside_view && has_been_seen) {
        instance_destroy();
    }
}