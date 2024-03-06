# frozen_string_literal: true

class FindMainVersionGroup
  version_group_hash_list = JSON.load_file('pokemon_data/version_group_list.json')
  VERSION_GROUP_LIST = version_group_hash_list.map{ |vg| VersionGroup.new(name: vg['name'], regions: vg['regions'], pokedexes: vg['pokedexes'], versions: vg['versions']) }
  ADDITIONAL_VERSION_GROUP_HASH = {
    'sword-shield': ['the-isle-of-armor', 'the-crown-tundra'],
    'scarlet-violet': ['the-teal-mask', 'the-indigo-disk']
  }.freeze

  class Output
    attr_accessor :name, :regions, :pokedexes, :versions, :additional_version_groups

    def initialize(name:, regions:, pokedexes:, versions:, additional_version_groups:)
      @name = name
      @regions = regions
      @pokedexes = pokedexes
      @additional_version_groups = additional_version_groups
      @versions = versions
    end
  end

  def execute(name:)
    return nil if ADDITIONAL_VERSION_GROUP_HASH.values.flatten.include?(name)

    main_version_group = VERSION_GROUP_LIST.find{ |vg| vg.name == name }
    return nil if main_version_group.nil?

    additional_version_groups = ADDITIONAL_VERSION_GROUP_HASH[name]&.map{ |v_name|  VERSION_GROUP_LIST.find{ |vg| vg.name == v_name } } || []

    Output.new(name: main_version_group.name,
               regions: main_version_group.regions,
               pokedexes: main_version_group.pokedexes,
               versions: main_version_group.versions,
               additional_version_groups: additional_version_groups)
  end
end
