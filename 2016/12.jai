day12 :: (data: string) -> string, string
{
    part_1 := run(data, 0);
    part_2 := run(data, 1);
    
    return tprint("%", part_1), tprint("%", part_2);

    run :: (data: string, c: s64) -> s64
    {
        reg : [4]s64;
        reg[2] = c;

        instructions := split(data, "\n");
        instructions.count -= 1;

        ip := 0;

        while ip < instructions.count
        {
            line := instructions[ip];
            if line[0] == {
                case #char "c"; advance(*line, 4); val := val_or_reg(); reg[line[0] - #char "a"] = val; ip += 1;
                case #char "i"; advance(*line, 4); reg[line[0] - #char "a"] += 1; ip += 1;
                case #char "d"; advance(*line, 4); reg[line[0] - #char "a"] -= 1; ip += 1;
                case #char "j"; advance(*line, 4); val := val_or_reg(); ip += ifx val != 0 then string_to_int(line) else 1;
            }

            val_or_reg :: () -> s64 #expand
            {
                if `line[0] >= #char "a" && `line[0] <= #char "d"
                {
                    val := reg[`line[0] - #char "a"];
                    advance(*`line, 2);
                    return val;
                }

                val : s64;
                while `line[0] >= #char "0" && `line[0] <= #char "9"
                {
                    val *= 10;
                    val += `line[0] - #char "0";
                    advance(*`line, 1);
                }
                advance(*`line, 1);
                return val;
            }
        }

        return reg[0];
    }
}

