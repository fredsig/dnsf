class DNSf

  attr_reader :options

  INTERFACES = [
    [:udp, "0.0.0.0", 5300]
  ]

  IN = Resolv::DNS::Resource::IN
  UPSTREAM = RubyDNS::Resolver.new([[:udp, "8.8.8.8", 53], [:tcp, "8.8.8.8", 53]])

  def initialize(options)
    @options = options
  end

  def run!
    RubyDNS::run_server(:listen => INTERFACES) do
      time = Time.new
      if time.hour.between?(0, 18) || time.hour.between?(21, 23)
        match(/youtube/, IN::A) do |transaction|
          transaction.respond!("127.0.0.1")
        end
      end
      otherwise do |transaction|
        transaction.passthrough!(UPSTREAM)
      end
    end
  end

end
