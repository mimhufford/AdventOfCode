day23 :: (data: string) -> string, string
{
    instructions_1 := parse_instructions(data);
    instructions_2 := parse_instructions(data);

    part_1 := run(instructions_1, 7);
    part_2 := run(instructions_2, 12);
    
    return tprint("%", part_1), tprint("%", part_2);
}

#scope_file;

Instruction :: struct
{
    type : enum { CPY; INC; DEC; JNZ; TGL; };
    src : int;
    dst : int;
    src_is_val : bool;
    dst_is_val : bool;
}

parse_instructions :: (s: string) -> []Instruction
{
    instructions : [..]Instruction;

    lines := split(s, "\n");
    lines.count -= 1;

    for line: lines
    {
        i : Instruction;

        if line[0] == {
            case #char "c";
                advance(*line, 4);
                i.type = .CPY;
                i.src, i.src_is_val = val_or_reg();
                i.dst, i.dst_is_val = val_or_reg();
            case #char "i";
                advance(*line, 4);
                i.type = .INC;
                i.src, i.src_is_val = val_or_reg();
            case #char "d";
                advance(*line, 4);
                i.type = .DEC;
                i.src, i.src_is_val = val_or_reg();
            case #char "j";
                advance(*line, 4);
                i.type = .JNZ;
                i.src, i.src_is_val = val_or_reg();
                i.dst, i.dst_is_val = val_or_reg();
            case #char "t";
                advance(*line, 4);
                i.type = .TGL;
                i.src, i.src_is_val = val_or_reg();
        }

        array_add(*instructions, i);
    }

    return instructions;

    val_or_reg :: () -> s64, bool #expand
    {
        if `line[0] >= #char "a" && `line[0] <= #char "d"
        {
            val := `line[0] - #char "a";
            if `line.count > 1 advance(*`line, 2);
            return val, false;
        }

        val : s64;
        mul : s64 = 1;
        if `line[0] == #char "-"
        {
            mul = -1;
            advance(*`line, 1);
        }
        while `line.count && `line[0] >= #char "0" && `line[0] <= #char "9"
        {
            val *= 10;
            val += `line[0] - #char "0";
            advance(*`line, 1);
        }
        if `line.count advance(*`line, 1);
        return mul*val, true;
    }
}

run :: (instructions: []Instruction, a: int) -> s64
{
    reg : [4]s64;
    reg[0] = a;
    ip := 0;

    while ip < instructions.count
    {
        inst := instructions[ip];

        src := ifx inst.src_is_val then inst.src else reg[inst.src];
        dst := ifx inst.dst_is_val then inst.dst else reg[inst.dst];
        
        if inst.type == {
            case .CPY; if !inst.dst_is_val  reg[inst.dst] = src;  ip += 1;
            case .INC; if !inst.src_is_val  reg[inst.src] += 1;   ip += 1;
            case .DEC; if !inst.src_is_val  reg[inst.src] -= 1;   ip += 1;
            case .JNZ; ip += ifx src then dst else 1;
            case .TGL;
                tip := ip + src;
                if tip >= 0 && tip < instructions.count
                {
                    mod := *instructions[tip];
                    if mod.type == {
                        case .INC; mod.type = .DEC;
                        case .DEC; mod.type = .INC;
                        case .TGL; mod.type = .INC;
                        case .JNZ; mod.type = .CPY;
                        case .CPY; mod.type = .JNZ;
                    }
                }
                ip += 1;
        }
    }

    return reg[0];
}