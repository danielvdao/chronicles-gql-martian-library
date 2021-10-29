# Notes:
# What does transmit do?
# What does subscribed do?
# How does graphQL call #execute?
# What does unsubscribed do?

class GraphqlChannel < ApplicationCable::Channel
  def subscribed
    @subscription_ids = []
  end

  def execute(data)
    result = execute_query(data)

    payload = {
      result: result.subscription? ? { data: nil } : result.to_h,
      more: result.subscription?,
    }

    @subscription_ids << context[:subscription_id] if result.context[:subscription_id]

    transmit(payload)
  end

  def unsubscribed
    @subscription_ids.each do |subscription_id|
      MartianLibrarySchema.subscriptions.delete_subscriptions(subscription_id)
    end
  end

  private

  def execute_query(data)
    MartianLibrarySchema.execute(
      query: data["query"],
      context: context,
      variables: data["variables"],
      operation_name: data["operationName"],
    )
  end

  def context
    {
      current_user_id: current_user&.id,
      current_user: current_user,
      channel: self,
    }
  end
end
