day25 :: (input: string) -> string, string
{
    card := read_number(*input);
    door := read_number(*input);

    card_secret := find_secret(card);

    part1 : u64 = 1;
    for 1..card_secret part1 = (part1 * door) % 20201227;

    return tprint("%", part1), ":)";
}

#scope_file

find_secret :: (i: u64) -> u64
{
    s : u64 = 0;
    n : u64 = 1;

    while true
    {
        n *= 7;
        n %= 20201227;
        s += 1;
        if n == i return s;
    }

    return 0;
}

read_number :: (s: *string) -> u64
{
    num : u64;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s);
    }

    if s.count advance(s);

    return num;
}