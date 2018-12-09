def pr_str(ast, print_readably = true)
  case ast
  when List, Vector, Dictionary
    "#{ast.class::START_SYMBOL}#{ast.map {|v| pr_str(v, print_readably)}.join(' ')}#{ast.class::END_SYMBOL}"
  when Hash
    result = ast.map {|k, v| [pr_str(k, print_readably), pr_str(v, print_readably)]}
    '{' + result.join(' ') + '}'
  when String
    if ast[0] == "\u029e"
      ":" + ast[1..-1]
    elsif print_readably
      ast.inspect
    else
      ast
    end
  when nil
    'nil'
  else
    ast.to_s
  end
end