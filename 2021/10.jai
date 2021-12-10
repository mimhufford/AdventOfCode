day10 :: (data : string) -> string, string
{
    corrupt_score : u64;
    incomplete : [..]u64;

    while data.count
    {
        stack : [..]u8;

        while data.count && data[0] != #char "\n"
        {
            is_corrupt :: (c : u8, score : u64) -> bool #expand
            {
                if !stack.count || stack[stack.count-1] != c
                {
                    corrupt_score += score;
                    stack.count = 0;
                    return true;
                }
                else
                {
                    stack.count -= 1;
                    return false;
                }
            }

            if data[0] == 
            {
                case #char ")"; if is_corrupt(#char "(", 3)     break;
                case #char "]"; if is_corrupt(#char "[", 57)    break;
                case #char "}"; if is_corrupt(#char "{", 1197)  break;
                case #char ">"; if is_corrupt(#char "<", 25137) break;
                case;           array_add(*stack, data[0]);
            }

            advance(*data, 1);
        }

        while data.count && data[0] != #char "\n"  advance(*data, 1);

        advance(*data, 1);

        if stack.count
        {
            incomplete_score : u64;

            while stack.count
            {
                incomplete_score *= 5;

                if stack[stack.count-1] ==
                {
                    case #char "("; incomplete_score += 1;
                    case #char "["; incomplete_score += 2;
                    case #char "{"; incomplete_score += 3;
                    case #char "<"; incomplete_score += 4;
                }

                stack.count -= 1;
            }

            array_add(*incomplete, incomplete_score);
        }
    }

    quick_sort(incomplete, x => x);

    incomplete_score := incomplete[(incomplete.count-1)/2];

	return tprint("%", corrupt_score), tprint("%", incomplete_score);
}