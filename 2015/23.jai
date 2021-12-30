day23 :: (data: string) -> string, string
{
    return tprint("%", collatz(9663)), tprint("%", collatz(77671));
}

collatz :: (start: u64) -> u64
{
    steps : u64;
    n := start;

    while n != 1
    {
        steps += 1;

        if n % 2 == 0
        {
            n /= 2;
        }
        else
        {
            n *= 3;
            n += 1;
        }
    }

    return steps;
}