@ns = {
    '+': lambda {|a, b| a + b},
    '-': lambda {|a, b| a - b},
    '*': lambda {|a, b| a * b},
    '/': lambda {|a, b| a / b},
    list: lambda {|*a| List.new a},
    list?: lambda {|*a| a.first.is_a?(List)},
    empty?: lambda {|a| a.size == 0},
    count: lambda {|a| a.nil? ? 0 : a.size},
    '=': lambda {|a, b| a == b},
    '<': lambda {|a, b| a < b},
    '<=': lambda {|a, b| a <= b},
    '>': lambda {|a, b| a > b},
    '>=': lambda {|a, b| a >= b},
    'pr-str': lambda {|*a| a.map{|v| pr_str(v, true)}.join(' ')},
    str: lambda {|*a| a.map{|v| pr_str(v, false)}.join('')},
    prn: lambda {|*a| puts a.map{|v| pr_str(v, true)}.join(' ')},
    println: lambda {|*a| puts a.map{|v| pr_str(v, false)}.join(' ')},

}