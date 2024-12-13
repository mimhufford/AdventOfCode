day13 :: (input: string) -> string, string
{
    part1, part2 := 0;

    while input
    {
        advance(*input, 12); ax := read_s64(*input);
        advance(*input,  4); ay := read_s64(*input);
        advance(*input, 12); bx := read_s64(*input);
        advance(*input,  4); by := read_s64(*input);
        advance(*input,  9); tx := read_s64(*input);
        advance(*input,  4); ty := read_s64(*input);

        part1 += best_cost(ax, ay, bx, by, tx, ty, 100);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

best_cost :: (ax: s64, ay: s64, bx: s64, by: s64, tx: s64, ty: s64, limit := S64_MAX) -> s64
{
    result := S64_MAX;

    for a: 0..limit
    {
        // Press the A button and work out how much farther we have to go
        x := tx - (a * ax);
        y := ty - (a * ay);

        // If we overshoot then there's no point pressing A more times
        if x < 0 break;
        if y < 0 break;

        // We reached the goal without using the B button
        if x == 0 && y == 0
        {
            result = min(result, a * 3);
            continue;
        }

        // Still some way to go on X and/or Y that we have to use B for
        if x % bx != 0 continue;
        if y % by != 0 continue;
        if x / bx != y / by continue;

        // Pressing B a number of times got us there
        result = min(result, a * 3 + x / bx);
    }

    return ifx result != S64_MAX then result;
}