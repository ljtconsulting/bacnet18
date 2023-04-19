<%@ page import="com.controlj.green.addonsupport.bacnet.object.CommonPropertyDefinitions" %>

<%@ page import="com.controlj.green.addonsupport.bacnet.*" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.property.BACnetPropertyIdentifiers" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.property.PropertyIdentifier" %>
<%@ page import="org.jetbrains.annotations.NotNull" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.property.BACnetPropertyTypes" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.property.PropertyDefinition" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.data.*" %>
<%--
  ~ Copyright (c) 2023 Automated Logic Corporation
  ~
  ~ Permission is hereby granted, free of charge, to any person obtaining a copy
  ~ of this software and associated documentation files (the "Software"), to deal
  ~ in the Software without restriction, including without limitation the rights
  ~ to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  ~ copies of the Software, and to permit persons to whom the Software is
  ~ furnished to do so, subject to the following conditions:
  ~
  ~ The above copyright notice and this permission notice shall be included in
  ~ all copies or substantial portions of the Software.
  ~
  ~ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  ~ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  ~ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  ~ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  ~ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  ~ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  ~ THE SOFTWARE.
  --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div>Device page</div>
<%
    PropertyDefinition< BACnetString > firmwareRevision = BACnetPropertyTypes.createDefinition(BACnetPropertyTypes.string, BACnetPropertyIdentifiers.firmwareRevision);

    int objIdNum = Integer.parseInt(request.getParameter("id"));
    int devInstanceNum = Integer.parseInt(request.getParameter("devid"));

    String errorMessage = "";
    String nameValue = "error";
    String firmwareRevisionStr = "error";
    String propertyListAll = "error";
	String propertyList1 = "error";
    int propertyListSize_rpm = -1;

    try
    {
        BACnetConnection conn = BACnet.getBACnet().getDefaultConnection();
        BACnetAccess bacnet = conn.getAccess();

        BACnetDevice device = bacnet.lookupDevice(devInstanceNum).get();
        BACnetObjectIdentifier objId = new BACnetObjectIdentifier(objIdNum);
        ReadPropertiesResult resultAll = device.readProperties(objId,
                CommonPropertyDefinitions.objectName, firmwareRevision;

        nameValue = resultAll.getValue(objId, CommonPropertyDefinitions.objectName).getValue();
        firmwareRevisionStr = resultAll.getValue(objId, firmwareRevision).getValue();

        try
        {
           ReadResult<BACnetArray<BACnetPropertyIdentifier>> result = device.readProperty(objId, CommonPropertyDefinitions.propertyList);
           propertyListAll = result.get().toString();

           final BACnetPropertyIdentifier resultProperty = resultAll.getValue( objId, CommonPropertyDefinitions.propertyList ).get( 0 );
           if ( resultProperty.getIdentifierNumber() > BACnetPropertyIdentifiers.values().length )
           {
                PropertyIdentifier property = new PropertyIdentifier()
                {
                    @Override
                    public int getId()
                    {
                        return resultProperty.getIdentifierNumber();
                    }

                    @NotNull
                    @Override
                    public String getName()
                    {
                        return "UNKNOWN:" + getId();
                    }
                };
                propertyList1 = property.getName();
           } else
                propertyList1 = resultProperty.getIdentifier().getName();

           propertyListSize_rpm = resultAll.getValue( objId, CommonPropertyDefinitions.propertyList ).size();
        }
        catch (BACnetException e)
        {
           propertyListAll = "The Property_List property is not supported in this device.";
        }
    }
    catch (Exception e)
    {
        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter( sw ) );
        errorMessage = sw.toString();

    }

%>

<table>
    <tr>
        <td>Error Message:</td>
        <td><%= errorMessage %></td>
    </tr>
    <tr>
        <td>Name:</td>
        <td><%= nameValue %></td>
    </tr>
    <tr>
        <td>Firmware Revision:</td>
        <td><%= firmwareRevisionStr %></td>
    </tr>
    <tr>
        <td>Property List:</td>
        <td><%= propertyListAll %></td>
    </tr>
    <tr>
        <td>Property List[1]:</td>
        <td><%= propertyList1 %></td>
    </tr>
    <tr>
        <td>Property List Size:</td>
        <td><%= propertyListSize_rpm %></td>
    </tr>
</table>
