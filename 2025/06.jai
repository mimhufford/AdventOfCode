day6 :: (input: string) -> string, string
{
    part1, part2 : s64;

    length := read_up_to(*trim(input), "\n").count;
    op : u8;
    answer := 0;
    horz : [4]s64;

    for col: 0..length-1 {
        digits : [5]u8;
        for 0..4 digits[it] = input[col + (it * (length+1))];

        if digits[4] == "+" then { op = "+"; answer = 0; }
        if digits[4] == "*" then { op = "*"; answer = 1; }

        vert := 0;
        for 0..3 if digits[it] != " " {
            vert     = vert     * 10 + (digits[it] - "0").(s64);
            horz[it] = horz[it] * 10 + (digits[it] - "0").(s64);
        }

        if vert then answer = ifx op == "+" then answer + vert else answer * vert;

        if !vert || col == length-1 {
            if op == "+" part1 += horz[0] + horz[1] + horz[2] + horz[3];
            if op == "*" part1 += horz[0] * horz[1] * horz[2] * horz[3];
            for 0..3 horz[it] = 0;
            part2 += answer;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}