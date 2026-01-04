day22 :: (input: string) -> string, string
{
    part1, part2 := 0;
    advance(*input, 7); depth := read_s64(*input);
    advance(*input, 8); tx := read_s64(*input);
    advance(*input);    ty := read_s64(*input);
    w, h := tx + 20, ty + 20;
    map := NewArray(w*h, s64);

    for y: 0..h-1 for x: 0..w-1 {
        if y == ty && x == tx { map[y*w+x] = depth % 20183; continue; }
        if y == 0 || x == 0 { map[y*w+x] = (x * 16807 + y * 48271 + depth) % 20183; continue; }
        map[y*w+x] = (map[(y-1)*w+x] * map[y*w+x-1] + depth) % 20183;
    }

    for * map it.* %= 3;
    for y: 0..ty for x: 0..tx part1 += map[y*w+x];

    return tprint("%", part1), tprint("%", part2);
}