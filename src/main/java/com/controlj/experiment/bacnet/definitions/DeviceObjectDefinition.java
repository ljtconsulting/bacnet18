package com.controlj.experiment.bacnet.definitions;

import com.controlj.green.addonsupport.bacnet.data.BACnetObjectIdentifier;
import com.controlj.green.addonsupport.bacnet.data.BACnetObjectType;
import com.controlj.green.addonsupport.bacnet.data.BACnetString;
import com.controlj.green.addonsupport.bacnet.data.BACnetUnsigned;
import com.controlj.green.addonsupport.bacnet.object.BACnetObjectTypes;
import com.controlj.green.addonsupport.bacnet.object.ObjectType;
import com.controlj.green.addonsupport.bacnet.property.BACnetPropertyIdentifiers;
import com.controlj.green.addonsupport.bacnet.property.BACnetPropertyTypes;
import com.controlj.green.addonsupport.bacnet.property.PropertyDefinition;
import org.jetbrains.annotations.NotNull;

import static com.controlj.green.addonsupport.bacnet.property.BACnetPropertyTypes.createDefinition;

public class DeviceObjectDefinition
{
   /**<!----- objectIdentifier ----------------------------------------------->
    The ObjectType for this definition, e.g. {@link BACnetObjectTypes#schedule}.
    <!----------------------------------------------------------------------->*/
   @NotNull public static final ObjectType type = BACnetObjectTypes.schedule;

   /**<!----- objectIdentifier ----------------------------------------------->
    Defines the Object_Identifier property for the Schedule Object Type.
    <!----------------------------------------------------------------------->*/
   @NotNull public static final PropertyDefinition< BACnetObjectIdentifier > objectIdentifier =
         createDefinition( BACnetPropertyTypes.objectIdentifier, BACnetPropertyIdentifiers.objectIdentifier);

   /**<!----- objectName ----------------------------------------------------->
    Defines the Object_Name property for the Schedule Object Type.
    <!----------------------------------------------------------------------->*/
   @NotNull public static final PropertyDefinition< BACnetString > objectName =
         createDefinition(BACnetPropertyTypes.string, BACnetPropertyIdentifiers.objectName);

   /**<!----- objectType ----------------------------------------------------->
    Defines the Object_Type property for the Schedule Object Type.
    <!----------------------------------------------------------------------->*/
   @NotNull public static final PropertyDefinition< BACnetObjectType > objectType =
         createDefinition(BACnetPropertyTypes.objectType, BACnetPropertyIdentifiers.objectType);

   @NotNull public static final PropertyDefinition< BACnetString > firmwareRevision =
         createDefinition(BACnetPropertyTypes.string, BACnetPropertyIdentifiers.firmwareRevision);

   @NotNull public static final PropertyDefinition< BACnetUnsigned > protocolRevision =
         createDefinition(BACnetPropertyTypes.unsigned, BACnetPropertyIdentifiers.protocolRevision);
}
