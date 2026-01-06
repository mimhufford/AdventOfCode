day3 :: (input: string) -> string, string
{
    part1, part2 := S64_MAX;

    wire : [2]Table(u64, s64);

    for line, id: split(trim(input), "\n") {
        p : struct { x, y: s32; #overlay(x) hash: u64; };
        steps := 0;
        while line {
            dir := line[0];
            amt := get(s64, *line);
            if line advance(*line);
            for 1..amt { 
                steps += 1;
                if dir == {
                    case "U"; p.y -= 1;
                    case "D"; p.y += 1;
                    case "L"; p.x -= 1;
                    case "R"; p.x += 1;
                }
                entry, new := find_or_add(*wire[id], p.hash);
                if new entry.* = steps;

                if id == 1 {
                    intersection := table_find_pointer(*wire[0], p.hash);
                    if !intersection continue;
                    part1 = min(part1, abs(p.x) + abs(p.y));
                    part2 = min(part2, entry.* + intersection.*);
                }
            }
        }
    }

    return tprint("%", part1), tprint("%", part2);
}