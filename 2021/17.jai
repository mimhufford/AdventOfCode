day17 :: (data : string) -> string, string
{
    //data := "target area: x=20..30, y=-10..-5\n";

    tx_min := read_s64(*data);
    tx_max := read_s64(*data);
    ty_min := read_s64(*data);
    ty_max := read_s64(*data);
    
    max_height := (abs(ty_min)-1) * abs(ty_min) / 2;

    // highest: s64;

    // for < start_dx: tx_min-1..0
    // {
    //     x := 0;
    //     dx := start_dx;
    //     steps := 0;

    //     while true
    //     {
    //         x += dx; if dx > 0 dx -= 1;
    //         steps += 1;

    //         if x < tx_min && dx == 0 break;
    //         if x > tx_max            break;

    //         if x >= tx_min && x <= tx_max
    //         {
    //             // found a good x and steps, time to find y
    //             for start_dy: 0..100
    //             {
    //                 y := 0;
    //                 dy := start_dy;

    //                 for step: 1..steps { y += dy; dy -= 1; }

    //                 if y >= ty_min && y <= ty_max
    //                     print("dx: % dy:%\n", start_dx, start_dy);
    //             }
    //         }
    //     }
    // }

    return tprint("%", max_height), tprint("%", "");
}

read_s64 :: (s: *string) -> s64
{
    num: s64;
    neg: bool;

    while s.count && s.data[0] != #char "-" && s.data[0] < #char "0" || s.data[0] > #char "9"
        advance(s, 1);

    if s.data[0] == #char "-"
    {
        neg = true;
        advance(s, 1);
    }

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s, 1);
    }

    while s.count && s.data[0] != #char "-" && s.data[0] < #char "0" && s.data[0] > #char "9"
        advance(s, 1);

    return ifx neg then -num else num;
}