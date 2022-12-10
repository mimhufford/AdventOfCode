day10 :: (input: string) -> string, string
{
    cycle, signal : s64;
    x := 1;

    while input
    {
        tick();
        if read_word(*input)[0] == #char "a"
        {
            tick();
            x += read_s32(*input);
        }
    }

    return tprint("%", signal), tprint("%", "");
}

#scope_file

tick :: () #expand
{
    `cycle += 1;
    if `cycle % 40 == 20 `signal += `x * `cycle;
}