day17 :: (data : string) -> string, string
{
    left   := read_s64(*data);
    right  := read_s64(*data);
    bottom := read_s64(*data);
    top    := read_s64(*data);
    
    max_height := (abs(bottom)-1) * abs(bottom) / 2;

    xs := calculate_possible_xs(left, right);
    ys := calculate_possible_ys(bottom, top);

    possibilities := count_hits(xs, ys, left, right, bottom, top);

    return tprint("%", max_height), tprint("%", possibilities);
}

count_hits :: (xs: []s64, ys: []s64, left: s64, right: s64, bottom: s64, top: s64) -> s64
{
    count := 0;

    for start_dx: xs
    {
        for start_dy: ys
        {
            x, y, step := 0;
            dx, dy := start_dx, start_dy;

            while y >= bottom && x <= right
            {
                step += 1;
                x += dx;
                y += dy;
                if dx dx -= 1;
                dy -= 1;

                if x >= left && x <= right && y >= bottom && y <= top
                {
                    count += 1;
                    break;
                }
            }
        }
    }

    return count;
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