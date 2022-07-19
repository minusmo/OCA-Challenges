using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Microsoft.Azure.WebJobs.Extensions.OpenApi;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Enums;
using Microsoft.OpenApi.Models;
using System.Net;

namespace OCAProject
{
    public class PingHttpTrigger
    {
        private readonly IMyService _service;
        public PingHttpTrigger(IMyService service) {
            this._service = service ?? throw new ArgumentNullException(nameof(service));
        }

        [FunctionName(nameof(PingHttpTrigger))]
        
        // open api operations
        [OpenApiOperation(operationId: "Ping", tags: new[] { "greeting" })] // open api에 등록
        [OpenApiSecurity(schemeName: "function_key", schemeType: SecuritySchemeType.ApiKey, Name = "x-functions-key", In = OpenApiSecurityLocationType.Header)]
        [OpenApiParameter(name: "name", In = ParameterLocation.Query, Required = true, Description = "Name of the person")]
        [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "application/json", bodyType: typeof(ResponseMessage), Description = "response description")]

        public IActionResult Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = "ping")] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string name = req.Query["name"];
            // 비즈니스 로직을 바깥으로 옮겼음.
            var result = this._service.GetMessage(name);

            var res = new ResponseMessage() { Message = result };

            return new OkObjectResult(res);
        }
    }

    public class ResponseMessage {
        [JsonProperty("response_message")] // Json 응답 객체의 key 를 변경. 기본적으로는 파스칼 케이싱을 캐멀 케이싱으로 변환.
        public string Message { get; set; }
    }

    public interface IMyService {
        string GetMessage(string name);
    }

    public class MyService : IMyService {
        public string GetMessage(string name) {
            string responseMessage = string.IsNullOrEmpty(name)
                ? "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."
                : $"Hello, {name}. This HTTP triggered function executed successfully.";

            return responseMessage;
        }
    }
}
