day2 :: (input: string) -> string, string
{
    part1, part2 := 0;

    while input.count
    {
        game_possible := true;
        advance(*input, 5); // skip "Game "
        game_id := read_s64(*input);
        advance(*input, 2); // skip ": "

        min_r, min_g, min_b := 0;

        while input[0] != #char "\n"
        {
            r, g, b := 0;

            while true
            {
                amount := read_s64(*input);

                if      starts_with(input, "r") { r = amount; min_r = max(min_r, r); advance(*input, 3); }
                else if starts_with(input, "g") { g = amount; min_g = max(min_g, g); advance(*input, 5); }
                else                            { b = amount; min_b = max(min_b, b); advance(*input, 4); }

                if input[0] == #char "\n" {                     break; }
                if input[0] == #char ";"  { advance(*input, 2); break; }
                if input[0] == #char ","  { advance(*input, 2); continue; }
            }

            if r > 12 || g > 13 || b > 14 game_possible = false;
        }

        if game_possible part1 += game_id;
        part2 += min_r * min_g * min_b;

        advance(*input);
    }

    return tprint("%", part1), tprint("%", part2);
}