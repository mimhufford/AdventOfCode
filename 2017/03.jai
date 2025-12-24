day3 :: (input: string) -> string, string
{
    part1, part2 := 0;
    id := read_s64(*input);

    coords :: (n: s64) -> s64, s64 {
        ring := ceil((sqrt(n.(float)) - 1) / 2).(s64);
        size := 2 * ring;
        maxi := (2 * ring + 1) * (2 * ring + 1);
        posi := maxi - n;

        if posi < 1 * size return ring-posi, -ring;
        if posi < 2 * size return -ring, -ring + (posi - size);
        if posi < 3 * size return -ring + (posi - 2 * size), ring;
        return ring, ring - (posi - 3 * size);
    }

    x, y := coords(id);
    part1 = abs(x) + abs(y);

    Point :: struct { x, y: s32; #overlay(x) hash: u64; }

    grid : Table(u64, s64);
    point : Point;

    for steps: 0..S64_MAX {
        for repeat: 0..1 {
            for step: 0..steps {
                part2 = 0;
                for dx: -1..1 for dy: -1..1 {
                    if dx == 0 && dy == 0 continue;
                    p := point;
                    p.x += dx.(s32);
                    p.y += dy.(s32);
                    v := table_find_pointer(*grid, p.hash);
                    if v then part2 += v.*;
                }
                if part2 > id break steps;
                table_add(*grid, point.hash, max(part2, 1));
                dirs :: Point.[.{1,0}, .{0,1}, .{-1,0}, .{0,-1}];
                point.x += dirs[(steps * 2 + repeat) % 4].x;
                point.y += dirs[(steps * 2 + repeat) % 4].y;
            }
        }
    }

    return tprint("%", part1), tprint("%", part2);
}