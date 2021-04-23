<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board view</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<meta name='viewport' content='width=device-width, initial-scale=1'>
<script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>


<!-- util.js JS 포함(반드시 reply Model JS 포함 위에 선언할 것!!) -->
<script type="text/javascript" src="/js/util.js"></script>
<!-- reply Model JS 포함 -->
<script type="text/javascript" src ="/js/reply.js"></script>

<script type="text/javascript">
$(function(){
//F5, ctrl + F5, ctrl + r 새로고침 막기
// 	   $(document).keydown(function (e) {
	        
// 	        if (e.which === 116) {
// 	            if (typeof event == "object") {
// 	                event.keyCode = 0;
// 	            }
// 	            return false;
// 	        } else if (e.which === 82 && e.ctrlKey) {
// 	            return false;
// 	        }
// 	   }); 
	   
	   ${(empty msg)?"":"alert('"+= msg +="');"}
	   
//모달 안에 있는 삭제 버튼 이벤트
$("#modal_deleteBtn").click(function () {
	alert("modal 삭제");
	$("#modal_form").submit();
});

//댓글 처리 JS 부분
console.log("------------------------------------");
console.log("JS Reply List Test!");

//전역 변수 선언 : $(function(){~~}); 안에 선언된 함수에서는 공통으로 사용 가능 
var no = ${vo.no};
console.log("JS Reply List no : " + no);
var replyPage = 1;
var replyPerPageNum = 5;
var replyUL = $(".chat"); 

//글보기를 하면 바로 댓글 목록 호출
showList();

//function showList() - no,page,perPageNum : 전역변수로 선언되어있으므로 변수명 사용 
function showList() {
	replyService.list(
		//서버에 넘겨 줄 데이터
		{no:no,replyPage:replyPage,replyPerPageNum:replyPerPageNum},
		//성공 했을 때의 함수 -> data라는 이름으로 list가 들어옴 (순서가 중요)
		function(list){
			var str = "";
			//li태그 만들기
			//데이터가 없을때의 처리
			if(!list || list.length == 0){
				//alert("데이터 없음");
				str += "<li>댓글이 존재하지 않습니다.</li>"
				
			}else{//데이터가 없을때의 처리
				//alert("데이터 있음");
			for(var i = 0; i < list.length; i++){
				console.log(list[i]);
				// tag 만들기 -데이터 한 개당 li tag 한 개가 생김
				str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
				str += "<div>";
				str += "<div class='header'>";
				str += "<strong class='primary-font replyWriterData'>" + list[i].writer + "</strong>"; 
				// class="muted" - 글자색을 회색으로 만들어 주는 BS CSS
				str += "<small class='pull-right text-muted'>" 
					+ replyService.displayTime(list[i].writeDate) + "</small>"; 
				str += "</div>"
				str += "<p><pre style='background:#d8f3eb; border: none;' class='replyContentData'>" + list[i].content + "</pre></p>";
				str += "<div class='text-right'>";
				str += "<button class='btn btn-primary btn-xs replyUpdateBtn'>수정</button>";
				str += "<button class='btn btn-primary btn-xs replyDeleteBtn'>삭제</button>";
				str += "</div>";
				str += "</div>";
				str += "</li>";
				}
			}
			replyUL.html(str);
		});
}//end of show list

//댓글 모달창의 전역변수
var replyModal = $("#replyModal");


//댓글 등록 이벤트 처리 : 댓글의 모달창 정보 조정과 보이기 
$("#writeReplyBtn").click(function () {
//	alert("댓글등록");

	//댓글 모달창의 제목 바꾸기
	$("#writeReplyBtn").text("Reply Write");
	
	//작업할 데이터의 입력란을 보이게 /  안보이게
	$("#replyModal .form-group").show();
	$("#replyRnoDiv").hide();

	//작업 할 버튼을 보이게 / 안보이게
	var footer = $("#replyModal .modal-footer");
	footer.find("button").show();
	footer.find("#replyModalUpdateBtn,#replyModalDeleteBtn").hide();
	
	//reply > Form input 데이터 지우기-> input 중에서 replyNo는 제외 시킴 
	replyModal.find("input,textarea").not("#replyNo").val("");
	
	//replyModal에 있는 입력 항목을 다 보이게
	replyModal.find("div.form-control").show();
	//rno 미사용 -> 보이지 않게 
	replyModal.find("#replyRnoDiv").hide();
	
	replyModal.modal("show");
});

//  댓글 모달창의 등록 버튼에 대한 이벤트 처리 - 입력 된 데이터를 가져와서 JSON 데이터 만들기 -서버에 전송
$("#replyModalWriteBtn").click(function () {
	var reply = {};
	reply.no = $("#replyNo").val();
	reply.content = $("#replyContent").val();
	reply.writer = $("#replyWriter").val();
	reply.pw = $("#replyPw").val();
//	alert(reply);
//	alert(JSON.stringify(reply));
	
	//ajax를 이용한 댓글 등록처리
	replyService.write(reply,
			//성공했을 때의 처리함수 
			function(result) {
				alert(result);
				replyModal.modal("hide");
				showList();
			});

});

//댓글 수정 폼 -모달창

$(".chat").on("click",".replyUpdateBtn",function () {
//	alert("댓글 수정");
//모달창 제목 바꾸기
$("#replyModalTitle").text("Reply Update");

//작업할 데이터의 입력란을 보이게 / 안보이게
$("#replyModal .form-group").show();
$("#replyNoDiv").hide();

//작업 할 버튼을 보이게 / 안보이게
var footer = $("#replyModal .modal-footer");
footer.find("button").show();
footer.find("#replyModalWriteBtn,#replyModalDeleteBtn").hide();



//데이터 수집
//전체 데이터를 토함하고 있는 태그 : li
var li = $(this).closest("li");

//html tag안에 속성으로 data-rno="2" 값을 넣어 둔 것은 obj.data("rno")으로 찾아서 씀 
var rno = li.data("rno");
var content=li.find(".replyContentData").text();
var writer=li.find(".replyWriterData").text();


//데이터 셋팅
$("#replyRno").val(rno);
$("#replyContent").val(content);
$("#replyWriter").val(writer);

//비밀번호는 삭제
$("#replyPw").val("");


replyModal.modal("show");
});

// ---모달창 수정 버튼 이벤트 ---
$("#replyModalUpdateBtn").click(function (){
//	alert("수정 처리");
	//데이터 수집
	var reply = {};
	reply.rno = $("#replyRno").val();
	reply.content = $("#replyContent").val();
	reply.writer = $("#replyWriter").val();
	reply.pw = $("#replyPw").val();
	
	//수집한 데이터 확인
//	alert(JSON.stringify(reply));
	
	//reply.js 안에 있는 replyService.update 호출해서 실행
	replyService.update(reply,
		function (result,status) {
//			alert("성공 : " + status);
			//성공 메세지 출력
			if(status == "notmodified")
				alert("수정이 완료되지 않았습니다.정보를 확인해주세요.");
			else{
			alert(result);
			// list 다시 표시
			showList();
			}
		},
		function(err,status) {
//			alert("실패 : " + status);
			//실패 메세지 출력
			alert(err);
		}
	); //end of replyService.update()
	//모달창은 숨겨둠
	replyModal.modal("hide");
	


});



//댓글 삭제 폼 -모달창

$(".chat").on("click",".replyDeleteBtn",function() {
//	alert("댓글 삭제");
	// 모달창 제목 바꾸기
	$("#replyModalTitle").text("Reply Delete");
	
	//작업할 데이터의 입력란을 보이게 안보이게
	$("#replyModal .form-group").show();
	$("#replyNoDiv,#replyContentDiv,#replyWriterDiv").hide();

	//작업 할 버튼을 보이게 안보이게
	var footer = $("#replyModal .modal-footer");
	footer.find("button").show();
	footer.find("#replyModalWriteBtn,#replyModalUpdateBtn").hide();
	
	//댓글 번호 가져오기
	var li = $(this).closest("li");
	var rno = li.data("rno");
	
	//댓글 번호 셋팅
	$("#replyRno").val(rno);
	
	//비밀번호는 삭제
	$("#replyPw").val("");
	
	//댓글 모달보이기
	replyModal.modal("show");
});

//---모달창 삭제 버튼 이벤트 ---
$("#replyModalDeleteBtn").click(function () {
//	alert("댓글 삭제 처리");
	//데이터 수집
	var reply = {};
	reply.rno = $("#replyRno").val(); //값을 가져 올 경우: val 객체를 가져올 경우: 그 자체 
	reply.pw = $("#replyPw").val();
	
	//reply.js 안에 있는 replyService.delete(reply JSON,성공함수,오류함수)
	replyService.delete(reply,
		function(result,status){
		//status -비밀번호가 틀려서 삭제가 되지 않으면 "notmodified"
//			alert("result : " + result + "\nstatus : " + status);
			if(status == "success"){
//				alert(result);
				showList();
			}else{
				alert("댓글 삭제가 완료되지 않았습니다.정보를 확인해주세요.")
				}
		},
		function(err,status){
			alert(err);
		}
			);
	replyModal.modal("hide");

});
});

