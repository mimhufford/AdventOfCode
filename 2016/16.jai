day16 :: (data: string) -> string, string
{
    buf : [..]u8;
    for 0..data.count-2 array_add(*buf, data[it] - #char "0");

    while buf.count < 35651584
    {
        array_add(*buf, 0);
        for < buf.count-2..0 array_add(*buf, 1-buf[it]);
    }

    checksum :: (n: int, buf: [..]u8) -> string
    {
        csc : [..]u8;
        for 0..n/2-1 array_add(*csc, cast(u8)(buf[it*2] == buf[it*2+1]) + #char "0");
        if csc.count % 2 == 0 return checksum(csc.count, csc);
        return cast(string)csc;
    }

    return tprint("%", checksum(272, buf)), tprint("%", checksum(35651584, buf));
}

#scope_file;