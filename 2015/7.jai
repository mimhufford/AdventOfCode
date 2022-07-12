day7 :: (input: string) -> string, string
{
    gates : [..]Gate;
    power : Table(string, u16);
    wires : [..]string;

    while input.count
    {
        while input.count && input[0] != #char "\n"
        {
            g : Gate;

            if input[0] == #char "N" // NOT
            {
                advance(*input, 4);
                g.op = "NOT";
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
                    g.op   = "AND";
                    g.src2 = read_wire_name(*input);
                    advance(*input, 4);
                    g.dest = read_wire_name(*input);
                }
                else // SOURCE
                {
                    advance(*input, 3);
                    g.op   = "SOURCE";
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
                    g.op = "AND";
                    g.src2 = read_wire_name(*input);
                    advance(*input, 4);
                    g.dest = read_wire_name(*input);
                }
                else if input[0] == #char "O" // OR
                {
                    advance(*input, 3);
                    g.op = "OR";
                    g.src2 = read_wire_name(*input);
                    advance(*input, 4);
                    g.dest = read_wire_name(*input);
                }
                else if input[0] == #char "L" // LSHIFT
                {
                    advance(*input, 7);
                    g.op = "LSHIFT";
                    g.val = read_number(*input);
                    advance(*input, 4);
                    g.dest = read_wire_name(*input);
                }
                else if input[0] == #char "R" // RSHIFT
                {
                    advance(*input, 7);
                    g.op = "RSHIFT";
                    g.val = read_number(*input);
                    advance(*input, 4);
                    g.dest = read_wire_name(*input);
                }
                else
                {
                    advance(*input, 3);
                    g.op = "DIRECT";
                    g.dest = read_wire_name(*input);
                }
            }

            while input.count && input[0] != #char "\n" advance(*input, 1); // TEMPORARY
            advance(*input, 1);
            array_add(*gates, g);
            if g.dest array_add_if_unique(*wires, g.dest);
            if g.src1 array_add_if_unique(*wires, g.src1);
            if g.src2 array_add_if_unique(*wires, g.src2);
        }
    }

    resolve();

    part_1 := <<table_find_pointer(*power, "a");
    table_reset(*power);

    for * gates if it.dest == "b"
    {
        it.op = "SOURCE";
        it.val = part_1;
    }
    
    resolve();

    return tprint("%", part_1), tprint("%", <<table_find_pointer(*power, "a"));
}

Gate :: struct {
    val  : u16;
    op   : string;
    src1 : string;
    src2 : string;
    dest : string;
}

resolve :: () #expand
{
    while `power.count != `wires.count
    {
        for g: `gates
        {
            if table_find_pointer(*`power, g.dest) continue;

            src1 := table_find_pointer(*`power, g.src1);
            src2 := table_find_pointer(*`power, g.src2);
            pow1 := ifx src1 then <<src1 else 0;
            pow2 := ifx src2 then <<src2 else 0;

            if g.op ==
            {
                case "SOURCE"; table_add(*`power, g.dest, g.val);
                case "NOT"; if src1 table_add(*`power, g.dest, ~pow1);
                case "AND"; if src1 && src2 table_add(*`power, g.dest, pow1 & pow2); else if g.val && src2 table_add(*`power, g.dest, g.val & pow2);
                case "OR";  if src1 && src2 table_add(*`power, g.dest, pow1 | pow2);
                case "RSHIFT"; if src1 table_add(*`power, g.dest, pow1 >> g.val);
                case "LSHIFT"; if src1 table_add(*`power, g.dest, pow1 << g.val);
                case "DIRECT"; if src1 table_add(*`power, g.dest, pow1);
            }
        }
    }
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

read_number :: (s : *string) -> u16 #expand
{
    num : u16;

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s, 1);
    }

    return num;
}