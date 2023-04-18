<%@ page import="com.controlj.experiment.bacnet.definitions.AnalogInputDefinition" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.data.BACnetObjectIdentifier" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.*" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.controlj.green.addonsupport.bacnet.object.BinaryPropertyDefinitions" %>
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
<div>Binary Input page</div>
<%
    int objIdNum = Integer.parseInt(request.getParameter("id"));
    int devInstanceNum = Integer.parseInt(request.getParameter("devid"));

    BACnetObjectIdentifier objId = null;
    ReadPropertiesResult resultAllArray = null;

    String errorMessage = "";
    String nameValue = "error";
    String presentValue = "error";

    try
    {
        BACnetConnection conn = BACnet.getBACnet().getDefaultConnection();
        BACnetAccess bacnet = conn.getAccess();

        BACnetDevice device = bacnet.lookupDevice(devInstanceNum).get();
        objId = new BACnetObjectIdentifier(objIdNum);

        // Read properties including the entire propertyList array
        resultAllArray = device.readProperties(objId,
                BinaryPropertyDefinitions.objectName, BinaryPropertyDefinitions.presentValue).get();

        nameValue = resultAllArray.getValue(objId, AnalogInputDefinition.objectName).getValue();
        presentValue = String.valueOf(resultAllArray.getValue(objId, BinaryPropertyDefinitions.presentValue).getValue());
    }
    catch ( Exception e )
    {
       StringWriter sw = new StringWriter();
       e.printStackTrace(new PrintWriter( sw ) );
       errorMessage = sw.toString();
    }
%>
<%= errorMessage %>
<table>
    <tr>
        <td>Name:</td>
        <td><%= nameValue %></td>
    </tr>
    <tr>
        <td>Present Value:</td>
        <td><%= presentValue %></td>
    </tr>
</table>
