day21 :: (input: string) -> string, string
{
    part1, part2 := 0;

    counts : Table(u32, s64);              // pattern_hash to on count
    transformations : Table(u32, [..]u32); // pattern_hash to []pattern_hash

    get_hash :: (pattern: []string) -> u32 {
        result : u32;
        for pattern result = get_hash(it, result);
        return result;
    }

    on_count :: (pattern: []string) -> s64 {
        count := 0;
        for pattern for it if it == "#" count += 1;
        return count;
    }

    for line: split(trim(input), "\n") {
        parts := split(line, " => ");
        in  := split(parts[0], "/");
        in_on_count := on_count(in);
        out := split(parts[1], "/");
        out_on_count := on_count(out);
        out_hash := get_hash(out);
        find_or_add(*counts, out_hash).* = out_on_count;

        for 1..2 {
            for 1..4 {
                if in[0].count == 2 {
                    in[0][0], in[0][1],
                    in[1][0], in[1][1] = 
                    in[1][0], in[0][0],
                    in[1][1], in[0][1];
                    in_hash := get_hash(in);
                    find_or_add(*counts, in_hash).* = in_on_count;
                    entry, new := find_or_add(*transformations, in_hash);
                    if new array_add(entry, out_hash);
                } else {
                    in[0][0], in[0][1], in[0][2],
                    in[1][0], in[1][1], in[1][2],
                    in[2][0], in[2][1], in[2][2] =
                    in[2][0], in[1][0], in[0][0],
                    in[2][1], in[1][1], in[0][1],
                    in[2][2], in[1][2], in[0][2];
                    in_hash := get_hash(in);
                    find_or_add(*counts, in_hash).* = in_on_count;
                    entry, new := find_or_add(*transformations, in_hash);
                    if !new continue;
                    array_add(entry, get_hash(string.[slice(out[0], 0, 2), slice(out[1], 0, 2)]));
                    array_add(entry, get_hash(string.[slice(out[0], 2, 2), slice(out[1], 2, 2)]));
                    array_add(entry, get_hash(string.[slice(out[2], 0, 2), slice(out[3], 0, 2)]));
                    array_add(entry, get_hash(string.[slice(out[2], 2, 2), slice(out[3], 2, 2)]));
                }
            }

            if in[0].count == 2 {
                in[0][0], in[0][1] = in[0][1], in[0][0]; 
                in[1][0], in[1][1] = in[1][1], in[1][0];
            } else {
                in[0][0], in[0][2] = in[0][2], in[0][0];
                in[1][0], in[1][2] = in[1][2], in[1][0];
                in[2][0], in[2][2] = in[2][2], in[2][0];
            }
        }
    }

    curr, next : Table(u32, s64); // pattern hash to occurences
    table_add(*curr, get_hash(split(".#./..#/###", "/")), 1);

    for 1..18 {
        for * entry, hash: curr {
            if entry.* == 0 continue;
            for next_hash: table_find_pointer(*transformations, hash).* {
                find_or_add(*next, next_hash).* += entry.*;
            }
            entry.* = 0;
        }

        if it == 6  for mult, hash: next part1 += mult * table_find_pointer(*counts, hash).*;
        if it == 18 for mult, hash: next part2 += mult * table_find_pointer(*counts, hash).*;
        curr, next = next, curr;
    }

    return tprint("%", part1), tprint("%", part2);
}