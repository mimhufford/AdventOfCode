day7 :: () -> string, string
{
    data := input(7);

    bags : [..]*Bag;

    while data.count
    {
        id, contents := parse_line(*data);

        found, bag := find_or_make_bag(bags, id);
        if !found array_add(*bags, bag);

        if contents[0] == #char "n" continue; // skip "no other bags"

        while true
        {
            ok, inner_count, inner_id := parse_bag(*contents);
            if !ok break;
            found, inner_bag := find_or_make_bag(bags, inner_id);
            if !found array_add(*bags, inner_bag);
            array_add(*bag.inner_count, inner_count);
            array_add(*bag.inner_bags, inner_bag);
        }
    }

    part1 := -1; // to account for idenity bag
    for bags if does_bag_contain_other_bag(it, "shiny gold") part1 += 1;
    
    found, shiny_gold_bag := find_or_make_bag(bags, "shiny gold");
    part2 := count_contents(shiny_gold_bag);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Bag :: struct
{
    id: string;
    inner_count: [..]u64;
    inner_bags:  [..]*Bag;
}

does_bag_contain_other_bag :: (bag: *Bag, id: string) -> bool
{
    if bag.id == id return true;
    for bag.inner_bags if does_bag_contain_other_bag(it, id) return true;
    return false;
}

count_contents :: (bag: *Bag) -> u64
{
    count : u64;
    for b, i: bag.inner_bags count += bag.inner_count[i] + bag.inner_count[i] * count_contents(b);
    return count;
}

find_or_make_bag :: (bags: []*Bag, id: string) -> bool, *Bag
{
    for bags if it.id == id return true, it;
    bag := New(Bag);
    bag.id = id;
    return false, bag;
}

read_number :: (s: *string) -> u64
{
    result : u64;

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        result *= 10;
        result += s.data[0] - #char "0";
        advance(s);
    } 

    advance(s);

    return result;
}

parse_line :: (s: *string) -> string, string
{
    id : string = ---;
    id.count = 0;
    id.data = s.data;

    while !(s.data[0] == #char " " && s.data[1] == #char "b" && s.data[2] == #char "a")
    {
        id.count += 1;
        advance(s);
    }

    advance(s, 14); // eat the contains bit

    contents : string = ---;
    contents.count = 0;
    contents.data = s.data;

    while s.count && s.data[0] != #char "."
    {
        advance(s, 1);
        contents.count += 1;
    } 

    advance(s, 1);            // eat the .
    if s.count advance(s, 1); // eat the \n

    return id, contents;
}

parse_bag :: (s: *string) -> bool, u64, string
{
    if !s.count return false, 0, "";

    count := read_number(s);

    id : string = ---;
    id.count = 0;
    id.data = s.data;

    while !(s.data[0] == #char " " && s.data[1] == #char "b" && s.data[2] == #char "a")
    {
        id.count += 1;
        advance(s);
    }

    advance(s, 4); // eat " bag"

    // eat any leftover junk
    if s.count && s.data[0] == #char "s" advance(s, 1);
    if s.count && s.data[0] == #char "," advance(s, 1);
    if s.count && s.data[0] == #char " " advance(s, 1);

    return true, count, id;
}