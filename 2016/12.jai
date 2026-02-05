day12 :: (data: string) -> string, string
{
    instructions := parse_instructions(data);

    part_1 := run(instructions, 0);
    part_2 := run(instructions, 1);
    
    return tprint("%", part_1), tprint("%", part_2);
}

#scope_file;

Instruction :: struct
{
    type : enum { CPY_VAL; CPY_REG; INC; DEC; JNZ_VAL; JNZ_REG; };
    src : int;
    dst : int;
}

parse_instructions :: (s: string) -> []Instruction
{
    instructions : [..]Instruction;

    lines := split(s, "\n");
    lines.count -= 1;

    val_or_reg :: () -> s64, bool #expand
    {
        if `line[0] >= #char "a" && `line[0] <= #char "d"
        {
            val := `line[0] - #char "a";
            advance(*`line, 2);
            return val, false;
        }

        val : s64;
        while `line[0] >= #char "0" && `line[0] <= #char "9"
        {
            val *= 10;
            val += `line[0] - #char "0";
            advance(*`line, 1);
        }
        advance(*`line, 1);
        return val, true;
    }

    for line: lines
    {
        i : Instruction;

        if line[0] == {
            case #char "c";
                advance(*line, 4);
                val, is_val := val_or_reg();
                i.src = val;
                i.type = .CPY_VAL; if !is_val i.type = .CPY_REG;
                i.dst = line[0] - #char "a";
            case #char "i";
                advance(*line, 4);
                i.type = .INC;
                i.dst = line[0] - #char "a";
            case #char "d";
                advance(*line, 4);
                i.type = .DEC;
                i.dst = line[0] - #char "a";
            case #char "j";
                advance(*line, 4);
                val, is_val := val_or_reg();
                i.type = .JNZ_VAL; if !is_val i.type = .JNZ_REG;
                i.src = val;
                i.dst = string_to_int(line);
        }

        array_add(*instructions, i);
    }

    return instructions;
}

run :: (instructions: []Instruction, c: s64) -> s64
{
    reg : [4]s64;
    reg[2] = c;
    ip := 0;

    while ip < instructions.count
    {
        inst := instructions[ip];
        if inst.type == {
            case .CPY_VAL; reg[inst.dst] = inst.src;       ip += 1;
            case .CPY_REG; reg[inst.dst] = reg[inst.src];  ip += 1;
            case .INC;     reg[inst.dst] += 1;             ip += 1;
            case .DEC;     reg[inst.dst] -= 1;             ip += 1;
            case .JNZ_VAL; ip += ifx inst.src      then inst.dst else 1;
            case .JNZ_REG; ip += ifx reg[inst.src] then inst.dst else 1;
        }
    }

    return reg[0];
}