day21 :: (data: string) -> string, string
{
    advance(*data, 12);
    bh := next_s64(*data);
    bd := next_s64(*data);
    ba := next_s64(*data);

    return tprint("%", ""), tprint("%", "");
}

play_game :: (bh: s64, bd: s64, ba: s64)
{
    ph : s64 = 100;
    pd : s64 = 0;
    pa : s64 = 0;

}

Item :: struct { c: s64; d: s64; a: s64; }
weapons :: Item.[ .{  8, 4, 0 }, .{ 10, 5, 0 }, .{  25, 6, 0 }, .{ 40, 7, 0 }, .{  74, 8, 0 } ];
armours :: Item.[ .{ 13, 0, 1 }, .{ 31, 0, 2 }, .{  53, 0, 3 }, .{ 75, 0, 4 }, .{ 102, 0, 5 } ];
rings   :: Item.[ .{ 25, 1, 0 }, .{ 50, 2, 0 }, .{ 100, 3, 0 }, .{ 20, 0, 1 }, .{  40, 0, 2 }, .{ 80, 0, 3 } ];