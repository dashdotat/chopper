module Chopper
  class PollerConfig < Sequel::Model
    one_to_many :stomp_messages
  end
end
