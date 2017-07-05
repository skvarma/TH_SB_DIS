@isTest
public class BillingCalloutServiceMock implements WebServiceMock{
   //Implement http mock callout here
    public void doInvoke(Object stub, Object soapRequest, Map<String,Object> responseMap, String endpoint, String soapAction, String requestName, String responseNamespace, String responseName, String responseType){
        BillingServiceProxy.billProjectResponse_element response_x = new BillingServiceProxy.billProjectResponse_element();
        response_x.status = 'ok';
        responseMap.put('response_x',response_x);
    }

}