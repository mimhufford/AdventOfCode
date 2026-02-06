day21 :: (data: string) -> string, string
{
    instructions := parse_instructions(data);
    input := u8.[97,98,99,100,101,102,103,104];

    part_1 := scramble(instructions, xx input);
    part_2 : string;

    while true {
        permute(input);
        if scramble(instructions, xx input) == "fbgdceah"
        {
            part_2 = xx input;
            break;
        }
    }

    return tprint("%", part_1), tprint("%", cast(string)part_2);
}

#scope_file

Instruction :: struct
{
    type : enum { SWAP_POS; SWAP_CHAR; ROTATE_CHAR; ROTATE_LEFT; ROTATE_RIGHT; REVERSE; MOVE; };
    a, b : u8;
}

parse_instructions :: (data: string) -> []Instruction
{
    instructions : [..]Instruction;

    for line: split(data, "\n")
    {
        if starts_with(line, "swap pos")
        {
            i : Instruction;
            i.type = .SWAP_POS;
            advance(*line, 14);
            i.a = next_u8(*line);
            i.b = next_u8(*line);
            array_add(*instructions, i);
        }
        else if starts_with(line, "swap let")
        {
            i : Instruction;
            i.type = .SWAP_CHAR;
            advance(*line, 12);
            i.a = line[0];
            advance(*line, 14);
            i.b = line[0];
            array_add(*instructions, i);
        }
        else if starts_with(line, "rotate based")
        {
            i : Instruction;
            i.type = .ROTATE_CHAR;
            i.a = line[line.count-1];
            array_add(*instructions, i);
        }
        else if starts_with(line, "rotate left")
        {
            i : Instruction;
            i.type = .ROTATE_LEFT;
            advance(*line, 12);
            i.a = next_u8(*line);
            array_add(*instructions, i);
        }
        else if starts_with(line, "rotate right")
        {
            i : Instruction;
            i.type = .ROTATE_RIGHT;
            advance(*line, 13);
            i.a = next_u8(*line);
            array_add(*instructions, i);
        }
        else if starts_with(line, "reverse")
        {
            i : Instruction;
            i.type = .REVERSE;
            advance(*line, 18);
            i.a = next_u8(*line);
            i.b = next_u8(*line);
            array_add(*instructions, i);
        }
        else if starts_with(line, "move")
        {
            i : Instruction;
            i.type = .MOVE;
            advance(*line, 14);
            i.a = next_u8(*line);
            i.b = next_u8(*line);
            array_add(*instructions, i);
        }
    }

    return instructions;
}

scramble :: (instructions: []Instruction, input: string) -> string
{
    buffer : [2][8]u8;
    for 0..7 {
        buffer[0][it] = input[it];
        buffer[1][it] = input[it];
    }

    curr := 0;
    next := 1;

    for inst: instructions
    {
        if inst.type ==
        {
            case .SWAP_POS;
                buffer[next][inst.a] = buffer[curr][inst.b];
                buffer[next][inst.b] = buffer[curr][inst.a];
        
            case .SWAP_CHAR;
                for 0..buffer[next].count-1
                {
                    if buffer[curr][it] == inst.a  buffer[next][it] = inst.b;
                    if buffer[curr][it] == inst.b  buffer[next][it] = inst.a;
                }

            case .ROTATE_CHAR;
                amt := 0;
                for 0..buffer[next].count-1
                {
                    if buffer[curr][it] == inst.a
                    {
                        amt = it;
                        break;
                    }
                }
                if amt >= 4 amt += 1;
                amt += 1;

                for 0..buffer[next].count-1
                    buffer[next][it] = buffer[curr][(it-amt+2*buffer[curr].count) % buffer[curr].count];
            
            case .ROTATE_LEFT;
                for 0..buffer[next].count-1
                    buffer[next][it] = buffer[curr][(it+inst.a) % buffer[curr].count];
        
            case .ROTATE_RIGHT;
                for 0..buffer[next].count-1
                    buffer[next][it] = buffer[curr][(it-inst.a+buffer[curr].count) % buffer[curr].count];
        
            case .REVERSE;
                d := inst.b - inst.a;
                for 0..d
                    buffer[next][it+inst.a] = buffer[curr][inst.b-it];
        
            case .MOVE;
                for inst.a..buffer[next].count-2      buffer[next][it] = buffer[next][it+1];
                for < inst.b+1..buffer[next].count-1  buffer[next][it] = buffer[next][it-1];
                buffer[next][inst.b] = buffer[curr][inst.a];
        }

        buffer[curr] = buffer[next];
        curr = 1 - curr;
        next = 1 - next;
    }

    return tprint(cast(string)buffer[curr]);
}

permute :: (current : [] u8)
{
    j := current.count-2;
    k := current.count-1;

    while current[j] > current[j+1] j -= 1;
    while current[j] > current[k]   k -= 1;

    swap(*current[j], *current[k]);

    r := current.count-1;
    s := j+1;

    while r > s {
        swap(*current[r], *current[s]);
        r -= 1;
        s += 1;
    }
}