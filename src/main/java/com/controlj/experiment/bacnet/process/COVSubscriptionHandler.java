package com.controlj.experiment.bacnet.process;

import com.controlj.green.addonsupport.bacnet.data.BACnetCOVSubscription;
import com.controlj.green.addonsupport.bacnet.data.BACnetList;
import com.controlj.green.addonsupport.bacnet.data.BACnetObjectPropertyReference;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class COVSubscriptionHandler
{
   private final BACnetList<BACnetCOVSubscription> covSubscriptions;

   public COVSubscriptionHandler( BACnetList<BACnetCOVSubscription> covSubscriptions )
   {
      this.covSubscriptions = covSubscriptions;
   }


   public List<String> getDisplayListOfSubscriptions()
   {
      List<String> subscriptionsString = new ArrayList<>();

      subscriptionsString = covSubscriptions.stream()
                    .map( opr -> opr.getPropertyReference().getObjectIdentifier().getObjectIdAsString() + " => "+opr.getPropertyReference().getPropertyIdentifier().getIdentifierNumber() )
                    .collect( Collectors.toList());
      return subscriptionsString;
   }

   public List< BACnetObjectPropertyReference > getListOfObjectsReferenced()
   {
      List< BACnetObjectPropertyReference > objectPropertyReferences = new ArrayList<>();
      for ( BACnetCOVSubscription covSubscription : covSubscriptions )
      {
         BACnetObjectPropertyReference opRef = covSubscription.getPropertyReference();
         objectPropertyReferences.add( opRef );
      }
      return objectPropertyReferences;
   }
}
