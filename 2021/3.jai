day3 :: (data: string) -> string, string
{
    readings := 0;
    counts : [12]u16;

    while data.count
    {
        for 0..11
        {
            counts[it] += data[0] - #char "0";
            advance(*data, 1);
        }
        advance(*data, 1);
        readings += 1;
    }

    gamma_rate   := 0;
    epsilon_rate := 0;

    for 0..11
    {
        if counts[it] > readings / 2
            gamma_rate   += 1 << (11-it);
        else
            epsilon_rate += 1 << (11-it);
    }

    return tprint("%", gamma_rate * epsilon_rate), "";
}