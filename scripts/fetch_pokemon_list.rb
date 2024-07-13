# frozen_string_literal: true

require_relative 'clazz/pokemon_list_fetcher'
require_relative 'clazz/version_group_list_fetcher'

PokemonListFetcher.execute(
  ['letsgo-kanto', 'updated-johto', 'galar', 'isle-of-armor', 'crown-tundra', 'paldea', 'kitakami', 'blueberry']
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
