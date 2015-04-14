Sequel.migration do
  up do
    create_table(:poller_configs) do
      primary_key :id
      String :topic_name, :null => false, :unique => true
      TrueClass :enabled, :null => false, :default => false
      String :message_processor_class, :null => false
    end
  end

  down do
    drop_table(:poller_configs)
  end
end
