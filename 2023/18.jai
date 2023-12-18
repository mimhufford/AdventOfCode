day18 :: (input: string) -> string, string
{
    DIM :: 600;
    l, r, t, b := DIM, 0, DIM, 0;
    map : [DIM][DIM]u8;
    x, y := DIM / 2;
    map[y][x] = 1;

    while input.count
    {
        dir := input;
        dir.count = 1;
        advance(*input, 2);
        dist := read_u8(*input);
        skip_to_next_line(*input);

        if      dir == "L" for 1..dist { x -= 1; map[y][x] = 1; }
        else if dir == "R" for 1..dist { x += 1; map[y][x] = 1; }
        else if dir == "U" for 1..dist { y -= 1; map[y][x] = 1; }
        else               for 1..dist { y += 1; map[y][x] = 1; }
        l = min(l,x);
        r = max(r,x);
        t = min(t,y);
        b = max(b,y);
    }

    part1, part2 := 0, 0;
    
    seen : Table(u32,u8);
    queue : [..]u32;
    array_add(*queue, 0);
    while queue.count
    {
        current := pop(*queue);
        if table_find_pointer(*seen, current) continue;
        table_add(*seen, current, 0);
        cy := current >> 16;
        cx := current & 0xFFFF;
        if map[cy][cx] == 1 continue;

        part1 += 1;
        
        if cx > 0     array_add(*queue, (cy << 16) | (cx - 1));
        if cy > 0     array_add(*queue, ((cy-1) << 16) | (cx));
        if cx < DIM-1 array_add(*queue, (cy << 16) | (cx + 1));
        if cy < DIM-1 array_add(*queue, ((cy+1) << 16) | (cx));
    }

    return tprint("%", DIM*DIM-part1), tprint("%", part2);
}