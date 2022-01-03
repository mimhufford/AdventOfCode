day14 :: (data: string) -> string, string
{
    // todo: remove all the tprint stuff
    //       avoid md5ing same thing multiple times
    key := data; key.count -= 1;
    key_indexes : [..]int;

    for i: 0..U64_MAX
    {
        result := md5(tprint("%1%2", key, i));

        for ci: 0..result.count-3
        {
            if result[ci] == result[ci+1] && result[ci] == result[ci+2]
            {
                for n: i+1..i+1001
                {
                    next := md5(tprint("%1%2", key, n));
                    for ni: 0..next.count-5
                    {
                        if next[ni+0] == result[ci] &&
                           next[ni+1] == result[ci] &&
                           next[ni+2] == result[ci] &&
                           next[ni+3] == result[ci] &&
                           next[ni+4] == result[ci]
                        {
                            array_add(*key_indexes, xx i);
                            break ci;
                        }
                    }
                }
                break;
            }
        }

        if key_indexes.count == 64 break;
    }

    return tprint("%", key_indexes[63]), tprint("%", "");
}

#scope_file;
#import "md5";