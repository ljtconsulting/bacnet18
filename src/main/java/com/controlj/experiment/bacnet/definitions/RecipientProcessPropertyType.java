package com.controlj.experiment.bacnet.definitions;

import com.controlj.green.addonsupport.bacnet.data.BACnetRecipient;
import com.controlj.green.addonsupport.bacnet.data.BACnetRecipientProcess;
import com.controlj.green.addonsupport.bacnet.data.BACnetUnsigned;
import com.controlj.green.addonsupport.bacnet.property.*;
import org.jetbrains.annotations.NotNull;

public class RecipientProcessPropertyType implements PropertyType<BACnetRecipientProcess>
{
   public static PropertyType< BACnetRecipientProcess > instance = new RecipientProcessPropertyType();

   private RecipientProcessPropertyType() {
   }

   @NotNull
   @Override
   public BACnetRecipientProcess decode(@NotNull Decoder decoder) throws EncodeDecodeException
   {
      BACnetRecipient recipient = decoder.forContext( 0 ).decode( BACnetPropertyTypes.recipient);
      BACnetUnsigned processIdentifier = decoder.forContext(1).decode(BACnetPropertyTypes.unsigned);
      return new BACnetRecipientProcess( recipient, processIdentifier );
   }

   @Override
   public void encode( @NotNull Encoder encoder, @NotNull BACnetRecipientProcess value) throws EncodeDecodeException
   {
      encoder.forContext(0).encode( BACnetPropertyTypes.recipient, value.getRecipient());
      encoder.forContext(1).encode(BACnetPropertyTypes.unsigned, value.getProcessId());
   }
}
