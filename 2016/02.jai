day2 :: (data: string) -> string, string
{
    keypad1 :: string.[
        ".....",
        ".123.",
        ".456.",
        ".789.",
        ".....",
    ];

    keypad2 :: string.[
        ".......",
        "...1...",
        "..234..",
        ".56789.",
        "..ABC..",
        "...D...",
        ".......",
    ];

    return tprint("%", solve(keypad1, data)), tprint("%", solve(keypad2, data));

    solve :: (keypad: []string, s: string) -> string
    {
        result : [..]u8;
        x, y := keypad.count / 2;

        while s.count
        {
            if s.data[0] == {
                case #char "L"; if keypad[y][x-1] != #char "." x -= 1;
                case #char "R"; if keypad[y][x+1] != #char "." x += 1;
                case #char "U"; if keypad[y-1][x] != #char "." y -= 1;
                case #char "D"; if keypad[y+1][x] != #char "." y += 1;
            }

            advance(*s, 1);

            if s.data[0] == #char "\n"
            {
                array_add(*result, keypad[y][x]);
                advance(*s, 1);
            }
        }

        return xx result;
    }
}