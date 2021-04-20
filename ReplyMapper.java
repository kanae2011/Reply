package org.zerock.board.mapper;

import java.util.List;
import java.util.Map;

import org.zerock.board.vo.ReplyVO;



public interface ReplyMapper {

	//1.댓글 목록 - 페이지 처리-MyBatis의 메소드들은 파라메터의 갯수를 한 개만 받도록 작성되어 있음 
	//때문에Map이용 - "pageObject":pageObject,"no":no
	public List<ReplyVO>list(Map<String, Object>map) throws Exception;
	
	//1-1.댓글 전체 데이터 가져오기-페이지 처리(화면에 보여주는 페이지네이션)
	public Long getTotalRow() throws Exception;
	
	//2.댓글보기 생략- 목록에 다 표시되어 있으므로 
	
	//3.댓글쓰기
	public int write(ReplyVO vo) throws Exception;
	
	//4.댓글수정
	public int update(ReplyVO vo) throws Exception;
	
	//5.댓글삭제
	public int delete(ReplyVO vo) throws Exception;
}
