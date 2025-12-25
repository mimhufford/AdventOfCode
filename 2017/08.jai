day8 :: (input: string) -> string, string
{
    part1, part2 := 0;

    registers : Table(string, s64);

    while input {
        reg := read_word(*input);
        dir := read_word(*input);
        amt := read_s64 (*input);
        _   := read_word(*input);
        cnd := read_word(*input);
        op  := read_word(*input);
        val := read_s64 (*input);

        do_instruction :: () #expand {
            r := find_or_add(*registers, reg);
            r.* += ifx dir[0] == "d" then -amt else amt;
            part2 = max(part2, r.*);
        }

        if op == {
            case  ">"; if find_or_add(*registers, cnd).*  > val then do_instruction();
            case  "<"; if find_or_add(*registers, cnd).*  < val then do_instruction();
            case "=="; if find_or_add(*registers, cnd).* == val then do_instruction();
            case "!="; if find_or_add(*registers, cnd).* != val then do_instruction();
            case ">="; if find_or_add(*registers, cnd).* >= val then do_instruction();
            case "<="; if find_or_add(*registers, cnd).* <= val then do_instruction();
        }
    }

    for registers part1 = max(part1, it);

    return tprint("%", part1), tprint("%", part2);
}