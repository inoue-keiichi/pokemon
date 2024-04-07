class Api::Pokemons::Shared::InputForm
  include ActiveModel::Validations
  attr_accessor :id, :version_group

  def initialize(id:, version_group:)
    @id = id
    @version_group = version_group
  end

  validates :id, presence: true
  validates :version_group, inclusion: {
    in: ['lets-go-pikachu-lets-go-eevee',
         'heartgold-soulsilver',
         'sword-shield',
         'scarlet-violet'],
    message: '存在しないか未対応のバージョンです'
  }
end
