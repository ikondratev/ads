Sequel.migration do
  up do
    create_table(:ads) do
      primary_key :id
      String :title, null: false
      String :description, null: false
      String :city, null: false
      Float :lat, null: true
      Float :lon, null: true
      Bignum :user_id, null: false
      DateTime :created_at, null: false
      DateTime :updatede_at, null: false
    end
  end

  down do
    drop_table(:ads)
  end
end