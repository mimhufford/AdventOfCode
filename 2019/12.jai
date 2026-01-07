day12 :: (input: string) -> string, string
{
    part1, part2 := 0;

    moons : [..] struct { x, y, z, ix, iy, iz, vx, vy, vz: s64; };

    while input {
        m := array_add(*moons);
        m.x = get(s64, *input); m.ix = m.x;
        m.y = get(s64, *input); m.iy = m.y;
        m.z = get(s64, *input); m.iz = m.z;
        advance(*input, 2);
    }

    x_cycle, y_cycle, z_cycle := 0;

    for 1..S64_MAX {
        for i: 0..moons.count-1 {
            a := *moons[i];
            for j: i+1..moons.count-1 {
                b := *moons[j];
                a.vx += ifx a.x < b.x then 1 else ifx a.x > b.x then -1;
                b.vx += ifx b.x < a.x then 1 else ifx b.x > a.x then -1;
                a.vy += ifx a.y < b.y then 1 else ifx a.y > b.y then -1;
                b.vy += ifx b.y < a.y then 1 else ifx b.y > a.y then -1;
                a.vz += ifx a.z < b.z then 1 else ifx a.z > b.z then -1;
                b.vz += ifx b.z < a.z then 1 else ifx b.z > a.z then -1;
            }
        }

        if it == 1000 for m: moons part1 += (abs(m.x) + abs(m.y) + abs(m.z)) * (abs(m.vx) + abs(m.vy) + abs(m.vz));

        x, y, z := true;
        for * m: moons {
            m.x, m.y, m.z += m.vx, m.vy, m.vz;
            x &= m.x == m.ix && m.vx == 0;
            y &= m.y == m.iy && m.vy == 0;
            z &= m.z == m.iz && m.vz == 0;
        }

        if !x_cycle && x then x_cycle = it;
        if !y_cycle && y then y_cycle = it;
        if !z_cycle && z then z_cycle = it;

        if x_cycle && y_cycle && z_cycle break;
    }

    part2 = lcm(lcm(x_cycle, y_cycle), z_cycle);

    return tprint("%", part1), tprint("%", part2);
}