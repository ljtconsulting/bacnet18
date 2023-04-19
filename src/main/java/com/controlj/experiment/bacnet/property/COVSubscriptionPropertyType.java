package com.controlj.experiment.bacnet.property;

import com.controlj.green.addonsupport.bacnet.data.*;
import com.controlj.green.addonsupport.bacnet.property.*;
import org.jetbrains.annotations.NotNull;

import java.util.concurrent.atomic.AtomicReference;

public class COVSubscriptionPropertyType implements PropertyType< BACnetCOVSubscription >
{
   public static PropertyType<BACnetCOVSubscription> instance = new COVSubscriptionPropertyType();

   private COVSubscriptionPropertyType() {
   }

   @NotNull
   @Override
   public BACnetCOVSubscription decode(@NotNull Decoder decoder) throws EncodeDecodeException
   {
      BACnetRecipientProcess bacnetRecipientProcess = decoder.forContext(0).decode( RecipientProcessPropertyType.instance);
      BACnetObjectPropertyReference propertyReference = decoder.forContext(1).decode(BACnetPropertyTypes.objectPropertyReference);
      BACnetBoolean confirmed = decoder.forContext(2).decode(BACnetPropertyTypes.bool);
      BACnetUnsigned expirationSecs = decoder.forContext(3).decode(BACnetPropertyTypes.unsigned);
      BACnetReal covIncrement = new BACnetReal(0.1f);
      if ( decoder.getChoiceContext() == 4 )
         covIncrement = decoder.forContext(4).decode(BACnetPropertyTypes.real);

      BACnetCOVSubscription covSubscription = new BACnetCOVSubscription( bacnetRecipientProcess, propertyReference, expirationSecs, confirmed, covIncrement );
      return covSubscription;
   }

   @Override
   public void encode( @NotNull Encoder encoder, @NotNull BACnetCOVSubscription value) throws EncodeDecodeException
   {
      AtomicReference< EncodeDecodeException > exception = new AtomicReference<>();

      encoder.forContext(0).encode(RecipientProcessPropertyType.instance, value.getBacnetRecipientProcess());
      encoder.forContext(1).encode( BACnetPropertyTypes.objectPropertyReference, value.getPropertyReference());
      encoder.forContext(2).encode(BACnetPropertyTypes.bool, value.getConfirmed());
      encoder.forContext(3).encode(BACnetPropertyTypes.unsigned, value.getExpirationTimeInSecs());
      value.getCovIncrement().ifPresent( v -> {
         try
         {
            encoder.forContext(4).encode(BACnetPropertyTypes.real, v);
         }
         catch ( EncodeDecodeException e )
         {
            exception.set( e );
         }
      } );
      if ( exception.get() != null )
         throw exception.get();
   }
}
