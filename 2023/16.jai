day16 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");

    history : [..]Direction;
    for map for 0..it.count-1 array_add(*history, 0);

    part1 := shoot_photon(map, history, -1, 0, .R);
    part2 := 0;

    for x: 0..map[0].count-1
    {
        part2 = max(part2, shoot_photon(map, history, xx x,           -1, .D));
        part2 = max(part2, shoot_photon(map, history, xx x, xx map.count, .U));
    }
    for y: 0..map.count-1
    {
        part2 = max(part2, shoot_photon(map, history,              -1, xx y, .R));
        part2 = max(part2, shoot_photon(map, history, xx map[0].count, xx y, .L));
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Photon :: struct
{
    x, y : s8;
    d : Direction;
}

Direction :: enum_flags u8 { L; R; U; D; }

direction_to_dx_dy :: (d: Direction) -> s8, s8
{
    if d == .L return -1,  0;
    if d == .R return  1,  0;
    if d == .U return  0, -1;
               return  0,  1;
}

shoot_photon :: (map: []string, history: [..]Direction, x: s8, y: s8, d: Direction) -> s64
{
    for 0..history.count-1 history[it] = 0;

    photons : [..]Photon;
    array_add(*photons, .{x, y, d});

    while photons.count
    {
        p := pop(*photons);
        dx, dy := direction_to_dx_dy(p.d);
        p.x += dx;
        p.y += dy;

        if p.x < 0 || p.x >= map[0].count      continue;
        if p.y < 0 || p.y >= map.count         continue;
        if history[p.y*map[0].count+p.x] & p.d continue;

        history[p.y*map[0].count+p.x] |= p.d;

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
    for history if it energy += 1;
    return energy;
}