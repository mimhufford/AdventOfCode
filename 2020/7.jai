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
            while inner_bag_id[0] >= #char "0" && inner_bag_id[0] <= #char "9" advance(*inner_bag_id);
            inner_bag_id.count -= 4;
            inner_bag_id = trim(inner_bag_id);

            found, inner_bag := find_or_make_bag(bags, inner_bag_id);
            if !found array_add(*bags, inner_bag);
            array_add(*bag.contains, inner_bag);
        }
    }

    part1 := -1; // to account for idenity bag
    for bags if does_bag_contain_other_bag(it, "shiny gold") part1 += 1;

    return tprint("%", part1), "";
}

does_bag_contain_other_bag :: (bag: *Bag, id: string) -> bool
{
    if bag.id == id return true;
    for bag.contains if does_bag_contain_other_bag(it, id) return true;
    return false;
}

find_or_make_bag :: (bags: []*Bag, id: string) -> bool, *Bag
{
    for bags if it.id == id return true, it;
    bag := New(Bag);
    bag.id = id;
    return false, bag;
}

Bag :: struct
{
    id: string;
    contains: [..]*Bag;
}