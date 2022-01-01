day5 :: (data: string) -> string, string
{
    buffer : [32]u8;
    for 0..data.count-1 buffer[it] = data[it];
    input  : string = ---; input.data = buffer.data; input.count = data.count;
    number : string = ---; number.data = buffer.data + data.count;

    password_1 : [..]u8;
    password_2 := u8.[255,255,255,255,255,255,255,255];
    password_2_count := 0;

    index : u64;

    while password_1.count != 8 || password_2_count != 8
    {
        push_allocator(temp);
        auto_release_temp();
        index += 1;
        append_num(index);
        out := md5(input);

        if out & 0xFFFFF000 != 0  continue;

        sixth := out & 0xF00 >> 8;

        if password_1.count != 8
        {
            char := "0123456789abcdef"[sixth];
            array_add(*password_1, char);
        }

        if sixth >= 0 && sixth <= 7 && password_2[sixth] == 255
        {
            seventh := out & 0xF0 >> 4;
            char := "0123456789abcdef"[seventh];
            password_2[sixth] = char;
            password_2_count += 1;
        }
    }

    return tprint("%", cast(string)password_1), tprint("%", cast(string)password_2);
}

#scope_file

// Avoid lots of memory allocation by implementing a custom
// u64 printer which prints directly into the existing memory
append_num :: (_v: u64) #expand
{
    output : [12] u8;
    end := output.data + 12;
    p   := end;
    v   := _v;

    while v
    {
        place := v % 10;
        v     =  v / 10;
        p -= 1;
        << p  = "0123456789"[place];
    }

    num_chars := end - p;
    `input.count = `data.count + num_chars;
    memcpy(`number.data, p, num_chars);
}

// @NOTE modified version of md5
// - removes concept of chunks becuase we don't need it for this
// - only returns first 32 bits of digest without slow string manipulation

md5 :: (input: string) -> u32 #must {
    // pad size to nearest 512 bits, plus make sure there is
    // room for 64 bits at the end to include the original size
    pad  := 64 - (input.count + 8) % 64;
    size := input.count + 8 + pad;
    assert(size % 64 == 0);

    // create a buffer we can work with
    data : []u8 = ---;
    data.count = size;
    data.data  = alloc(size);

    // zero everything out
    memset(data.data, 0, size);

    // copy in the original input
    memcpy(data.data, input.data, input.count);

    // write a 1 bit right after the original input
    data[input.count] = 0b1000_0000;

    // write original size (in bits) into last 64 bits    
    dst := cast(*u64) (data.data + size - 8);
    <<dst = cast(u64) (input.count * 8);
    
    // set up digest parts
    a0 : u32 = 0x67452301;
    b0 : u32 = 0xefcdab89;
    c0 : u32 = 0x98badcfe;
    d0 : u32 = 0x10325476;

    A, B, C, D := a0, b0, c0, d0;
    
    // 64 passes
    for 0..cast(u32)63 {
        F, g : u32;

        if it < 16 {
            F = D ^ (B & (C ^ D));
            g = it;
        } else if it < 32 {
            F = C ^ (D & (B ^ C));
            g = (it*5 + 1) % 16;
        } else if it < 48 {
            F = B ^ C ^ D;
            g = (it*3 + 5) % 16;
        } else {
            F = C ^ (B | (~D));
            g = (it*7) % 16;
        }

        // grab the relevant 32 bits from the original input
        word := << ((cast(*u32)data.data) + g);

        // apply this section of data
        F += A + K[it] + word;
        A = D;
        D = C;
        C = B;
        B += F <<< s[it];
    }

    a0 += A;

    return ((a0>>24) & 0xff)     |  // move byte 3 to byte 0
           ((a0<<8)  & 0xff0000) |  // move byte 1 to byte 2
           ((a0>>8)  & 0xff00)   |  // move byte 2 to byte 1
           ((a0<<24) & 0xff000000); // byte 0 to byte 3
}

s :: u32.[
    7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
    5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
    4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
    6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,
];

K :: u32.[
    0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
    0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
    0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
    0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
    0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
    0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
    0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
    0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
    0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
    0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
    0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
    0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
    0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
    0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391,
];