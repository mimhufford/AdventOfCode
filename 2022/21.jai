day21 :: (input: string) -> string, string
{
    root, humn, nodes := parse_nodes(input);
    resolve(root);
    part1 := root.value;
    part2 := 0;

    humn_val := 0;

    for inf: 0..S64_MAX
    {
        avg_diff_1 := 0;

        for i: 1..10
        {
            for nodes if it.op != 0 it.done = false;
            humn.value = humn_val;
            resolve(root);
            diff := abs(root.ops[0].value - root.ops[1].value);

            if diff == 0 
            {
                part2 = humn_val;
                break inf;
            }

            avg_diff_1 += diff;

            humn_val += 1;
        }

        avg_diff_2 := 0;
        for i: 1..10
        {
            for nodes if it.op != 0 it.done = false;
            humn.value = humn_val;
            resolve(root);
            diff := abs(root.ops[0].value - root.ops[1].value);

            if diff == 0 
            {
                part2 = humn_val;
                break inf;
            }

            avg_diff_2 += diff;

            humn_val += 1;
        }

        avg_diff_1 /= 10;
        avg_diff_2 /= 10;

        rough_amount_per_10 := avg_diff_1 - avg_diff_2;
        amount_to_jump_to_get_about_half_way := avg_diff_2 / 2 / rough_amount_per_10;
        humn_val += amount_to_jump_to_get_about_half_way;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Node :: struct
{
    name  : string;
    value : s64;
    done  : bool;
    op    : u8;
    ops   : [2]*Node;
}

resolve :: (node: *Node)
{
    if node.done return;

    resolve(node.ops[0]);
    resolve(node.ops[1]);

    if node.op == {
        case #char "+"; node.value = node.ops[0].value + node.ops[1].value;
        case #char "-"; node.value = node.ops[0].value - node.ops[1].value;
        case #char "*"; node.value = node.ops[0].value * node.ops[1].value;
        case #char "/"; node.value = node.ops[0].value / node.ops[1].value;
    }

    node.done = true;
}

parse_nodes :: (input: string) -> *Node, *Node, []*Node
{
    find_or_add :: (nodes: *[..]*Node, name: string) -> *Node
    {
        for nodes.* if it.name == name return it;

        node := New(Node);
        node.name = name;
        array_add(nodes, node);
        return node;
    }

    nodes : [..]*Node;

    while input
    {
        name := read_word(*input);
        name.count -= 1;

        node := find_or_add(*nodes, name);

        if is_digit(input[0])
        {
            node.value = read_s64(*input);
            node.done  = true;
        }
        else
        {
            node.ops[0] = find_or_add(*nodes, read_word(*input));
            node.op     = read_word(*input)[0];
            node.ops[1] = find_or_add(*nodes, read_word(*input));
        }
    }

    // simplify the tree by resolving nodes that don't include humn
    while true
    {
        delete : [..]*Node;
        for n: nodes
        {
            if n.name == "humn"        continue;
            if n.op == 0               continue; 
            if n.ops[0].op   != 0      continue;
            if n.ops[1].op   != 0      continue;
            if n.ops[0].name == "humn" continue;
            if n.ops[1].name == "humn" continue;
            if n.op == #char "+" n.value = n.ops[0].value + n.ops[1].value;
            if n.op == #char "-" n.value = n.ops[0].value - n.ops[1].value;
            if n.op == #char "*" n.value = n.ops[0].value * n.ops[1].value;
            if n.op == #char "/" n.value = n.ops[0].value / n.ops[1].value;
            n.op = 0;
            n.done = true;
            array_add(*delete, n.ops[0]);
            array_add(*delete, n.ops[1]);
        }

        if delete.count == 0 break;

        for delete array_unordered_remove_by_value(*nodes, it);
    }

    return find_or_add(*nodes, "root"), find_or_add(*nodes, "humn"), nodes;
}