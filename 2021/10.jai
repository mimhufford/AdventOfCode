day10 :: (data : string) -> string, string
{
    corrupt_score : u64;
    incomplete_scores : [..]u64;

    while data.count
    {
        stack : [..]u8;

        while data.count && data[0] != #char "\n"
        {
            is_corrupt :: (c : u8) -> bool #expand { return !stack.count || pop(*stack) != c; }

            if data[0] == 
            {
                case #char ")"; if is_corrupt(#char "(") { stack.count = 0; corrupt_score += 3;     break; }
                case #char "]"; if is_corrupt(#char "[") { stack.count = 0; corrupt_score += 57;    break; }
                case #char "}"; if is_corrupt(#char "{") { stack.count = 0; corrupt_score += 1197;  break; }
                case #char ">"; if is_corrupt(#char "<") { stack.count = 0; corrupt_score += 25137; break; }
                case; array_add(*stack, data[0]);
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
                if pop(*stack) ==
                {
                    case #char "("; incomplete_score = incomplete_score * 5 + 1;
                    case #char "["; incomplete_score = incomplete_score * 5 + 2;
                    case #char "{"; incomplete_score = incomplete_score * 5 + 3;
                    case #char "<"; incomplete_score = incomplete_score * 5 + 4;
                }
            }

            array_add(*incomplete_scores, incomplete_score);
        }
    }

    quick_sort(incomplete_scores, x => x);

	return tprint("%", corrupt_score), tprint("%", incomplete_scores[incomplete_scores.count/2]);
}