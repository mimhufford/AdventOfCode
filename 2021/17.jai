day17 :: (data : string) -> string, string
{
    tx_min := read_s64(*data);
    tx_max := read_s64(*data);
    ty_min := read_s64(*data);
    ty_max := read_s64(*data);
    
    xs := calculate_possible_xs(tx_min, tx_max);

    return tprint("%", xs), tprint("%", "");
}

calculate_possible_xs :: (min: s64, max: s64) -> [..]s64
{
    xs: [..]s64;

    for < start_x: min-1..0
    {
        x := start_x;

        for < next_x: start_x-1..0
        {
            x += next_x;
            if x >= min && x <= max
            {
                array_add(*xs, start_x);
                break;
            }
        }
    }

    return xs;
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