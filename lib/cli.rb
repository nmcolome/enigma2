module Cli
  def cli(args)
    @input = File.open(args[0], 'r')
    @output = File.open(args[1], 'w')
    @key = args[2]
    @date = args[3]
  end

  def close
    @input.close
    @output.close
  end

  def feedback(name, key, date, type = 'regular')
    if type == 'regular'
      "Created '#{name}' with the key #{key} and date #{date}"
    elsif type == 'crack'
      "Created '#{name}' with the cracked key #{key} and date #{date}"
    end
  end
end
