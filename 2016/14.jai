day14 :: (data: string) -> string, string
{
    key := data; key.count -= 1;

    return tprint("%", solve(key, 1)), tprint("%", solve(key, 2017));
}

#scope_file;

solve :: (key: string, times: int) -> int
{
    // todo: remove all the tprint stuff
    key_indexes : [..]int;

    hashes : [..]string;
    index := 0;

    while hashes.count != 1001
    {
        hash := md5(tprint("%1%2", key, index));
        for 1..times-1 hash = md5(hash);
        array_add(*hashes, hash);
        index += 1;
    }

    while key_indexes.count != 64
    {
        result := hashes[0];

        for ci: 0..result.count-3
        {
            if result[ci] == result[ci+1] && result[ci] == result[ci+2]
            {
                for n: 1..1000
                {
                    next := hashes[n];
                    for ni: 0..next.count-5
                    {
                        if next[ni+0] == result[ci] &&
                           next[ni+1] == result[ci] &&
                           next[ni+2] == result[ci] &&
                           next[ni+3] == result[ci] &&
                           next[ni+4] == result[ci]
                        {
                            array_add(*key_indexes, xx index - 1001);
                            break ci;
                        }
                    }
                }
                break;
            }
        }

        array_ordered_remove_by_index(*hashes, 0); // todo slow
        hash := md5(tprint("%1%2", key, index));
        for 1..times-1 hash = md5(hash);
        array_add(*hashes, hash);
        index += 1;
    }

    return key_indexes[63];
}

#import "md5";