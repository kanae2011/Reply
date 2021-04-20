package org.zerock.board.controller;

import java.net.URLEncoder;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
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
	@GetMapping(value = "/list.do",produces = {MediaType.APPLICATION_XML_VALUE,MediaType.APPLICATION_PROBLEM_JSON_UTF8_VALUE})
	
	// ResponseEntity : 실행 상태 코드와 함께 실행결과를 클라이언트에서 전달 할 때 사용하는 객체 
	public ResponseEntity<List<ReplyVO>> list(
			@RequestParam(defaultValue =  "1") long replyPage,
			@RequestParam(defaultValue =  "5")long replyPerPageNum,
			Long no) throws Exception {
		
		//댓글에 대한 페이지 정보
		PageObject replyPageObject = new PageObject(replyPage,replyPerPageNum);
		log.info("list().replyPageObject : " + replyPageObject + "......");
		return new ResponseEntity<> (service.list(replyPageObject,no),HttpStatus.OK);
		
	}
	
	
	@PostMapping("/write.do")
	//2.게시판 작성 /write.do - post
	public String write(ReplyVO vo,int perPageNum, RedirectAttributes rttr) throws Exception {
		log.info("write.vo()" + vo);
		service.write(vo);
		rttr.addFlashAttribute("msg","글 작성 성공");
		return "redirect:list.do?perPageNum=" + perPageNum;
	}
	
	
	@PostMapping("/update.do")
	//4-2.게시판 글수정 /update.do - post
	public String update(ReplyVO vo,RedirectAttributes rttr,PageObject pageObject) throws Exception {
		log.info("update().vo" + vo);
		
		int result = service.update(vo);
		if(result == 0)throw new Exception("Board update Fasle -정보 확인 요망");
		log.info("update().result" + result);
		rttr.addFlashAttribute("msg", "글 수정 성공");
		return "redirect:view.do?no=" + vo.getNo() + "&inc=0" 
			+ "&page=" + pageObject.getPage() 
			+ "&perPageNum=" + pageObject.getPerPageNum()
			+ "&key=" + pageObject.getKey()
			//URL로 요청되는 경우 서버의 한글이 적용되므로 UTF-8로 Encode시킴
			+ "&word=" + URLEncoder.encode(pageObject.getWord(),"utf-8") 
			;
	}
	
	@DeleteMapping("/delete.do")
	//5.게시판 글삭제 delete방식
	public String delete(ReplyVO vo,int perPageNum,RedirectAttributes rttr) throws Exception {
		log.info("delete().vo:"  + vo);
		
		int result = service.delete(vo);
		//result가 0이면 비밀번호가 틀림
		if(result == 0)throw new Exception("Board delete false - 정보확인 요망");
		rttr.addFlashAttribute("msg", "글 삭제 성공");
		return "redirect:list.do?perPageNum=" + perPageNum;
	}
}
