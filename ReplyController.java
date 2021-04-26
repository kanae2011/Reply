package org.zerock.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.board.service.ReplyService;
import org.zerock.board.vo.ReplyVO;

import com.webjjang.util.PageObject;

import lombok.extern.log4j.Log4j;

//자동생성 - @Controller,@Service,@Repository,@Component,@RestController,@RestControllerAdvice ->Component-scan 설정 : servlet-context.xml,root-context.xml
@RestController
@RequestMapping("/replies")
@Log4j
public class ReplyController {

	//자동DI
	@Autowired
	@Qualifier("rsi")
	private ReplyService service;
	
	//1.게시판 댓글 목록(보기 포함) -검색 /list.do - get
	@GetMapping(value = "/list.do",
			produces = {
					MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_UTF8_VALUE})
	
	// ResponseEntity : 실행 상태 코드와 함께 실행결과를 클라이언트에서 전달 할 때 사용하는 객체 
		public ResponseEntity<Map<String,Object>>list(
	//	public ResponseEntity<List<ReplyVO>> list(
			@RequestParam(defaultValue =  "1") long replyPage,
			@RequestParam(defaultValue =  "5")long replyPerPageNum,
			Long no) throws Exception {
		Map<String,Object>map = new HashMap<>();
		//댓글에 대한 페이지 정보
		PageObject replyPageObject = new PageObject(replyPage,replyPerPageNum);
		log.info("list().replyPageObject : " + replyPageObject + "......");
		
		map.put("pageObject", replyPageObject);
		map.put("list", service.list(replyPageObject, no));
		
		return new ResponseEntity<>(map,HttpStatus.OK);
		
//		return new ResponseEntity<>(service.list(replyPageObject, no), HttpStatus.OK);
	      // /WEB-INF/views + /board/list + .jsp -> servlet-context.xml 정보
		
	}
	
	//게시판 댓글 등록 처리
	@PostMapping(value = "/write.do",
//			consumes = "application/json", 
			consumes = {MediaType.APPLICATION_JSON_UTF8_VALUE},
			produces = {"application/text; charset=utf-8"})
//			produces = {MediaType.TEXT_PLAIN_VALUE})
	//2.게시판 작성 /write.do - post
	public ResponseEntity<String> write(@RequestBody ReplyVO vo)throws Exception {
		log.info("write.vo()" + vo);
		
		//db에 데이터 저장
		service.write(vo);
		return new ResponseEntity<String>("댓글이 등록되었습니다.",HttpStatus.OK);
		
	}
	
	
	@PatchMapping(value = "/update.do",
			consumes = {MediaType.APPLICATION_JSON_UTF8_VALUE},
			produces = {"application/text; charset=utf-8"})
	//4-2.게시판 글수정 /update.do - post
	public ResponseEntity<String> update(@RequestBody ReplyVO vo) throws Exception {
		log.info("update().vo : " + vo);
		
		int result = service.update(vo);
		
		//전달 되는 데이터의 선언
		String msg = "댓글 수정을 완료했습니다.";
		HttpStatus status = HttpStatus.OK;
		
		if(result == 0) {
			msg = "댓글 수정 중 오류가 발생했습니다.";
			status = HttpStatus.NOT_MODIFIED;
		}
		log.info("update().msg : " + msg);
		
		return new ResponseEntity<String>(msg,status);
			
	}
	
	@DeleteMapping(value = "/delete.do",
			consumes = {MediaType.APPLICATION_JSON_UTF8_VALUE},
			produces = {"application/text; charset=utf-8"})
	//5.게시판 글삭제 delete방식
	public ResponseEntity<String> delete(@RequestBody ReplyVO vo) throws Exception {
		log.info("delete().vo:"  + vo);
		
		int result = service.delete(vo);
		
		//전달 되는 데이터의 선언
		String msg = "댓글 삭제를 완료했습니다.";
		HttpStatus status = HttpStatus.OK;
		
		if(result == 0) {
			msg = "댓글 삭제 중 오류가 발생했습니다.";
			status = HttpStatus.NOT_MODIFIED;
		}
		log.info("delete().msg : " + msg);
		
		return new ResponseEntity<String>(msg,status);
	}
}
