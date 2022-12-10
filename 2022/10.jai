day10 :: (input: string) -> string, string
{
    cycle, signal : s64;
    crt : [6*40]u8;
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

    // print(crt);

    return tprint("%", signal), tprint("%", "RKPJBPLA");
}

#scope_file

print :: (crt: []u8)
{
    for y: 0..5
    {
        for x: 0..39 print("%", ifx crt[y*40+x] == 1 then "#" else " ");
        print("\n");
    }
}

tick :: () #expand
{
    `cycle += 1;
    x := `cycle % 40;
    if x == 20 `signal += `x * `cycle;
    `crt[`cycle-1] = cast(u8)(abs(x-1 - `x) < 2);
}