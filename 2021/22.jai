day22 :: (data : string) -> string, string
{
    instructions : [..]Cube;
    bounds : Cube;

    while data.count
    {
        c := read_cube(*data);
        array_add(*instructions, c);
        bounds.x_min = min(bounds.x_min, c.x_min);
        bounds.x_max = max(bounds.x_max, c.x_max);
        bounds.y_min = min(bounds.y_min, c.y_min);
        bounds.y_max = max(bounds.y_max, c.y_max);
        bounds.z_min = min(bounds.z_min, c.z_min);
        bounds.z_max = max(bounds.z_max, c.z_max);
    }
    return tprint("%", ""), tprint("%", "");
}

Cube :: struct
{
    on : bool;
    x_min, x_max : s32;
    y_min, y_max : s32;
    z_min, z_max : s32;
}

read_cube :: (s: *string) -> Cube
{
    c : Cube;

    if s.data[1] == #char "n" c.on = true;
    advance(s, ifx c.on then 5 else 6);
    c.x_min = read_num(); advance(s, 2);
    c.x_max = read_num(); advance(s, 3);
    c.y_min = read_num(); advance(s, 2);
    c.y_max = read_num(); advance(s, 3);
    c.z_min = read_num(); advance(s, 2);
    c.z_max = read_num(); advance(s, 1);

    return c;

    read_num :: () -> s32 #expand
    {
        neg := false;
        num : s32;
        if s.data[0] == #char "-" { neg = true; advance(s, 1); }
        while s.data[0] >= #char "0" && s.data[0] <= #char "9"
        {
            num *= 10;
            num += s.data[0] - #char "0";
            advance(s, 1);
        }
        return ifx neg then -num else num;
    }
}