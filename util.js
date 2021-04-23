/**
 * 여러가지 Utility 함수
 */
 
 //날짜 객체를 날짜 문자열로 표시하는 함수-dateToStr(date,sep)-yyyy.mm.dd
 function dateToDateStr(date,sep){
	//sep 년월일을 구분하는 문자
	if(!sep)sep = ".";
	//반드시 date 객체
	var yy = date.getFullYear();
	var mm = date.getMonth() + 1; // month : 0~11
	var dd = date.getDate(); 
	return yy + sep + addNumZero(mm) + sep + addNumZero(dd);
}

 //날짜 객체를 시간 문자열로 표시하는 함수-dateToTimeStr(date,sep)-yyyy.mm.dd
 function dateToTimeStr(date){
	
	//날짜를 확인해서 숫자는 나오지만 ~~000 시간 정보가 포함되어 있지 않음
	//Oracle DB-> select to_char(writeDate,'hh-mi-ss') from board reply
	//JAVA 코드 확인 return service.list(); -> list=service.list();sys(list); return list;
	
	//반드시 date 객체
	var hh = date.getHours();
	var mi = date.getMinutes(); // month : 0~11
	var ss = date.getSeconds(); 
	return addNumZero(hh)  + ":" + addNumZero(mi) + ":" + addNumZero(ss);
	
	}
	
	//숫자를 두 자리로 만들어 주는 함수 -> 9보다 작거나 같으면 앞에 0을 붙임 
	function addNumZero(data){
		if(data > 9 )return data
		return "0" + data;
	}
	
	
 //날짜 데이터를 'timestemp: Long 타입' 긴 숫자를 받아서 날짜 계산에 의해 현재 시간 기준으로 24시간이 지났으면 날짜 문자열을 출력 그렇지 않으면 숫자 문자열을 돌려주는 함수  
 function displayTime(timeStemp){
 	//오늘 날짜 객체 만들기
 	var today = new Date();
 	//오늘 날짜 타임스탬프에서 비교해야 할 날짜의 타임스탬프를 빼기 
 	var gap = today.getTime() - timeStemp;
 	
 	//24시간이 지나지 않았으면(시간이 지났으면) 날짜를 문자열로 돌려줌 
 	if(gap < (1000 * 60 * 60 * 24))
 		return dateToTimeStr(new Date(timeStemp));
 	else return dateToDateStr(new Date(timeStemp),".");	
 	}
