begin
  require 'awesome_print'
  AwesomePrint.pry!
  Pry.config.print = proc { |output, value| output.puts value.ai }
rescue LoadError => err
end
