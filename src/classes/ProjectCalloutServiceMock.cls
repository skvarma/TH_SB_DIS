@isTest
public class ProjectCalloutServiceMock implements HttpCalloutMock{
   public static HttpResponse respond(HttpRequest httpRequest){

      HttpResponse httpResponse = new  HttpResponse();
      httpResponse.setStatusCode(201);
      httpResponse.setStatus('Created');
      return httpResponse;
   }
}