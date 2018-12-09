class Reader
  attr_accessor :tokens
  attr_accessor :position

  def initialize(tokens)
    self.tokens = tokens
    self.position = 0
  end

  def next
    self.position += 1
    self.tokens[self.position - 1]
  end

  def peek
    self.tokens[self.position]
  end
end

def tokenizer(str)
  re = /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"|;.*|[^\s\[\]{}('"`,;)]*)/
  str.scan(re).flatten.reject {|v| v.empty?}
end

def parse_str(t) # trim and unescape
  t[1..-2].gsub(/\\./, {"\\\\" => "\\", "\\n" => "\n", "\\\"" => '"'})
end

def read_atom(reader)
  c = reader.next
  case c
  when /^-?\d+$/
    c.to_i
  when /^".*"$/
    parse_str(c)
  when /^:/
    "\u029e" + c[1..-1]
  when 'nil'
    nil
  when 'true'
    true
  when 'false'
    false
  else
    c.to_sym
  end
end

def read_list(reader, klass)
  list = klass.new
  c = reader.next
  if c != klass::START_SYMBOL
    raise "list start not '#{klass::START_SYMBOL}'"
  end

  while true
    c = read_form(reader)
    break if c.to_s == klass::END_SYMBOL
    list.push(c)
  end

  list
end

def read_form(reader)
  case reader.peek
  when List::START_SYMBOL
    read_list(reader, List)
  when Vector::START_SYMBOL
    read_list(reader, Vector)
  when Dictionary::START_SYMBOL
    read_list(reader, Dictionary)
  when "'"
    reader.next
    List.new [:quote, read_form(reader)]
  when '`'
    reader.next
    List.new [:quasiquote, read_form(reader)]
  when '~'
    reader.next
    List.new [:unquote, read_form(reader)]
  when '@'
    reader.next
    List.new [:deref, read_form(reader)]
  when '~@'
    reader.next
    List.new [:'splice-unquote', read_form(reader)]
  when '^'
    reader.next
    meta = read_form(reader)
    List.new [:'with-meta', read_form(reader), meta]
  else
    read_atom(reader)
  end
end

def read_str(str)
  tokens = tokenizer(str)
  read_form(Reader.new(tokens))
end
