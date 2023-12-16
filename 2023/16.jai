day16 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");

    part1 := shoot_photon(map, -1, 0, .R);
    part2 := 0;

    for x: 0..map[0].count-1
    {
        part2 = max(part2, shoot_photon(map, x,        -1, .D));
        part2 = max(part2, shoot_photon(map, x, map.count, .U));
    }
    for y: 0..map.count-1
    {
        part2 = max(part2, shoot_photon(map, -1,           y, .R));
        part2 = max(part2, shoot_photon(map, map[0].count, y, .L));
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Photon :: struct
{
    x, y : s64;
    d : Direction;
}

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

shoot_photon :: (map: []string, x: s64, y: s64, d: Direction) -> s64
{
    history : [..][..]Direction;

    for map
    {
        row := array_add(*history);
        for 0..it.count-1 array_add(row, .N);
    }

    photons : [..]Photon;
    array_add(*photons, .{x, y, d});

    while photons.count
    {
        p := pop(*photons);
        dx, dy := direction_to_dx_dy(p.d);
        p.x += dx;
        p.y += dy;

        if p.x < 0 || p.x >= map[0].count continue;
        if p.y < 0 || p.y >= map.count    continue;
        if history[p.y][p.x] & p.d        continue;

        history[p.y][p.x] |= p.d;

        if map[p.y][p.x] == #char "."
        {
            array_add(*photons, .{ p.x, p.y, p.d });
        }
        else if map[p.y][p.x] == #char "|" && (p.d == .U || p.d == .D)
        {
            array_add(*photons, .{ p.x, p.y, p.d });
        }
        else if map[p.y][p.x] == #char "-" && (p.d == .L || p.d == .R)
        {
            array_add(*photons, .{ p.x, p.y, p.d });
        }
        else if map[p.y][p.x] == #char "|" && (p.d == .L || p.d == .R)
        {
            array_add(*photons, .{ p.x, p.y, .U });
            array_add(*photons, .{ p.x, p.y, .D });
        }
        else if map[p.y][p.x] == #char "-" && (p.d == .U || p.d == .D)
        {
            array_add(*photons, .{ p.x, p.y, .L });
            array_add(*photons, .{ p.x, p.y, .R });
        }
        else if map[p.y][p.x] == #char "/" && (p.d == .R)
        {
            array_add(*photons, .{ p.x, p.y, .U });
        }
        else if map[p.y][p.x] == #char "/" && (p.d == .L)
        {
            array_add(*photons, .{ p.x, p.y, .D });
        }
        else if map[p.y][p.x] == #char "/" && (p.d == .U)
        {
            array_add(*photons, .{ p.x, p.y, .R });
        }
        else if map[p.y][p.x] == #char "/" && (p.d == .D)
        {
            array_add(*photons, .{ p.x, p.y, .L });
        }
        else if map[p.y][p.x] == #char "\\" && (p.d == .R)
        {
            array_add(*photons, .{ p.x, p.y, .D });
        }
        else if map[p.y][p.x] == #char "\\" && (p.d == .L)
        {
            array_add(*photons, .{ p.x, p.y, .U });
        }
        else if map[p.y][p.x] == #char "\\" && (p.d == .U)
        {
            array_add(*photons, .{ p.x, p.y, .L });
        }
        else if map[p.y][p.x] == #char "\\" && (p.d == .D)
        {
            array_add(*photons, .{ p.x, p.y, .R });
        }
    }

    energy := 0;
    for history for it if it energy += 1;
    return energy;
}