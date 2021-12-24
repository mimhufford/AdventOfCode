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
            // TEMP: debugging
            c := instructions; for 0..999 if instructions[it] == #char "\n" { c.count = it; break; } print(c);

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

            print("  %\n", reg);
        }


        if reg[3] == 0 print("%\n", model_number);
        break;
    }

    return tprint("%", ""), tprint("%", "");
}


/*

Hand converted instructions:

w, x, y, z = 0;

w = FIRST DIGIT;
x = ((z % 26) + 11) != w
y = (25 * x) + 1;
z *= y;
y = (w + 14) * x;
z += y;

w = SECOND DIGIT;
x = ((z % 26) + 13) != w
y = (25 * x) + 1;
z *= y;
y = (w + 8) * x;
z += y;

w = THIRD DIGIT;
x = ((z % 26) + 11) != w
y = (25 * x) + 1;
z *= y;
y = (w + 4) * x;
z += y;

w = FOURTH DIGIT;
x = ((z % 26) + 10) != w
y = (25 * x) + 1;
z *= y;
y = (w + 10) * x;
z += y;

// FIRST DIFFERENCE HERE ==================
w = FIFTH DIGIT;
x = (z % 26);
z /= 26;
x -= 3;
x = x != w
y = (25 * x) + 1;
z *= y;
y = (w + 14) * x;
z += y;

w = SIXTH DIGIT;
x = (z % 26);
z /= 26;
x -= 4;
x = x != w
y = (25 * x) + 1;
z *= y;
y = (w + 10) * x;
z += y;

w = SEVENTH DIGIT;
x = (z % 26);
x += 12;
x = x != w
y = (25 * x) + 1;
z *= y;
y = (w + 4) * x;
z += y;

w = EIGTH DIGIT;
x = (z % 26);
z /= 26;
x -= 8;
x = x != w
y = (25 * x) + 1;
z *= y;
y = (w + 14) * x;
z += y;

w = NINTH DIGIT;
x = (z % 26);
z /= 26;
x -= 3;
x = x != w
y = (25 * x) + 1;
z *= y;
y = (w + 1) * x;
z += y;

w = TENTH DIGIT;
x = (z % 26);
z /= 26;
x -= 12;
x = x != w
y = (25 * x) + 1;
z *= y;
y = (w + 6) * x;
z += y;

w = ELEVENTH DIGIT;
x = (z % 26);
x += 14;
x = x != w
y = (25 * x) + 1;
z *= y;
y = (w + 0) * x;
z += y;

w = TWELTH DIGIT;
x = (z % 26);
z /= 26;
x -= 6;
x = x != w
y = (25 * x) + 1;
z *= y;
y = (w + 9) * x;
z += y;

w = THIRTEENTH DIGIT;
x = (z % 26);
x += 11;
x = x != w
y = (25 * x) + 1;
z *= y;
y = (w + 13) * x;
z += y;

w = FOURTEENTH DIGIT;
x = (z % 26);
z /= 26;
x -= 12;
x = x != w
y = (25 * x) + 1;
z *= y;
y = (w + 12) * x;
z += y;

*/