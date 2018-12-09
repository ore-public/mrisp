class Env
  attr_accessor :data

  def initialize(outer = nil, binds = [], exprs = [])
    self.data = {}
    @outer = outer
    binds.zip(exprs).each_with_index do |v, i|
      if v[0] == :&
        self.data[binds[i + 1]] = exprs.drop(i)
        break
      else
        self.data[v[0]] = v[1]
      end
    end
  end

  def set(key, value)
    data[key] = value
  end

  def find(key)
    return self if self.data.key? key
    return @outer.find(key) unless @outer.nil?
    nil
  end

  def get(key)
    env = find(key)
    unless env.nil?
      return env.data[key]
    else
      raise "'#{key}' not found"
    end
  end
end