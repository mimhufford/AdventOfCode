day20 :: (input: string) -> string, string
{
    part1, part2 := 0;

    particles : [..] struct {
        px, py, pz: s64;
        vx, vy, vz: s64;
        ax, ay, az: s64;
        hash: u32;
        #overlay(px) pos: [3]s64;
    };
    
    while input {
        p := array_add(*particles); advance(*input, 3);
        p.px = read_s64(*input);    advance(*input, 1);
        p.py = read_s64(*input);    advance(*input, 1);
        p.pz = read_s64(*input);    advance(*input, 6);
        p.vx = read_s64(*input);    advance(*input, 1);
        p.vy = read_s64(*input);    advance(*input, 1);
        p.vz = read_s64(*input);    advance(*input, 6);
        p.ax = read_s64(*input);    advance(*input, 1);
        p.ay = read_s64(*input);    advance(*input, 1);
        p.az = read_s64(*input);    advance(*input, 2);
    }

    closest := S64_MAX;
    for * particles {
        x := it.px + it.vx + it.ax * 1_000_000_000;
        y := it.py + it.vy + it.ay * 1_000_000_000;
        z := it.pz + it.vz + it.az * 1_000_000_000;
        distance := abs(x) + abs(y) + abs(z);
        if distance >= closest continue;
        closest = distance;
        part1 = it_index;
    }

    seen : Table(u32, s64);
    for 1..40 {
        for * particles {
            it.hash = get_hash(it.pos);
            entry, new := find_or_add(*seen, it.hash);
            entry.* += 1;
            if !new remove it;
        }
        for * particles {
            if find_or_add(*seen, it.hash).* > 1 remove it;
            it.vx, it.vy, it.vz += it.ax, it.ay, it.az;
            it.px, it.py, it.pz += it.vx, it.vy, it.vz;
        }
        table_reset(*seen);
    }

    part2 = particles.count;

    return tprint("%", part1), tprint("%", part2);
}