Sequel.migration do
  up do
    create_table(:stomp_messages) do
      primary_key :id
      TrueClass :processed, :null => false, :default => false
      TrueClass :archived, :null => false, :default => false
      DateTime :timestamp, :null => false
      String :message, :text => true, :null => false
      foreign_key :poller_config_id, :poller_configs
    end
  end

  down do
    drop_table(:stomp_messages)
  end
end
