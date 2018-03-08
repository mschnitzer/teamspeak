FactoryBot.define do
  factory :server, class: TeamSpeak3::Server do
    ip_address '127.0.0.1'
    query_port 10011

    initialize_with { new(ip_address, query_port) }
  end
end
