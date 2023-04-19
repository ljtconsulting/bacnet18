<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.*" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.object.CommonPropertyDefinitions" %>
<%@ page import="com.controlj.experiment.bacnet.definitions.DeviceObjectDefinition" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.data.*" %>
<%@ page import="com.controlj.experiment.bacnet.process.COVSubscriptionHandler" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
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
<%
    int deviceInstance = Integer.parseInt(request.getParameter("id"));
    int deviceIdentifier = Integer.parseInt(request.getParameter("devid"));
%>
<script type="text/javascript">
    function showDevice(id) {
        $('#show_info').html("Testing "+id);
    }
</script>
<div>Device Instance #<%= deviceInstance %></div>
<div>
    <button onclick="new function() { showDevice('<%=deviceInstance%>'); }">Show Info</button>
</div>
<%
    String errorMessage = "";
    String nameValue = "error";
    String firmwareRevisionStr = "error";
    List<String> stringListOfObjects = new ArrayList<>();
    boolean noCOVSupport = false;
    BACnetObjectIdentifier objId = new BACnetObjectIdentifier((short)8, deviceInstance);
    BACnetDevice device = null;

    try
    {
        BACnetConnection conn = BACnet.getBACnet().getDefaultConnection();
        BACnetAccess bacnet = conn.getAccess();

        device = bacnet.lookupDevice(deviceInstance).get();
        ReadPropertiesResult resultAll = device.readProperties(objId,
                CommonPropertyDefinitions.objectName, DeviceObjectDefinition.firmwareRevision).get();

        nameValue = resultAll.getValue(objId, CommonPropertyDefinitions.objectName).getValue();
        firmwareRevisionStr = resultAll.getValue(objId, DeviceObjectDefinition.firmwareRevision).getValue();

        try
        {
            ReadResult< BACnetList< BACnetCOVSubscription > > result = device.readProperty( objId, DeviceObjectDefinition.activeCovSubscriptions );
            BACnetList< BACnetCOVSubscription > bacnetList = result.get();

            COVSubscriptionHandler handler = new COVSubscriptionHandler( bacnetList );
            stringListOfObjects = handler.getDisplayListOfSubscriptions();
        } catch (Exception ex)
        {
            noCOVSupport = true;
        }

    }
    catch (BACnetException e)
    {
        if ( e.getErrorCode() == ErrorCodes.rejectUnrecognizedService && device!=null )
       {
           errorMessage = "Read Property Multiple not supported.";
           ReadResult< BACnetString > result = device.readProperty( objId, DeviceObjectDefinition.objectName );
           nameValue = result.get().getValue();

           ReadResult< BACnetString > result2 = device.readProperty( objId, DeviceObjectDefinition.firmwareRevision );
           firmwareRevisionStr = result2.get().getValue();
       }
       else
          errorMessage = e.getMessage();
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
    <% if ( !noCOVSupport ) { %>
    <tr>
        <td>Active COV Subscriptions Size:</td>
        <td><%= stringListOfObjects.size() %></td>
    </tr>
    <tr>
        <td>Active COV Subscriptions:</td>
        <td><%= stringListOfObjects %></td>
    </tr>
    <% } %>
</table>
