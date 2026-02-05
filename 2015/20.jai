houses : [1_000_000]u32;

day20 :: (data: string) -> string, string
{
    solve :: (limit: u32, multiplier: u32) -> s64 #expand
    {
        input := data;
        min_presents := get(u32, *input);
        memset(houses.data, 0, houses.count * size_of(type_of(houses[0])));

        for e: 1..houses.count-1
        {
            h := e;
            c := 0;
            while h < houses.count && c < limit
            {
                houses[h] += xx(e * multiplier);
                if houses[h] >= min_presents return h;
                h += e;
                c += 1;
            }
        }

        return 0;
    }

    return tprint("%", solve(U32_MAX, 10)), tprint("%", solve(50, 11));
}