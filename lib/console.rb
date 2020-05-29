class Console
  attr_reader :input, :output

  def initialize(input={})
    @input = input.fetch(:input, $stdin)
    @output = input.fetch(:output, $stdout)
  end

  public

  def read
    input.gets.chomp
  end

  def write(string)
    output.puts(string)
  end

  def prompt(string)
    write(string)
    read
  end
end