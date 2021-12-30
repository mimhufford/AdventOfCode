day25 :: (data: string) -> string, string
{
    n : u64 = 20151125;

    for 1..index(2978, 3083)
    {
        n *= 252533;
        n %= 33554393;
    }

    return tprint("%", n), tprint("%", "");
}

index :: (r: u64, c: u64) -> u64
{
    return (r+c-1) * (r+c-2) / 2 + c-1;
}