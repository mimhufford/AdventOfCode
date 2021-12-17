day17 :: (data : string) -> string, string
{
    tx_min := read_s64(*data);
    tx_max := read_s64(*data);
    ty_min := read_s64(*data);
    ty_max := read_s64(*data);
    
    highest := calculate_highest(tx_min, tx_max);

    return tprint("%", highest), tprint("%", "");
}

calculate_highest :: (min: s64, max: s64) -> s64
{
    highest: s64;

    for < start_x: min-1..0
    {
        x := start_x;
        steps := 0;

        for < next_x: start_x-1..0
        {
            steps += 1;
            x += next_x;

            if x >= min && x <= max
            {
                print("start: % steps: % x: %\n", start_x, steps, x);
            }
        }
    }

    return highest;
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