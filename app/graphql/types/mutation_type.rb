module Types
  class MutationType < Types::BaseObject
    field :sign_in, mutation: Mutations::SignInMutation
    field :add_item, mutation: Mutations::AddItemMutation
    field :update_item, mutation: Mutations::UpdateItemMutation
    field :generate_string, mutation: Mutations::GenerateStringMutation
  end
end
