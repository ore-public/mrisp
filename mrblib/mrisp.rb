def eval_ast(ast, repl_env)
  case ast
  when Symbol
    repl_env.get(ast)
  when List
    List.new(1, ast.map {|v| EVAL(v, repl_env)}).first
  when Vector
    Vector.new(1, ast.map {|v| EVAL(v, repl_env)}).first
  when Dictionary
    new_h = {}
    ast.to_hash.each {|k, v| new_h[EVAL(k, repl_env)] = EVAL(v, repl_env)}
    new_h
  else
    ast
  end
end

def READ(v)
  read_str(v)
end

def EVAL(ast, repl_env)
  while true
    return eval_ast(ast, repl_env) unless ast.is_a?(List)
    return ast if ast.empty?

    a0, a1, a2, a3 = ast
    case a0
    when :def!
      return repl_env.set(a1, EVAL(a2, repl_env))
    when :'let*'
      let_env = Env.new(repl_env)
      a1.each_slice(2) do |a,e|
        let_env.set(a, EVAL(e, let_env))
      end
      repl_env = let_env
      ast = a2
    when :do
      el = eval_ast(ast[1..-1], repl_env)
      ast = el.last
    when :if
      cond = EVAL(a1, repl_env)
      if cond
        ast = a2
      else
        return nil if a3 == nil
        ast = a3
      end
    when :'fn*'
      return Function.new(a2, repl_env, a1)
    else
      func, *args = eval_ast(ast, repl_env)
      if func.is_a?(Function)
        ast = func.ast
        repl_env = func.get_env(args)
      else
        return func.call(*args)
      end
    end
  end
end

def PRINT(v)
  pr_str(v)
end


def rep(line, repl_env)
  PRINT(EVAL(READ(line), repl_env))
end


def __main__(argv)
  if argv[1] == "version"
    puts "v#{Mrisp::VERSION}"
    return
  end

  repl_env = Env.new(nil)
  @ns.each do |name, body|
    repl_env.set(name, body)
  end

  if argv[1].nil?
    # REPL
    rep("(def! not (fn* (a) (if a false true)))", repl_env)
    while line = Readline.readline('user> ', true)
      begin
        puts rep(line, repl_env)
      rescue Exception => e
        puts "Error: #{e}\n#{e.backtrace.join("\n")}"
      end
    end
  else
    # from File
    open(argv[1]) do |f|
      asts = READ('(' + f.read + ')')
      asts.each do |ast|
        PRINT(EVAL(ast, repl_env))
      end
    end
  end
end

