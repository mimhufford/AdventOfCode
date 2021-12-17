day17 :: (data : string) -> string, string
{
    //data := "target area: x=20..30, y=-10..-5\n";

    tx_min := read_s64(*data);
    tx_max := read_s64(*data);
    ty_min := read_s64(*data);
    ty_max := read_s64(*data);
    
    max_height := (abs(ty_min)-1) * abs(ty_min) / 2;

    xs := calculate_possible_xs(tx_min, tx_max);
    ys := calculate_possible_ys(ty_min, ty_max);

    return tprint("%", max_height), tprint("%", "");
}

calculate_possible_xs :: (min: s64, max: s64) -> [..]s64
{
    xs: [..]s64;

    for < start_dx: max..0
    {
        x := 0;
        dx := start_dx;

        while dx >= 0
        {
            if x >= min && x <= max
            {
                array_add(*xs, start_dx);
                break;
            }

            x += dx;
            dx -= 1;
        }
    }

    return xs;
}

calculate_possible_ys :: (min: s64, max: s64) -> [..]s64
{
    ys: [..]s64;

    for start_dy: min..abs(min)
    {
        y := 0;
        dy := start_dy;

        while y > max
        {
            y += dy;
            dy -= 1;

            if y >= min && y <= max
            {
                array_add(*ys, start_dy);
                break;
            }
        }
    }

    return ys;
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