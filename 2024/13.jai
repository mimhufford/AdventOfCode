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

        best_cost := S64_MAX;

        for a: 0..100
        {
            // Press the A button and work out how much farther we have to go
            x := tx - (a * ax);
            y := ty - (a * ay);

            // If we overshoot then there's no point pressing A more times
            if x < 0 break;
            if y < 0 break;

            // This never happens, but maybe we got there without using B
            if x == 0 && y == 0
            {
                best_cost = min(best_cost, a * 3);
                continue;
            }

            // Still some way to go on X and/or Y that we have to use B for
            if x % bx != 0 continue;
            if y % by != 0 continue;
            if x / bx != y / by continue;

            best_cost = min(best_cost, a * 3 + x / bx);
        }

        if best_cost != S64_MAX then part1 += best_cost;
    }

    return tprint("%", part1), tprint("%", part2);
}