</script>

<style type="text/css">
.title_label{
	border:1px solid #ddd;
}	

ul.chat{
	list-style:none;
}

ul.chat > li {
	margin-bottom: :15px;
}

.commentForm{
   background: #ecf9f5;
}
.dataRow:hover {
   cursor: pointer;
   background: #d8f3eb;
}

h2{
   text-align: center;
   margin: 50px;
   color: white; 
    background: #bce7f6; 
}

div {
   background: none;
}

 body { 
    background-color: #ecf9f5;  
    margin: 0; */
 } 
.wBtn {
   background-color: #8bdac4; /* Green */
   border: none;
   color: white;
   padding: 8px 16px;
   text-align: center;
   text-decoration: none;
   display: inline-block;
   font-size: 12px;
   margin: 2px 1px;
   transition-duration: 0.4s;
   cursor: pointer;
}

.wBtn {
   background-color: white;
   color: black;
   border: 2px solid #8bdac4;
}
.wBtn:hover {
   background-color: #8bdac4;
   color: white;
}
.abc{
    background-color: #ecf9f5; 
}

</style>
</head>
<body>
<div class="container">
<h2>Board view</h2>
<!-- 데이터 표시하는 부분 -->
<ul class="list-group">
  <li class="list-group-item list-group-item-success row">
  	<div class="col-md-2 title_label">번호</div>
  	<div class="col-md-10">${vo.no }</div>
  </li>
  <li class="list-group-item list-group-item-success row">
  	<div class="col-md-2 title_label">제목</div>
  	<div class="col-md-10">${vo.title }</div>
  </li>
  <li class="list-group-item list-group-item-success row">
  	<div class="col-md-2 title_label">내용</div>
  	<div class="col-md-10">${vo.content }</div>
  </li>
  <li class="list-group-item list-group-item-success row">
  	<div class="col-md-2 title_label">작성자</div>
  	<div class="col-md-10">${vo.writer }</div>
  </li>
  <li class="list-group-item list-group-item-success row">
  	<div class="col-md-2 title_label">작성일</div>
  	<div class="col-md-10">
	  	<fmt:formatDate value="${vo.writeDate }" pattern="yyyy.MM.dd"/> 
	  	<fmt:formatDate value="${vo.writeDate }" pattern="hh:mm.ss"/> 
  	</div>
  </li>
  <li class="list-group-item list-group-item-success row">
  	<div class="col-md-2 title_label">조회수</div>
  	<div class="col-md-10">${vo.hit }</div>
  </li>

