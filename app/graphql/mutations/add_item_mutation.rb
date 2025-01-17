
# app/graphql/mutations/add_item_mutation.rb

module Mutations
  class AddItemMutation < Mutations::BaseMutation
    argument :title, String, required: true
    argument :description, String, required: false
    argument :image_url, String, required: false

    field :item, Types::ItemType, null: true
    field :errors, [String], null: false

    def resolve(title:, description: nil, image_url: nil)
      if context[:current_user].nil?
        raise GraphQL::ExecutionError,
              "You need to authenificate to perform this action"
      end

      item = Item.new(
        title: title,
        description: description,
        image_url: image_url,
        user: context[:current_user]
      )

      if item.save
        puts 'whaaaaaat save'
        MartianLibrarySchema.subscriptions.trigger("itemAdded", {}, item)
        { item: item }
      else
        puts 'whaaaaaat'
        Rails.logger.info(items.errors.full_messages)
        { errors: item.errors.full_messages }
      end
    end
  end
end