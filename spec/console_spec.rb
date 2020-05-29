require "./lib/console.rb"

describe Console do
  context "#initialize" do
    it "Does not raise an exception when initialized with an empty {}" do
      expect{ Console.new }.not_to raise_error(KeyError)
    end

    it "By default has input set to $stdin" do
      console = Console.new
      expect(console.input).to eql($stdin)
    end

    it "By default has output set to $stdout" do
      console = Console.new
      expect(console.output).to eql($stdout)
    end

    it "Input can be initialized with a StringIO object" do
      console = Console.new( {:input => StringIO.new } )
      expect(console.input).to be_a(StringIO)
    end

    it "Output can be initialized with a StringIO object" do
      console = Console.new( {:output => StringIO.new } )
      expect(console.output).to be_a(StringIO)
    end
  end

  context "#write" do
    it "Writes a string to output" do
      console = Console.new( {:output => StringIO.new} )
      message = "Hello\n"
      console.write(message)
      expect(console.output.string).to eql(message)
    end
  end

  context "#read" do
    it "Reads the input and removes the new line character" do
      console = Console.new( {:input => StringIO.new("29\n")} )
      expect(console.read).to eql("29")
    end
  end

  context "#prompt" do
    it "Writes a prompt message to output" do
      console = Console.new( {:input => StringIO.new("29\n"), :output => StringIO.new} )
      message = "Enter your age.\n"
      console.prompt(message)
      expect(console.output.string).to eql(message)
    end

    it "Returns the input" do
      console = Console.new( {:input => StringIO.new("29\n"), :output => StringIO.new} )
      message = "Enter your age.\n"
      expect(console.prompt(message)).to eql("29")
    end
  end
end