</ul>
<a href="update.do?no=${vo.no }&page=${pageObject.page}&perPageNum=${pageObject.perPageNum}&key=${pageObject.key}&word=${pageObject.word}" class="btn wBtn">수정</a>
<a class="btn wBtn" data-toggle="modal" data-target="#myModal" onclick="return false;">삭제</a>
<a href="list.do?page=${pageObject.page }&perPageNum=${pageObject.perPageNum}&key=${pageObject.key}&word=${pageObject.word}" class="btn wBtn">목록</a>

<!-- 댓글의 시작 -->
<div class="row" style="margin:20px -35px;">
	<div class="col-lg-12">
		<div class="panel" style="background: #bce7f6;">
			<div class="panel-heading">
				<i class='far fa-comments' style='font-size:20px'></i>
				Reply
				<button class=" pull-right btn btn-primary btn-xs " id="writeReplyBtn">New Reply</button>
			</div>
		    <div class="panel-body commentForm">
			    <ul class="chat">
			    	<!-- 데이터가 있는 만큼 li 태그 반복처리  -->
			    	<!-- rno를 표시하지 않고 속성으로 숨겨 높음 -> data-rno="12" -->
			    	<li class="left clearfix" data-rno="12">
			    		<div>
			    			<div class="header">
			    				<strong class="primary-font">user00</strong> 
		    					<small class="pull-right text-muted">2021.04.21</small> 
			    			</div>
			    			<p>I like you</p> 
			    			<div class="text-right">
			    				<button class="btn btn-primary btn-xs replyUpdateBtn">수정</button>
			    				<button class="btn btn-primary btn-xs replyDeleteBtn">삭제</button>
			    			</div>
			    		</div>
			    	</li>
			    </ul>
		    </div>
		</div>
	</div>
