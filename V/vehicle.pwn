#include <YSI_Coding\y_hooks>

/**
 * # Header
 */

static
    DBID:gVehicleDBID[MAX_VEHICLES]
;

new
    Iterator:OwnedVehicle<MAX_PLAYERS, MAX_VEHICLES>
;

/**
 * # External
 */

stock DBID:GetVehicleDatabaseID(vehicleid) {
    return gVehicleDBID[vehicleid];
}

/**
 * # Calls
 */

hook OnPlayerConnect(playerid) {
    inline const FetchVehicle() {
        new
            rows = cache_num_rows()
        ;

        if (!rows) {
            @return 1;
        }

        new
            DBID:id,
            DBID:lastId,
            data[8],
            vehicleid
        ;

        for (new i; i < rows; i++) {
            cache_get_value_name_int(i, "id", _:id);

            if (lastId != id) {
                cache_get_value_name_int(i, "model", data[0]);
                cache_get_value_name_int(i, "colour-1", data[1]);
                cache_get_value_name_int(i, "colour-2", data[2]);

                cache_get_value_name_float(i, "x", Float:data[3]);
                cache_get_value_name_float(i, "y", Float:data[4]);
                cache_get_value_name_float(i, "z", Float:data[5]);
                cache_get_value_name_float(i, "a", Float:data[6]);

                vehicleid = CreateVehicle(
                    data[0],
                    Float:data[3], Float:data[4], Float:data[5], Float:data[6],
                    data[1], data[2],
                    -1
                );

                if (!IsValidVehicle(vehicleid)) {
                    @return 1;
                }

                gVehicleDBID[vehicleid] = id;
                Iter_Add(OwnedVehicle<playerid>, vehicleid);
                
                lastId = id;
            }

            cache_get_value_name_int(i, "component-id", data[7]);
            AddVehicleComponent(vehicleid, data[7]);
        }
    }

    MySQL_TQueryInline(MySQL_GetHandle(), using inline FetchVehicle, "\
        SELECT \
            `v`.*, \
            `c`.`component-id` \
        FROM \
            `owned-vehicles` AS `v` \
        INNER JOIN \
            `vehicle-components` AS `c` \
        ON \
            `c`.`vehicle-id` = `v`.`id` \
        WHERE \
            `user-id` = %i \
        ORDER BY \
            `v`.`id`;", _:GetUserDatabaseID(playerid));
    
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    foreach (new vehicleid: OwnedVehicle<playerid>) {
        gVehicleDBID[vehicleid] = DBID:0;
        DestroyVehicle(vehicleid);
    }

    Iter_Clear(OwnedVehicle<playerid>);
    
    return 1;
}
