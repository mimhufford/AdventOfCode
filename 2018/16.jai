day16 :: (input: string) -> string, string
{
    part1, part2 := 0;

    instructions :: #type ([]s64,u8,u8,u8).[
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = r[a] + r[b]; },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = r[a] + b; },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = r[a] * r[b]; },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = r[a] * b; },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = r[a] & r[b]; },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = r[a] & b; },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = r[a] | r[b]; },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = r[a] | b; },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = r[a]; },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = a; },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = ifx a > r[b] then cast(u8, 1); },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = ifx r[a] > b then cast(u8, 1); },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = ifx r[a] > r[b] then cast(u8, 1); },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = ifx a == r[b] then cast(u8, 1); },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = ifx r[a] == b then cast(u8, 1); },
        (r: []s64, a: u8, b: u8, c: u8) { r[c] = ifx r[a] == r[b] then cast(u8, 1); },
    ];
    
    op_to_instruction : [16][..]([]s64,u8,u8,u8);
    for * op_to_instruction array_add(it, ..instructions);

    while true {
        before : [4]s64; advance(*input, 9);
        before[0] = read_s64(*input); advance(*input, 2);
        before[1] = read_s64(*input); advance(*input, 2);
        before[2] = read_s64(*input); advance(*input, 2);
        before[3] = read_s64(*input); advance(*input, 2);
        o, a, b, c := read_u8(*input), read_u8(*input), read_u8(*input), read_u8(*input);
        actual : [4]s64; advance(*input, 9);
        actual[0] = read_s64(*input); advance(*input, 2);
        actual[1] = read_s64(*input); advance(*input, 2);
        actual[2] = read_s64(*input); advance(*input, 2);
        actual[3] = read_s64(*input); advance(*input, 3);

        for i: op_to_instruction[o] {
            r := before;
            i(r, a, b, c);
            for 0..3 if r[it] != actual[it] { remove i; continue i; }
        }

        count := 0;
        for i: instructions {
            r := before;
            i(r, a, b, c);
            for 0..3 if r[it] != actual[it] continue i;
            count += 1;
            if count == 3 { part1 += 1; break; }
        }

        if input[0] == "\n" break;
    }

    for pass: 1..S64_MAX {
        for * i: op_to_instruction {
            if i.count != 1 continue;
            for * o: op_to_instruction {
                if i == o continue;
                for o.* if it == i.*[0] { remove it; continue pass; }
            } 
        }
        break;
    }

    advance(*input, 2);
    registers : [4]s64;
    while input {
        o, a, b, c := read_u8(*input), read_u8(*input), read_u8(*input), read_u8(*input);
        op_to_instruction[o][0](registers, a, b, c);
    }
    part2 = registers[0];

    return tprint("%", part1), tprint("%", part2);
}