// parameter는 bicep 바깥에서 들어오는 입력
param name string // 값이 반드시 필요. 없으면 에러
param env string = 'dev' // default 값 설정
param loc string = 'krc'

// variable은 bicep 안에서 사용되는 변수
var rg = 'rg-${name}-${env}-${loc}'
