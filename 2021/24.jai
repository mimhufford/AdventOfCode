day24 :: (data : string) -> string, string
{
    for < model_number: 99999999999999..11111111111111
    {
        instructions := data;
        reg : [4]s64;
        input : [..]s64;

        model := model_number;
        for 1..14
        {
            digit := model % 10;
            if digit == 0 continue model_number;
            model /= 10;
            array_add(*input, digit);
        }

        while instructions.count
        {
            instruction : string = ---;
            instruction.data = instructions.data;
            instruction.count = 3;
            advance(*instructions, 4);
            dest := instructions[0] - #char "w";
            advance(*instructions, 1);

            if instruction == "inp"
            {
                assert(input.count > 0, "out of input data");
                reg[dest] = pop(*input);
                advance(*instructions, 1);
            }
            else if instruction == "add"
            {
                val := read_reg_or_literal();
                reg[dest] += val;
            }
            else if instruction == "mul"
            {
                val := read_reg_or_literal();
                reg[dest] *= val;
            }
            else if instruction == "div"
            {
                val := read_reg_or_literal();
                assert(val != 0, "can't div 0");
                reg[dest] /= val;
            }
            else if instruction == "mod"
            {
                val := read_reg_or_literal();
                assert(val != 0, "can't mod 0");
                reg[dest] %= val;
            }
            else if instruction == "eql"
            {
                val := read_reg_or_literal();
                reg[dest] = ifx reg[dest] == val then 1 else 0;
            }
            else { print("%", instruction); assert(false); }

            read_reg_or_literal :: () -> s64 #expand
            {
                advance(*instructions, 1);
                r := instructions[0] - #char "w";
                if r >= 0 && r <= 3
                {
                    advance(*instructions, 2);
                    return reg[r];
                }
                neg := false;
                if instructions[0] == #char "-"
                {
                    neg = true;
                    advance(*instructions, 1);
                }
                num : s64;
                while instructions[0] >= #char "0" && instructions[0] <= #char "9"
                {
                    num *= 10;
                    num += instructions[0] - #char "0";
                    advance(*instructions, 1);
                }
                advance(*instructions, 1);
                return ifx neg then -num else num;
            }
        }

        if reg[3] == 0 print("%\n", model_number);
    }

    return tprint("%", ""), tprint("%", "");
}