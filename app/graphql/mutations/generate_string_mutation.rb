
# app/graphql/mutations/update_item_mutation.rb

module Mutations
  class GenerateStringMutation < Mutations::BaseMutation
    field :random_type, Types::RandomType, null: false

    def resolve
      random_type = { title: Random.rand.to_s }
      MartianLibrarySchema.subscriptions.trigger("generateString", {}, random_type)
    end
  end
end