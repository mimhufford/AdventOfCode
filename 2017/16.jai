day16 :: (input: string) -> string, string
{
    moves : [..]struct { op, op1, op2: u8; };

    while input {
        m := array_add(*moves);
        m.op = input[0];
        advance(*input);
        if m.op == {
            case "s";
                m.op1 = read_u8(*input); if input advance(*input);
            case "x";
                m.op1 = read_u8(*input); if input advance(*input);
                m.op2 = read_u8(*input); if input advance(*input);
            case "p";
                m.op1 = input[0]; if input advance(*input, 2);
                m.op2 = input[0]; if input advance(*input, 2);
        }
    }

    data := u8.["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p"];
    offset := 0;

    seen : Table(string, s64);
    part1, part2 : [..]u8;

    for iteration: 1..1_000_000_000 {
        for m: moves {
            if m.op == {
                case "s";
                    offset += m.op1;
                    offset %= 16;
                case "x";
                    a := m.op1.(s64);
                    b := m.op2.(s64);
                    swap(*data[(a-offset+16)%16], *data[(b-offset+16)%16]);
                case "p"; 
                    _, a := array_find(data, m.op1);
                    _, b := array_find(data, m.op2);
                    swap(*data[a], *data[b]);
            }
        }
        key := tprint("%0%", data.(string), offset);
        entry, new := find_or_add(*seen, key);
        if !new {
            cycle := iteration - entry.*;
            while iteration + cycle < 1_000_000_000 iteration += cycle;
        }
        entry.* = iteration;
        if iteration == 1 for 0..15 array_add(*part1, data[(it + (16 - offset)) % 16]);
    }

    for 0..15 array_add(*part2, data[(it + (16 - offset)) % 16]);

    return part1.(string), part2.(string);
}