// parameter는 bicep 바깥에서 들어오는 입력
param name string // 값이 반드시 필요. 없으면 에러
param env string = 'dev' // default 값 설정
param loc string = 'krc'

// variable은 bicep 안에서 사용되는 변수
// param과 variable의 순서는 상관이 없다.
var rg = 'rg-${name}-${env}-${loc}'

// 다른 bicep 파일에서 참조 가능하게 함. 모듈화할 때 사용.
output rn string = rg
