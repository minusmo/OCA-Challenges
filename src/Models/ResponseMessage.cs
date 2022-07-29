using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace OCAProject.Models
{
    public class ResponseMessage {
        [JsonProperty("response_message")] // Json 응답 객체의 key 를 변경. 기본적으로는 파스칼 케이싱을 캐멀 케이싱으로 변환.
        public string Message { get; set; }
    }
}