/**
 * 게시판 댓글 처리에 필요한 JS(jQuery)
 */
 
//브라우저의 console tab에 출력 -alert()출력 
console.log("Reply Module........");
 
//replyService 변수 - 타입 Object -JSON{} - {k:v, k:v, k:func()}
//replyService 처리하면 결과 function으로 나옴 / 결과 뒤에 () 붙이면 실행이 됨 
var replyService = (
	//list
	//param : JSON{no:2,replyPage:1,replyPerPageNum:5}
	function(){
		function list(param,callback,error){
			var no = param.no;
			//param.replyPage || 1 -> param.replyPage의 값이 없으면 1 사용
			var page = param.replyPage || 1;
			//param.replyPerPageNum || 5 -> param.replyPerPageNum의 값이 없으면 5 사용
			var perPageNum = param.replyPerPageNum || 5;
			
//			alert(no);
			
			//Ajax를 이용한 데이터 가져오기 -> 형식에 맞으면 Ajax 사용 
			//Ajax 함수 : $.getJSON() - $.ajax() 통해서 JSON 데이터를 받아오게 만든 함수 
			//			$(selector).load(url[,success])-아이디 중복체크 시 사용
			$.getJSON(
				//ajax로 호출하는 URL
				"/replies/list.do?no=" + no + "&replyPage=" + page + "&replyPerPageNum" + perPageNum,
				//success 상태 일 때 처리되는 함수
				//데이터 처리가 성공해서 데이터를 가져오면 data로 넣어줌.list이므로 배열이 넘어옴 
				function(data){
					//alert(data);
					//callback : 데이터를 가져오면 처리하는 함수 - 가져온 list를 HTML로 만듦.지정한 곳에 넣어줌
					if(callback){
						callback(data);
					}
				}
			)
			//error 상태 일 때 처리되는 함수
			.fail(function(xhr,status,err){
				//오류 함수가 있으면 오류 함수 실행
					if(error){
						error();
					}else{
						// 오류 출력 - {}, []구조 가능 / <> - JSON데이터가 아니므로 오류
						alert(err);
					}
					
				}
				
			);
	}	 //list의 끝
	
	//write()
	function write(reply,callback,error){
		console.log("------------------reply write()------------------")
		console.log("------------------reply data()------------------")
		//ajax를 이용해서 데이터를 서버에 보냄
		$.ajax({
			//Replycontroller-postMapping
			//전송 방법에 대한 타입 : get,post,put,patch,delete,update
			type :"post",
			//요청 URL
			url :"/replies/write.do",
			
			
			//전송되는 데이터 
			data : JSON.stringify(reply),
		
			//전송되는 데이터의 타입과 엔코딩 방식 
			contentType:"application/json; charset=utf-8",
			//정상적으로 댓글쓰기 성공했을 경우의 처리함수
			success : function(result,status,xhr){
				if(callback)callback(result);
				else alert("댓글 쓰기 성공");
			},
			
			//처리 도중 오류가 난 경우의 처리함수 속성 
			error : function(xhr,status,err){
				if(error)error();
				else alert("댓글 쓰기 오류");
			}
		});
	}
	
	//update()
	function update(reply,callback,error){
		console.log("------------------reply update()------------------")
		//ajax이용해서 데이터 넘기기
		$.ajax({
			type :"patch",
			url : "/replies/update.do",
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result,status,xhr){
				if(callback)callback(result,status);
				else alert("댓글 수정 성공");
			},
			error : function(xhr,status,err){
				if(error) error(err,status);
				else alert("댓글 수정 오류");
			}
		});

	}
	
	
	//delete가 예약어 이므로 변수나 함수로 이용불가-> deleteReply로 지정 
	function deleteReply(reply,callback,error){
		console.log("-----------------reply deleteReply()----------------")
		$.ajax({
			type : "delete",
			url : "/replies/delete.do",
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result,status,xhr){
				if(callback) callback(result,status);
				else alert("댓글 삭제 성공");
			},
			error : function(xhr,status,err){
				if(error)error(err);
				else alert("댓글 삭제 오류");
			}
			
		})
	}
	
	
	return {
		//replyService.list(param,callback,error)
		list : list,
		write : write,
		update : update,
		delete : deleteReply,
		displayTime : displayTime 
	}
	}
)();
 console.log(replyService);
 
 
