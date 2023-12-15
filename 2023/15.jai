day15 :: (input: string) -> string, string
{
    part1, part2 := 0;
    map : [256][..]Item;

    for word: split(trim(input), ",")
    {
        full_hash, hash: u8;
        
        for 0..word.count-1
        {
            full_hash += word[it];
            full_hash *= 17;
            if word[it] == #char "=" continue;
            if word[it] == #char "-" continue;
            if is_digit(word[it])    continue;
            hash += word[it];
            hash *= 17;
        }
        
        if word[word.count-1] != #char "-"
        {
            key := word; key.count -= 2;
            found := false;
            for * slot: map[hash]
            {
                if slot.key == key
                {
                    slot.value = word[word.count-1] - #char "0";
                    found = true;
                    break;
                }
            }
            if !found array_add(*map[hash], .{key, hash, word[word.count-1] - #char "0"});
        }
        else
        {
            key := word; key.count -= 1;
            index := -1;
            for * slot, slot_index: map[hash]
            {
                if slot.key == key
                {
                    index = slot_index;
                    break;
                }
            }
            if index >=0 array_ordered_remove_by_index(*map[hash], index);
        }

        part1 += full_hash;
    }

    for box, box_index: map for item, slot_index: box
    {
        part2 += (box_index+1) * (slot_index+1) * item.value;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Item :: struct
{
    key   : string;
    hash  : u8;
    value : u8;
}