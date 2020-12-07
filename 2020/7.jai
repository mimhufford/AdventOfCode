day7 :: () -> string, string
{
    data := string_lines(7);

    bags : [..]*Bag;

    for line: data
    {
        parts := split(line, " contain ");

        // get current bag
        id := parts[0];
        id.count -= 5;
        found, bag := find_or_make_bag(bags, id);
        if !found array_add(*bags, bag);

        // add contents of bag
        contents := parts[1];
        // skip "no other bags"
        if contents[0] == #char "n" continue;
        contents.count -= 1; // remove the .
        inner_bags := split(contents, ", ");
        for inner_bags
        {
            inner_bag_id := it;
            count := read_number(*inner_bag_id);
            inner_bag_id.count -= 4;
            inner_bag_id = trim(inner_bag_id);
            found, inner_bag := find_or_make_bag(bags, inner_bag_id);
            if !found array_add(*bags, inner_bag);
            array_add(*bag.inner_count, count);
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

    return result;
}