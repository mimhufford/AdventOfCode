day13 :: (data: string) -> string, string
{
    happiness: Table(string, Table(string, s64));
    people: [..]string;

    while data.count
    {
        first, second, delta := read_line(*data);
        array_add_if_unique(*people, first);
        array_add_if_unique(*people, second);
        f := table_find_pointer(happiness, first);
        if !f f = table_add(*happiness, first, .{});
        table_add(f, second, delta);
    }

    part_1 := max_happiness(people, happiness);

    array_add(*people, "me");
    table_add(*happiness, "me", .{});
    for ft, f: happiness
    {
        table_add(table_find_pointer(happiness, "me"), f, 0);
        table_add(*ft, "me", 0);
    }

    part_2 := max_happiness(people, happiness);

    return tprint("%", part_1), tprint("%", part_2);
}

max_happiness :: (people: []string, happiness: Table) -> s64
{
    #import "Permute";
    indexes : [..]int;
    for people array_add(*indexes, it_index);
    order : []int = indexes;
    rounds := permutation_count(xx order.count, xx order.count) / xx people.count;
    best := S64_MIN;
    for 1..rounds
    {
        order = permutation(order);

        total := 0;

        for i: 0..order.count-1
        {
            l := people[order[(i-1+order.count) % order.count]];
            m := people[order[i]];
            r := people[order[(i+1) % order.count]];
            ml := <<table_find_pointer(<<table_find_pointer(happiness, m), l);
            mr := <<table_find_pointer(<<table_find_pointer(happiness, m), r);
            total += ml + mr;
        }

        best = max(best, total);
    }

    return best;
}

read_line :: (s: *string) -> string, string, s64
{
    first: string;
    second: string;
    happiness: s64;

    first.data = s.data;
    while s.data[0] != #char " "
    {  
        first.count += 1;
        advance(s, 1);
    }

    advance(s, 7);
    neg := s.data[0] == #char "l";
    advance(s, 5);

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        happiness *= 10;
        happiness += s.data[0] - #char "0";
        advance(s, 1);
    }

    advance(s, 36);

    second.data = s.data;
    while s.data[0] != #char "."
    {
        second.count += 1;
        advance(s, 1);
    }

    advance(s, 2);

    return first, second, ifx neg then -happiness else happiness;
}