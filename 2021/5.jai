day5 :: (data : string) -> string, string
{
    map : []u8 = ---;
    map.count = 999<<10 + 999;
    map.data  = alloc(999<<10 + 999);

    while data.count
    {
        x0 := next_u64(*data); 
        y0 := next_u64(*data); 
        x1 := next_u64(*data); 
        y1 := next_u64(*data); 

        if x0 > x1  x0, x1 = swap(x0, x1);
        if y0 > y1  y0, y1 = swap(y0, y1);

        if x0 == x1 || y0 == y1
        {
            for x: x0..x1
            {
                for y: y0..y1
                {
                    map[x<<10 + y] += 1;
                }
            }
        }
    }

    part1 : u64;
    for map  if it > 1  part1 += 1;

    return tprint("%", part1), "";
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