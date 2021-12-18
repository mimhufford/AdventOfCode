houses : [1_000_000]u32;

day20 :: (data: string) -> string, string
{
    for * houses {<<it = 0;}
    min_presents : u32 : 36000000;
    first : u32;

    for e: 1..houses.count-1
    {
        h := e;
        while h < houses.count
        {
            houses[h] += xx(e * 10);
            if houses[h] >= min_presents
            {
                first = xx h;
                break e;
            }
            h += e;
        }
    }

    return tprint("%", first), tprint("%", "");
}