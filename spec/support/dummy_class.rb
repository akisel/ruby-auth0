class DummyClass
  attr_reader :domain

  def initialize
    @domain = 'test.auth0.com'
  end

  %w(get post put patch delete).map(&:to_sym).each do |method|
    define_method(method) do |_path, _body = {}|
      true
    end
  end
end
