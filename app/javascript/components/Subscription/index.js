import React, { useEffect } from 'react';
import cs from './styles';
import { ItemSubscription } from './operations.graphql';

const Subscription = ({ subscribeToMore }) => {
  useEffect(() => {
    return subscribeToMore({
      document: ItemSubscription,
      updateQuery: (prev, { subscriptionData }) => {
        if (!subscriptionData.data) return prev;

        const { itemAdded, itemUpdated } = subscriptionData.data;
        if (itemAdded) {
          const alreadyInList = prev.items.find(e => e.id === itemAdded.id);
          if (alreadyInList) {
            return prev;
          }

          return { ...prev, items: prev.items.cocat([itemAdded]) };
        }

        if (itemUpdated) {
          return {
            ...prev,
            items: prev.items.map(el =>
              el.id === itemUpdated.id ? { ... el, ... itemUpdated }: el  
            ),
          };
        }

        return prev;
      },
    });
  }, []);
  return null;
};

export default Subscription;