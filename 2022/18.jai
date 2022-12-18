day18 :: (input: string) -> string, string
{
    drops : Table(u32, void);
    p_min : Pos; p_min.x = 255; p_min.y = 255; p_min.z = 255;
    p_max : Pos;

    while input
    {
        p : Pos;
        // shift everything a bit to stay in u8 land
        p.x = read_u8(*input) + 5; advance(*input);
        p.y = read_u8(*input) + 5; advance(*input);
        p.z = read_u8(*input) + 5;
        v : drops.Value_Type;
        table_add(*drops, p.hash, v);
        p_min.x = min(p_min.x, p.x-1); p_min.y = min(p_min.y, p.y-1); p_min.z = min(p_min.z, p.z-1);
        p_max.x = max(p_max.x, p.x+1); p_max.y = max(p_max.y, p.y+1); p_max.z = max(p_max.z, p.z+1);
    }

    outside : Table(u32, void);
    queue   : [..]Pos;
    array_add(*queue, p_min);

    while queue
    {
        p := pop(*queue);
        if p.x < p_min.x || p.y < p_min.y || p.z < p_min.z continue;
        if p.x > p_max.x || p.y > p_max.y || p.z > p_max.z continue;
        if table_find_pointer(*outside, p.hash) continue;
        if table_find_pointer(*drops,   p.hash) continue;

        v : outside.Value_Type;
        table_add(*outside, p.hash, v);
        p.x += 1; array_add(*queue, p); p.x -= 1;
        p.x -= 1; array_add(*queue, p); p.x += 1;
        p.y += 1; array_add(*queue, p); p.y -= 1;
        p.y -= 1; array_add(*queue, p); p.y += 1;
        p.z += 1; array_add(*queue, p); p.z -= 1;
        p.z -= 1; array_add(*queue, p); p.z += 1;
    }

    surface_area  := count_surface_area(drops);
    outer_surface := count_surface_area(outside);
    outer_surface -= 2 * (cast(s64)p_max.x - p_min.x + 1) * (cast(s64)p_max.y - p_min.y + 1);
    outer_surface -= 2 * (cast(s64)p_max.x - p_min.x + 1) * (cast(s64)p_max.z - p_min.z + 1);
    outer_surface -= 2 * (cast(s64)p_max.y - p_min.y + 1) * (cast(s64)p_max.z - p_min.z + 1);

    return tprint("%", surface_area), tprint("%", outer_surface);
}

#scope_file

Pos :: struct
{
    x: u8;
    y: u8;
    z: u8;
    #place x;
    hash: u32;
}

count_surface_area :: (positions: Table(u32, void)) -> s64
{
    surface_area := 0;

    for positions
    {
        p : Pos;
        p.hash = it_index;
        p.x += 1; if !table_find_pointer(*positions, p.hash) surface_area += 1; p.x -= 1;
        p.x -= 1; if !table_find_pointer(*positions, p.hash) surface_area += 1; p.x += 1;
        p.y += 1; if !table_find_pointer(*positions, p.hash) surface_area += 1; p.y -= 1;
        p.y -= 1; if !table_find_pointer(*positions, p.hash) surface_area += 1; p.y += 1;
        p.z += 1; if !table_find_pointer(*positions, p.hash) surface_area += 1; p.z -= 1;
        p.z -= 1; if !table_find_pointer(*positions, p.hash) surface_area += 1; p.z += 1;
    }

    return surface_area;
}