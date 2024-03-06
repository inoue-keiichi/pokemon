# frozen_string_literal: true

require_relative 'clazz/pokemon_list_fetcher'
require_relative 'clazz/version_group_list_fetcher'

PokemonListFetcher.execute(
  ['lets-go-pikachu-lets-go-eevee',
   'heartgold-soulsilver',
   'sword-shield',
   'scarlet-violet']
)
VersionGroupListFetcher.execute(
  [
    'lets-go-pikachu-lets-go-eevee',
    'heartgold-soulsilver',
    'sword-shield',
    'the-isle-of-armor',
    'the-crown-tundra',
    'scarlet-violet',
    'the-teal-mask',
    'the-indigo-disk'
  ]
)
