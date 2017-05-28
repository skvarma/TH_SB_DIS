@isTest
public class ProjectCalloutServiceMockFailure implements HttpCalloutMock{

   public static HttpResponse respond(HttpRequest httpRequest) {
      HttpResponse httpResponse = new HttpResponse();
      httpResponse.setStatusCode(500);
      httpResponse.setStatus('Failure');
      return httpResponse;
   }

}