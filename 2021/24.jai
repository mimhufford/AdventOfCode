day24 :: (data : string) -> string, string
{
    reg : [4]s64;
    input : [..]s64;
    for 1..14 array_add(*input, 9);

    while data.count
    {
        instruction : string = ---;
        instruction.data = data.data;
        instruction.count = 3;
        advance(*data, 4);
        dest := data[0] - #char "w";
        advance(*data, 1);

        if instruction == "inp"
        {
            assert(input.count > 0, "out of input data");
            reg[dest] = pop(*input);
            advance(*data, 1);
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
            advance(*data, 1);
            r := data[0] - #char "w";
            if r >= 0 && r <= 3
            {
                advance(*data, 2);
                return reg[r];
            }
            neg := false;
            if data[0] == #char "-"
            {
                neg = true;
                advance(*data, 1);
            }
            num : s64;
            while data[0] >= #char "0" && data[0] <= #char "9"
            {
                num *= 10;
                num += data[0] - #char "0";
                advance(*data, 1);
            }
            advance(*data, 1);
            return ifx neg then -num else num;
        }
    }

    return tprint("%", reg), tprint("%", "");
}