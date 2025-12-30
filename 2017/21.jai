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

    curr: [..]u32;
    next: [..]u32;
    step_counts : [..]s64;
    array_add(*curr, get_hash(split(".#./..#/###", "/")));
    array_add(*step_counts, 5);

    for 1..6 {
        step_1_count, step_2_count, step_3_count := 0;
        for curr {
            // step 1: go from 3x3 to 4x4
            two_by_twos := table_find_pointer(*transformations, it).*;
            assert(two_by_twos.count == 4);
            for two_by_twos step_1_count += table_find_pointer(*counts, it).*;

            // step 2: go from 4x4 (4 2x2s) to 6x6 (4 3x3s)
            three_by_threes : [4]u32;
            for two_by_twos {
                three_by_three := table_find_pointer(*transformations, it).*;
                assert(three_by_three.count == 1);
                three_by_threes[it_index] = three_by_three[0];
            }
            for three_by_threes {
                step_2_count += table_find_pointer(*counts, it).*;
            }

            // step 3: convert 6x6 (4 3x3s) to 6x6 (9 2x2), then go to 9x9 (9 3x3s)
            p33 : [4][]string;
            for three_by_threes {
                p33[it_index] = table_find_pointer(*patterns, it).*;
            }
            px9x22 : [9][]string;
            px9x22[0] = string.[slice(p33[0][0], 0, 2), slice(p33[0][1], 0, 2)];
            px9x22[1] = string.[u8.[p33[0][0][2],p33[1][0][0]].(string), u8.[p33[0][1][2],p33[1][1][0]].(string)];
            px9x22[2] = string.[slice(p33[1][0], 1, 2), slice(p33[1][1], 1, 2)];
            px9x22[3] = string.[slice(p33[0][2], 0, 2), slice(p33[2][0], 0, 2)];
            px9x22[4] = string.[u8.[p33[0][2][2],p33[1][2][0]].(string), u8.[p33[2][0][2],p33[3][0][0]].(string)];
            px9x22[5] = string.[slice(p33[1][2], 1, 2), slice(p33[3][0], 1, 2)];
            px9x22[6] = string.[slice(p33[2][1], 0, 2), slice(p33[2][2], 0, 2)];
            px9x22[7] = string.[u8.[p33[2][1][2],p33[3][1][0]].(string), u8.[p33[2][2][2],p33[3][2][0]].(string)];
            px9x22[8] = string.[slice(p33[3][1], 1, 2), slice(p33[3][2], 1, 2)];
            for px9x22 {
                h33 := table_find_pointer(*transformations, get_hash(it)).*[0];
                step_3_count += table_find_pointer(*counts, h33).*;
                array_add(*next, h33);
            }
        }

        array_add(*step_counts, step_1_count);
        array_add(*step_counts, step_2_count);
        array_add(*step_counts, step_3_count);
        array_reset_keeping_memory(*curr);
        curr, next = next, curr;
    }

    return tprint("%", step_counts[5]), tprint("%", step_counts[18]);
}