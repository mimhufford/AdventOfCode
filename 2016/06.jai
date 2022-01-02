day6 :: (data: string) -> string, string
{
    frequencies : [..][26]int;

    lines := split(data, "\n");
    lines.count -= 1;

    while data[0] != #char "\n"
    {
        _ := array_add(*frequencies);
        advance(*data, 1);
    }

    for line: lines
    {
        for i: 0..line.count-1
        {
            frequencies[i][line[i] - #char "a"] += 1;
        }
    }

    hi_message  : [..]u8;
    lo_message : [..]u8;

    for freq: frequencies
    {
        hi_char, hi := 0;
        lo_char, lo := 10000;

        for freq
        {
            if it > hi { hi = it; hi_char = it_index + #char "a"; }
            if it < lo { lo = it; lo_char = it_index + #char "a"; }
        }

        array_add(*hi_message, xx hi_char);
        array_add(*lo_message, xx lo_char);
    }

    return tprint("%", cast(string)hi_message), tprint("%", cast(string)lo_message);
}