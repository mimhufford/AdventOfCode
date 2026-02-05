day5 :: (data : string) -> string, string
{
    orth_lines : [..]Line;
    diag_lines : [..]Line;

    map : [..]u8;
    array_resize(*map, 1000*1000);

    while data.count
    {
        l : Line = ---;
        l.x0 = get(s64, *data); 
        l.y0 = get(s64, *data); 
        advance(*data, 3);
        l.x1 = get(s64, *data); 
        l.y1 = get(s64, *data); 

        if l.x0 == l.x1 || l.y0 == l.y1  array_add(*orth_lines, l);
        else                             array_add(*diag_lines, l);
    }

    part1 := draw_and_count(map, orth_lines);
    part2 := draw_and_count(map, diag_lines);

    return tprint("%", part1), tprint("%", part2);
}

Line :: struct
{
    x0, y0, x1, y1 : s64;
}

draw_and_count :: (map: []u8, lines: []Line) -> s64
{
    delta :: (a: s64, b: s64) -> s64 #expand { if a < b return 1; if a == b return 0; return -1; }

    for * l : lines
    {
        dx, dy := delta(l.x0, l.x1), delta(l.y0, l.y1);
         x,  y := l.x0 - dx, l.y0 - dy;

        while x != l.x1 || y != l.y1
        {
            x += dx;  y += dy;
            map[x*1000+y] += 1;
        }
    }

    count := 0;
    for map if it > 1  count += 1;
    return count;
}