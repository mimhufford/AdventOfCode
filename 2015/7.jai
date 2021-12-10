day7 :: (input: string) -> string, string
{
    gates : [..]Gate;

    while input.count
    {
        while input.count && input[0] != #char "\n"
        {
            g : Gate;

            if input[0] == #char "N" // NOT
            {
                advance(*input, 4);
                g.op = #char "N";
                g.src1 = read_wire_name(*input);
                advance(*input, 4);
                g.dest = read_wire_name(*input);
            }
            else if input[0] >= #char "0" && input[0] <= #char "9" // AND or SOURCE
            {
                g.val = read_number(*input);
                advance(*input, 1);

                if input[0] == #char "A" // AND
                {
                    advance(*input, 4);
                    g.op   = #char "A";
                    g.src2 = read_wire_name(*input);
                }
                else // SOURCE
                {
                    advance(*input, 4);
                    g.op   = #char "S";
                    g.dest = read_wire_name(*input);
                }
            }
            else // AND or OR or LSHIFT or RSHIFT or DIRECT
            {
                g.src1 = read_wire_name(*input);
                advance(*input, 1);

                if input[0] == #char "A" // AND
                {
                    advance(*input, 4);
                    g.op = #char "A";
                    g.src2 = read_wire_name(*input);
                    advance(*input, 4);
                    g.dest = read_wire_name(*input);
                }
                else if input[0] == #char "O" // OR
                {
                    advance(*input, 3);
                    g.op = #char "O";
                    g.src2 = read_wire_name(*input);
                    advance(*input, 4);
                    g.dest = read_wire_name(*input);
                }
                else if input[0] == #char "L" // LSHIFT
                {
                    advance(*input, 7);
                    g.op = #char "L";
                    g.val = read_number(*input);
                    advance(*input, 4);
                    g.dest = read_wire_name(*input);
                }
                else if input[0] == #char "R" // RSHIFT
                {
                    advance(*input, 7);
                    g.op = #char "R";
                    g.val = read_number(*input);
                    advance(*input, 4);
                    g.dest = read_wire_name(*input);
                }
                else
                {
                    advance(*input, 3);
                    g.op = #char "D";
                    g.dest = read_wire_name(*input);
                }
            }

            while input.count && input[0] != #char "\n" advance(*input, 1); // TEMPORARY
            advance(*input, 1);
            array_add(*gates, g);
        }
    }

    return tprint("%", gates), "";
}

Gate :: struct {
    val  : u64;
    op   : u8; // "S"OURCE, "N"OT, "A"ND, "O"R, "R"SHIFT, "L"SHIFT, "D"IRECT
    src1 : string;
    src2 : string;
    dest : string;
}

read_wire_name :: (s : *string) -> string #expand
{
    result : string = ---;
    result.data  = s.data;
    result.count = 0;

    while s.count && s.data[0] >= #char "a" && s.data[0] <= #char "z"
    {
        result.count += 1;
        advance(s, 1);
    }

    return result;
}

read_number :: (s : *string) -> u64 #expand
{
    num : u64;

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s, 1);
    }

    return num;
}