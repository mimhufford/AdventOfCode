day15 :: (input: string) -> string, string
{
    advance(*input, 24);
    a := read_s64(*input);
    advance(*input, 24);
    b := read_s64(*input);

    judge :: (a: s64, b: s64, $am: s64, $bm: s64, $amt: s64) -> s64 {
        result := 0;
        for 1..amt {
            while true { a = a * 16807 % 2147483647; if a % am == 0 break; }
            while true { b = b * 48271 % 2147483647; if b % bm == 0 break; }
            result += ifx a.(u16,no_check) == b.(u16,no_check) then 1;
        }
        return result;
    }

    part1 := judge(a, b, 1, 1, 40000000);
    part2 := judge(a, b, 4, 8, 5000000);

    return tprint("%", part1), tprint("%", part2);
}