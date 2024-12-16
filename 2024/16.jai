day16 :: (input: string) -> string, string
{
    for y: 0..SIZE-1
    {
        for x: 0..SIZE-1
        {
            map[y][x] = ifx input[0] == #char "#" then WALL else S64_MAX;
            advance(*input);
        }   
        advance(*input);
    }

    walk(1, SIZE-2, 0, SIZE-2, 1);

    part1, part2 := map[1][SIZE-2], 0;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

WALL :: -1;
dirs :: []s64.[.[1,0],.[0,1],.[-1,0],.[0,-1]];
SIZE :: 141;
map : [SIZE][SIZE]s64;

walk :: (x: s64, y: s64, d: s64, tx: s64, ty: s64, score := 0)
{
    if map[y][x] <= score return;

    map[y][x] = score;

    for dir, dir_index: dirs
    {
        if map[y+dir[1]][x+dir[0]] == WALL continue;
        cost := 1 + ifx dir_index != d then 1000;
        walk(x+dir[0], y+dir[1], dir_index, tx, ty, score + cost);
    }
}