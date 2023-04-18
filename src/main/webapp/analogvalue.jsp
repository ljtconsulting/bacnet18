<%@ page import="com.controlj.green.addonsupport.bacnet.data.BACnetObjectIdentifier" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.*" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.object.CommonPropertyDefinitions" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.Objects" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.data.BACnetUnsigned" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.object.AnalogPropertyDefinitions" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.data.BACnetReal" %>
<%@ page import="com.controlj.experiment.bacnet.definitions.DeviceObjectDefinition" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.data.BACnetDeviceObjectPropertyReference" %>
<%--
  ~ Copyright (c) 2010 Automated Logic Corporation
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
<div>Analog Value page</div>
<%
    int objIdNum = Integer.parseInt(request.getParameter("id"));
    int devInstanceNum = Integer.parseInt(request.getParameter("devid"));

    BACnetObjectIdentifier objId = null;
    ReadPropertiesResult result1 = null;
    ReadResult< BACnetReal > result3 = null;

    String errorMessage = "";
    String property21 = "error";
    String property22 = "error";
    int propertyListSize = -1;
    float presentValue = 0.0f;
    int protocolRevision = 12;  // default to lower

    try
    {
        BACnetConnection conn = BACnet.getBACnet().getDefaultConnection();
        BACnetAccess bacnet = conn.getAccess();

        BACnetDevice device = bacnet.lookupDevice(devInstanceNum).get();
        objId = new BACnetObjectIdentifier(objIdNum);
        protocolRevision = device.readProperty(device.getDeviceIdentifier(), DeviceObjectDefinition.protocolRevision ).get().asInt();

        if ( protocolRevision > 18 )
        {
            // New for 1.10
            // Read just element 1 and 2 of the propertyList array
            result1 = device.readProperties( objId,
                    CommonPropertyDefinitions.propertyList.element( 1 ),
                    CommonPropertyDefinitions.propertyList.element( 2 ),
                    CommonPropertyDefinitions.propertyList.size() ).get();
            property21 = result1.getValue(objId, CommonPropertyDefinitions.propertyList.element( 1 )).getIdentifier().getName();
            property22 = result1.getValue(objId, CommonPropertyDefinitions.propertyList.element(2)).getIdentifier().getName();
            propertyListSize = result1.getValue(objId, CommonPropertyDefinitions.propertyList.size()).asInt();
        }

        result3 = device.readProperty( objId, AnalogPropertyDefinitions.presentValue );
        presentValue = result3.get().getValue();
    }
    catch ( Exception e )
    {
        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter( sw ) );
        errorMessage = sw.toString();
    }
%>
<table>
    <tr><td><%= errorMessage %></td></tr>
    <tr><td>Protocol Revision:</td><td><%= protocolRevision %></td></tr>
    <% if ( protocolRevision > 18 )  { %>
    <tr>
        <td>Property List [1]:</td>
        <td><%= property21  %></td>
    </tr>
    <tr>
        <td>Property List [2]:</td>
        <td><%= property22  %></td>
    </tr>
    <tr>
        <td>Property List Size:</td>
        <td><%= propertyListSize %></td>
    </tr>
    <% } %>
    <tr>
        <td>Present Value:</td>
        <td><%= presentValue %></td>
    </tr>
</table>