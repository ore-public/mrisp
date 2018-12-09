class List < Array
  START_SYMBOL = '('
  END_SYMBOL = ')'
end

class Vector < Array
  START_SYMBOL = '['
  END_SYMBOL = ']'
end

class Dictionary < Array
  START_SYMBOL = '{'
  END_SYMBOL = '}'

  def to_hash
    Hash[self.each_slice(2).to_a]
  end
end

class Function
  attr_accessor :ast
  attr_accessor :env
  attr_accessor :params

  def initialize(ast=nil, env=nil, params=nil)
    self.ast = ast
    self.env = env
    self.params = params
  end

  def get_env(args)
    return Env.new(self.env, self.params, args)
  end
end