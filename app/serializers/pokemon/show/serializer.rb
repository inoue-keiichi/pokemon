class Pokemon::Show::Serializer < Panko::Serializer
  attributes :id, :name, :types, :status, :sprites, :flavor_text, :moves, :version_group, :damage_from
end
