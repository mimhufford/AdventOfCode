day25 :: (data: string) -> string, string
{
    instructions := parse_instructions(data);

    part_1 := 0;
    while !run(instructions, part_1) part_1 += 1;

    return tprint("%", part_1), tprint("%", ":)");
}

Instruction :: struct
{
    type : enum { CPY; INC; DEC; JNZ; OUT; };
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
            case #char "o";
                advance(*line, 4);
                i.type = .OUT;
                i.src, i.src_is_val = val_or_reg();
        }

        array_add(*instructions, i);
    }

    return instructions;
}

run :: (instructions: []Instruction, a: int) -> bool
{
    reg : [4]s64;
    reg[0] = a;
    ip := 0;

    output := 1;
    output_count := 0;

    while ip < instructions.count
    {
        inst := instructions[ip];

        src := ifx inst.src_is_val then inst.src else reg[inst.src];
        dst := ifx inst.dst_is_val then inst.dst else reg[inst.dst];
        
        if inst.type == {
            case .CPY; if !inst.dst_is_val  reg[inst.dst] = src;  ip += 1;
            case .INC; if !inst.src_is_val  reg[inst.src] += 1;   ip += 1;
            case .DEC; if !inst.src_is_val  reg[inst.src] -= 1;   ip += 1;
            case .OUT; if reg[inst.src] != 1-output return false; output = reg[inst.src]; output_count += 1; ip += 1;
            case .JNZ; ip += ifx src then dst else 1;
        }

        if output_count > 100 break;
    }

    return true;
}