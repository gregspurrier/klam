require 'stringio'
require 'klam'

module EvalKl
  def read_kl(str)
    stream = StringIO.new(str)
    reader = Klam::Reader.new(stream)
    reader.next
  end

  def eval_kl(str)
    form = read_kl(str)
    @env.__send__(:"eval-kl", form)
  end

  def expect_kl(str)
    expect(eval_kl(str))
  end
end

RSpec.configure do |cfg|
  # Support eval_kl and friends in functional specs
  cfg.include EvalKl, :type => :functional
  cfg.before(:each, :type => :functional) do
    @env = Klam::Environment.new
  end
end
