day15 :: (data : string) -> string, string
{
    map   : [..][..]s32;
    cost1 : [..][..]s32;
    cost5 : [..][..]s32;

    while data.count
    {
        map_row : [..]s32;
        cost_row : [..]s32;

        while data[0] >= #char "0" && data[0] <= #char "9"
        {
            array_add(*map_row, data[0] - #char "0");
            array_add(*cost_row, S32_MAX);
            advance(*data, 1);
        }

        array_add(*map, map_row);
        array_add(*cost1, cost_row);
        advance(*data, 1);
    }

    w : s32 = xx map[0].count;
    h : s32 = xx map.count;

    for y: 0..h*5-1
    {
        row : [..]s32;
        for x: 0..w*5-1 array_add(*row, S32_MAX);
        array_add(*cost5, row);
    }

    cost1[0][0] = 0;
    cost5[0][0] = 0;

    dp :: (size: s32, cost: [..][..]s32) #expand
    {
        for y: 0..w*size-1
        {
            for x: 0..h*size-1
            {
                if x == 0 && y == 0 continue;
                l := ifx x > 0        then cost[y][x-1] else S32_MAX;
                r := ifx x < w*size-1 then cost[y][x+1] else S32_MAX;
                u := ifx y > 0        then cost[y-1][x] else S32_MAX;
                d := ifx y < h*size-1 then cost[y+1][x] else S32_MAX;
                val := (map[y%h][x%w] + x/w + y/h - 1) % 9 + 1;
                cost[y][x] = val + min(l, r, u, d);
            }
        }
    }

    for 1..10 dp(1, cost1);
    for 1..10 dp(5, cost5);

    return tprint("%", cost1[h-1][w-1]), tprint("%", cost5[h*5-1][w*5-1]);
}