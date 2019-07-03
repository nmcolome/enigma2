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

  def user_feedback(name, key, date)
    "Created '#{name}' with the key #{key} and date #{date}"
  end
end