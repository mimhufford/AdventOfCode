day21 :: (input: string) -> string, string
{
    counts : Table(u32, s64);              // pattern_hash to on count
    transformations : Table(u32, [..]u32); // pattern_hash to []pattern_hash
    patterns : Table(u32, []string);       // pattern_hash to pattern

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
        in := split(parts[0], "/");
        in_on_count := on_count(in);
        out := split(parts[1], "/");
        out_on_count := on_count(out);
        out_hash := get_hash(out);
        find_or_add(*counts, out_hash).* = out_on_count;
        table_add(*patterns, out_hash, out);

        for 1..8 {
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

            if it != 4 continue;
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

    curr, next: Table(u32, s64); // pattern_hash to how many we have
    results : [..]s64;
    table_add(*curr, get_hash(split(".#./..#/###", "/")), 1);
    array_add(*results, 5);

    for 1..6 {
        step_1_count, step_2_count, step_3_count := 0;
        for * multiplier, hash: curr {
            if multiplier.* == 0 continue;

            hx4x33 : [4]u32;
            for table_find_pointer(*transformations, hash).* {
                step_1_count += multiplier.* * table_find_pointer(*counts, it).*;
                hx4x33[it_index] = table_find_pointer(*transformations, it).*[0];
            }

            px4x33 : [4][]string;
            for hx4x33 {
                step_2_count += multiplier.* * table_find_pointer(*counts, it).*;
                px4x33[it_index] = table_find_pointer(*patterns, it).*;
            }

            px9x22 : [9][]string;
            px9x22[0] = string.[slice(px4x33[0][0], 0, 2), slice(px4x33[0][1], 0, 2)];
            px9x22[1] = string.[u8.[px4x33[0][0][2],px4x33[1][0][0]].(string), u8.[px4x33[0][1][2],px4x33[1][1][0]].(string)];
            px9x22[2] = string.[slice(px4x33[1][0], 1, 2), slice(px4x33[1][1], 1, 2)];
            px9x22[3] = string.[slice(px4x33[0][2], 0, 2), slice(px4x33[2][0], 0, 2)];
            px9x22[4] = string.[u8.[px4x33[0][2][2],px4x33[1][2][0]].(string), u8.[px4x33[2][0][2],px4x33[3][0][0]].(string)];
            px9x22[5] = string.[slice(px4x33[1][2], 1, 2), slice(px4x33[3][0], 1, 2)];
            px9x22[6] = string.[slice(px4x33[2][1], 0, 2), slice(px4x33[2][2], 0, 2)];
            px9x22[7] = string.[u8.[px4x33[2][1][2],px4x33[3][1][0]].(string), u8.[px4x33[2][2][2],px4x33[3][2][0]].(string)];
            px9x22[8] = string.[slice(px4x33[3][1], 1, 2), slice(px4x33[3][2], 1, 2)];
            for px9x22 {
                h33 := table_find_pointer(*transformations, get_hash(it)).*[0];
                step_3_count += multiplier.* * table_find_pointer(*counts, h33).*;
                find_or_add(*next, h33).* += multiplier.*;
            }

            multiplier.* = 0;
        }

        array_add(*results, step_1_count, step_2_count, step_3_count);
        curr, next = next, curr;
    }

    return tprint("%", results[5]), tprint("%", results[18]);
}