day16 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");
    history : [..][..]Direction;

    for map
    {
        row := array_add(*history);
        for 0..it.count-1 array_add(row, .N);
    }

    shoot_photon(map, history, -1, 0, .R);

    part1, part2 := 0;

    for history for it if it part1 += 1;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Direction :: enum_flags u8
{
    N :: 0b0000;
    L :: 0b0001;
    R :: 0b0010;
    U :: 0b0100;
    D :: 0b1000;
}

direction_to_dx_dy :: (d: Direction) -> s64, s64
{
    if d == .L return -1,  0;
    if d == .R return  1,  0;
    if d == .U return  0, -1;
               return  0,  1;
}

shoot_photon :: (map: []string, history: [..][..]Direction, _x: s64, _y: s64, d: Direction)
{
    dx, dy := direction_to_dx_dy(d);
     x,  y := _x + dx, _y + dy;

    if x < 0 || x >= map[0].count return;
    if y < 0 || y >= map.count    return;
    if history[y][x] & d          return;

    history[y][x] |= d;

    if map[y][x] == #char "."
    {
        shoot_photon(map, history, x, y, d);
    }
    else if map[y][x] == #char "|" && (d == .U || d == .D)
    {
        shoot_photon(map, history, x, y, d);
    }
    else if map[y][x] == #char "-" && (d == .L || d == .R)
    {
        shoot_photon(map, history, x, y, d);
    }
    else if map[y][x] == #char "|" && (d == .L || d == .R)
    {
        shoot_photon(map, history, x, y, .U);
        shoot_photon(map, history, x, y, .D);
    }
    else if map[y][x] == #char "-" && (d == .U || d == .D)
    {
        shoot_photon(map, history, x, y, .L);
        shoot_photon(map, history, x, y, .R);
    }
    else if map[y][x] == #char "/" && (d == .R)
    {
        shoot_photon(map, history, x, y, .U);
    }
    else if map[y][x] == #char "/" && (d == .L)
    {
        shoot_photon(map, history, x, y, .D);
    }
    else if map[y][x] == #char "/" && (d == .U)
    {
        shoot_photon(map, history, x, y, .R);
    }
    else if map[y][x] == #char "/" && (d == .D)
    {
        shoot_photon(map, history, x, y, .L);
    }
    else if map[y][x] == #char "\\" && (d == .R)
    {
        shoot_photon(map, history, x, y, .D);
    }
    else if map[y][x] == #char "\\" && (d == .L)
    {
        shoot_photon(map, history, x, y, .U);
    }
    else if map[y][x] == #char "\\" && (d == .U)
    {
        shoot_photon(map, history, x, y, .L);
    }
    else if map[y][x] == #char "\\" && (d == .D)
    {
        shoot_photon(map, history, x, y, .R);
    }
}