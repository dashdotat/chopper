module Chopper
  class StompMessage < Sequel::Model
    many_to_one :poller_config
  end
end
