day7 :: (input: string) -> string, string
{
    steps1, steps2 : [26][..]u8;

    while input {
        array_add(*steps1[input[36] - "A"], input[5] - "A");
        array_add(*steps2[input[36] - "A"], input[5] - "A");
        advance(*input, 49);
    }

    part1 : [..]u8;
    for iteration: 0..S64_MAX {
        for dependants, id: steps1 {
            if array_find(part1, id.(u8) + "A") continue;
            if dependants.count > 0 continue;
            array_add(*part1, id.(u8) + "A");
            for * steps1 array_unordered_remove_by_value(it, id.(u8));
            continue iteration;
        }
        break;
    }

    done := 0;
    workers : [5] struct { id : u8 = 255; finish: s64; };
    for second: 0..S64_MAX {
        for w: workers {
            if w.finish != second continue;
            for * steps2 array_unordered_remove_by_value(it, w.id - "A");
        }

        for * w: workers {
            if w.finish > second continue;
            for dependants, id: steps2 {
                if done & (1 << id) continue;
                if dependants.count > 0 continue;
                w.id = id.(u8) + "A";
                w.finish = id + 1 + second + 60;
                done |= 1 << id;
                if done == 1<<26-1 break second;
                break;
            }
        }
    }

    part2 := 0;
    for workers part2 = max(part2, it.finish);

    return part1.(string), tprint("%", part2);
}