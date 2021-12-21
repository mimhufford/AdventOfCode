day21 :: (data: string) -> string, string
{
    advance(*data, 12);
    bh := next_s64(*data);
    bd := next_s64(*data);
    ba := next_s64(*data);

    cheapest_win := S64_MAX;
    dearest_lose := S64_MIN;

    for w: weapons for a: armours for r1i: 0..rings.count-1 for r2i: r1i+1..rings.count-1
    {
        r1 := rings[r1i];
        r2 := rings[r2i];

        if play_game(bh, bd, ba, 100, w.d+a.d+r1.d+r2.d, w.a+a.a+r1.a+r2.a)
            cheapest_win = min(cheapest_win, w.c+a.c+r1.c+r2.c);
        else
            dearest_lose = max(dearest_lose, w.c+a.c+r1.c+r2.c);
    }

    return tprint("%", cheapest_win), tprint("%", dearest_lose);
}

play_game :: (_bh: s64, bd: s64, ba: s64, _ph: s64, pd: s64, pa: s64) -> bool
{
    bh := _bh;
    ph := _ph;

    while true
    {
        bh -= max(pd-ba, 1);
        if bh <= 0 return true;
        ph -= max(bd-pa, 1);
        if ph <= 0 return false;
    }

    return false;
}

Item :: struct { c: s64; d: s64; a: s64; }
weapons :: Item.[ .{ 8, 4, 0 }, .{ 10, 5, 0 }, .{ 25, 6, 0 }, .{ 40, 7, 0 }, .{ 74, 8, 0 } ];
armours :: Item.[ .{ 0, 0, 0 }, .{ 13, 0, 1 }, .{ 31, 0, 2 }, .{ 53, 0, 3 }, .{ 75, 0, 4 }, .{ 102, 0, 5 } ];
rings   :: Item.[ .{ 0, 0, 0 }, .{  0, 0, 0 }, .{ 25, 1, 0 }, .{ 50, 2, 0 }, .{ 20, 0, 1 }, .{ 100, 3, 0 }, .{ 40, 0, 2 }, .{ 80, 0, 3 } ];