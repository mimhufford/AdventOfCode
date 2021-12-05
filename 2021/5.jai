day5 :: (data : string) -> string, string
{
    orth_lines : [..]Line;
    diag_lines : [..]Line;

    map : []u8 = ---;
    map.count = 999<<10 + 999;
    map.data  = alloc(999<<10 + 999);
    memset(map.data, 0, map.count);

    while data.count
    {
        l : Line = ---;
        l.x0 = next_u64(*data); 
        l.y0 = next_u64(*data); 
        l.x1 = next_u64(*data); 
        l.y1 = next_u64(*data); 

        if l.x0 == l.x1 || l.y0 == l.y1  array_add(*orth_lines, l);
        else                             array_add(*diag_lines, l);
    }

    part1, part2 : u64;

    for * l : orth_lines
    {
        if l.x0 > l.x1  l.x0, l.x1 = swap(l.x0, l.x1);
        if l.y0 > l.y1  l.y0, l.y1 = swap(l.y0, l.y1);
        for x: l.x0..l.x1  for y: l.y0..l.y1  map[x<<10 + y] += 1;
    }

    for map  if it > 1  part1 += 1;

    for * l : diag_lines
    {
        x := l.x0;
        y := l.y0;

        map[x<<10 + y] += 1;

        while x != l.x1
        {
            if x < l.x1  x += 1;  else  x -= 1;
            if y < l.y1  y += 1;  else  y -= 1;
            map[x<<10 + y] += 1;
        }
    }

    for map  if it > 1  part2 += 1;

    return tprint("%", part1), tprint("%", part2);
}

Line :: struct
{
    x0, y0 : u64;
    x1, y1 : u64;
}

next_u64 :: (s: *string) -> u64
{
    num : u64;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s, 1);
    }

    while s.count && (s.data[0] < #char "0" || s.data[0] > #char "9") advance(s, 1);

    return num;
}