</div>
<!-- 댓글의 끝 -->
</div>
<!-- container 끝 -->
 <!-- Modal 게시판 글삭제 시 사용되는 모달창 -->
<div id="myModal" class="modal fade" role="dialog">

  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">글삭제용 비밀번호 입력</h4>
      </div>
      <div class="modal-body">
        <form action="delete.do" method="post" id="modal_form">
        <input type="hidden" name="no" value="${vo.no }">
        <input type="hidden" name="perPageNum" value="${pageObject.perPageNum}">
        	<div class="form-group">
        		<label>비밀번호 : </label>
        		<input name="pw" type="password" id="pw" pattern="[^가-힣ㄱ-ㅎ]{4,20}"required="required" title="4자 이상 20자 미만 입력,한글은 입력 할 수 없습니다.">
        	</div>
        
        </form>
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal" id="modal_deleteBtn">삭제</button>
        <button type="button" class="btn btn-success" data-dismiss="modal">취소</button>
      </div>
    </div>

  </div>
</div>
 <!-- Modal 게시판 글삭제 시 사용되는 모달창 끝 -->


 
 <!-- Modal 댓글 작성/수정 시 사용되는 모달창 -->
 <div id="replyModal" class="modal fade" role="dialog">
  <div class="modal-dialog">

   			 <!-- Modal content-->
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">&times;</button>
						<h4 class="modal-title">
						<i class='far fa-comments' style='font-size:20px'></i>
						<span id="replyModalTitle">New Reply</span>
						 </h4>
					</div>
				<div class="modal-body">
					<form>
						<div class="form-group" id="replyRnoDiv">
							<label for="replyRno">ReplyNo.</label> <input
								class="form-control" id="replyRno" readonly="readonly"
								name="replyRno">
						</div>
						<div class="form-group" id="replyNoDiv">
							<label for="replyNo">No.</label> <input class="form-control"
								id="replyNo" readonly="readonly" name="replyNo"
								value="${vo.no }">
						</div>
						<div class="form-group" id="replyContentDiv">
							<label for="replyContent">내용</label>
							<textarea name="replyContent" class="form-control"
								id="replyContent" required="required">
						</textarea>
						</div>
						<div class="form-group" id="replyWriterDiv">
							<label for="replyWriter">작성자</label> <input name="replyWriter"
								type="text" class="form-control" id="replyWriter"
								required="required" pattern="[A-Za-z가-힣][A-Za-z가-힝0-9],{1,9}">
						</div>
						<div class="form-group" id="replyPwDiv">
							<label for="replyPw">비밀번호</label> <input name="replyPw"
								type="password" class="form-control" id="replyPw"
								pattern=".{4,20}" >
						</div>
					</form>
				</div>
				<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal" id="replyModalWriteBtn">등록</button>
						<button type="button" class="btn btn-default" data-dismiss="modal" id="replyModalUpdateBtn">수정</button>
						<button type="button" class="btn btn-default" data-dismiss="modal" id="replyModalDeleteBtn">삭제</button>
						<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
					</div>
				</div>
			</div>
	</div>
</body>
</html>