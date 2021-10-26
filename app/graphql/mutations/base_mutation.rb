module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    def check_authentication!
      if context[:current_user].nil?
        raise GraphQL::ExecutionError,
              "You need to authenificate to perform this action"
      end
    end
  end
end