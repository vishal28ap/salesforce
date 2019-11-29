@isTest
global class ProjectCalloutServiceMock implements HttpCalloutMock{
   //Implement http mock callout here
    global HTTPResponse respond(HTTPRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(201);
        return response; 
    }
}