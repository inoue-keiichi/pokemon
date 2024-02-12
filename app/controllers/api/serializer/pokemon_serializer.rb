class Api::Serializer::PokemonSerializer < Panko::Serializer
  attributes :id, :name, :types, :sprites, :flavor_text

  def name
    I18n.t("pokemon.#{object.name}")
  end

  def types
    object.types.map { |type| {slot: type.slot, name: I18n.t("type.#{type.type.name}"), url: type.type.url} }
  end

  def flavor_text
    object.flavor_text_entries.find{ |entry| entry.language.name == 'ja' && entry.version.name == 'lets-go-pikachu' }&.flavor_text || object.flavor_text_entries.find do |entry|
      entry.language.name == 'ja'
    end
  end
end
