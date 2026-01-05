day22 :: (input: string) -> string, string
{
    part1, part2 := 0;
    advance(*input, 7); depth := read_s64(*input);
    advance(*input, 8); tx := read_s64(*input);
    advance(*input);    ty := read_s64(*input);
    w, h := tx + 30, ty + 200;
    map := NewArray(w*h, struct { type: s64; best: [3]s64; });

    for y: 0..h-1 for x: 0..w-1 {
        if y == ty && x == tx { map[y*w+x].type = depth % 20183; continue; }
        if y == 0 || x == 0 { map[y*w+x].type = (x * 16807 + y * 48271 + depth) % 20183; continue; }
        map[y*w+x].type = (map[(y-1)*w+x].type * map[y*w+x-1].type + depth) % 20183;
    }

    for * map { it.type %= 3; for * it.best it.* = S64_MAX; }
    for y: 0..ty for x: 0..tx part1 += map[y*w+x].type;

    State :: struct { x: s64; y: s64; t: s8; steps: s64; }
    queue : [..]State;
    array_add(*queue, { x = 0, y = 0, t = 1, steps = 0});

    // 0 = neither, 1 = torch, 2 = climbing gear
    // 0 rocky  = 1 or 2
    // 1 wet    = 0 or 2
    // 2 narrow = 0 or 1

    while queue {
        using curr := pop(*queue);
        cell := *map[y*w+x];
        if cell.best[t] <= steps continue;
        cell.best[t] = steps;
        if cell.type == 0 && t == 1 && cell.best[2] > steps+7 array_add(*queue, { x=x, y=y, t=2, steps=steps+7 });
        if cell.type == 0 && t == 2 && cell.best[1] > steps+7 array_add(*queue, { x=x, y=y, t=1, steps=steps+7 });
        if cell.type == 1 && t == 0 && cell.best[2] > steps+7 array_add(*queue, { x=x, y=y, t=2, steps=steps+7 });
        if cell.type == 1 && t == 2 && cell.best[0] > steps+7 array_add(*queue, { x=x, y=y, t=0, steps=steps+7 });
        if cell.type == 2 && t == 0 && cell.best[1] > steps+7 array_add(*queue, { x=x, y=y, t=1, steps=steps+7 });
        if cell.type == 2 && t == 1 && cell.best[0] > steps+7 array_add(*queue, { x=x, y=y, t=0, steps=steps+7 });
        move :: (dx: s64, dy: s64) #expand {
            nx, ny := x + dx, y + dy;
            if nx < 0 || nx >= w return;
            if ny < 0 || ny >= h return;
            next := *map[ny*w+nx];
            if next.type == t return;
            if next.best[t] <= steps+1 return;
            array_add(*queue, { x=nx, y=ny, t=t, steps=steps+1 });
        }
        move(-1, 0); move(+1, 0); move(0, -1); move(0, +1);
    }

    part2 = map[ty*w+tx].best[1];

    return tprint("%", part1), tprint("%", part2);
}