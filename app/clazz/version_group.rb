class VersionGroup
  attr_reader :name, :regions, :pokedexes, :versions

  def initialize(name:, regions:, pokedexes:, versions:)
    @name = name
    @regions = regions
    @pokedexes = pokedexes
    @versions = versions
  end


end
