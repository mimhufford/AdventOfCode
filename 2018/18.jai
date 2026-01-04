day18 :: (input: string) -> string, string
{
    part1, part2 := 0;

    seen : Table(u32, s64);
    curr, next : [52][52]u8;
    for y: 0..49 for x: 0..49 curr[y+1][x+1] = input[y * 51 + x];

    value :: (map: [52][52]u8) -> s64 {
        tree, yard := 0;
        for y: 1..50 for x: 1..50 {
            if map[y][x] == {
                case "|"; tree += 1;
                case "#"; yard += 1;
            }
        }
        return tree * yard;
    }

    for i: 1..1_000_000_000 {
        for y: 1..50 for x: 1..50 {
            tree, yard, open := 0;
            for dy: -1..1 for dx: -1..1 if dy || dx {
                if curr[y+dy][x+dx] == {
                    case "."; open += 1;
                    case "|"; tree += 1;
                    case "#"; yard += 1;
                }
            }
            if curr[y][x] == {
                case "."; next[y][x] = ifx tree >= 3              then "|".(u8) else ".".(u8);
                case "|"; next[y][x] = ifx yard >= 3              then "#".(u8) else "|".(u8);
                case "#"; next[y][x] = ifx yard >= 1 && tree >= 1 then "#".(u8) else ".".(u8);
            }
        }
    
        entry, new := find_or_add(*seen, get_hash(next));
        if !new then i += (999_999_999 - i) / (i - entry.*) * (i - entry.*);
        entry.* = i;

        if i == 10            part1 = value(next);
        if i == 1_000_000_000 part2 = value(next);
        curr, next = next, curr;
    }

    return tprint("%", part1), tprint("%", part2);
}