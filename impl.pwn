hook OnPlayerConnect(playerid) {
    inline const VehicleFetched() {
        new 
            vehicles = cache_num_rows()
        ;

        if (vehicles) {
            for (new i; i < vehicles; i++) {
                cache_get_value_name_int(i, "id", Player.Vehicle[playerid][i][@id]);
                cache_get_value_name_int(i, "player_id", Player.Vehicle[playerid][i][@player_id]);
                cache_get_value_name(i, "owner", Player.Vehicle[playerid][i][@player]);
                cache_get_value_name_int(i, "model_id", Player.Vehicle[playerid][i][@model_id]);
                cache_get_value_name_int(i, "price", Player.Vehicle[playerid][i][@price]);
                cache_get_value_name_float(i, "x", Player.Vehicle[playerid][i][@pos][0]);
                cache_get_value_name_float(i, "y", Player.Vehicle[playerid][i][@pos][1]);
                cache_get_value_name_float(i, "z", Player.Vehicle[playerid][i][@pos][2]);
                cache_get_value_name_float(i, "a", Player.Vehicle[playerid][i][@pos][3]);

                Iter_Add(PlayerVehicle[playerid], i);

                inline const ComponentFetched() {
                    new
                        components = cache_num_rows()
                    ;

                    if (components) {
                        for (new j; j < components; j++) {
                            cache_get_value_name_int(j, "component_id", Player.Vehicle[playerid][i][@component_id][j]);
                        }
                    }
                }

                MySQL_PQueryInline(db, using inline ComponentFetched, "\
                    SELECT \
                        `component_id` \
                    FROM \
                        `components` \
                    WHERE \
                        `vehicle_id` = %i \
                    LIMIT 0, %i;", Player.Vehicle[playerid][i][@id], MAX_VEHICLE_COMPONENTS
                );
            }
        }
    }

    MySQL_TQueryInline(db, using inline VehicleFetched, "\
        SELECT \
            `pv`.*, \
            `p`.`name` AS `owner` \
        FROM \
            `player_vehicles` `pv` \
        JOIN \
            `players` `p` ON `p`.`id` = `pv`.`player_id` \
        WHERE \
            `p`.`id` = %i \
        LIMIT 0, %i;", Player.Data[playerid][@id], MAX_PLAYER_OWNABLE_VEHICLES
    );

    return 1;
}
