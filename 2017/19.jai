day19 :: (input: string) -> string, string
{
    part1 : [..]u8;
    part2 := 0;
    map := split(input, "\n");
    x, y, dx, dy := 0, 0, 0, 1;

    for map[0] if it == "|" { x = it_index; break; }
    
    while map[y][x] != " " {
        if map[y][x] >= "A" && map[y][x] <= "Z" array_add(*part1, map[y][x]);
        if map[y][x] == "+" {
            if dy then dy, dx = 0, ifx map[y][x-1] != " " then -1 else 1;
            else       dx, dy = 0, ifx map[y-1][x] != " " then -1 else 1;
        }
        x, y, part2 += dx, dy, 1;
    }

    return part1.(string), tprint("%", part2);
}