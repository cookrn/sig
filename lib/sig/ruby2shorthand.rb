require 'ruby2ruby'

class Ruby2Shorthand < Ruby2Ruby
  # OVERRIDE
  # * Remove unwanted spaces
  def process_arglist(exp) # custom made node
    code = []
    until exp.empty? do
      code << process(exp.shift)
    end
    # CUSTOM
    code.join ','
  end

  # OVERRIDE
  # * customize lambda incantation to `->`
  # * remove parens around single arg function calls
  # * remove parens around binary function calls
  # * use [] syntax 
  def process_call(exp)
    receiver_node_type = exp.first.nil? ? nil : exp.first.first
    receiver = process exp.shift
    receiver = "(#{receiver})" if ASSIGN_NODES.include? receiver_node_type

    name = exp.shift
    args = []

    # this allows us to do both old and new sexp forms:
    exp.push(*exp.pop[1..-1]) if exp.size == 1 && exp.first.first == :arglist

    @calls.push name

    in_context :arglist do
      until exp.empty? do
        arg_type = exp.first.sexp_type
        is_empty_hash = (exp.first == s(:hash))
        arg = process exp.shift

        next if arg.empty?

        strip_hash = (arg_type == :hash and
                      not BINARY.include? name and
                      not is_empty_hash and
                      (exp.empty? or exp.first.sexp_type == :splat))
        wrap_arg = Ruby2Ruby::ASSIGN_NODES.include? arg_type

        arg = arg[2..-3] if strip_hash
        arg = "(#{arg})" if wrap_arg

        args << arg
      end
    end

    case name
    when *BINARY then
      # CUSTOM
      "#{receiver}#{name}#{args.join(', ')}"
    when :[] then
      receiver ||= "self"
      "#{receiver}[#{args.join(', ')}]"
    when :[]= then
      receiver ||= "self"
      rhs = args.pop
      "#{receiver}[#{args.join(', ')}] = #{rhs}"
    when :"-@" then
      "-#{receiver}"
    when :"+@" then
      "+#{receiver}"
    # CUSTOM
    when :lambda then
      '->'
    # CUSTOM
    when :call then
      args = if args.empty?
               nil
             elsif args
               args.join(',')
             end

      "#{receiver}[#{args}]"
    else
      args = nil if args.empty?

      # CUSTOM
      args = if args and args.size == 1
               # It's safe to map a single arg to be spaced from
               # the receiver w/out parens in this context
               " #{ args.first }"
             elsif args
               "(#{args.join(', ')})"
             end

      receiver = "#{receiver}." if receiver

      "#{receiver}#{name}#{args}"
    end
  ensure
    @calls.pop
  end

  # OVERRIDE
  # * remove spaces around =>
  # * remove spaces around ,
  # * remove spaces inside {}
  def process_hash(exp)
    result = []

    until exp.empty?
      lhs = process(exp.shift)
      rhs = exp.shift
      t = rhs.first
      rhs = process rhs
      rhs = "(#{rhs})" unless [:lit, :str].include? t # TODO: verify better!

      result << "#{lhs}=>#{rhs}"
    end

    return result.empty? ? "{}" : "{#{result.join(',')}}"
  end

  # OVERRIDE
  # * customize lambda incantation
  def process_iter(exp)
    if exp.first.last == :lambda
      process_lambda_iter exp
    else
      process_regular_iter exp
    end
  end

  # Custom renders:
  # * place args in ()s before {}s
  # * render nothing for empty args
  def process_lambda_iter(exp)
    iter = process exp.shift
    args = exp.shift
    body = exp.empty? ? nil : process(exp.shift)

    args = case args
           when 0 then
             # CUSTOM
             ''
           else
             a = process(args)[1..-2]
             a = "(#{a})" unless a.empty?
             a
           end

    b, e = if iter == "END" then
             [ "{", "}" ]
           else
             [ "do", "end" ]
           end

    iter.sub!(/\(\)$/, '')

    # REFACTOR: ugh
    result = []
    # CUSTOM
    result << "#{iter}#{args}{"
    if body then
      # CUSTOM
      result << body.strip
    else
      # CUSTOM
      result << ''
    end
    result << "}"
    result = result.join
    return result if result !~ /\n/ and result.size < LINE_LENGTH

    result = []
    result << "#{iter} #{b}"
    result << args
    result << "\n"
    if body then
      result << indent(body.strip)
      result << "\n"
    end
    result << e
    result.join
  end

  # OVERRIDE
  # * remove unwanted spaces
  def process_lasgn(exp)
    s = "#{exp.shift}"
    s += "=#{process exp.shift}" unless exp.empty?
    s
  end

  # OVERRIDE
  # * remove spaces around arglists
  # * remove spaces around body
  def process_regular_iter(exp)
    iter = process exp.shift
    args = exp.shift
    body = exp.empty? ? nil : process(exp.shift)

    args = case args
           when 0 then
             ' ||'
           else
             a = process(args)[1..-2]
             a = "|#{a}|" unless a.empty?
             a
           end

    b, e = if iter == "END" then
             [ "{", "}" ]
           else
             [ "do", "end" ]
           end

    iter.sub!(/\(\)$/, '')

    # REFACTOR: ugh
    result = []
    # CUSTOM
    result << "#{iter}{"
    result << args
    if body then
      # CUSTOM
      result << body.strip
    else
      # CUSTOM
      result << ''
    end
    result << "}"
    result = result.join
    return result if result !~ /\n/ and result.size < LINE_LENGTH

    result = []
    result << "#{iter} #{b}"
    result << args
    result << "\n"
    if body then
      result << indent(body.strip)
      result << "\n"
    end
    result << e
    result.join
  end
end
